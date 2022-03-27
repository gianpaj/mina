type t =
  ( Marlin_plonk_bindings_pasta_fq.t
  , Marlin_plonk_bindings_pasta_pallas.Affine.t
  , Marlin_plonk_bindings_pasta_fq_urs.Poly_comm.t )
  Marlin_plonk_bindings_types.Plonk_proof.t

external create :
     Marlin_plonk_bindings_pasta_fq_index.t
  -> primary_input:Marlin_plonk_bindings_pasta_fq_vector.t
  -> auxiliary_input:Marlin_plonk_bindings_pasta_fq_vector.t
  -> prev_challenges:Marlin_plonk_bindings_pasta_fq.t array
  -> prev_sgs:Marlin_plonk_bindings_pasta_pallas.Affine.t array
  -> t = "caml_pasta_fq_plonk_proof_create"

external verify :
     Marlin_plonk_bindings_pasta_fq_urs.Poly_comm.t array
  -> Marlin_plonk_bindings_pasta_fq_verifier_index.t
  -> t
  -> bool = "caml_pasta_fq_plonk_proof_verify"

external batch_verify :
     Marlin_plonk_bindings_pasta_fq_urs.Poly_comm.t array array
  -> Marlin_plonk_bindings_pasta_fq_verifier_index.t array
  -> t array
  -> bool = "caml_pasta_fq_plonk_proof_batch_verify"

external dummy : unit -> t = "caml_pasta_fq_plonk_proof_dummy"

external deep_copy : t -> t = "caml_pasta_fq_plonk_proof_deep_copy"
