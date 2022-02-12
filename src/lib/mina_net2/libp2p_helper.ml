open Async
open Core
open Pipe_lib
open O1trace

exception Libp2p_helper_died_unexpectedly

module Go_log = struct
  let ours_of_go lvl =
    let open Logger.Level in
    match lvl with
    | "error" | "panic" | "fatal" ->
        Error
    | "warn" ->
        Debug
    | "info" ->
        (* this is intentionally debug, because the go info logs are too verbose for our info *)
        Debug
    | "debug" ->
        Spam
    | _ ->
        Spam

  (* there should be no other levels. *)

  type record =
    { ts : string
    ; module_ : string [@key "logger"]
    ; level : string
    ; msg : string
    ; metadata : Yojson.Safe.t String.Map.t
    }

  let record_of_yojson (json : Yojson.Safe.t) =
    let open Result.Let_syntax in
    let prefix = "Mina_net2.Go_log.record_of_yojson: " in
    let string_of_yojson = function
      | `String s ->
          Ok s
      | _ ->
          Error "Expected a string"
    in
    let take_string map key =
      match Map.find map key with
      | Some json -> (
          match string_of_yojson json with
          | Ok value ->
              Ok (value, Map.remove map key)
          | Error err ->
              Error
                (Printf.sprintf "%sCould not parse field '%s': %s" prefix key
                   err) )
      | None ->
          Error (Printf.sprintf "%sField '%s' is required" prefix key)
    in
    let rewrite_key map bad_key good_key =
      match Map.find map bad_key with
      | Some data -> (
          match Map.remove map bad_key |> Map.add ~key:good_key ~data with
          | `Ok map' ->
              Ok map'
          | `Duplicate ->
              Error
                (Printf.sprintf "%sField '%s' should not already exist" prefix
                   good_key) )
      | None ->
          Ok map
    in
    match json with
    | `Assoc fields ->
        let obj = String.Map.of_alist_exn fields in
        let%bind ts, obj = take_string obj "ts" in
        let%bind module_, obj = take_string obj "logger" in
        let%bind level, obj = take_string obj "level" in
        let%bind msg, obj = take_string obj "msg" in
        let%map metadata = rewrite_key obj "error" "go_error" in
        { ts; module_; level; msg; metadata }
    | _ ->
        Error (prefix ^ "Expected a JSON object")

  let record_to_message r =
    Logger.Message.
      { timestamp = Time.of_string r.ts
      ; level = ours_of_go r.level
      ; source =
          Some
            (Logger.Source.create
               ~module_:(sprintf "Libp2p_helper.Go.%s" r.module_)
               ~location:"(not tracked)")
      ; message = String.concat [ "libp2p_helper: "; r.msg ]
      ; metadata = r.metadata
      ; event_id = None
      }
end

let%test "record_of_yojson 1" =
  let lines =
    [ "{\"level\":\"info\",\"ts\":\"2021-09-20T16:36:34.150+0300\",\"logger\":\"helper \
       top-level JSON handling\",\"msg\":\"libp2p_helper has the following \
       logging subsystems active: [badger swarm2 p2p-config dht blankhost \
       connmgr ipns mplex reuseport-transport tcp-tpt basichost autorelay \
       addrutil dht.pb providers dht/RtRefreshManager mdns routedhost table \
       routing/record peerstore/ds test-logger peerstore autonat helper \
       top-level JSON handling relay codanet.Helper eventlog discovery nat \
       net/identify ping pubsub stream-upgrader diversityFilter]\"}"
    ; "2021/09/20 17:38:12 capnp: decode: too many segments to decode"
    ]
  in
  List.equal Bool.equal
    (List.map
       ~f:(fun line ->
         try
           match line |> Yojson.Safe.from_string |> Go_log.record_of_yojson with
           | Ok _ ->
               true
           | Error _ ->
               false
         with _ -> false)
       lines)
    [ true; false ]

type t =
  { process : Child_processes.t
  ; logger : Logger.t
  ; mutable finished : bool
  ; outstanding_requests :
      Libp2p_ipc.rpc_response_body Or_error.t Ivar.t
      Libp2p_ipc.Sequence_number.Table.t
  }

