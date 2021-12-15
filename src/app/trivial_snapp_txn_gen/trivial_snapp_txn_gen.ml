open Core
open Async
open Mina_base

let constraint_constants = Genesis_constants.Constraint_constants.compiled

let proof_level = Genesis_constants.Proof_level.Full

let graphql_snapp_command (parties : Parties.t) =
  let pk_string = Signature_lib.Public_key.Compressed.to_base58_check in
  let authorization (a : Control.t) =
    match a with
    | Proof pi ->
        let p =
          Pickles.Side_loaded.Proof.Stable.V1.sexp_of_t pi
          |> Sexp.to_string |> Base64.encode_exn
        in
        sprintf "{ proof: \"%s\" }" p
    | Signature s ->
        sprintf "{  signature: \"%s\" }" (Signature.to_base58_check s)
    | None_given ->
        "null"
  in
  let permissions (p : Mina_base.Permissions.t Snapp_basic.Set_or_keep.t) =
    match p with
    | Keep ->
        "null"
    | Set
        { stake
        ; edit_state
        ; send
        ; receive
        ; set_delegate
        ; set_permissions
        ; set_verification_key
        ; set_snapp_uri
        ; edit_sequence_state
        ; set_token_symbol
        } ->
        let auth = function
          | Mina_base.Permissions.Auth_required.None ->
              "None"
          | Either ->
              "Either"
          | Proof ->
              "Proof"
          | Signature ->
              "Signature"
          | Both ->
              "Both"
          | Impossible ->
              "Impossible"
        in
        sprintf
          {|
      { stake: %s
  , editState: %s
  , send: %s
  , receive: %s
  , setDelegate: %s
  , setPermissions: %s
  , setVerificationKey: %s
  , setSnappUri: %s
  , editSequenceState: %s
  , setTokenSymbol: %s
      }
    |}
          (if stake then "true" else "false")
          (auth edit_state) (auth send) (auth receive) (auth set_delegate)
          (auth set_permissions)
          (auth set_verification_key)
          (auth set_snapp_uri) (auth edit_sequence_state)
          (auth set_token_symbol)
  in
  let party (p : Party.t) =
    let authorization = authorization p.authorization in
    let predicate =
      match p.data.predicate with
      | Nonce n ->
          sprintf "{ nonce: \"%s\" }" (Account.Nonce.to_string n)
      | Full _a ->
          "{\n\
          \          account: {\n\
          \            balance:null,\n\
          \            nonce:null,\n\
          \            receiptChainHash:null,\n\
          \            publicKey:null,\n\
          \            delegate:null,\n\
          \            state:\n\
          \              {elements: [null,\n\
          \              null,\n\
          \              null,\n\
          \              null,\n\
          \              null,\n\
          \              null,\n\
          \              null,\n\
          \             null]},\n\
          \            sequenceState:null,\n\
          \            provedState:null}}"
      | Accept ->
          ""
    in
    let delta =
      let sgn =
        match Currency.Amount.Signed.sgn p.data.body.delta with
        | Pos ->
            "PLUS"
        | Neg ->
            "MINUS"
      in
      let magnitude =
        Currency.Amount.(to_string (Signed.magnitude p.data.body.delta))
      in
      sprintf "{sign: %s, magnitude: \"%s\"}" sgn magnitude
    in
    let pk = pk_string p.data.body.pk in
    sprintf
      {|
        authorization: %s, 
      data: {
        predicate: %s, 
        body: {
          depth: 0, 
          callData: "0x0000000000000000000000000000000000000000000000000000000000000000", 
          sequenceEvents: [], 
          events: [], 
          delta: %s, 
          tokenId: "1", 
          update: {
            timing: null, 
            tokenSymbol: null, 
            snappUri: null, 
            permissions: %s, 
            verificationKey: null, 
            delegate: null, 
            appState: [
          null ,
          null,
          null,
          null,
          null,
          null,
          null,
          null]}, 
          publicKey: "%s"}}
    |}
      authorization predicate delta
      (permissions p.data.body.update.permissions)
      pk
  in
  let fee_payer =
    let p = parties.fee_payer in
    let authorization = Signature.to_base58_check p.authorization in
    let nonce = Account.Nonce.to_string p.data.predicate in
    let fee = Currency.Fee.to_string p.data.body.delta in
    let pk = pk_string p.data.body.pk in
    sprintf
      {|
        authorization: "%s", 
      data: {
        predicate: "%s", 
        body: {
          depth: "0", 
          callData: "0x0000000000000000000000000000000000000000000000000000000000000000", 
          sequenceEvents:[], 
          events: [], 
          fee: %s, 
          update: {
            timing: null, 
            tokenSymbol: null, 
            snappUri: null, 
            permissions: %s, 
            verificationKey: null, 
            delegate: null, 
            appState: [
          null ,
          null,
          null,
          null,
          null,
          null,
          null,
          null]}, 
          pk: "%s" }
        |}
      authorization nonce fee
      (permissions p.data.body.update.permissions)
      pk
  in
  let other_parties =
    let start = ref true in
    let a =
      List.fold ~init:"[" parties.other_parties ~f:(fun acc p ->
          let p = party p in
          let sep =
            if !start then (
              start := false ;
              "" )
            else ","
          in
          acc ^ sprintf "%s { %s }" sep p)
    in
    a ^ "]"
  in
  sprintf
    {|
mutation MyMutation {
  __typename
  sendSnapp(input: {
        protocolState: {
      nextEpochData: {
        epochLength: null, 
        lockCheckpoint: null, 
        startCheckpoint: null, 
        seed: null, 
        ledger: {
          totalCurrency: null, 
          hash: null}}, 
      stakingEpochData: {
        epochLength: null, 
        lockCheckpoint: null, 
        startCheckpoint: null, 
        seed: null, 
        ledger: {
          totalCurrency: null, 
          hash: null}}, 
      globalSlotSinceGenesis: null, 
      globalSlotSinceHardFork: null, 
      totalCurrency: null, 
      minWindowDensity: null, 
      blockchainLength: null, 
      timestamp: null, 
      snarkedNextAvailableToken: null, 
      snarkedLedgerHash: null}, 
    otherParties: %s, 
    feePayer: {%s} }})
}
    |}
    other_parties fee_payer

