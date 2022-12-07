open Mina_base
open Core_kernel
open Async
open Context
open Bit_catchup_state

let check_body_storage ~context header_with_hash =
  let (module Context : CONTEXT) = context in
  Context.check_body_in_storage
    ( With_hash.data header_with_hash
    |> Mina_block.Header.protocol_state
    |> Mina_state.(
         Fn.compose Blockchain_state.body_reference
           Protocol_state.blockchain_state) )

(** [mark_done state_hash] assigns a transition corresponding to [state_hash]
  with a [Processing] or [Failed] status new status [Processing (Done ())] and
  returns in-progress context if the transition was in progress of receiving ancestry.
*)
let mark_done ~logger ~transition_states state_hash =
  let%bind.Option st = Transition_states.find transition_states state_hash in
  let%bind.Option st' =
    match st with
    | Transition_state.Received
        ({ substate = { status = Processing _ as old_status; _ } as s; _ } as r)
    | Received
        ({ substate = { status = Failed _ as old_status; _ } as s; _ } as r) ->
        let status = Substate.Processing (Done ()) in
        let metadata =
          Substate.add_error_if_failed ~tag:"old_status_error" old_status
          @@ Substate.add_error_if_failed ~tag:"new_status_error" status
          @@ [ ("state_hash", State_hash.to_yojson state_hash) ]
        in
        [%log debug]
          "Updating status of $state_hash from %s to %s (state: received)"
          (Substate.name_of_status old_status)
          (Substate.name_of_status status)
          ~metadata ;
        Some (Transition_state.Received { r with substate = { s with status } })
    | _ ->
        None
  in
  Transition_states.update transition_states st' ;
  match st with
  | Transition_state.Received
      { substate = { status = Processing (In_progress ctx); _ }; _ } ->
      Some (ctx.timeout, ctx.interrupt_ivar)
  | _ ->
      None

(** Save new transition state and process the hint.

    When state is [Transition_state.Downloading_body], pass the baton
    to ancestor (and restart failed) if [baton] is [true]. 
*)
let handle_preserve_hint ~actions ~transition_states ~context (st, hint) =
  Transition_states.update transition_states st ;
  let (module Context : CONTEXT) = context in
  let meta = Transition_state.State_functions.transition_meta st in
  let log_bp = function
    | `No_body_preserved ->
        ()
    | `Preserved_body ->
        [%log' debug Context.logger] "Preserved body for $state_hash (state %s)"
          (Transition_state.State_functions.name st)
          ~metadata:[ ("state_hash", State_hash.to_yojson meta.state_hash) ]
  in
  match hint with
  | `Nop bp ->
      log_bp bp
  | `Mark_verifying_blockchain_proof_processed (bp, iv_header) ->
      log_bp bp ;
      Verifying_blockchain_proof.make_processed ~context ~actions
        ~transition_states iv_header
  | `Start_processing_verifying_complete_works (bp, state_hash) ->
      log_bp bp ;
      Verifying_complete_works.make_independent ~context ~actions
        ~transition_states state_hash
  | `Mark_downloading_body_processed ivar_opt ->
      ( match st with
      | Downloading_body { baton = true; _ } ->
          Downloading_body.pass_the_baton ~transition_states ~context
            ~actions:(Async_kernel.Deferred.return actions)
            meta.parent_state_hash
      | _ ->
          () ) ;
      Option.iter ivar_opt ~f:(Fn.flip Ivar.fill_if_empty ()) ;
      actions.Misc.mark_processed_and_promote
        ~reason:"received gossip with body" [ meta.state_hash ]

let pre_validate_header ~context:(module Context : CONTEXT) hh =
  let open Result in
  let open Mina_block.Validation in
  let open Context in
  validate_delta_block_chain (wrap_header hh)
  >>= validate_protocol_versions
  >>= validate_genesis_protocol_state ~genesis_state_hash
  >>| skip_time_received_validation_header
        `This_block_was_not_received_via_gossip

let is_in_frontier frontier =
  Fn.compose Option.is_some (Transition_frontier.find frontier)

(** Check transition's status in catchup state and frontier *)
let lookup_transition ~transition_states ~frontier state_hash =
  match Transition_states.find transition_states state_hash with
  | Some (Transition_state.Invalid _) ->
      `Invalid
  | Some _ ->
      `Present
  | None ->
      if is_in_frontier frontier state_hash then `Present else `Not_present

(** Insert invalid transition to transition states and mark
    children of the transition invalid.
    
    Pre-condition: transition doesn't exist in transition states.
*)
let insert_invalid_state_impl ~is_parent_in_frontier ~state ~actions
    ~transition_meta ~children_list error =
  Transition_states.add_new state.transition_states
    (Transition_state.Invalid { transition_meta; error }) ;
  Misc.handle_non_regular_child ~state ~is_parent_in_frontier ~is_invalid:true
    transition_meta ;
  List.iter children_list ~f:(fun state_hash ->
      actions.Misc.mark_invalid state_hash ~error )

(** Insert invalid transition to transition states and remove
    corresponding record from orphans.
    
    Pre-condition: transition doesn't exist in transition states.
*)
let insert_invalid_state ~actions ~is_parent_in_frontier ~state ~transition_meta
    error =
  let children_list_opt =
    State_hash.Table.find state.children transition_meta.Substate.state_hash
  in
  Option.iter children_list_opt ~f:(fun (_tag, children_list) ->
      State_hash.Table.set state.children ~key:transition_meta.state_hash
        ~data:(`Invalid_children, children_list) ) ;
  let children_list = Option.value_map children_list_opt ~f:snd ~default:[] in
  insert_invalid_state_impl ~actions ~state ~is_parent_in_frontier
    ~transition_meta ~children_list error

