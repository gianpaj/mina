open Core_kernel
open Currency
open Mina_base
open Mina_numbers
open Signature_lib
open Helpers
open Protocol_config_examples
open Unsigned
open Zkapp_cmd_builder

let trials = 100

let balance_to_fee = Fn.compose Amount.to_fee Balance.to_amount

let global_slot_gen_excl low high =
  let open Global_slot in
  let succ a = if a < max_value then Some (add a (of_int 1)) else None in
  let pred a = sub a (of_int 1) in
  let l = Option.map ~f:(gen_incl zero) (pred low) in
  let h = Option.map ~f:(fun x -> gen_incl x max_value) (succ high) in
  Quickcheck.Generator.union (List.filter_map ~f:Fn.id [ l; h ])

let find_account ~ledger account =
  let open Option.Let_syntax in
  let account_id = Test_account.account_id account in
  let%bind loc = Ledger.location_of_account ledger account_id in
  Ledger.get ledger loc

let find_account_exn ~ledger account =
  Option.value_exn (find_account ~ledger account)

let gen_valid_while =
  Zkapp_precondition.Closed_interval.gen Global_slot.gen Global_slot.compare

(* This module tests the "pure" transaction logic implemented in this library.
   By "pure" we mean that ZK SNARKs aren't used for verification, instead all
   signatures and proofs are assumed to be valid. These verification details
   are provided by the functor parameters (Inputs module) and a full-featured
   implementation leveraging ZK SNARKs is given in transaction_snark library.

   As a consequence, we don't bother with constructing correct signatures or
   proofs here. We just give dummy signatures because this implementation
   accepts anything anyway. Note, however, that this implementation DOES check
   whether SOME signature or proof is given whenever required. It just doesn't
   validate them. *)
