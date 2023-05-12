open Alcotest
open Mina_base

let () =
  run "Test mina_base."
    [ Zkapp_account_test.
        ( "zkapp-accounts"
        , [ test_case "Event hashes don't collide." `Quick
              event_hashes_well_behaved
          ; test_case "Zkapp_uri hashes don't collide." `Quick
              zkapp_uri_hashes_well_behaved
          ; test_case "Events pop after push is idempotent." `Quick
              (checked_pop_reverses_push (module Zkapp_account.Events))
          ; test_case "Actions pop after push is idempotent." `Quick
              (checked_pop_reverses_push (module Zkapp_account.Actions))
          ] )
    ; Account_test.
        ( "accounts"
        , [ test_case "Test fine-tuning of the account generation." `Quick
              fine_tuning_of_the_account_generation
          ; test_case "Cliff amount is immediately released at cliff time."
              `Quick cliff_amount_is_immediately_released_at_cliff_time
          ; test_case
              "Final vesting slot is the first when minimum balance is 0."
              `Quick final_vesting_slot_is_the_first_when_minimum_balance_is_0
          ; test_case "Minimum balance never changes before the cliff time."
              `Quick minimum_balance_never_changes_before_the_cliff_time
          ; test_case "Minimum balance never increases over time." `Quick
              minimum_balance_never_increases_over_time
          ; test_case
              "Every vesting period minimum balance decreases by vesting \
               increment."
              `Quick
              every_vesting_period_minimum_balance_decreases_by_vesting_increment
          ; test_case "Incremental balance between slots before cliff is 0."
              `Quick incremental_balance_between_slots_before_cliff_is_0
          ; test_case
              "Incremental balance between slots after vesting finished is 0."
              `Quick
              incremental_balance_between_slots_after_vesting_finished_is_0
          ; test_case "Incremental balance where end is before start is 0."
              `Quick incremental_balance_where_end_is_before_start_is_0
          ; test_case
              "Incremental balance during vesting is a multiple of vesting \
               increment."
              `Quick
              incremental_balance_during_vesting_is_a_multiple_of_vesting_increment
          ; test_case "Liquid balance in untimed account always equals balance."
              `Quick liquid_balance_in_untimed_account_equals_balance
          ; test_case
              "Liquid balance is balance - minimum balance at given slot."
              `Quick
              liquid_balance_is_balance_minus_minimum_balance_at_given_slot
          ; test_case "Token symbol to_bits of_bits roundtrip." `Quick
              token_symbol_to_bits_of_bits_roundtrip
          ; test_case "Token symbol of_bits to_bits roundtrip." `Quick
              token_symbol_of_bits_to_bits_roundtrip
          ] )
    ; Account_update_test.
        ( "account update"
        , [ test_case "Account precondition JSON roundtrip." `Quick
              update_json_roundtrip
          ; test_case "Account precondition JSON roundtrip with nonce." `Quick
              precondition_json_roundtrip_nonce
          ; test_case "Account precondition JSON roundtrip full." `Quick
              precondition_json_roundtrip_full
          ; test_case "Account precondition JSON roundtrip full with nonce."
              `Quick precondition_json_roundtrip_full_with_nonce
          ; test_case "Account precondition to JSON conversion." `Quick
              precondition_to_json
          ; test_case "Body JSON roundtrip." `Quick body_json_roundtrip
          ; test_case "Body fee payer JSON roundtrip." `Quick
              body_fee_payer_json_roundtrip
          ; test_case "Fee payer JSON roundtrip." `Quick
              fee_payer_json_roundtrip
          ; test_case "JSON roundtrip." `Quick json_roundtrip_dummy
          ; test_case "Account precondition digests don't collide." `Quick
              precodition_digest_well_behaved
          ; test_case "Account update body digests don't collide." `Quick
              body_digest_well_behaved
          ] )
    ; Call_forest_test.
        ( "call forest"
        , [ test_case "Test fold_forest." `Quick Tree_test.fold_forest
          ; test_case "Test fold_forest2." `Quick Tree_test.fold_forest2
          ; test_case "Test fold_forest2 failure." `Quick
              Tree_test.fold_forest2_fails
          ; test_case "Test iter_forest2_exn." `Quick Tree_test.iter_forest2_exn
          ; test_case "Test iter_forest2_exn failure." `Quick
              Tree_test.iter_forest2_exn_fails
          ; test_case "iter2_exn" `Quick Tree_test.iter2_exn
          ; test_case "mapi with trees preserves shape." `Quick
              Tree_test.mapi_with_trees_preserves_shape
          ; test_case "mapi with trees preserves shape." `Quick
              Tree_test.mapi_with_trees_unit_test
          ; test_case "Test mapi with trees." `Quick
              Tree_test.mapi_forest_with_trees_preserves_shape
          ; test_case "mapi_forest with trees preserves shape." `Quick
              Tree_test.mapi_forest_with_trees_unit_test
          ; test_case "Test mapi_forest with trees." `Quick
              Tree_test.mapi_forest_with_trees_is_distributive
          ; test_case "mapi_forest with trees is distributive." `Quick
              Tree_test.mapi_prime_preserves_shape
          ; test_case "mapi' preserves shape." `Quick
              Tree_test.mapi_prime_preserves_shape
          ; test_case "Test mapi'." `Quick Tree_test.mapi_prime
          ; test_case "Test mapi_forest'." `Quick Tree_test.mapi_forest_prime
          ; test_case "map_forest is distibutive." `Quick
              Tree_test.map_forest_is_distributive
          ; test_case "deferred_map_forest is equivalent to map_forest." `Quick
              Tree_test.deferred_map_forest_equivalent_to_map_forest
          ; test_case "Test shape." `Quick test_shape
          ; test_case "shape_indices always start with 0 and increse by 1."
              `Quick shape_indices_always_start_with_0_and_increse_by_1
          ; test_case "Test match_up success." `Quick match_up_ok
          ; test_case "Test match_up failure." `Quick match_up_error
          ; test_case "Test match_up failure 2." `Quick match_up_error_2
          ; test_case "Test match_up empty." `Quick match_up_empty
          ; test_case "Test mask." `Quick mask
          ; test_case "to_account_updates is the inverse of of_account_updates."
              `Quick to_account_updates_is_the_inverse_of_of_account_updates
          ; test_case "Test to_zkapp_command with hashes list." `Quick
              to_zkapp_command_with_hashes_list
          ] )
    ; Coinbase_test.
        ( "coinbase"
        , [ test_case "Accessed accounts are also those referenced." `Quick
              accessed_accounts_are_also_referenced
          ; test_case "Refrenced accounts are either one or two." `Quick
              referenced_accounts_either_1_or_2
          ] )
    ; Control_test.
        ("contol", [ test_case "JSON roundtrip." `Quick json_roundtrip ])
    ; Fee_excess_test.
        ( "fee-excess"
        , [ test_case "Checked and unchecked behaviour consistent." `Quick
              combine_checked_unchecked_consistent
          ; test_case "Combine succeeds when the middle excess is zero." `Quick
              combine_succeed_with_0_middle
          ; test_case "Rebalanced fee excess is really rebalanced." `Quick
              rebalancing_properties_hold
          ] )
    ; Fee_related_test.
        ( "fee-related"
        , [ test_case "Test fee." `Quick test_fee
          ; test_case "Test fee_payer account update." `Quick
              fee_payer_account_update
          ; test_case "Test fee_payer public key." `Quick fee_payer_pk
          ; test_case "Test fee_excess." `Quick fee_excess
          ] )
    ; Merkle_tree_test.
        ( "merkle tree"
        , [ test_case "Test isomorphism between lists and merkle trees." `Quick
              merkle_tree_isomorphic_to_list
          ; test_case "Test item retrieval by index." `Quick index_retrieval
          ; test_case "Test non-existent index retrieval." `Quick
              index_non_existent
          ; test_case "Test merkle root soundness." `Quick merkle_root
          ; test_case "Free hashes don't collide." `Quick free_hash_well_behaved
          ] )
    ; Pending_coinbase_test.
        ( "pending coinbase"
        , [ test_case "Add stack + remove stack = initial tree." `Quick
              add_stack_plus_remove_stack_equals_initial_tree
          ; test_case "Checked_stack = unchecked_stack." `Quick
              checked_stack_equals_unchecked_stack
          ; test_case "Checked_tree = unchecked_tree." `Quick
              checked_tree_equals_unchecked_tree
          ; test_case "Checked_tree = unchecked_tree after pop." `Quick
              checked_tree_equals_unchecked_tree_after_pop
          ; test_case "Push and pop multiple stacks." `Quick
              push_and_pop_multiple_stacks
          ] )
    ; Permissions_test.
        ( "permissions"
        , [ test_case "Decode-encode roundtrip." `Quick decode_encode_roundtrip
          ; test_case "JSON roundtrip." `Quick json_roundtrip
          ; test_case "JSON value." `Quick json_value
          ] )
    ; Receipt_test.
        ( "receipt"
        , [ test_case "Checked-unchecked equivalence (signed command)." `Quick
              checked_unchecked_equivalence_signed_command
          ; test_case "Checked-unchecked equivalence (zkApp command)." `Quick
              checked_unchecked_equivalence_zkapp_command
          ; test_case "JSON roundtrip." `Quick json_roundtrip
          ] )
    ; Signature_test.
        ( "signature"
        , [ test_case "Signature decode after encode is identity." `Quick
              signature_decode_after_encode_is_identity
          ; test_case "Base58Check is stable." `Quick base58Check_stable
          ] )
    ; Signed_command_test.
        ( "signed command"
        , [ test_case "Completeness." `Quick completeness
          ; test_case "JSON." `Quick json
          ] )
    ; Transaction_status_test.
        ( "transaction status"
        , [ test_case "To string roundtrip," `Quick
              of_string_to_string_roundtrip
          ] )
    ; Transaction_union_tag_test.
        ( "transaction union tag"
        , [ test_case "Is payment." `Quick is_payment
          ; test_case "Is stake_delegation." `Quick is_stake_delegation
          ; test_case "Is free transfer." `Quick is_fee_transfer
          ; test_case "Is coinbase." `Quick is_coinbase
          ; test_case "Is user command." `Quick is_user_command
          ; test_case "Not user command." `Quick not_user_command
          ; test_case "Test bit representation." `Quick bit_representation
          ] )
    ; Zkapp_basic_test.
        ( "zkApp basic"
        , [ test_case "Int to bits and back to int is identity." `Quick
              int_to_bits_roundtrip
          ; test_case "Invalid public key is invalid." `Quick
              invalid_public_key_is_invalid
          ] )
    ; Zkapp_command_test.
        ( "zkApp commands"
        , [ test_case "Account_update_or_stack.of_zkapp_command_list." `Quick
              account_update_or_stack_of_zkapp_command_list
          ; test_case "Wire embedded in t." `Quick wire_embedded_in_t
          ; test_case "Wire embedded in graphql." `Quick
              wire_embedded_in_graphql
          ; test_case "JSON roundtrip dummy." `Quick
              Test_derivers.json_roundtrip_dummy
          ; test_case "Full circuit." `Quick Test_derivers.full_circuit
          ] )
    ]