let set_processing_to_failed error = function
  | Transition_state.Received
      ( { substate = { status = Processing (In_progress _); _ }; gossip_data; _ }
      as r ) ->
      Gossip.drop_gossip_data `Ignore gossip_data ;
      Some
        (Transition_state.Received
           { r with
             substate = { r.substate with status = Failed error }
           ; gossip_data = Gossip.No_validation_callback
           } )
  | st ->
      Some st

let split_retrieve_chain_element ~context = function
  | `Block bh ->
      let hh = With_hash.map ~f:Mina_block.header bh in
      ( Substate.transition_meta_of_header_with_hash hh
      , Some hh
      , Some (Mina_block.body @@ With_hash.data bh) )
  | `Header hh ->
      ( Substate.transition_meta_of_header_with_hash hh
      , Some hh
      , check_body_storage ~context hh )
  | `Meta m ->
      (m, None, None)

let is_received = function Transition_state.Received _ -> true | _ -> false

let rec pre_validate_and_add ~context ~actions ~sender ~state ?body hh =
  match pre_validate_header ~context hh with
  | Ok vh ->
      add_received ~context ~actions ~sender ~state ?body
        (Gossip.Pre_initial_valid vh) ;
      Ok ()
  | Error e ->
      let header = With_hash.data hh in
      let (module Context : CONTEXT) = context in
      Context.record_event (`Pre_validate_header_invalid (sender, header, e)) ;
      let e' =
        Error.of_string
        @@
        match e with
        | `Invalid_genesis_protocol_state ->
            "invalid genesis state"
        | `Invalid_delta_block_chain_proof ->
            "invalid delta transition chain proof"
        | `Mismatched_protocol_version ->
            "protocol version mismatch"
        | `Invalid_protocol_version ->
            "invalid protocol version"
      in
      let transition_meta = Substate.transition_meta_of_header_with_hash hh in
      let is_parent_in_frontier =
        Option.is_some
        @@ Transition_frontier.find Context.frontier
             transition_meta.parent_state_hash
      in
      insert_invalid_state ~actions ~state ~transition_meta
        ~is_parent_in_frontier e' ;
      Error e'

(** Handle an ancestor returned by [retrieve_chain] function.
  
    The ancestor's block is pre-validated and added to transition states
    (if not yet present there).

    In case ancestor is already in transition states and body is available
    from.

    Returns error iff the ancestor is invalid. *)
and handle_retrieved_ancestor ~context ~actions ~state ~sender el =
  let (module Context : CONTEXT) = context in
  let extend_aux aux =
    { aux with
      Transition_state.received =
        { received_at = Time.now (); gossip = false; sender }
        :: aux.Transition_state.received
    }
  in
  let transition_meta, hh_opt, body =
    split_retrieve_chain_element ~context el
  in
  let state_hash = transition_meta.state_hash in
  match (Transition_states.find state.transition_states state_hash, hh_opt) with
  | Some (Transition_state.Invalid _), _ ->
      Error (Error.of_string "invalid")
  | Some st, _ ->
      let st' = Transition_state.modify_aux_data ~f:extend_aux st in
      let hint =
        Option.value_map ~f:(Gossip.preserve_body st')
          ~default:(st', `Nop `No_body_preserved)
          body
      in
      handle_preserve_hint ~actions ~transition_states:state.transition_states
        ~context hint ;
      Ok ()
  | None, Some hh -> (
      let relevance_status =
        Gossip.verify_header_is_relevant ~event_recording:false ~context ~sender
          ~transition_states:state.transition_states hh
      in
      match relevance_status with
      | `Relevant ->
          pre_validate_and_add ~context ~actions ~sender ~state ?body hh
      | _ ->
          Ok () )
  | None, None ->
      ignore
        ( State_hash.Table.add state.parents ~key:state_hash
            ~data:(transition_meta.parent_state_hash, sender)
          : [ `Duplicate | `Ok ] ) ;
      Ok ()

