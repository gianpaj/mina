module type Constraint_matrix_intf = sig
  module Field : Field.S

  type t

  val create : unit -> t

  val append_row : t -> Snarky_bn382.Usize_vector.t -> Field.Vector.t -> unit
end

type 'a abc = {a: 'a; b: 'a; c: 'a} [@@deriving sexp]

let weight = ref 0

let wt = ref {a= 0; b= 0; c= 0}

module Weight = struct
  open Core

  type t = int abc [@@deriving sexp]

  let ( + ) t1 (a, b, c) = {a= t1.a + a; b= t1.b + b; c= t1.c + c}

  let norm {a; b; c} = Int.(max a (max b c))
end

module Make
    (Fp : Field.S)
    (Mat : Constraint_matrix_intf with module Field := Fp) =
struct
  open Core

  type t =
    { m: Mat.t abc
    ; mutable weight: Weight.t
    ; mutable public_input_size: int
    ; mutable auxiliary_input_size: int }

  let create () =
    { public_input_size= 0
    ; auxiliary_input_size= 0
    ; weight= {a= 0; b= 0; c= 0}
    ; m= {a= Mat.create (); b= Mat.create (); c= Mat.create ()} }

  (* TODO *)
  let to_json _ = `List []

  let get_auxiliary_input_size t = t.auxiliary_input_size

  let get_primary_input_size t = t.public_input_size

  let set_auxiliary_input_size t x = t.auxiliary_input_size <- x

  let set_primary_input_size t x = t.public_input_size <- x

  (* TODO *)
  let digest _ = Md5.digest_string ""

  let finalize = ignore

  let merge_terms xs0 ys0 ~init ~f =
    let rec go acc xs ys =
      match (xs, ys) with
      | [], [] ->
          acc
      | [], (y, iy) :: ys ->
          go (f acc iy (`Right y)) [] ys
      | (x, ix) :: xs, [] ->
          go (f acc ix (`Left x)) xs []
      | (x, ix) :: xs', (y, iy) :: ys' ->
          if ix < iy then go (f acc ix (`Left x)) xs' ys
          else if ix = iy then go (f acc ix (`Both (x, y))) xs' ys'
          else go (f acc iy (`Right y)) xs ys'
    in
    go init xs0 ys0

  let sub_terms xs ys =
    merge_terms ~init:[]
      ~f:(fun acc i t ->
        let c =
          match t with
          | `Left x ->
              x
          | `Right y ->
              Fp.negate y
          | `Both (x, y) ->
              Fp.sub x y
        in
        (c, i) :: acc )
      xs ys
    |> List.rev

  let decr_constant_term = function
    | (c, 0) :: terms ->
        (Fp.(sub c one), 0) :: terms
    | (_, _) :: _ as terms ->
        (Fp.(sub zero one), 0) :: terms
    | [] ->
        []

  let canonicalize x =
    let c, terms =
      Fp.(
        Snarky.Cvar.to_constant_and_terms ~add ~mul ~zero:(of_int 0)
          ~one:(of_int 1))
        x
    in
    let terms =
      List.sort terms ~compare:(fun (_, i) (_, j) -> Int.compare i j)
    in
    let has_constant_term = Option.is_some c in
    let terms = match c with None -> terms | Some c -> (c, 0) :: terms in
    match terms with
    | [] ->
        None
    | (c0, i0) :: terms ->
        let acc, i, ts, n =
          Sequence.of_list terms
          |> Sequence.fold ~init:(c0, i0, [], 0)
               ~f:(fun (acc, i, ts, n) (c, j) ->
                 if Int.equal i j then (Fp.add acc c, i, ts, n)
                 else (c, j, (acc, i) :: ts, n + 1) )
        in
        Some (List.rev ((acc, i) :: ts), n + 1, has_constant_term)

  let choose_best base opts terms =
    let ( +. ) = Weight.( + ) in
    let best f xs =
      List.min_elt xs ~compare:(fun (_, wt1) (_, wt2) ->
          Int.compare
            (Weight.norm (base +. f wt1))
            (Weight.norm (base +. f wt2)) )
      |> Option.value_exn
    in
    let swap_ab (a, b, c) = (b, a, c) in
    let best_unswapped, d_unswapped = best Fn.id opts in
    let best_swapped, d_swapped = best swap_ab opts in
    let w_unswapped, w_swapped = (base +. d_unswapped, base +. d_swapped) in
    if Weight.(norm w_swapped < norm w_unswapped) then
      (swap_ab (terms best_swapped), w_swapped)
    else (terms best_unswapped, w_unswapped)

  let choose_best base opts terms =
    let ( +. ) = Weight.( + ) in
    let best xs =
      Sequence.min_elt xs ~compare:(fun (_, wt1) (_, wt2) ->
          Int.compare (Weight.norm (base +. wt1)) (Weight.norm (base +. wt2))
      )
      |> Option.value_exn
    in
    let swap_ab (a, b, c) = (b, a, c) in
    let opts =
      let s = Sequence.of_list opts in
      Sequence.append
        (Sequence.map s ~f:(fun (x, w) -> ((`unswapped, x), w)))
        (Sequence.map s ~f:(fun (x, w) -> ((`swapped, x), swap_ab w)))
    in
    let (swap, best), delta = best opts in
    let terms =
      let terms = terms best in
      match swap with `unswapped -> terms | `swapped -> swap_ab terms
    in
    (*
    let s =
      match swap with
      | `unswapped -> "unswapped"
      | `swapped -> "swapped"
    in
    let print () =
      sprintf !"%s (delta=%{sexp:int * int * int}) (pre=%{sexp:Weight.t}) (post=%{sexp:Weight.t}) \n%!"
        s
        delta
        base
        (base +. delta)
    in
    (if !i mod 1000 = 0 then print_endline (print ()));
    if not (Weight.norm (base +. delta) <= Weight.norm (base +. swap_ab delta))
    then failwith (print ())
  );
  incr i ; *)
    (terms, base +. delta)

  let add_r1cs t (a, b, c) =
    let append m v =
      let indices = Snarky_bn382.Usize_vector.create () in
      let coeffs = Fp.Vector.create () in
      List.iter v ~f:(fun (x, i) ->
          Snarky_bn382.Usize_vector.emplace_back indices
            (Unsigned.Size_t.of_int i) ;
          Fp.Vector.emplace_back coeffs x ) ;
      Mat.append_row m indices coeffs
    in
    append t.m.a a ;
    append t.m.b b ;
    append t.m.c c ;
    weight := Int.max (Weight.norm t.weight) !weight ;
    wt := t.weight

  let add_constraint ?label:_ t
      (constr : Fp.t Snarky.Cvar.t Snarky.Constraint.basic) =
    let var = canonicalize in
    let var_exn t = Option.value_exn (var t) in
    let choose_best opts terms =
      let constr, new_weight = choose_best t.weight opts terms in
      t.weight <- new_weight ;
      add_r1cs t constr
    in
    match constr with
    | Boolean x ->
        let x, x_weight, x_has_constant_term = var_exn x in
        let x_minus_1_weight =
          x_weight + if x_has_constant_term then 0 else 1
        in
        choose_best
          (* x * x = x
             x * (x - 1) = 0 *)
          [ (`x_x_x, (x_weight, x_weight, x_weight))
          ; (`x_xMinus1_0, (x_weight, x_minus_1_weight, 0)) ]
          (function
            | `x_x_x ->
                (x, x, x)
            | `x_xMinus1_0 ->
                (x, decr_constant_term x, []) )
    | Equal (x, y) ->
        (* x * 1 = y
         y * 1 = x
        (x - y) * 1 = 0
      *)
        let x_terms, x_weight, _ = var_exn x in
        let y_terms, y_weight, _ = var_exn y in
        let x_minus_y_weight =
          merge_terms ~init:0 ~f:(fun acc _ _ -> acc + 1) x_terms y_terms
        in
        let options =
          [ (`x_1_y, (x_weight, 1, y_weight))
          ; (`y_1_x, (y_weight, 1, x_weight))
          ; (`x_minus_y_1_zero, (x_minus_y_weight, 1, 0)) ]
        in
        let one = [(Fp.one, 0)] in
        choose_best options (function
          | `x_1_y ->
              (x_terms, one, y_terms)
          | `y_1_x ->
              (y_terms, one, x_terms)
          | `x_minus_y_1_zero ->
              (sub_terms x_terms y_terms, one, []) )
    | Square (x, z) ->
        let x, x_weight, _ = var_exn x in
        let z, z_weight, _ = var_exn z in
        choose_best [((), (x_weight, x_weight, z_weight))] (fun () -> (x, x, z))
    | R1CS (a, b, c) ->
        let a, a_weight, _ = var_exn a in
        let b, b_weight, _ = var_exn b in
        let c, c_weight, _ = var_exn c in
        choose_best [((), (a_weight, b_weight, c_weight))] (fun () -> (a, b, c))
end