let handle_libp2p_helper_termination t ~pids ~killed result =
  Hashtbl.iter t.outstanding_requests ~f:(fun iv ->
      Ivar.fill_if_empty iv
        (Or_error.error_string "libp2p_helper process died before answering")) ;
  Hashtbl.clear t.outstanding_requests ;
  Child_processes.Termination.remove pids (Child_processes.pid t.process) ;
  if (not killed) && not t.finished then (
    match result with
    | Ok ((Error (`Exit_non_zero _) | Error (`Signal _)) as e) ->
        [%log' fatal t.logger]
          !"libp2p_helper process died unexpectedly: $exit_status"
          ~metadata:
            [ ("exit_status", `String (Unix.Exit_or_signal.to_string_hum e)) ] ;
        t.finished <- true ;
        raise Libp2p_helper_died_unexpectedly
    | Error err ->
        [%log' fatal t.logger]
          !"Child processes library could not track libp2p_helper process: $err"
          ~metadata:[ ("err", Error_json.error_to_yojson err) ] ;
        t.finished <- true ;
        let%map () = Deferred.ignore_m (Child_processes.kill t.process) in
        raise Libp2p_helper_died_unexpectedly
    | Ok (Ok ()) ->
        [%log' error t.logger]
          "libp2p helper process exited peacefully but it should have been \
           killed by shutdown!" ;
        Deferred.unit )
  else
    let exit_status =
      match result with
      | Ok e ->
          `String (Unix.Exit_or_signal.to_string_hum e)
      | Error err ->
          Error_json.error_to_yojson err
    in
    [%log' info t.logger]
      !"libp2p_helper process killed successfully: $exit_status"
      ~metadata:[ ("exit_status", exit_status) ] ;
    Deferred.unit

let handle_incoming_message t msg ~handle_push_message =
  let open Libp2p_ipc.Reader in
  let open DaemonInterface.Message in
  let record_message_delay time_sent_ipc =
    let message_delay =
      Time_ns.diff (Time_ns.now ())
        (Libp2p_ipc.unix_nano_to_time_span time_sent_ipc)
    in
    Mina_metrics.Network.(
      Ipc_latency_histogram.observe ipc_latency_ns_summary
        (Time_ns.Span.to_ns message_delay))
  in
  match msg with
  | RpcResponse rpc_response ->
      O1trace.time_execution' "handling_libp2p_helper_subprocess_rpc_response"
        (fun () ->
          let rpc_header =
            Libp2pHelperInterface.RpcResponse.header_get rpc_response
          in
          let sequence_number =
            RpcMessageHeader.sequence_number_get rpc_header
          in
          record_message_delay (RpcMessageHeader.time_sent_get rpc_header) ;
          match Hashtbl.find t.outstanding_requests sequence_number with
          | Some ivar ->
              if Ivar.is_full ivar then
                [%log' error t.logger]
                  "Attempted fill outstanding libp2p_helper RPC request more \
                   than once"
              else
                Ivar.fill ivar
                  (Libp2p_ipc.rpc_response_to_or_error rpc_response)
          | None ->
              [%log' error t.logger]
                "Attempted to fill outstanding libp2p_helper RPC request, but \
                 not outstanding request was found") ;
      Deferred.unit
  | PushMessage push_msg ->
      O1trace.time_execution "handling_libp2p_helper_subprocess_push" (fun () ->
          let push_header = DaemonInterface.PushMessage.header_get push_msg in
          record_message_delay (PushMessageHeader.time_sent_get push_header) ;
          handle_push_message t (DaemonInterface.PushMessage.get push_msg))
  | Undefined n ->
      Libp2p_ipc.undefined_union ~context:"DaemonInterface.Message" n ;
      Deferred.unit

let spawn ~logger ~pids ~conf_dir ~handle_push_message =
  let termination_handler = ref (fun ~killed:_ _result -> Deferred.unit) in
  match%map
    Child_processes.start_custom ~logger ~name:"libp2p_helper"
      ~git_root_relative_path:"src/app/libp2p_helper/result/bin/libp2p_helper"
      ~conf_dir ~args:[] ~stdout:`Chunks ~stderr:`Lines
      ~termination:
        (`Handler
          (fun ~killed _process result -> !termination_handler ~killed result))
  with
  | Error e ->
      Or_error.tag (Error e)
        ~tag:
          "Could not start libp2p_helper. If you are a dev, did you forget to \
           `make libp2p_helper` and set MINA_LIBP2P_HELPER_PATH? Try \
           MINA_LIBP2P_HELPER_PATH=$PWD/src/app/libp2p_helper/result/bin/libp2p_helper."
  | Ok process ->
      Child_processes.register_process pids process Libp2p_helper ;
      let t =
        { process
        ; logger
        ; finished = false
        ; outstanding_requests = Libp2p_ipc.Sequence_number.Table.create ()
        }
      in
      termination_handler := handle_libp2p_helper_termination t ~pids ;
      O1trace.time_execution "handling_libp2p_helper_subprocess_logs" (fun () ->
          trace_recurring_task "process libp2p_helper stderr" (fun () ->
              Child_processes.stderr process
              |> Strict_pipe.Reader.iter ~f:(fun line ->
                     let record_result =
                       let open Result.Let_syntax in
                       let%bind json =
                         try Ok (Yojson.Safe.from_string line)
                         with Yojson.Json_error error ->
                           Error
                             (Printf.sprintf "Failed to parse json line: %s"
                                error)
                       in
                       Go_log.record_of_yojson json
                     in
                     ( match record_result with
                     | Ok record ->
                         record |> Go_log.record_to_message |> Logger.raw logger
                     | Error error ->
                         [%log error]
                           "failed to parse record over libp2p_helper stderr: \
                            $error"
                           ~metadata:[ ("error", `String error) ] ) ;
                     Deferred.unit))) ;
      O1trace.time_execution "handling_libp2p_helper_incoming_ipc" (fun () ->
          trace_recurring_task "process libp2p_helper stdout" (fun () ->
              O1trace.time_execution "read_libp2p_helper_ipc_incoming"
                (fun () ->
                  Child_processes.stdout process
                  |> Libp2p_ipc.read_incoming_messages)
              |> Strict_pipe.Reader.iter ~f:(function
                   | Ok msg ->
                       msg |> Libp2p_ipc.Reader.DaemonInterface.Message.get
                       |> handle_incoming_message t ~handle_push_message
                   | Error error ->
                       [%log error]
                         "failed to parse IPC message over libp2p_helper \
                          stdout: $error"
                         ~metadata:
                           [ ("error", `String (Error.to_string_hum error)) ] ;
                       Deferred.unit))) ;
      Or_error.return t

let shutdown t =
  t.finished <- true ;
  Deferred.ignore_m (Child_processes.kill t.process)

let do_rpc (type a b) (t : t) ((module Rpc) : (a, b) Libp2p_ipc.Rpcs.rpc)
    (request : a) : b Deferred.Or_error.t =
  let open Deferred.Or_error.Let_syntax in
  if
    (not t.finished)
    && (not @@ Writer.is_closed (Child_processes.stdin t.process))
  then (
    [%log' spam t.logger] "sending $message_type to libp2p_helper"
      ~metadata:[ ("message_type", `String Rpc.name) ] ;
    let ivar = Ivar.create () in
    let sequence_number = Libp2p_ipc.Sequence_number.create () in
    Hashtbl.add_exn t.outstanding_requests ~key:sequence_number ~data:ivar ;
    request |> Rpc.Request.to_rpc_request_body
    |> Libp2p_ipc.create_rpc_request ~sequence_number
    |> Libp2p_ipc.rpc_request_to_outgoing_message
    |> Libp2p_ipc.write_outgoing_message (Child_processes.stdin t.process) ;
    let%bind response = Ivar.read ivar in
    match Rpc.Response.of_rpc_response_body response with
    | Some r ->
        Deferred.Or_error.return r
    | None ->
        Deferred.Or_error.error_string "invalid RPC response" )
  else
    Deferred.Or_error.errorf "helper process already exited (doing RPC %s)"
      Rpc.name

let send_validation t ~validation_id ~validation_result =
  if
    (not t.finished)
    && (not @@ Writer.is_closed (Child_processes.stdin t.process))
  then
    Libp2p_ipc.create_push_message ~validation_id ~validation_result
    |> Libp2p_ipc.push_message_to_outgoing_message
    |> Libp2p_ipc.write_outgoing_message (Child_processes.stdin t.process)