(** Launch retrieval of ancestry for a received header.

Pre-condition: header's parent is neither present in transition states nor in transition frontier.
*)
and launch_ancestry_retrieval ~context ~actions ~retrieve_immediately
    ~cancel_child_contexts ~timeout ~preferred_peers ~state header_with_hash =
  let (module Context : CONTEXT) = context in
  let parent_hash =
    With_hash.data header_with_hash
    |> Mina_block.Header.protocol_state
    |> Mina_state.Protocol_state.previous_state_hash
  in
  let parent_length =
    Mina_block.Header.blockchain_length (With_hash.data header_with_hash)
    |> Mina_numbers.Length.pred
  in
  let lookup_transition =
    lookup_transition ~transition_states:state.transition_states
      ~frontier:Context.frontier
  in
  let some_ancestors =
    let rec impl lst h =
      Option.value_map (State_hash.Table.find state.parents h) ~default:lst
        ~f:(fun ((p, _) as pair) -> impl (pair :: lst) p)
    in
    impl []
  in
  let module I = Interruptible.Make () in
  let retrieve_do () =
    Context.retrieve_chain
      ~some_ancestors:(some_ancestors parent_hash)
      ~target_length:parent_length ~target_hash:parent_hash ~preferred_peers
      ~lookup_transition
      (module I)
    |> I.map ~f:(Result.map_error ~f:(fun e -> `Other e))
  in
  let ancestry =
    if retrieve_immediately then retrieve_do ()
    else
      (* We rely on one of children to retrieve ancestry and
         launch downloading ourselves only in case children timed out *)
      let%bind.I () = I.lift (after Context.ancestry_download_timeout) in
      match lookup_transition parent_hash with
      | `Not_present ->
          retrieve_do ()
      | _ ->
          I.return @@ Error `Present
  in
  let top_state_hash =
    State_hash.With_state_hashes.state_hash header_with_hash
  in
  upon (I.force ancestry)
    (upon_f ~top_state_hash ~actions ~context ~state ~cancel_child_contexts) ;
  interrupt_after_timeout ~timeout I.interrupt_ivar ;
  I.interrupt_ivar

(** [upon_f] is a callback to be executed upon completion of retrieving ancestry
    (or a failure). *)
and upon_f ~top_state_hash ~actions ~context ~state ~cancel_child_contexts =
  let f res (el, sender) =
    if Result.is_ok res then
      handle_retrieved_ancestor ~context ~actions ~state ~sender el
    else
      let error = Error.of_string "parent is invalid" in
      let transition_meta, _, _ = split_retrieve_chain_element ~context el in
      ( match
          Transition_states.find state.transition_states
            transition_meta.state_hash
        with
      | Some (Transition_state.Invalid _) ->
          ()
      | Some _ ->
          actions.Misc.mark_invalid ~error transition_meta.state_hash
      | None ->
          insert_invalid_state ~is_parent_in_frontier:false ~actions ~state
            ~transition_meta error ) ;
      res
  in
  let (module Context : CONTEXT) = context in
  let log_failed reason =
    [%log' debug Context.logger]
      "Updating status of $state_hash from processing (in progress) to failed \
       (state: received)"
      ~metadata:
        [ ("state_hash", State_hash.to_yojson top_state_hash)
        ; ("new_status_error", reason)
        ]
  in
  let on_error e =
    cancel_child_contexts () ;
    log_failed (Error_json.error_to_yojson e) ;
    Transition_states.update' state.transition_states top_state_hash
      ~f:(set_processing_to_failed e)
  in
  function
  | Result.Error () ->
      on_error (Error.of_string "interrupted")
  | Ok (Result.Ok lst) ->
      cancel_child_contexts () ;
      ignore
        ( List.fold (Non_empty_list.to_list lst) ~init:(Ok ()) ~f
          : unit Or_error.t ) ;
      let reason = "failed to retrieve ancestors" in
      log_failed (`String reason) ;
      (* This will trigger only is the top state hash remained in Processing state
         after handling all of the fetched ancestors *)
      Transition_states.update' state.transition_states top_state_hash
        ~f:(set_processing_to_failed @@ Error.of_string reason)
  | Ok (Error (`Other e)) ->
      on_error e
  | Ok (Error `Present) ->
      ()

and restart_failed_ancestor ~state ~actions ~context top_state_hash =
  let (module Context : CONTEXT) = context in
  let transition_states = state.transition_states in
  let handle_unprocessed ~preferred_peers header =
    let timeout = Time.add (Time.now ()) Context.ancestry_download_timeout in
    let hh = Gossip.header_with_hash_of_received_header header in
    let interrupt_ivar =
      launch_ancestry_retrieval ~actions ~context ~cancel_child_contexts:Fn.id
        ~retrieve_immediately:true ~preferred_peers ~timeout ~state hh
    in
    let state_hash = State_hash.With_state_hashes.state_hash hh in
    let downto_ = Mina_numbers.Length.zero in
    Substate.Processing
      (In_progress { timeout; interrupt_ivar; downto_; holder = ref state_hash })
  in
  let f st =
    if is_received st then
      let unprocessed_opt =
        Processed_skipping.next_unprocessed ~state_functions ~transition_states
          ~dsu:Context.processed_dsu st
      in
      match unprocessed_opt with
      | Some
          (Received
            ( { header
              ; substate = { status = Failed _ as old_status; _ }
              ; aux = { received; _ }
              ; _
              } as r ) ) ->
          let status =
            handle_unprocessed
              ~preferred_peers:
                (List.map received ~f:(fun { sender; _ } -> sender))
              header
          in
          let state_hash = Gossip.state_hash_of_received_header header in
          let metadata =
            Substate.add_error_if_failed ~tag:"old_status_error" old_status
            @@ Substate.add_error_if_failed ~tag:"new_status_error" status
            @@ [ ("state_hash", State_hash.to_yojson state_hash) ]
          in
          [%log' debug Context.logger]
            "Updating status of $state_hash from %s to %s (state: received)"
            (Substate.name_of_status old_status)
            (Substate.name_of_status status)
            ~metadata ;
          Transition_states.update transition_states
            (Received { r with substate = { r.substate with status } })
      | _ ->
          ()
  in
  Option.iter (Transition_states.find transition_states top_state_hash) ~f

(** [add_received] adds a gossip to the state.

  Pre-conditions:
  * transition is neither in frontier nor in catchup state
  * [verify_header_is_relevant] returns [`Relevant] for the gossip
*)
and add_received ~context ~actions ~sender ~state ?gossip_type ?vc
    ?body:body_opt received_header =
  let (module Context : CONTEXT) = context in
  let transition_states = state.transition_states in
  let header_with_hash =
    Gossip.header_with_hash_of_received_header received_header
  in
  let header = With_hash.data header_with_hash in
  let state_hash = State_hash.With_state_hashes.state_hash header_with_hash in
  let parent_hash =
    Mina_block.Header.protocol_state header
    |> Mina_state.Protocol_state.previous_state_hash
  in
  let parent_presence =
    match Transition_states.find transition_states parent_hash with
    | Some (Transition_state.Invalid _) ->
        `Invalid
    | Some _ ->
        `In_process
    | None ->
        if is_in_frontier Context.frontier parent_hash then `In_frontier
        else `Not_present
  in
  let all_children =
    Option.value_map ~f:snd ~default:[]
    @@ State_hash.Table.find state.children state_hash
  in
  let invalid_children, non_invalid_children =
    List.partition_tf all_children ~f:(fun child ->
        match Transition_states.find transition_states child with
        | Some (Invalid _) ->
            true
        | _ ->
            false )
  in
  State_hash.Table.set state.children ~key:state_hash
    ~data:(`Invalid_children, invalid_children) ;
  State_hash.Table.remove state.parents state_hash ;
  let received_at = Time.now () in
  (* [invariant] children.processed = children.waiting_for_parent = empty *)
  let children =
    { Substate.empty_children_sets with
      processing_or_failed = State_hash.Set.of_list non_invalid_children
    }
  in
  (* descendants are marked as Done and responsibility to fetch ancestry is moved to
     the freshly received transition or its ancestors *)
  let child_contexts =
    List.filter_map non_invalid_children
      ~f:(mark_done ~logger:Context.logger ~transition_states)
  in
  let gossip = Option.is_some gossip_type in
  let add_to_state status =
    Transition_states.add_new transition_states
      (Received
         { body_opt
         ; header = received_header
         ; gossip_data = Gossip.create_gossip_data ?gossip_type vc
         ; substate = { children; status }
         ; aux =
             { received_via_gossip = gossip
             ; received = [ { gossip; sender; received_at } ]
             }
         } )
  in
  let cancel_child_contexts () =
    List.iter child_contexts ~f:(fun (_, interrupt_ivar) ->
        Ivar.fill_if_empty interrupt_ivar () )
  in
  let transition_meta =
    Substate.transition_meta_of_header_with_hash header_with_hash
  in
  let is_parent_in_frontier =
    match parent_presence with `In_frontier -> true | _ -> false
  in
  match parent_presence with
  | `Invalid ->
      cancel_child_contexts () ;
      insert_invalid_state_impl ~actions ~state ~transition_meta
        ~children_list:non_invalid_children ~is_parent_in_frontier:false
        (Error.of_string "parent is invalid")
  | `In_frontier | `In_process ->
      cancel_child_contexts () ;
      (* Children sets of parent are not updated explicitly because [mark_processed_and_promote] call
         will perform the update *)
      add_to_state @@ Substate.Processing (Done ()) ;
      Misc.handle_non_regular_child ~state ~is_parent_in_frontier
        ~is_invalid:false transition_meta ;
      actions.Misc.mark_processed_and_promote
        ~reason:"parent in frontier/transition states"
        (state_hash :: non_invalid_children) ;
      restart_failed_ancestor ~state ~actions ~context parent_hash
  | `Not_present ->
      let max_timeout =
        Time.add
          (List.fold ~init:received_at child_contexts ~f:(fun t (timeout, _) ->
               Time.max t timeout ) )
          Context.ancestry_download_timeout
      in
      let timeout =
        Time.min max_timeout @@ Time.add received_at
        @@ Time.Span.scale Context.ancestry_download_timeout 2.
      in
      (* Children sets of parent are not updated because parent is not present *)
      let interrupt_ivar =
        launch_ancestry_retrieval ~actions ~context ~cancel_child_contexts
          ~retrieve_immediately:(List.is_empty child_contexts)
          ~preferred_peers:[ sender ] ~timeout ~state header_with_hash
      in
      add_to_state
      @@ Processing
           (In_progress
              { timeout
              ; interrupt_ivar
              ; downto_ = Mina_numbers.Length.zero
              ; holder = ref state_hash
              } ) ;
      Misc.add_orphan ~state transition_meta ;
      actions.Misc.mark_processed_and_promote non_invalid_children
        ~reason:"parent just added to transition states"

(** Add a gossip to catchup state *)
let handle_gossip ~context ~actions ~state ~sender ?body ~gossip_type ?vc
    gossip_header =
  let header_with_hash = Mina_block.Validation.header_with_hash gossip_header in
  let body =
    if is_some body then body else check_body_storage ~context header_with_hash
  in
  let state_hash = State_hash.With_state_hashes.state_hash header_with_hash in
  let relevance_status =
    Gossip.verify_header_is_relevant ~context ~sender
      ~transition_states:state.transition_states header_with_hash
  in
  match relevance_status with
  | `Irrelevant ->
      ()
  | `Relevant ->
      add_received ~actions ~context ~sender ~state ~gossip_type ?vc ?body
        (Initial_valid gossip_header)
  | `Preserve_gossip_data ->
      let f =
        Fn.compose
          (handle_preserve_hint ~actions
             ~transition_states:state.transition_states ~context )
          (Gossip.preserve_relevant_gossip ?body ?vc ~context ~gossip_type
             ~gossip_header ~sender )
      in
      Option.iter ~f (Transition_states.find state.transition_states state_hash)

(** [handle_collected_transition] adds a transition that was collected during bootstrap
    to the catchup state. *)
let handle_collected_transition ~context:(module Context : CONTEXT) ~actions
    ~state (b_or_h_env, vc) =
  let header_with_validation, body, gossip_type =
    match Network_peer.Envelope.Incoming.data b_or_h_env with
    | Bootstrap_controller.Transition_cache.Block block ->
        ( Mina_block.Validation.to_header block
        , Some (Mina_block.body @@ Mina_block.Validation.block block)
        , `Block )
    | Bootstrap_controller.Transition_cache.Header header ->
        (header, None, `Header)
  in
  match Network_peer.Envelope.Incoming.sender b_or_h_env with
  | Local ->
      [%log' warn Context.logger]
        "handle_collected_transition: called for a transition with local sender"
        ~metadata:
          [ ( "state_hash"
            , State_hash.to_yojson
                (state_hash_of_header_with_validation header_with_validation) )
          ]
  | Remote sender ->
      (* TODO: is it safe to add this as a gossip? Transition was received
         through gossip, but was potentially sent not within its slot
         as boostrap controller is not able to verify this part.orphans
         Hence maybe it's worth leaving it as non-gossip, a dependent transition. *)
      handle_gossip
        ~context:(module Context)
        ~actions ~state ~sender ?vc ?body ~gossip_type header_with_validation

(** [handle_network_transition] adds a transition that was received through gossip
    to the catchup state. *)
let handle_network_transition ~context:(module Context : CONTEXT) ~actions
    ~state (b_or_h, `Valid_cb vc) =
  Option.value ~default:()
  @@ let%map.Option sender, header_with_validation, body, gossip_type =
       let log_local_header hh =
         [%log' warn Context.logger]
           "handle_network_transition: called for a transition with local \
            sender"
           ~metadata:
             [ ( "state_hash"
               , State_hash.to_yojson
                   (State_hash.With_state_hashes.state_hash hh) )
             ]
       in
       let open Network_peer.Envelope.Incoming in
       match b_or_h with
       | `Block { sender = Remote sender; data = block; _ } ->
           Some
             ( sender
             , Mina_block.Validation.to_header block
             , Some (Mina_block.body @@ Mina_block.Validation.block block)
             , `Block )
       | `Block { data = block; _ } ->
           log_local_header
             ( Mina_block.Validation.block_with_hash block
             |> With_hash.map ~f:Mina_block.header ) ;
           None
       | `Header { sender = Remote sender; data = header; _ } ->
           Some (sender, header, None, `Header)
       | `Header { data = header; _ } ->
           log_local_header (Mina_block.Validation.header_with_hash header) ;
           None
     in
     handle_gossip
       ~context:(module Context)
       ~actions ~state ~sender ?body ?vc ~gossip_type header_with_validation