let%test_module "Test transaction logic." =
  ( module struct
    open Transaction_logic.Transaction_applied.Zkapp_command_applied

    let run_zkapp_cmd ~global_slot ~fee_payer ~fee ~accounts txns =
      let open Result.Let_syntax in
      let cmd =
        zkapp_cmd ~noncemap:(noncemap accounts) ~fee:(fee_payer, fee) txns
      in
      let%bind ledger = test_ledger accounts in
      let%map txn, _ =
        Transaction_logic.apply_zkapp_command_unchecked ~constraint_constants
          ~state_view:
            { protocol_state with global_slot_since_genesis = global_slot }
          ~global_slot ledger cmd
      in
      (txn, ledger)

    let%test_unit "Many transactions between distinct accounts." =
      Quickcheck.test ~trials
        (let open Quickcheck in
        let open Quickcheck.Generator.Let_syntax in
        let%bind accs_and_txns =
          Generator.list_non_empty Simple_txn.gen_account_pair_and_txn
          (* Generating too many transactions makes this test take too much time. *)
          |> Generator.filter ~f:(fun l -> List.length l < 10)
        in
        let account_pairs, txns = List.unzip accs_and_txns in
        let accounts =
          List.concat_map account_pairs ~f:(fun (a, b) -> [ a; b ])
        in
        (* Select a receiver to pay the fee. *)
        let%bind fee_payer =
          Generator.of_list @@ List.map ~f:snd account_pairs
        in
        let%bind fee =
          Fee.(gen_incl zero @@ balance_to_fee fee_payer.balance)
        in
        let%map global_slot = Global_slot.gen in
        (global_slot, fee_payer.pk, fee, accounts, (txns :> transaction list)))
        ~f:(fun (global_slot, fee_payer, fee, accounts, txns) ->
          [%test_pred: Zk_cmd_result.t Or_error.t]
            (Predicates.pure ~f:(fun (txn, ledger) ->
                 Transaction_status.equal txn.command.status Applied
                 && Predicates.verify_balance_changes ~txn ~ledger accounts ) )
            (run_zkapp_cmd ~global_slot ~fee_payer ~fee ~accounts txns) )

    let%test_unit "Fee payer must be able to pay the fee." =
      Quickcheck.test ~trials
        (let open Quickcheck in
        let open Generator.Let_syntax in
        let%bind (sender, receiver), txn =
          Simple_txn.gen_account_pair_and_txn
          |> Generator.filter
               ~f:Balance.(fun ((a, _), _) -> a.balance < max_int)
        in
        let accounts = [ sender; receiver ] in
        (* Make sure that fee is too high. *)
        let min_fee =
          Balance.(sender.balance - txn#amount)
          |> Option.value_map ~default:Fee.zero ~f:balance_to_fee
          |> Fee.(fun f -> f + of_nanomina_int_exn 1)
          |> Option.value ~default:Fee.max_int
        in
        let max_fee =
          Fee.(min_fee + of_mina_int_exn 10)
          |> Option.value ~default:Fee.max_int
        in
        let%bind fee = Fee.(gen_incl min_fee max_fee) in
        let%map global_slot = Global_slot.gen in
        (global_slot, sender.pk, fee, accounts, [ (txn :> transaction) ]))
        ~f:(fun (global_slot, fee_payer, fee, accounts, txns) ->
          [%test_pred: Zk_cmd_result.t Or_error.t]
            (Predicates.pure
               ~with_error:(fun e ->
                 String.is_substring (Error.to_string_hum e)
                   ~substring:"Overflow" )
               ~f:(fun (txn, _) ->
                 Transaction_status.equal txn.command.status
                   (Failed [ []; [ Overflow ]; [ Cancelled ] ]) ) )
            (run_zkapp_cmd ~global_slot ~fee_payer ~fee ~accounts txns) )

    let%test_unit "Currency cannot be created out of thin air." =
      Quickcheck.test ~trials
        (let open Quickcheck in
        let open Generator.Let_syntax in
        let%bind account =
          Test_account.gen_constrained_balance ()
            ~max:
              Balance.(
                Option.value_exn @@ (max_int - Amount.of_nanomina_int_exn 1))
        in
        let max_amount =
          Balance.(max_int - to_amount account.balance)
          |> Option.value_map ~default:Amount.zero ~f:Balance.to_amount
        in
        let%bind unsigned_amount =
          Amount.(gen_incl (of_nanomina_int_exn 1) max_amount)
        in
        let amount = Amount.Signed.of_unsigned unsigned_amount in
        let update = Single.make ~account:account.pk amount in
        let%bind fee = Fee.(gen_incl zero (balance_to_fee account.balance)) in
        let%map global_slot = Global_slot.gen in
        (global_slot, account.pk, fee, [ account ], [ (update :> transaction) ]))
        ~f:(fun (global_slot, fee_payer, fee, accounts, txns) ->
          [%test_pred: Zk_cmd_result.t Or_error.t]
            (Predicates.pure ~f:(fun (txn, _) ->
                 Transaction_status.equal txn.command.status
                   (Failed [ []; [ Invalid_fee_excess ] ]) ) )
            (run_zkapp_cmd ~global_slot ~fee_payer ~fee ~accounts txns) )

    let%test_unit "Currency cannot be destroyed." =
      Quickcheck.test ~trials
        (let open Quickcheck in
        let open Generator.Let_syntax in
        let%bind unsigned_amount =
          Amount.(gen_incl (of_nanomina_int_exn 1) max_int)
        in
        let%bind account =
          let min = Balance.of_uint64 @@ Amount.to_uint64 unsigned_amount in
          Test_account.gen_constrained_balance ~min ()
        in
        let amount = Amount.Signed.(negate @@ of_unsigned unsigned_amount) in
        let update = Single.make ~account:account.pk amount in
        let max_fee =
          Balance.(account.balance - unsigned_amount)
          |> Option.value_map ~default:Fee.zero ~f:balance_to_fee
        in
        let%bind fee = Fee.(gen_incl zero max_fee) in
        let%map global_slot = Global_slot.gen in
        (global_slot, account.pk, fee, [ account ], [ (update :> transaction) ]))
        ~f:(fun (global_slot, fee_payer, fee, accounts, txns) ->
          [%test_pred: Zk_cmd_result.t Or_error.t]
            (Predicates.pure ~f:(fun (txn, _) ->
                 Transaction_status.equal txn.command.status
                   (Failed [ []; [ Invalid_fee_excess ] ]) ) )
            (run_zkapp_cmd ~global_slot ~fee_payer ~fee ~accounts txns) )

    let%test_unit "Token_symbol of the account can be altered." =
      Quickcheck.test ~trials
        (let open Quickcheck in
        let open Generator.Let_syntax in
        let%bind account = Test_account.gen in
        (* The symbol is limited to 6 characters, but this limit is being
           enforced elsewhere and, unfortunately we cannot see this function
           fail if the symbol exceeds that limit.*)
        let%bind token = String.gen_with_length 6 Char.gen_uppercase in
        let txn =
          Alter_account.make ~account:account.pk
            { Account_update.Update.noop with token_symbol = Set token }
        in
        let%bind fee = Fee.(gen_incl zero (balance_to_fee account.balance)) in
        let%map global_slot = Global_slot.gen in
        (global_slot, account.pk, fee, [ account ], [ (txn :> transaction) ]))
        ~f:(fun (global_slot, fee_payer, fee, accounts, txns) ->
          [%test_pred: Zk_cmd_result.t Or_error.t]
            (Predicates.pure ~f:(fun (txn, ledger) ->
                 Transaction_status.equal txn.command.status Applied
                 && Predicates.verify_account_updates (List.hd_exn accounts)
                      ~txn ~ledger ~f:(fun balance_change -> function
                      | Some orig, Some updt ->
                          Predicates.verify_balance_change ~balance_change orig
                            updt
                          && not
                               Account.Poly.(
                                 Account.Token_symbol.equal orig.token_symbol
                                   updt.token_symbol)
                      | _ ->
                          false ) ) )
            (run_zkapp_cmd ~global_slot ~fee_payer ~fee ~accounts txns) )

    let%test_unit "Delegate of an account can be set." =
      Quickcheck.test ~trials
        (let open Quickcheck in
        let open Generator.Let_syntax in
        let%bind delegator = Test_account.gen in
        let%bind delegate = Test_account.gen in
        let txn =
          Alter_account.make ~account:delegator.pk
            { Account_update.Update.noop with delegate = Set delegate.pk }
        in
        let%bind fee = Fee.(gen_incl zero (balance_to_fee delegate.balance)) in
        let%map global_slot = Global_slot.gen in
        ( global_slot
        , delegate.pk
        , fee
        , [ delegator; delegate ]
        , [ (txn :> transaction) ] ))
        ~f:(fun (global_slot, fee_payer, fee, accounts, txns) ->
          [%test_pred: Zk_cmd_result.t Or_error.t]
            (Predicates.pure ~f:(fun (txn, ledger) ->
                 let delegator = List.hd_exn accounts in
                 let delegate_pk =
                   (Option.value_exn @@ List.nth accounts 1).pk
                 in
                 Transaction_status.equal txn.command.status Applied
                 && Predicates.verify_account_updates delegator ~txn ~ledger
                      ~f:(fun _ -> function
                      | Some _, Some updt ->
                          Option.equal Public_key.Compressed.equal updt.delegate
                            (Some delegate_pk)
                      | _ ->
                          false ) ) )
            (run_zkapp_cmd ~global_slot ~fee_payer ~fee ~accounts txns) )

    (* It is assumed here that the account is indeed a zkApp account. Presumably
       it's being checked elsewhere. If there's no zkApp associated with the
       account, this update succeeds, but does nothing. For the moment we're ignoring
       the fact that the account isn't being updated. We'll revisit and strengthen
       this test after some refactoring. *)
    let%test_unit "Zkapp URI can be set." =
      Quickcheck.test ~trials
        (let open Quickcheck in
        let open Generator.Let_syntax in
        let%bind account = Test_account.gen_with_zkapp in
        let%bind uri =
          Generator.filter Zkapp_account.gen_uri ~f:(fun uri ->
              Option.value_map account.zkapp ~default:true ~f:(fun zkapp ->
                  not @@ String.equal uri zkapp.zkapp_uri ) )
        in
        let txn =
          Alter_account.make ~account:account.pk
            { Account_update.Update.noop with zkapp_uri = Set uri }
        in
        let%bind fee = Fee.(gen_incl zero (balance_to_fee account.balance)) in
        let%map global_slot = Global_slot.gen in
        ( global_slot
        , account.pk
        , fee
        , [ account ]
        , [ (txn :> transaction) ]
        , uri ))
        ~f:(fun (global_slot, fee_payer, fee, accounts, txns, uri) ->
          [%test_pred: Zk_cmd_result.t Or_error.t]
            (Predicates.pure ~f:(fun (txn, ledger) ->
                 let account = List.hd_exn accounts in
                 Transaction_status.equal txn.command.status Applied
                 && Predicates.verify_account_updates ~txn ~ledger account
                      ~f:(fun _ -> function
                      | Some _, Some updt ->
                          Option.value_map updt.zkapp ~default:false
                            ~f:(fun zkapp -> String.equal uri zkapp.zkapp_uri)
                      | _ ->
                          false ) ) )
            (run_zkapp_cmd ~global_slot ~fee_payer ~fee ~accounts txns) )

    let%test_unit "Timing of an account can be changed." =
      Quickcheck.test ~trials
        (let open Quickcheck in
        let open Generator.Let_syntax in
        let%bind account =
          Test_account.gen_constrained_balance
            ~min:Balance.(of_nanomina_int_exn 1)
            ()
        in
        (* Can't be too big, or else there will be no legal timing for the account. *)
        let global_slot = Global_slot.of_int 100 in
        let%bind timing =
          Account.gen_timing account.balance
          |> Generator.filter
               ~f:(fun
                    { cliff_time
                    ; cliff_amount
                    ; vesting_period
                    ; vesting_increment
                    ; initial_minimum_balance
                    ; _
                    }
                  ->
                 Account.min_balance_at_slot ~global_slot ~cliff_time
                   ~cliff_amount ~vesting_period ~vesting_increment
                   ~initial_minimum_balance
                 |> Balance.(( < ) zero) )
        in
        let timing_info =
          Account.Timing.of_record timing
          |> Account_update.Update.Timing_info.of_account_timing
          |> Option.value_exn
          (* Timing is guaranteed to return a proper timing. *)
        in
        let txn =
          Alter_account.make ~account:account.pk
            { Account_update.Update.noop with timing = Set timing_info }
        in
        (* Fee can't result in the balance falling below the set minimum. *)
        let max_fee =
          Fee.(
            balance_to_fee account.balance
            - balance_to_fee timing.initial_minimum_balance)
          |> Option.value ~default:Fee.zero
        in
        let%map fee = Fee.(gen_incl zero max_fee) in
        ( global_slot
        , account.pk
        , fee
        , [ account ]
        , [ (txn :> transaction) ]
        , timing ))
        ~f:(fun (global_slot, fee_payer, fee, accounts, txns, timing) ->
          [%test_pred: Zk_cmd_result.t Or_error.t]
            (Predicates.pure ~f:(fun (txn, ledger) ->
                 let account = List.hd_exn accounts in
                 Transaction_status.equal txn.command.status Applied
                 && Predicates.verify_account_updates account ~txn ~ledger
                      ~f:(fun _ -> function
                      | Some orig, Some updt ->
                          let open Account.Timing in
                          equal orig.timing Untimed
                          && equal updt.timing (Account.Timing.of_record timing)
                      | _ ->
                          false ) ) )
            (run_zkapp_cmd ~global_slot ~fee_payer ~fee ~accounts txns) )

    let%test_unit "Minimum balance cannot be set below the actual balance." =
      Quickcheck.test ~trials
        (let open Quickcheck in
        let open Generator.Let_syntax in
        let%bind global_slot = Global_slot.(gen_incl zero (of_int 100)) in
        let gen_timing =
          let%map t = Account.gen_timing Balance.max_int in
          let minimum_balance =
            Account.min_balance_at_slot ~global_slot
              ~initial_minimum_balance:t.initial_minimum_balance
              ~vesting_period:t.vesting_period
              ~vesting_increment:t.vesting_increment ~cliff_time:t.cliff_time
              ~cliff_amount:t.cliff_amount
          in
          (t, minimum_balance)
        in
        let%bind timing, minimum_balance =
          Generator.filter gen_timing
            ~f:Balance.(fun (_, min_bal) -> min_bal > of_nanomina_int_exn 1)
        in
        let%map account =
          Test_account.gen_constrained_balance ()
            ~min:Balance.(of_nanomina_int_exn 1)
            ~max:
              Balance.(
                Option.value ~default:max_int
                @@ (minimum_balance - Amount.of_nanomina_int_exn 1))
        in
        let timing_info =
          Account.Timing.of_record timing
          |> Account_update.Update.Timing_info.of_account_timing
          |> Option.value_exn
          (* Timing is guaranteed to return a proper timing. *)
        in
        let txn =
          Alter_account.make ~account:account.pk
            { Account_update.Update.noop with timing = Set timing_info }
        in
        ( global_slot
        , account.pk
        , Fee.zero
        , [ account ]
        , [ (txn :> transaction) ] ))
        ~f:(fun (global_slot, fee_payer, fee, accounts, txns) ->
          [%test_pred: Zk_cmd_result.t Or_error.t]
            (Predicates.pure ~f:(fun (txn, _ledger) ->
                 Transaction_status.equal txn.command.status
                   (Failed [ []; [ Source_minimum_balance_violation ] ]) ) )
            (run_zkapp_cmd ~global_slot ~fee_payer ~fee ~accounts txns) )

    let%test_unit "The account's voting choice can be changed." =
      Quickcheck.test ~trials
        (let open Quickcheck.Generator.Let_syntax in
        let%bind account = Test_account.gen in
        let%bind state_hash = State_hash.gen in
        let txn =
          Alter_account.make ~account:account.pk
            { Account_update.Update.noop with voting_for = Set state_hash }
        in
        let%bind fee = Fee.(gen_incl zero (balance_to_fee account.balance)) in
        let%map global_slot = Global_slot.gen in
        ( global_slot
        , account.pk
        , fee
        , [ account ]
        , [ (txn :> transaction) ]
        , state_hash ))
        ~f:(fun (global_slot, fee_payer, fee, accounts, txns, voting_choice) ->
          [%test_pred: Zk_cmd_result.t Or_error.t]
            (Predicates.pure ~f:(fun (txn, ledger) ->
                 let account = List.hd_exn accounts in
                 Transaction_status.equal txn.command.status Applied
                 && Predicates.verify_account_updates account ~ledger ~txn
                      ~f:(fun _ -> function
                      | Some orig, Some updt ->
                          let open State_hash in
                          equal orig.voting_for zero
                          && equal updt.voting_for voting_choice
                      | _ ->
                          false ) ) )
            (run_zkapp_cmd ~global_slot ~fee_payer ~fee ~accounts txns) )

    let%test_unit "The account's permissions can be changed." =
      Quickcheck.test ~trials
        (let open Quickcheck.Generator.Let_syntax in
        let%bind account = Test_account.gen in
        let%bind perms = Permissions.gen ~auth_tag:Proof in
        let txn =
          Alter_account.make ~account:account.pk
            { Account_update.Update.noop with permissions = Set perms }
        in
        let%bind fee = Fee.(gen_incl zero (balance_to_fee account.balance)) in
        let%map global_slot = Global_slot.gen in
        ( global_slot
        , account.pk
        , fee
        , [ account ]
        , [ (txn :> transaction) ]
        , perms ))
        ~f:(fun (global_slot, fee_payer, fee, accounts, txns, perms) ->
          [%test_pred: Zk_cmd_result.t Or_error.t]
            (Predicates.pure ~f:(fun (txn, ledger) ->
                 let account = List.hd_exn accounts in
                 Transaction_status.equal txn.command.status Applied
                 && Predicates.verify_account_updates account ~txn ~ledger
                      ~f:(fun _ -> function
                      | Some _, Some updt ->
                          Permissions.equal updt.permissions perms
                      | _ ->
                          false ) ) )
            (run_zkapp_cmd ~global_slot ~fee_payer ~fee ~accounts txns) )

    let%test_unit "Zkapp account's state can be changed." =
      Quickcheck.test ~trials
        (let open Quickcheck in
        let open Generator.Let_syntax in
        let%bind account = Test_account.gen_with_zkapp in
        let%bind fee = Fee.(gen_incl zero (balance_to_fee account.balance)) in
        let gen_field =
          Generator.create (fun ~size:_ ~random:_ -> Zkapp_basic.F.random ())
        in
        let%bind app_state_update =
          Generator.list_with_length 8 (Zkapp_basic.Set_or_keep.gen gen_field)
        in
        let app_state = Zkapp_state.V.of_list_exn app_state_update in
        let txn =
          Alter_account.make ~account:account.pk
            { Account_update.Update.noop with app_state }
        in
        let zk_app_state =
          (Option.value_exn account.zkapp).app_state |> Zkapp_state.V.to_list
          |> List.map2_exn app_state_update ~f:(fun update state ->
                 match update with Keep -> state | Set new_state -> new_state )
          |> Zkapp_state.V.of_list_exn
        in
        let%map global_slot = Global_slot.gen in
        ( global_slot
        , account.pk
        , fee
        , [ account ]
        , [ (txn :> transaction) ]
        , zk_app_state ))
        ~f:(fun (global_slot, fee_payer, fee, accounts, txns, zkapp_state) ->
          [%test_pred: Zk_cmd_result.t Or_error.t]
            (Predicates.pure ~f:(fun (txn, ledger) ->
                 Transaction_status.equal txn.command.status Applied
                 && List.for_all accounts
                      ~f:
                        (Predicates.verify_account_updates ~ledger ~txn
                           ~f:(fun _ -> function
                           | _, Some updt ->
                               let open Zkapp_account in
                               Option.value_map ~default:false
                                 ~f:(fun zkapp ->
                                   Zkapp_state.V.equal Zkapp_basic.F.equal
                                     zkapp.app_state zkapp_state )
                                 updt.zkapp
                           | _ ->
                               false ) ) ) )
            (run_zkapp_cmd ~global_slot ~fee_payer ~fee ~accounts txns) )

    (* Note that the change to the permissions takes effect immediately and can
       influence further updates. *)
    let%test_unit "After permissions were set to proof-only, signatures are \
                   insufficient authorization for making transactions." =
      Quickcheck.test ~trials
        (let open Quickcheck in
        let open Generator.Let_syntax in
        let%bind sender =
          Test_account.gen_constrained_balance () ~min:Balance.one
        in
        let%bind receiver =
          Test_account.gen_constrained_balance ()
            ~max:Balance.(Option.value_exn (max_int - Amount.one))
        in
        let%bind perms = Permissions.gen ~auth_tag:Proof in
        let max_amount =
          let open Balance in
          max_int - to_amount receiver.balance
          |> Option.value ~default:(of_nanomina_int_exn 1)
          |> min sender.balance |> to_amount
        in
        let%bind amount =
          Amount.(gen_incl (of_nanomina_int_exn 1) max_amount)
        in
        let alter_perms =
          Alter_account.make ~account:sender.pk
            { Account_update.Update.noop with
              (* These settings actually matter for this scenario, so they must
                 be fixed. We try to increment nonces in the process, so that
                 must *not* require authorisation or we will see more errors
                 than expected. *)
              permissions =
                Set { perms with send = Proof; increment_nonce = None }
            }
        in
        let mina_transfer =
          Simple_txn.make ~sender:sender.pk ~receiver:receiver.pk amount
        in
        let txns =
          [ (alter_perms :> transaction); (mina_transfer :> transaction) ]
        in
        let%bind fee = Fee.(gen_incl zero (balance_to_fee receiver.balance)) in
        let%map global_slot = Global_slot.gen in
        (global_slot, receiver.pk, fee, [ sender; receiver ], txns))
        ~f:(fun (global_slot, fee_payer, fee, accounts, txns) ->
          [%test_pred: Zk_cmd_result.t Or_error.t]
            (Predicates.pure ~f:(fun (txn, _ledger) ->
                 Transaction_status.equal txn.command.status
                   (Failed
                      [ []
                      ; [ Cancelled ]
                      ; [ Update_not_permitted_balance ]
                      ; [ Cancelled ]
                      ] ) ) )
            (run_zkapp_cmd ~global_slot ~fee_payer ~fee ~accounts txns) )

    let%test_unit "All updates must succeed or none is applied." =
      (* But the fee is still paid. *)
      Quickcheck.test ~trials
        (let open Quickcheck in
        let open Generator.Let_syntax in
        let%bind sender =
          Test_account.gen_constrained_balance ~min:Balance.one ()
        in
        let%bind amounts = gen_balance_split ~limit:2 sender.balance in
        let amount1 = List.hd_exn amounts in
        let fee =
          List.nth amounts 1
          |> Option.value_map ~default:Fee.zero ~f:Amount.to_fee
        in
        let%bind amount2 = Amount.(gen_incl (of_nanomina_int_exn 1) max_int) in
        let%bind receiver1 = Test_account.gen_empty in
        let%bind receiver2 = Test_account.gen_empty in
        let txn1 =
          Simple_txn.make ~sender:sender.pk ~receiver:receiver1.pk amount1
        in
        let txn2 =
          Simple_txn.make ~sender:sender.pk ~receiver:receiver2.pk amount2
        in
        let%map global_slot = Global_slot.gen in
        ( global_slot
        , sender.pk
        , fee
        , [ sender; receiver1; receiver2 ]
        , ([ txn1; txn2 ] :> transaction list) ))
        ~f:(fun (global_slot, fee_payer, fee, accounts, txns) ->
          [%test_pred: Zk_cmd_result.t Or_error.t]
            (Predicates.pure ~f:(fun (txn, ledger) ->
                 Transaction_status.equal txn.command.status
                   (Failed
                      [ []
                      ; [ Cancelled ]
                      ; [ Cancelled ]
                      ; [ Overflow ]
                      ; [ Cancelled ]
                      ] )
                 && Predicates.verify_balances_unchanged ~txn ~ledger accounts )
            )
            (run_zkapp_cmd ~global_slot ~fee_payer ~fee ~accounts txns) )

    let%test_unit "If fee can't be paid, operation results in an error." =
      Quickcheck.test ~trials
        (let open Quickcheck in
        let open Generator.Let_syntax in
        let%bind delegator =
          Test_account.gen_constrained_balance ()
            ~max:Balance.(Option.value_exn (max_int - Amount.one))
        in
        let%bind delegate = Test_account.gen in
        let txn =
          Alter_account.make ~account:delegator.pk
            { Account_update.Update.noop with delegate = Set delegate.pk }
        in
        let min_fee =
          Balance.(delegator.balance + Amount.one)
          |> Option.value_map ~f:balance_to_fee ~default:Fee.max_int
        in
        let%bind fee = Fee.(gen_incl min_fee max_int) in
        let%map global_slot = Global_slot.gen in
        ( global_slot
        , delegator.pk
        , fee
        , [ delegator; delegate ]
        , [ (txn :> transaction) ] ))
        ~f:(fun (global_slot, fee_payer, fee, accounts, txns) ->
          [%test_pred: Zk_cmd_result.t Or_error.t]
            (function
              | Ok _ ->
                  false
              | Error e ->
                  String.is_substring ~substring:"Overflow"
                    (Error.to_string_hum e) )
            (run_zkapp_cmd ~global_slot ~fee_payer ~fee ~accounts txns) )

    let%test_unit "Fee must be payed before account updates are processed." =
      (* In particular the fee payer cannot pay the fee with funds obtained from
         account updates. In this scenario, fee is smaller than the amount given
         to the fee payer; but the fee needs to be paid first. *)
      Quickcheck.test ~trials
        (let open Quickcheck in
        let open Generator.Let_syntax in
        let%bind fee_payer = Test_account.gen_empty in
        let%bind account =
          Test_account.gen_constrained_balance ()
            ~min:Balance.(of_mina_int_exn 1)
        in
        let%bind amount =
          Amount.(gen_incl one Balance.(to_amount account.balance))
        in
        let%bind fee = Fee.(gen_incl one Amount.(to_fee amount)) in
        let txn =
          Simple_txn.make ~sender:account.pk ~receiver:fee_payer.pk amount
        in
        let%map global_slot = Global_slot.gen in
        ( global_slot
        , fee_payer.pk
        , fee
        , [ fee_payer; account ]
        , [ (txn :> transaction) ] ))
        ~f:(fun (global_slot, fee_payer, fee, accounts, txns) ->
          [%test_pred: Zk_cmd_result.t Or_error.t]
            (function
              | Ok _ ->
                  false
              | Error e ->
                  String.is_substring (Error.to_string_hum e)
                    ~substring:"Overflow" )
            (run_zkapp_cmd ~global_slot ~fee_payer ~fee ~accounts txns) )

    let%test_unit "Funds from a single subtraction can be distributed." =
      Quickcheck.test ~trials
        (let open Quickcheck in
        let open Generator.Let_syntax in
        let%bind recv_count = Int.gen_incl 15 99 in
        let%bind sender =
          Test_account.gen_constrained_balance ()
            ~min:Balance.(of_nanomina_int_exn recv_count)
        in
        let amount =
          UInt64.Infix.(
            Balance.to_uint64 sender.balance / UInt64.of_int recv_count)
          |> Amount.of_uint64
        in
        let total = Option.value_exn Amount.(scale amount recv_count) in
        let%bind receivers =
          Generator.list_with_length recv_count
          @@ Test_account.gen_constrained_balance ()
               ~max:Balance.(Option.value_exn @@ (max_int - amount))
        in
        let txns =
          Single.make ~account:sender.pk
            Amount.Signed.(negate @@ of_unsigned total)
          :: List.map receivers ~f:(fun r ->
                 Single.make ~account:r.pk Amount.Signed.(of_unsigned amount) )
        in
        let max_fee =
          Balance.(sender.balance - total)
          |> Option.value_map ~f:balance_to_fee ~default:Fee.zero
        in
        let%bind fee = Fee.(gen_incl zero max_fee) in
        let%map global_slot = Global_slot.gen in
        ( global_slot
        , sender.pk
        , fee
        , sender :: receivers
        , (txns :> transaction list) ))
        ~f:(fun (global_slot, fee_payer, fee, accounts, txns) ->
          [%test_pred: Zk_cmd_result.t Or_error.t]
            (Predicates.pure ~f:(fun (txn, ledger) ->
                 Transaction_status.equal txn.command.status Applied
                 && Predicates.verify_balance_changes ~txn ~ledger accounts ) )
            (run_zkapp_cmd ~global_slot ~fee_payer ~fee ~accounts txns) )

    let%test_unit "Balance updates are being applied in turn." =
      (* Balance changes are not being squashed before application. If they did,
         all balance changes in this transaction would cancel out and it could be
         applied successfully. *)
      Quickcheck.test ~trials
        (let open Quickcheck in
        let open Generator.Let_syntax in
        let%bind total_currency =
          Balance.(gen_incl (of_nanomina_int_exn 4) max_int)
        in
        let balance =
          Balance.(of_uint64 UInt64.(div (to_uint64 total_currency) (of_int 2)))
        in
        let%bind accounts =
          Generator.list_with_length 2 Test_account.gen_empty
        in
        let alice = { (List.hd_exn accounts) with balance } in
        let bob = { (List.last_exn accounts) with balance } in
        (* Transfer more currency than the available total. *)
        let amount =
          Amount.Signed.of_unsigned @@ Balance.to_amount total_currency
        in
        let txns =
          List.concat_map [ alice; bob ] ~f:(fun account ->
              let open Amount.Signed in
              [ Single.make ~account:account.pk (negate amount)
              ; Single.make ~account:account.pk amount
              ] )
        in
        let%map global_slot = Global_slot.gen in
        ( global_slot
        , alice.pk
        , Fee.zero
        , [ alice; bob ]
        , (txns :> transaction list) ))
        ~f:(fun (global_slot, fee_payer, fee, accounts, txns) ->
          [%test_pred: Zk_cmd_result.t Or_error.t]
            (Predicates.pure ~f:(fun (txn, _ledger) ->
                 Transaction_status.equal txn.command.status
                   (Failed
                      [ []
                      ; [ Overflow ]
                      ; [ Overflow ]
                      ; [ Overflow ]
                      ; [ Overflow ]
                      ] ) ) )
            (run_zkapp_cmd ~global_slot ~fee_payer ~fee ~accounts txns) )

    (* Assign all funds to a single account, then split these funds among two more
       accounts; then each of these splits their funds among 2 more accounts and so
       on. These updates are organised into a deep tree instead of a flat list. *)
    let%test_unit "Account updates can be organised into trees." =
      Quickcheck.test ~trials:1
        (let open Quickcheck in
        let open Generator.Let_syntax in
        let%bind accounts =
          Generator.list_with_length 127 Test_account.gen_empty
        in
        let accounts =
          match accounts with
          | [] ->
              assert false (* can't happen *)
          | a :: acs ->
              { a with balance = Balance.max_int } :: acs
        in
        let rec gen_txns (funds : Amount.t) :
            Test_account.t list -> transaction list = function
          | sender :: receiver1 :: receiver2 :: accs ->
              let remaining_accounts = List.length accs in
              let bal_decrease = Amount.Signed.(of_unsigned funds |> negate) in
              let funds' =
                UInt64.Infix.(Amount.to_uint64 funds / UInt64.of_int 2)
                |> Amount.of_uint64
              in
              let bal_increase = Amount.Signed.of_unsigned funds' in
              let children =
                [ (Single.make ~account:receiver1.pk bal_increase :> transaction)
                ; (Single.make ~account:receiver2.pk bal_increase :> transaction)
                ]
                @ gen_txns funds'
                    (receiver1 :: List.take accs (remaining_accounts / 2))
                @ gen_txns funds'
                    (receiver2 :: List.drop accs (remaining_accounts / 2))
              in
              [ ( Txn_tree.make ~account:sender.pk ~amount:bal_decrease
                    ~children Account_update.Update.noop
                  :> transaction )
              ]
          | _ ->
              []
        in
        let fee_payer = List.hd_exn accounts in
        let funds =
          Amount.of_uint64 UInt64.(add one @@ div max_int (of_int 2))
        in
        let%map global_slot = Global_slot.gen in
        (global_slot, fee_payer.pk, Fee.zero, accounts, gen_txns funds accounts))
        ~f:(fun (global_slot, fee_payer, fee, accounts, txns) ->
          [%test_pred: Zk_cmd_result.t Or_error.t]
            (Predicates.pure ~f:(fun (txn, ledger) ->
                 Transaction_status.equal txn.command.status Applied
                 && Predicates.verify_balance_changes ~ledger ~txn accounts ) )
            (run_zkapp_cmd ~global_slot ~fee_payer ~fee ~accounts txns) )

    let%test_unit "Account updates are applied depth-first." =
      (* These transactions are constructed such that if they are executed in a
         specific order, they would work. However, because the tree is processed
         depth-first, some of the accounts lack funds to be taken away and so
         some of the updates result in Overflows. *)
      Quickcheck.test ~trials:1
        (let open Quickcheck in
        let open Generator.Let_syntax in
        let%bind alice =
          Test_account.gen_constrained_balance ()
            ~max:Balance.(of_mina_int_exn 10000)
            ~min:Balance.(of_mina_int_exn 1000)
        in
        let%bind bob =
          Test_account.gen_constrained_balance ()
            ~min:Balance.(of_mina_int_exn 100)
            ~max:Balance.(of_mina_int_exn 500)
        in
        let%bind caroll = Test_account.gen_empty in
        let txns =
          (* The updates are arranged as follows:
             |- Alice -500 MINA
             |    |- Bob -600 MINA
             |    |- Caroll +600 MINA
             |- Bob +500 MINA
                  |- Caroll -100 MINA
                  |- Alice + 100 MINA
             Hence Bob can't give away 600 MINA to Caroll before he gets his
             500 MINA from Alice, which only happens in the other branch of the
             tree that is being processed later. However, even though overflow
             happens on the second update, it still is applied, which makes Bob's
             balance very high, so when we try to add to his balance money
             transferred from Alice, it overflows again That is why we've got
             2 overflows in the results and not just 1. Caroll on the other hands
             receives 600 MINA before she gives away 100 MINA, so that one
             does not overflow. *)
          [ ( Txn_tree.make ~account:alice.pk
                ~amount:
                  Amount.Signed.(
                    negate @@ of_unsigned @@ Amount.of_mina_int_exn 500)
                ~children:
                  [ ( Simple_txn.make ~sender:bob.pk ~receiver:caroll.pk
                        (Amount.of_mina_int_exn 600)
                      :> transaction )
                  ]
                Account_update.Update.noop
              :> transaction )
          ; ( Txn_tree.make ~account:bob.pk
                ~amount:
                  Amount.Signed.(of_unsigned @@ Amount.of_mina_int_exn 500)
                ~children:
                  [ ( Simple_txn.make ~sender:caroll.pk ~receiver:alice.pk
                        (Amount.of_mina_int_exn 100)
                      :> transaction )
                  ]
                Account_update.Update.noop
              :> transaction )
          ]
        in
        let%bind fee = Fee.(gen_incl zero (Fee.of_mina_int_exn 500)) in
        let%map global_slot = Global_slot.gen in
        (global_slot, alice.pk, fee, [ alice; bob; caroll ], txns))
        ~f:(fun (global_slot, fee_payer, fee, accounts, txns) ->
          [%test_pred: Zk_cmd_result.t Or_error.t]
            (Predicates.pure ~f:(fun (txn, ledger) ->
                 Transaction_status.equal txn.command.status
                   (Failed
                      [ []
                      ; [ Cancelled ]
                      ; [ Overflow ]
                      ; [ Cancelled ]
                      ; [ Overflow ]
                      ; [ Cancelled ]
                      ; [ Cancelled ]
                      ] )
                 && Predicates.verify_balances_unchanged ~ledger ~txn accounts )
            )
            (run_zkapp_cmd ~global_slot ~fee_payer ~fee ~accounts txns) )

    let%test_unit "Update preconditions can block update application." =
      Quickcheck.test ~trials
        (let open Quickcheck.Generator.Let_syntax in
        let%bind sender =
          Test_account.gen_constrained_balance
            ~min:Balance.(of_mina_int_exn 5)
            ()
        in
        let%bind receiver = Test_account.gen_empty in
        let max_fee =
          let open Fee in
          balance_to_fee sender.balance - one |> Option.value ~default:one
        in
        let%bind fee = Fee.(gen_incl one max_fee) in
        let balance_after_fee =
          let open Balance in
          sender.balance - Amount.of_fee fee
          |> Option.value_map ~default:Amount.zero ~f:to_amount
        in
        let%bind amount = Amount.(gen_incl one balance_after_fee) in
        let%bind valid_while_intv = gen_valid_while in
        let%map global_slot =
          global_slot_gen_excl valid_while_intv.lower valid_while_intv.upper
        in
        let preconditions =
          let open Account_update in
          let open Preconditions in
          { network = Zkapp_precondition.Protocol_state.accept
          ; account = Account_precondition.Accept
          ; valid_while = Check valid_while_intv
          }
        in
        let txn =
          Simple_txn.make ~preconditions ~sender:sender.pk ~receiver:receiver.pk
            amount
        in
        ( global_slot
        , sender.pk
        , fee
        , [ sender; receiver ]
        , [ (txn :> transaction) ] ))
        ~f:(fun (global_slot, fee_payer, fee, accounts, txns) ->
          [%test_pred: Zk_cmd_result.t Or_error.t]
            (Predicates.pure ~f:(fun (txn, ledger) ->
                 Transaction_status.equal txn.command.status
                   (Failed
                      [ []
                      ; [ Valid_while_precondition_unsatisfied ]
                      ; [ Valid_while_precondition_unsatisfied ]
                      ] )
                 && Predicates.verify_balances_unchanged ~ledger ~txn accounts )
            )
            (run_zkapp_cmd ~global_slot ~fee_payer ~fee ~accounts txns) )

    let%test_unit "Account preconditions are checked against the local state." =
      Quickcheck.test ~trials
        (let open Quickcheck.Generator.Let_syntax in
        let%bind sender =
          Test_account.gen_constrained_balance
            ~min:Balance.(of_mina_int_exn 5)
            ()
        in
        let%bind receiver = Test_account.gen_empty in
        let max_fee =
          let open Fee in
          balance_to_fee sender.balance - one |> Option.value ~default:one
        in
        let%bind fee = Fee.(gen_incl one max_fee) in
        let balance_after_fee =
          let open Balance in
          sender.balance - Amount.of_fee fee |> Option.value ~default:zero
        in
        let%bind amount =
          Amount.(gen_incl one (Balance.to_amount balance_after_fee))
        in
        let%map global_slot = Global_slot.gen in
        let recv_balance = Balance.of_uint64 @@ Amount.to_uint64 amount in
        (* The precondition checks that money has been transferred to the receiver,
           which is already the case in the intermediate (local) state between
           the transfer and the delegation update. *)
        let preconditions =
          let open Account_update in
          let open Preconditions in
          { network = Zkapp_precondition.Protocol_state.accept
          ; account =
              Full
                { Zkapp_precondition.Account.accept with
                  balance = Check { lower = recv_balance; upper = recv_balance }
                }
          ; valid_while = Ignore
          }
        in
        let txns =
          [ ( Single.make ~account:sender.pk
                Amount.Signed.(negate @@ of_unsigned amount)
              :> transaction )
          ; ( Single.make ~account:receiver.pk Amount.Signed.(of_unsigned amount)
              :> transaction )
          ; ( Alter_account.make ~preconditions ~account:receiver.pk
                { Account_update.Update.noop with delegate = Set sender.pk }
              :> transaction )
          ]
        in
        ( global_slot
        , sender.pk
        , fee
        , [ sender; receiver ]
        , (txns :> transaction list) ))
        ~f:(fun (global_slot, fee_payer, fee, accounts, txns) ->
          [%test_pred: Zk_cmd_result.t Or_error.t]
            (Predicates.pure ~f:(fun (txn, ledger) ->
                 Transaction_status.equal txn.command.status Applied
                 && Predicates.verify_balance_changes ~ledger ~txn accounts ) )
            (run_zkapp_cmd ~global_slot ~fee_payer ~fee ~accounts txns) )

    let%test_unit "Nonces are being incremented once for each account update." =
      Quickcheck.test ~trials
        (let open Quickcheck in
        let open Generator.Let_syntax in
        let%bind sender =
          Test_account.gen_constrained_balance
            ~min:(Balance.of_mina_int_exn 2)
            ()
        in
        let%bind receivers =
          Generator.list_with_length 2 Test_account.gen_empty
        in
        let max_fee =
          Balance.(sender.balance - Amount.of_mina_int_exn 1)
          |> Option.value_map ~f:balance_to_fee ~default:Fee.zero
        in
        let%bind fee = Fee.(gen_incl one max_fee) in
        let max_amount =
          let balance_after_fee =
            Balance.(sender.balance - Amount.of_fee fee)
            |> Option.value ~default:Balance.zero
          in
          UInt64.Infix.(Balance.to_uint64 balance_after_fee / UInt64.of_int 2)
          |> Amount.of_uint64
        in
        let%bind amount = Amount.(gen_incl one max_amount) in
        let receiver n = (List.nth_exn receivers n).pk in
        let txns =
          [ Simple_txn.make ~sender:sender.pk ~receiver:(receiver 0) amount
          ; Simple_txn.make ~sender:sender.pk ~receiver:(receiver 1) amount
          ]
        in
        let%map global_slot = Global_slot.gen in
        ( global_slot
        , sender.pk
        , fee
        , sender :: receivers
        , (txns :> transaction list) ))
        ~f:(fun (global_slot, fee_payer, fee, accounts, txns) ->
          [%test_pred: Zk_cmd_result.t Or_error.t]
            (Predicates.pure ~f:(fun (txn, ledger) ->
                 Transaction_status.equal txn.command.status Applied
                 &&
                 match accounts with
                 | [] ->
                     false
                 | sender :: receivers ->
                     let open Account.Nonce in
                     let sender' = find_account_exn ~ledger sender in
                     (* There's a fee payment and 2 deductions from the account,
                        which amounts to 3 nonce increments. *)
                     equal (add sender.nonce (of_int 3)) sender'.nonce
                     && List.for_all receivers ~f:(fun receiver ->
                            let receiver' = find_account_exn ~ledger receiver in
                            equal (succ receiver.nonce) receiver'.nonce ) ) )
            (run_zkapp_cmd ~global_slot ~fee_payer ~fee ~accounts txns) )
  end )