module T = Transaction_snark.Make (struct
  let constraint_constants = constraint_constants

  let proof_level = proof_level
end)

let generate_snapp_txn (keypair : Signature_lib.Keypair.t) (ledger : Ledger.t) =
  let open Deferred.Let_syntax in
  let receiver =
    Quickcheck.random_value Signature_lib.Public_key.Compressed.gen
  in
  let spec =
    { Transaction_logic.For_tests.Transaction_spec.sender =
        (keypair, Account.Nonce.zero)
    ; fee = Currency.Fee.of_int 10000000000 (*1 Mina*)
    ; receiver
    ; amount = Currency.Amount.of_int 10000000000 (*10 Mina*)
    }
  in
  let%bind parties =
    Transaction_snark.For_tests.create_trivial_predicate_snapp
      ~constraint_constants spec ledger
  in
  Core.printf "Snapp transaction yojson: %s\n\n%!"
    (Parties.to_yojson parties |> Yojson.Safe.to_string) ;
  Core.printf "Snapp transaction graphQL input %s\n\n%!"
    (graphql_snapp_command parties) ;
  Core.printf "Updated accounts\n" ;
  List.iter (Ledger.to_list ledger) ~f:(fun acc ->
      Core.printf "Account: %s\n%!"
        ( Genesis_ledger_helper_lib.Accounts.Single.of_account acc None
        |> Runtime_config.Accounts.Single.to_yojson |> Yojson.Safe.to_string )) ;
  let consensus_constants =
    Consensus.Constants.create ~constraint_constants
      ~protocol_constants:Genesis_constants.compiled.protocol
  in
  let state_body =
    let compile_time_genesis =
      (*not using Precomputed_values.for_unit_test because of dependency cycle*)
      Mina_state.Genesis_protocol_state.t
        ~genesis_ledger:Genesis_ledger.(Packed.t for_unit_tests)
        ~genesis_epoch_data:Consensus.Genesis_epoch_data.for_unit_tests
        ~constraint_constants ~consensus_constants
    in
    compile_time_genesis.data |> Mina_state.Protocol_state.body
  in
  let witnesses =
    Transaction_snark.parties_witnesses_exn ~constraint_constants ~state_body
      ~fee_excess:Currency.Amount.Signed.zero
      ~pending_coinbase_init_stack:Pending_coinbase.Stack.empty (`Ledger ledger)
      [ parties ]
  in
  let open Async.Deferred.Let_syntax in
  let%map _ =
    Async.Deferred.List.fold ~init:((), ()) (List.rev witnesses)
      ~f:(fun _ ((witness, spec, statement, snapp_statement) as w) ->
        Core.printf "%s"
          (sprintf
             !"current witness \
               %{sexp:(Transaction_witness.Parties_segment_witness.t * \
               Transaction_snark.Parties_segment.Basic.t * \
               Transaction_snark.Statement.With_sok.t * (int * \
               Snapp_statement.t)option) }%!"
             w) ;
        let%map _ =
          T.of_parties_segment_exn ~snapp_statement ~statement ~witness ~spec
        in
        ((), ()))
  in
  ()

let main keyfile config_file () =
  let open Deferred.Let_syntax in
  let%bind keypair =
    Secrets.Keypair.Terminal_stdin.read_exn ~should_prompt_user:false
      ~which:"payment keypair" keyfile
  in
  let%bind ledger =
    let%map config_json = Genesis_ledger_helper.load_config_json config_file in
    let runtime_config =
      Or_error.ok_exn config_json
      |> Runtime_config.of_yojson |> Result.ok_or_failwith
    in
    let accounts =
      let config = Option.value_exn runtime_config.Runtime_config.ledger in
      match config.base with
      | Accounts accounts ->
          lazy (Genesis_ledger_helper.Accounts.to_full accounts)
      | _ ->
          failwith "invlaid genesis ledger- pass all the accounts"
    in
    let packed =
      Genesis_ledger_helper.Ledger.packed_genesis_ledger_of_accounts
        ~depth:constraint_constants.ledger_depth accounts
    in
    Lazy.force (Genesis_ledger.Packed.t packed)
  in
  generate_snapp_txn keypair ledger

let () =
  Command.(
    run
      (let open Let_syntax in
      Command.async
        ~summary:
          "Generate a trivial snapp transaction and genesis ledger with \
           verification key for testing"
        (let%map keyfile =
           Param.flag "--fee-payer-key"
             ~doc:
               "KEYFILE Private key file for the fee payer of the transaction \
                (should be in the genesis ledger)"
             Param.(required string)
         and config_file =
           Param.flag "--config-file" ~aliases:[ "config-file" ]
             ~doc:
               "PATH path to a configuration file consisting the genesis ledger"
             Param.(required string)
         in
         main keyfile config_file)))
