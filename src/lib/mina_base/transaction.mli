module Poly : sig
  module Stable : sig
    module V1 : sig
      type 'command t =
        | Command of 'command
        | Fee_transfer of Fee_transfer.Stable.V1.t
        | Coinbase of Coinbase.Stable.V1.t

      val to_yojson : ('command -> Yojson.Safe.t) -> 'command t -> Yojson.Safe.t

      val of_yojson :
           (Yojson.Safe.t -> 'command Ppx_deriving_yojson_runtime.error_or)
        -> Yojson.Safe.t
        -> 'command t Ppx_deriving_yojson_runtime.error_or

      val version : int

      val __versioned__ : unit

      val t_of_sexp :
           (Ppx_sexp_conv_lib.Sexp.t -> 'command)
        -> Ppx_sexp_conv_lib.Sexp.t
        -> 'command t

      val sexp_of_t :
           ('command -> Ppx_sexp_conv_lib.Sexp.t)
        -> 'command t
        -> Ppx_sexp_conv_lib.Sexp.t

      val compare :
        ('command -> 'command -> int) -> 'command t -> 'command t -> int

      val equal :
        ('command -> 'command -> bool) -> 'command t -> 'command t -> bool

      val hash_fold_t :
           (   Ppx_hash_lib.Std.Hash.state
            -> 'command
            -> Ppx_hash_lib.Std.Hash.state)
        -> Ppx_hash_lib.Std.Hash.state
        -> 'command t
        -> Ppx_hash_lib.Std.Hash.state

      val to_latest : 'a -> 'a

      module With_version : sig
        type 'command typ = 'command t

        val bin_shape_typ : Core.Bin_prot.Shape.t -> Core.Bin_prot.Shape.t

        val bin_size_typ :
             'command Core.Bin_prot.Size.sizer
          -> 'command typ Core.Bin_prot.Size.sizer

        val bin_write_typ :
             'command Core.Bin_prot.Write.writer
          -> 'command typ Core.Bin_prot.Write.writer

        val bin_writer_typ :
             'a Core.Bin_prot.Type_class.writer
          -> 'a typ Core.Bin_prot.Type_class.writer

        val __bin_read_typ__ :
             'command Core.Bin_prot.Read.reader
          -> (int -> 'command typ) Core.Bin_prot.Read.reader

        val bin_read_typ :
             'command Core.Bin_prot.Read.reader
          -> 'command typ Core.Bin_prot.Read.reader

        val bin_reader_typ :
             'a Core.Bin_prot.Type_class.reader
          -> 'a typ Core.Bin_prot.Type_class.reader

        val bin_typ :
          'a Core.Bin_prot.Type_class.t -> 'a typ Core.Bin_prot.Type_class.t

        type 'command t = { version : int; t : 'command typ }

        val bin_shape_t : Core.Bin_prot.Shape.t -> Core.Bin_prot.Shape.t

        val bin_size_t :
             'command Core.Bin_prot.Size.sizer
          -> 'command t Core.Bin_prot.Size.sizer

        val bin_write_t :
             'command Core.Bin_prot.Write.writer
          -> 'command t Core.Bin_prot.Write.writer

        val bin_writer_t :
             'a Core.Bin_prot.Type_class.writer
          -> 'a t Core.Bin_prot.Type_class.writer

        val __bin_read_t__ :
             'command Core.Bin_prot.Read.reader
          -> (int -> 'command t) Core.Bin_prot.Read.reader

        val bin_read_t :
             'command Core.Bin_prot.Read.reader
          -> 'command t Core.Bin_prot.Read.reader

        val bin_reader_t :
             'a Core.Bin_prot.Type_class.reader
          -> 'a t Core.Bin_prot.Type_class.reader

        val bin_t :
          'a Core.Bin_prot.Type_class.t -> 'a t Core.Bin_prot.Type_class.t

        val create : 'a typ -> 'a t
      end

      val bin_read_t :
           'a Core.Bin_prot.Read.reader
        -> Bin_prot.Common.buf
        -> pos_ref:Bin_prot.Common.pos_ref
        -> 'a t

      val __bin_read_t__ :
           'a Core.Bin_prot.Read.reader
        -> Bin_prot.Common.buf
        -> pos_ref:Bin_prot.Common.pos_ref
        -> int
        -> 'a t

      val bin_size_t : 'a Core.Bin_prot.Size.sizer -> 'a t -> int

      val bin_write_t :
           'a Core.Bin_prot.Write.writer
        -> Bin_prot.Common.buf
        -> pos:Bin_prot.Common.pos
        -> 'a t
        -> Bin_prot.Common.pos

      val bin_shape_t : Core.Bin_prot.Shape.t -> Core.Bin_prot.Shape.t

      val bin_reader_t :
           'a Core.Bin_prot.Type_class.reader
        -> 'a t Core.Bin_prot.Type_class.reader

      val bin_writer_t :
           'a Core.Bin_prot.Type_class.writer
        -> 'a t Core.Bin_prot.Type_class.writer

      val bin_t :
        'a Core.Bin_prot.Type_class.t -> 'a t Core.Bin_prot.Type_class.t

      val __ :
        (   'a Core.Bin_prot.Read.reader
         -> Bin_prot.Common.buf
         -> pos_ref:Bin_prot.Common.pos_ref
         -> 'a t)
        * (   'b Core.Bin_prot.Read.reader
           -> Bin_prot.Common.buf
           -> pos_ref:Bin_prot.Common.pos_ref
           -> int
           -> 'b t)
        * ('c Core.Bin_prot.Size.sizer -> 'c t -> int)
        * (   'd Core.Bin_prot.Write.writer
           -> Bin_prot.Common.buf
           -> pos:Bin_prot.Common.pos
           -> 'd t
           -> Bin_prot.Common.pos)
        * (Core.Bin_prot.Shape.t -> Core.Bin_prot.Shape.t)
        * (   'e Core.Bin_prot.Type_class.reader
           -> 'e t Core.Bin_prot.Type_class.reader)
        * (   'f Core.Bin_prot.Type_class.writer
           -> 'f t Core.Bin_prot.Type_class.writer)
        * ('g Core.Bin_prot.Type_class.t -> 'g t Core.Bin_prot.Type_class.t)
    end

    module Latest = V1
  end

  type 'command t = 'command Stable.V1.t =
    | Command of 'command
    | Fee_transfer of Fee_transfer.t
    | Coinbase of Coinbase.t

  val to_yojson : ('command -> Yojson.Safe.t) -> 'command t -> Yojson.Safe.t

  val of_yojson :
       (Yojson.Safe.t -> 'command Ppx_deriving_yojson_runtime.error_or)
    -> Yojson.Safe.t
    -> 'command t Ppx_deriving_yojson_runtime.error_or

  val t_of_sexp :
       (Ppx_sexp_conv_lib.Sexp.t -> 'command)
    -> Ppx_sexp_conv_lib.Sexp.t
    -> 'command t

  val sexp_of_t :
       ('command -> Ppx_sexp_conv_lib.Sexp.t)
    -> 'command t
    -> Ppx_sexp_conv_lib.Sexp.t

  val compare : ('command -> 'command -> int) -> 'command t -> 'command t -> int

  val equal : ('command -> 'command -> bool) -> 'command t -> 'command t -> bool

  val hash_fold_t :
       (Ppx_hash_lib.Std.Hash.state -> 'command -> Ppx_hash_lib.Std.Hash.state)
    -> Ppx_hash_lib.Std.Hash.state
    -> 'command t
    -> Ppx_hash_lib.Std.Hash.state
end

module Valid : sig
  module Stable : sig
    module V1 : sig
      type t = User_command.Valid.Stable.V1.t Poly.t

      val to_yojson : t -> Yojson.Safe.t

      val of_yojson : Yojson.Safe.t -> t Ppx_deriving_yojson_runtime.error_or

      val version : int

      val __versioned__ : unit

      val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> t

      val sexp_of_t : t -> Ppx_sexp_conv_lib.Sexp.t

      val compare : t -> t -> int

      val equal : t -> t -> bool

      val hash_fold_t :
        Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state

      val hash : t -> Ppx_hash_lib.Std.Hash.hash_value

      val to_latest : 'a -> 'a

      module With_version : sig
        type typ = t

        val bin_shape_typ : Core.Bin_prot.Shape.t

        val bin_size_typ : typ Core.Bin_prot.Size.sizer

        val bin_write_typ : typ Core.Bin_prot.Write.writer

        val bin_writer_typ : typ Core.Bin_prot.Type_class.writer

        val __bin_read_typ__ : (int -> typ) Core.Bin_prot.Read.reader

        val bin_read_typ : typ Core.Bin_prot.Read.reader

        val bin_reader_typ : typ Core.Bin_prot.Type_class.reader

        val bin_typ : typ Core.Bin_prot.Type_class.t

        type t = { version : int; t : typ }

        val bin_shape_t : Core.Bin_prot.Shape.t

        val bin_size_t : t Core.Bin_prot.Size.sizer

        val bin_write_t : t Core.Bin_prot.Write.writer

        val bin_writer_t : t Core.Bin_prot.Type_class.writer

        val __bin_read_t__ : (int -> t) Core.Bin_prot.Read.reader

        val bin_read_t : t Core.Bin_prot.Read.reader

        val bin_reader_t : t Core.Bin_prot.Type_class.reader

        val bin_t : t Core.Bin_prot.Type_class.t

        val create : typ -> t
      end

      val bin_read_t :
        Bin_prot.Common.buf -> pos_ref:Bin_prot.Common.pos_ref -> t

      val __bin_read_t__ :
        Bin_prot.Common.buf -> pos_ref:Bin_prot.Common.pos_ref -> int -> t

      val bin_size_t : t -> int

      val bin_write_t :
           Bin_prot.Common.buf
        -> pos:Bin_prot.Common.pos
        -> t
        -> Bin_prot.Common.pos

      val bin_shape_t : Core.Bin_prot.Shape.t

      val bin_reader_t : t Core.Bin_prot.Type_class.reader

      val bin_writer_t : t Core.Bin_prot.Type_class.writer

      val bin_t : t Core.Bin_prot.Type_class.t

      val __ :
        (Bin_prot.Common.buf -> pos_ref:Bin_prot.Common.pos_ref -> t)
        * (Bin_prot.Common.buf -> pos_ref:Bin_prot.Common.pos_ref -> int -> t)
        * (t -> int)
        * (   Bin_prot.Common.buf
           -> pos:Bin_prot.Common.pos
           -> t
           -> Bin_prot.Common.pos)
        * Core.Bin_prot.Shape.t
        * t Core.Bin_prot.Type_class.reader
        * t Core.Bin_prot.Type_class.writer
        * t Core.Bin_prot.Type_class.t
    end

    module Latest = V1

    val versions :
      (int * (Core_kernel.Bigstring.t -> pos_ref:int Core.ref -> Latest.t))
      array

    val bin_read_to_latest_opt :
         Bin_prot.Common.buf
      -> pos_ref:Bin_prot.Common.pos Core_kernel.ref
      -> Latest.t option

    val __ :
         Bin_prot.Common.buf
      -> pos_ref:Bin_prot.Common.pos Core_kernel.ref
      -> Latest.t option
  end

  type t = Stable.Latest.t

  val to_yojson : t -> Yojson.Safe.t

  val of_yojson : Yojson.Safe.t -> t Ppx_deriving_yojson_runtime.error_or

  val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> t

  val sexp_of_t : t -> Ppx_sexp_conv_lib.Sexp.t

  val hash_fold_t :
    Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state

  val hash : t -> Ppx_hash_lib.Std.Hash.hash_value

  val hashable : t Core_kernel__.Hashtbl.Hashable.t

  module Table : sig
    type key = t

    type ('a, 'b) hashtbl = ('a, 'b) Core_kernel__.Hashtbl.t

    type 'b t = (key, 'b) hashtbl

    val sexp_of_t :
      ('b -> Ppx_sexp_conv_lib.Sexp.t) -> 'b t -> Ppx_sexp_conv_lib.Sexp.t

    type ('a, 'b) t_ = 'b t

    type 'a key_ = key

    val hashable : key Core_kernel__.Hashtbl_intf.Hashable.t

    val invariant :
      'a Base__.Invariant_intf.inv -> 'a t Base__.Invariant_intf.inv

    val create :
      ( key
      , 'b
      , unit -> 'b t )
      Core_kernel__.Hashtbl_intf.create_options_without_hashable

    val of_alist :
      ( key
      , 'b
      , (key * 'b) list -> [ `Duplicate_key of key | `Ok of 'b t ] )
      Core_kernel__.Hashtbl_intf.create_options_without_hashable

    val of_alist_report_all_dups :
      ( key
      , 'b
      , (key * 'b) list -> [ `Duplicate_keys of key list | `Ok of 'b t ] )
      Core_kernel__.Hashtbl_intf.create_options_without_hashable

    val of_alist_or_error :
      ( key
      , 'b
      , (key * 'b) list -> 'b t Base__.Or_error.t )
      Core_kernel__.Hashtbl_intf.create_options_without_hashable

    val of_alist_exn :
      ( key
      , 'b
      , (key * 'b) list -> 'b t )
      Core_kernel__.Hashtbl_intf.create_options_without_hashable

    val of_alist_multi :
      ( key
      , 'b list
      , (key * 'b) list -> 'b list t )
      Core_kernel__.Hashtbl_intf.create_options_without_hashable

    val create_mapped :
      ( key
      , 'b
      ,    get_key:('r -> key)
        -> get_data:('r -> 'b)
        -> 'r list
        -> [ `Duplicate_keys of key list | `Ok of 'b t ] )
      Core_kernel__.Hashtbl_intf.create_options_without_hashable

    val create_with_key :
      ( key
      , 'r
      ,    get_key:('r -> key)
        -> 'r list
        -> [ `Duplicate_keys of key list | `Ok of 'r t ] )
      Core_kernel__.Hashtbl_intf.create_options_without_hashable

    val create_with_key_or_error :
      ( key
      , 'r
      , get_key:('r -> key) -> 'r list -> 'r t Base__.Or_error.t )
      Core_kernel__.Hashtbl_intf.create_options_without_hashable

    val create_with_key_exn :
      ( key
      , 'r
      , get_key:('r -> key) -> 'r list -> 'r t )
      Core_kernel__.Hashtbl_intf.create_options_without_hashable

    val group :
      ( key
      , 'b
      ,    get_key:('r -> key)
        -> get_data:('r -> 'b)
        -> combine:('b -> 'b -> 'b)
        -> 'r list
        -> 'b t )
      Core_kernel__.Hashtbl_intf.create_options_without_hashable

    val sexp_of_key : 'a t -> key -> Base__.Sexp.t

    val clear : 'a t -> unit

    val copy : 'b t -> 'b t

    val fold : 'b t -> init:'c -> f:(key:key -> data:'b -> 'c -> 'c) -> 'c

    val iter_keys : 'a t -> f:(key -> unit) -> unit

    val iter : 'b t -> f:('b -> unit) -> unit

    val iteri : 'b t -> f:(key:key -> data:'b -> unit) -> unit

    val existsi : 'b t -> f:(key:key -> data:'b -> bool) -> bool

    val exists : 'b t -> f:('b -> bool) -> bool

    val for_alli : 'b t -> f:(key:key -> data:'b -> bool) -> bool

    val for_all : 'b t -> f:('b -> bool) -> bool

    val counti : 'b t -> f:(key:key -> data:'b -> bool) -> int

    val count : 'b t -> f:('b -> bool) -> int

    val length : 'a t -> int

    val is_empty : 'a t -> bool

    val mem : 'a t -> key -> bool

    val remove : 'a t -> key -> unit

    val choose : 'b t -> (key * 'b) option

    val choose_exn : 'b t -> key * 'b

    val set : 'b t -> key:key -> data:'b -> unit

    val add : 'b t -> key:key -> data:'b -> [ `Duplicate | `Ok ]

    val add_exn : 'b t -> key:key -> data:'b -> unit

    val change : 'b t -> key -> f:('b option -> 'b option) -> unit

    val update : 'b t -> key -> f:('b option -> 'b) -> unit

    val map : 'b t -> f:('b -> 'c) -> 'c t

    val mapi : 'b t -> f:(key:key -> data:'b -> 'c) -> 'c t

    val filter_map : 'b t -> f:('b -> 'c option) -> 'c t

    val filter_mapi : 'b t -> f:(key:key -> data:'b -> 'c option) -> 'c t

    val filter_keys : 'b t -> f:(key -> bool) -> 'b t

    val filter : 'b t -> f:('b -> bool) -> 'b t

    val filteri : 'b t -> f:(key:key -> data:'b -> bool) -> 'b t

    val partition_map :
      'b t -> f:('b -> [ `Fst of 'c | `Snd of 'd ]) -> 'c t * 'd t

    val partition_mapi :
         'b t
      -> f:(key:key -> data:'b -> [ `Fst of 'c | `Snd of 'd ])
      -> 'c t * 'd t

    val partition_tf : 'b t -> f:('b -> bool) -> 'b t * 'b t

    val partitioni_tf : 'b t -> f:(key:key -> data:'b -> bool) -> 'b t * 'b t

    val find_or_add : 'b t -> key -> default:(unit -> 'b) -> 'b

    val findi_or_add : 'b t -> key -> default:(key -> 'b) -> 'b

    val find : 'b t -> key -> 'b option

    val find_exn : 'b t -> key -> 'b

    val find_and_call :
      'b t -> key -> if_found:('b -> 'c) -> if_not_found:(key -> 'c) -> 'c

    val findi_and_call :
         'b t
      -> key
      -> if_found:(key:key -> data:'b -> 'c)
      -> if_not_found:(key -> 'c)
      -> 'c

    val find_and_remove : 'b t -> key -> 'b option

    val merge :
         'a t
      -> 'b t
      -> f:
           (   key:key
            -> [ `Both of 'a * 'b | `Left of 'a | `Right of 'b ]
            -> 'c option)
      -> 'c t

    type 'a merge_into_action =
          'a Core_kernel__Hashable.Make(Stable.V1).Table.merge_into_action =
      | Remove
      | Set_to of 'a

    val merge_into :
         src:'a t
      -> dst:'b t
      -> f:(key:key -> 'a -> 'b option -> 'b merge_into_action)
      -> unit

    val keys : 'a t -> key list

    val data : 'b t -> 'b list

    val filter_keys_inplace : 'a t -> f:(key -> bool) -> unit

    val filter_inplace : 'b t -> f:('b -> bool) -> unit

    val filteri_inplace : 'b t -> f:(key:key -> data:'b -> bool) -> unit

    val map_inplace : 'b t -> f:('b -> 'b) -> unit

    val mapi_inplace : 'b t -> f:(key:key -> data:'b -> 'b) -> unit

    val filter_map_inplace : 'b t -> f:('b -> 'b option) -> unit

    val filter_mapi_inplace :
      'b t -> f:(key:key -> data:'b -> 'b option) -> unit

    val equal : 'b t -> 'b t -> ('b -> 'b -> bool) -> bool

    val similar : 'b1 t -> 'b2 t -> ('b1 -> 'b2 -> bool) -> bool

    val to_alist : 'b t -> (key * 'b) list

    val validate :
         name:(key -> string)
      -> 'b Base__.Validate.check
      -> 'b t Base__.Validate.check

    val incr : ?by:int -> ?remove_if_zero:bool -> int t -> key -> unit

    val decr : ?by:int -> ?remove_if_zero:bool -> int t -> key -> unit

    val add_multi : 'b list t -> key:key -> data:'b -> unit

    val remove_multi : 'a list t -> key -> unit

    val find_multi : 'b list t -> key -> 'b list

    module Provide_of_sexp : functor
      (Key : sig
         val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> key
       end)
      -> sig
      val t_of_sexp :
           (Ppx_sexp_conv_lib.Sexp.t -> 'v_x__001_)
        -> Ppx_sexp_conv_lib.Sexp.t
        -> 'v_x__001_ t
    end

    module Provide_bin_io : functor
      (Key : sig
         val bin_size_t : key Bin_prot.Size.sizer

         val bin_write_t : key Bin_prot.Write.writer

         val bin_read_t : key Bin_prot.Read.reader

         val __bin_read_t__ : (int -> key) Bin_prot.Read.reader

         val bin_shape_t : Bin_prot.Shape.t

         val bin_writer_t : key Bin_prot.Type_class.writer

         val bin_reader_t : key Bin_prot.Type_class.reader

         val bin_t : key Bin_prot.Type_class.t
       end)
      -> sig
      val bin_shape_t : Bin_prot.Shape.t -> Bin_prot.Shape.t

      val bin_size_t : ('a, 'a t) Bin_prot.Size.sizer1

      val bin_write_t : ('a, 'a t) Bin_prot.Write.writer1

      val bin_read_t : ('a, 'a t) Bin_prot.Read.reader1

      val __bin_read_t__ : ('a, int -> 'a t) Bin_prot.Read.reader1

      val bin_writer_t : ('a, 'a t) Bin_prot.Type_class.S1.writer

      val bin_reader_t : ('a, 'a t) Bin_prot.Type_class.S1.reader

      val bin_t : ('a, 'a t) Bin_prot.Type_class.S1.t
    end

    val t_of_sexp :
         (Ppx_sexp_conv_lib.Sexp.t -> 'v_x__002_)
      -> Ppx_sexp_conv_lib.Sexp.t
      -> 'v_x__002_ t
  end

  module Hash_set : sig
    type elt = t

    type t = elt Core_kernel__.Hash_set.t

    val sexp_of_t : t -> Ppx_sexp_conv_lib.Sexp.t

    type 'a t_ = t

    type 'a elt_ = elt

    val create :
      ( 'a
      , unit -> t )
      Core_kernel__.Hash_set_intf.create_options_without_first_class_module

    val of_list :
      ( 'a
      , elt list -> t )
      Core_kernel__.Hash_set_intf.create_options_without_first_class_module

    module Provide_of_sexp : functor
      (X : sig
         val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> elt
       end)
      -> sig
      val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> t
    end

    module Provide_bin_io : functor
      (X : sig
         val bin_size_t : elt Bin_prot.Size.sizer

         val bin_write_t : elt Bin_prot.Write.writer

         val bin_read_t : elt Bin_prot.Read.reader

         val __bin_read_t__ : (int -> elt) Bin_prot.Read.reader

         val bin_shape_t : Bin_prot.Shape.t

         val bin_writer_t : elt Bin_prot.Type_class.writer

         val bin_reader_t : elt Bin_prot.Type_class.reader

         val bin_t : elt Bin_prot.Type_class.t
       end)
      -> sig
      val bin_size_t : t Bin_prot.Size.sizer

      val bin_write_t : t Bin_prot.Write.writer

      val bin_read_t : t Bin_prot.Read.reader

      val __bin_read_t__ : (int -> t) Bin_prot.Read.reader

      val bin_shape_t : Bin_prot.Shape.t

      val bin_writer_t : t Bin_prot.Type_class.writer

      val bin_reader_t : t Bin_prot.Type_class.reader

      val bin_t : t Bin_prot.Type_class.t
    end

    val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> t
  end

  module Hash_queue : sig
    type key = t

    val length : ('a, 'b) Core_kernel__.Hash_queue.t -> int

    val is_empty : ('a, 'b) Core_kernel__.Hash_queue.t -> bool

    val iter : ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> unit) -> unit

    val fold :
         ('b, 'a) Core_kernel__.Hash_queue.t
      -> init:'accum
      -> f:('accum -> 'a -> 'accum)
      -> 'accum

    val fold_result :
         ('b, 'a) Core_kernel__.Hash_queue.t
      -> init:'accum
      -> f:('accum -> 'a -> ('accum, 'e) Base__.Result.t)
      -> ('accum, 'e) Base__.Result.t

    val fold_until :
         ('b, 'a) Core_kernel__.Hash_queue.t
      -> init:'accum
      -> f:
           (   'accum
            -> 'a
            -> ('accum, 'final) Base__.Container_intf.Continue_or_stop.t)
      -> finish:('accum -> 'final)
      -> 'final

    val exists : ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> bool) -> bool

    val for_all : ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> bool) -> bool

    val count : ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> bool) -> int

    val sum :
         (module Base__.Container_intf.Summable with type t = 'sum)
      -> ('b, 'a) Core_kernel__.Hash_queue.t
      -> f:('a -> 'sum)
      -> 'sum

    val find :
      ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> bool) -> 'a option

    val find_map :
      ('c, 'a) Core_kernel__.Hash_queue.t -> f:('a -> 'b option) -> 'b option

    val to_list : ('b, 'a) Core_kernel__.Hash_queue.t -> 'a list

    val to_array : ('b, 'a) Core_kernel__.Hash_queue.t -> 'a array

    val min_elt :
         ('b, 'a) Core_kernel__.Hash_queue.t
      -> compare:('a -> 'a -> int)
      -> 'a option

    val max_elt :
         ('b, 'a) Core_kernel__.Hash_queue.t
      -> compare:('a -> 'a -> int)
      -> 'a option

    val invariant :
      ('key, 'data) Core_kernel__.Hash_queue.t -> Core_kernel__.Import.unit

    val create :
         ?growth_allowed:Core_kernel__.Import.bool
      -> ?size:Core_kernel__.Import.int
      -> Core_kernel__.Import.unit
      -> (t, 'data) Core_kernel__.Hash_queue.t

    val clear :
      ('key, 'data) Core_kernel__.Hash_queue.t -> Core_kernel__.Import.unit

    val mem :
         ('key, 'data) Core_kernel__.Hash_queue.t
      -> 'key
      -> Core_kernel__.Import.bool

    val lookup :
         ('key, 'data) Core_kernel__.Hash_queue.t
      -> 'key
      -> 'data Core_kernel__.Import.option

    val lookup_exn : ('key, 'data) Core_kernel__.Hash_queue.t -> 'key -> 'data

    val enqueue :
         ('key, 'data) Core_kernel__.Hash_queue.t
      -> [ `back | `front ]
      -> 'key
      -> 'data
      -> [ `Key_already_present | `Ok ]

    val enqueue_exn :
         ('key, 'data) Core_kernel__.Hash_queue.t
      -> [ `back | `front ]
      -> 'key
      -> 'data
      -> Core_kernel__.Import.unit

    val enqueue_back :
         ('key, 'data) Core_kernel__.Hash_queue.t
      -> 'key
      -> 'data
      -> [ `Key_already_present | `Ok ]

    val enqueue_back_exn :
         ('key, 'data) Core_kernel__.Hash_queue.t
      -> 'key
      -> 'data
      -> Core_kernel__.Import.unit

    val enqueue_front :
         ('key, 'data) Core_kernel__.Hash_queue.t
      -> 'key
      -> 'data
      -> [ `Key_already_present | `Ok ]

    val enqueue_front_exn :
         ('key, 'data) Core_kernel__.Hash_queue.t
      -> 'key
      -> 'data
      -> Core_kernel__.Import.unit

    val lookup_and_move_to_back :
         ('key, 'data) Core_kernel__.Hash_queue.t
      -> 'key
      -> 'data Core_kernel__.Import.option

    val lookup_and_move_to_back_exn :
      ('key, 'data) Core_kernel__.Hash_queue.t -> 'key -> 'data

    val lookup_and_move_to_front :
         ('key, 'data) Core_kernel__.Hash_queue.t
      -> 'key
      -> 'data Core_kernel__.Import.option

    val lookup_and_move_to_front_exn :
      ('key, 'data) Core_kernel__.Hash_queue.t -> 'key -> 'data

    val first :
         ('key, 'data) Core_kernel__.Hash_queue.t
      -> 'data Core_kernel__.Import.option

    val first_with_key :
         ('key, 'data) Core_kernel__.Hash_queue.t
      -> ('key * 'data) Core_kernel__.Import.option

    val keys :
      ('key, 'data) Core_kernel__.Hash_queue.t -> 'key Core_kernel__.Import.list

    val dequeue :
         ('key, 'data) Core_kernel__.Hash_queue.t
      -> [ `back | `front ]
      -> 'data Core_kernel__.Import.option

    val dequeue_exn :
      ('key, 'data) Core_kernel__.Hash_queue.t -> [ `back | `front ] -> 'data

    val dequeue_back :
         ('key, 'data) Core_kernel__.Hash_queue.t
      -> 'data Core_kernel__.Import.option

    val dequeue_back_exn : ('key, 'data) Core_kernel__.Hash_queue.t -> 'data

    val dequeue_front :
         ('key, 'data) Core_kernel__.Hash_queue.t
      -> 'data Core_kernel__.Import.option

    val dequeue_front_exn : ('key, 'data) Core_kernel__.Hash_queue.t -> 'data

    val dequeue_with_key :
         ('key, 'data) Core_kernel__.Hash_queue.t
      -> [ `back | `front ]
      -> ('key * 'data) Core_kernel__.Import.option

    val dequeue_with_key_exn :
         ('key, 'data) Core_kernel__.Hash_queue.t
      -> [ `back | `front ]
      -> 'key * 'data

    val dequeue_back_with_key :
         ('key, 'data) Core_kernel__.Hash_queue.t
      -> ('key * 'data) Core_kernel__.Import.option

    val dequeue_back_with_key_exn :
      ('key, 'data) Core_kernel__.Hash_queue.t -> 'key * 'data

    val dequeue_front_with_key :
         ('key, 'data) Core_kernel__.Hash_queue.t
      -> ('key * 'data) Core_kernel__.Import.option

    val dequeue_front_with_key_exn :
      ('key, 'data) Core_kernel__.Hash_queue.t -> 'key * 'data

    val dequeue_all :
         ('key, 'data) Core_kernel__.Hash_queue.t
      -> f:('data -> Core_kernel__.Import.unit)
      -> Core_kernel__.Import.unit

    val remove :
      ('key, 'data) Core_kernel__.Hash_queue.t -> 'key -> [ `No_such_key | `Ok ]

    val remove_exn :
         ('key, 'data) Core_kernel__.Hash_queue.t
      -> 'key
      -> Core_kernel__.Import.unit

    val replace :
         ('key, 'data) Core_kernel__.Hash_queue.t
      -> 'key
      -> 'data
      -> [ `No_such_key | `Ok ]

    val replace_exn :
         ('key, 'data) Core_kernel__.Hash_queue.t
      -> 'key
      -> 'data
      -> Core_kernel__.Import.unit

    val drop :
         ?n:Core_kernel__.Import.int
      -> ('key, 'data) Core_kernel__.Hash_queue.t
      -> [ `back | `front ]
      -> Core_kernel__.Import.unit

    val drop_front :
         ?n:Core_kernel__.Import.int
      -> ('key, 'data) Core_kernel__.Hash_queue.t
      -> Core_kernel__.Import.unit

    val drop_back :
         ?n:Core_kernel__.Import.int
      -> ('key, 'data) Core_kernel__.Hash_queue.t
      -> Core_kernel__.Import.unit

    val iteri :
         ('key, 'data) Core_kernel__.Hash_queue.t
      -> f:(key:'key -> data:'data -> Core_kernel__.Import.unit)
      -> Core_kernel__.Import.unit

    val foldi :
         ('key, 'data) Core_kernel__.Hash_queue.t
      -> init:'b
      -> f:('b -> key:'key -> data:'data -> 'b)
      -> 'b

    type 'data t = (key, 'data) Core_kernel__.Hash_queue.t

    val sexp_of_t :
      ('data -> Ppx_sexp_conv_lib.Sexp.t) -> 'data t -> Ppx_sexp_conv_lib.Sexp.t
  end

  val ( >= ) : t -> t -> bool

  val ( <= ) : t -> t -> bool

  val ( = ) : t -> t -> bool

  val ( > ) : t -> t -> bool

  val ( < ) : t -> t -> bool

  val ( <> ) : t -> t -> bool

  val equal : t -> t -> bool

  val compare : t -> t -> int

  val min : t -> t -> t

  val max : t -> t -> t

  val ascending : t -> t -> int

  val descending : t -> t -> int

  val between : t -> low:t -> high:t -> bool

  val clamp_exn : t -> min:t -> max:t -> t

  val clamp : t -> min:t -> max:t -> t Base__.Or_error.t

  type comparator_witness =
    Core_kernel__Comparable.Make(Stable.V1).comparator_witness

  val comparator : (t, comparator_witness) Base__.Comparator.comparator

  val validate_lbound : min:t Base__.Maybe_bound.t -> t Base__.Validate.check

  val validate_ubound : max:t Base__.Maybe_bound.t -> t Base__.Validate.check

  val validate_bound :
       min:t Base__.Maybe_bound.t
    -> max:t Base__.Maybe_bound.t
    -> t Base__.Validate.check

  module Replace_polymorphic_compare : sig
    val ( >= ) : t -> t -> bool

    val ( <= ) : t -> t -> bool

    val ( = ) : t -> t -> bool

    val ( > ) : t -> t -> bool

    val ( < ) : t -> t -> bool

    val ( <> ) : t -> t -> bool

    val equal : t -> t -> bool

    val compare : t -> t -> int

    val min : t -> t -> t

    val max : t -> t -> t
  end

  module Map : sig
    module Key : sig
      type t = Table.key

      val t_of_sexp : Sexplib0.Sexp.t -> t

      val sexp_of_t : t -> Sexplib0.Sexp.t

      type comparator_witness =
        Core_kernel__Comparable.Make(Stable.V1).comparator_witness

      val comparator :
        (t, comparator_witness) Core_kernel__.Comparator.comparator
    end

    module Tree : sig
      type 'a t =
        (Table.key, 'a, comparator_witness) Core_kernel__.Map_intf.Tree.t

      val empty : 'a t

      val singleton : Table.key -> 'a -> 'a t

      val of_alist :
        (Table.key * 'a) list -> [ `Duplicate_key of Table.key | `Ok of 'a t ]

      val of_alist_or_error : (Table.key * 'a) list -> 'a t Base__.Or_error.t

      val of_alist_exn : (Table.key * 'a) list -> 'a t

      val of_alist_multi : (Table.key * 'a) list -> 'a list t

      val of_alist_fold :
        (Table.key * 'a) list -> init:'b -> f:('b -> 'a -> 'b) -> 'b t

      val of_alist_reduce : (Table.key * 'a) list -> f:('a -> 'a -> 'a) -> 'a t

      val of_sorted_array : (Table.key * 'a) array -> 'a t Base__.Or_error.t

      val of_sorted_array_unchecked : (Table.key * 'a) array -> 'a t

      val of_increasing_iterator_unchecked :
        len:int -> f:(int -> Table.key * 'a) -> 'a t

      val of_increasing_sequence :
        (Table.key * 'a) Base__.Sequence.t -> 'a t Base__.Or_error.t

      val of_sequence :
           (Table.key * 'a) Base__.Sequence.t
        -> [ `Duplicate_key of Table.key | `Ok of 'a t ]

      val of_sequence_or_error :
        (Table.key * 'a) Base__.Sequence.t -> 'a t Base__.Or_error.t

      val of_sequence_exn : (Table.key * 'a) Base__.Sequence.t -> 'a t

      val of_sequence_multi : (Table.key * 'a) Base__.Sequence.t -> 'a list t

      val of_sequence_fold :
           (Table.key * 'a) Base__.Sequence.t
        -> init:'b
        -> f:('b -> 'a -> 'b)
        -> 'b t

      val of_sequence_reduce :
        (Table.key * 'a) Base__.Sequence.t -> f:('a -> 'a -> 'a) -> 'a t

      val of_iteri :
           iteri:(f:(key:Table.key -> data:'v -> unit) -> unit)
        -> [ `Duplicate_key of Table.key | `Ok of 'v t ]

      val of_tree : 'a t -> 'a t

      val of_hashtbl_exn : (Table.key, 'a) Table.hashtbl -> 'a t

      val of_key_set :
           (Table.key, comparator_witness) Base.Set.t
        -> f:(Table.key -> 'v)
        -> 'v t

      val quickcheck_generator :
           Table.key Core_kernel__.Quickcheck.Generator.t
        -> 'a Core_kernel__.Quickcheck.Generator.t
        -> 'a t Core_kernel__.Quickcheck.Generator.t

      val invariants : 'a t -> bool

      val is_empty : 'a t -> bool

      val length : 'a t -> int

      val add :
        'a t -> key:Table.key -> data:'a -> 'a t Base__.Map_intf.Or_duplicate.t

      val add_exn : 'a t -> key:Table.key -> data:'a -> 'a t

      val set : 'a t -> key:Table.key -> data:'a -> 'a t

      val add_multi : 'a list t -> key:Table.key -> data:'a -> 'a list t

      val remove_multi : 'a list t -> Table.key -> 'a list t

      val find_multi : 'a list t -> Table.key -> 'a list

      val change : 'a t -> Table.key -> f:('a option -> 'a option) -> 'a t

      val update : 'a t -> Table.key -> f:('a option -> 'a) -> 'a t

      val find : 'a t -> Table.key -> 'a option

      val find_exn : 'a t -> Table.key -> 'a

      val remove : 'a t -> Table.key -> 'a t

      val mem : 'a t -> Table.key -> bool

      val iter_keys : 'a t -> f:(Table.key -> unit) -> unit

      val iter : 'a t -> f:('a -> unit) -> unit

      val iteri : 'a t -> f:(key:Table.key -> data:'a -> unit) -> unit

      val iteri_until :
           'a t
        -> f:(key:Table.key -> data:'a -> Base__.Map_intf.Continue_or_stop.t)
        -> Base__.Map_intf.Finished_or_unfinished.t

      val iter2 :
           'a t
        -> 'b t
        -> f:
             (   key:Table.key
              -> data:[ `Both of 'a * 'b | `Left of 'a | `Right of 'b ]
              -> unit)
        -> unit

      val map : 'a t -> f:('a -> 'b) -> 'b t

      val mapi : 'a t -> f:(key:Table.key -> data:'a -> 'b) -> 'b t

      val fold :
        'a t -> init:'b -> f:(key:Table.key -> data:'a -> 'b -> 'b) -> 'b

      val fold_right :
        'a t -> init:'b -> f:(key:Table.key -> data:'a -> 'b -> 'b) -> 'b

      val fold2 :
           'a t
        -> 'b t
        -> init:'c
        -> f:
             (   key:Table.key
              -> data:[ `Both of 'a * 'b | `Left of 'a | `Right of 'b ]
              -> 'c
              -> 'c)
        -> 'c

      val filter_keys : 'a t -> f:(Table.key -> bool) -> 'a t

      val filter : 'a t -> f:('a -> bool) -> 'a t

      val filteri : 'a t -> f:(key:Table.key -> data:'a -> bool) -> 'a t

      val filter_map : 'a t -> f:('a -> 'b option) -> 'b t

      val filter_mapi :
        'a t -> f:(key:Table.key -> data:'a -> 'b option) -> 'b t

      val partition_mapi :
           'a t
        -> f:(key:Table.key -> data:'a -> [ `Fst of 'b | `Snd of 'c ])
        -> 'b t * 'c t

      val partition_map :
        'a t -> f:('a -> [ `Fst of 'b | `Snd of 'c ]) -> 'b t * 'c t

      val partitioni_tf :
        'a t -> f:(key:Table.key -> data:'a -> bool) -> 'a t * 'a t

      val partition_tf : 'a t -> f:('a -> bool) -> 'a t * 'a t

      val compare_direct : ('a -> 'a -> int) -> 'a t -> 'a t -> int

      val equal : ('a -> 'a -> bool) -> 'a t -> 'a t -> bool

      val keys : 'a t -> Table.key list

      val data : 'a t -> 'a list

      val to_alist :
           ?key_order:[ `Decreasing | `Increasing ]
        -> 'a t
        -> (Table.key * 'a) list

      val validate :
           name:(Table.key -> string)
        -> 'a Base__.Validate.check
        -> 'a t Base__.Validate.check

      val merge :
           'a t
        -> 'b t
        -> f:
             (   key:Table.key
              -> [ `Both of 'a * 'b | `Left of 'a | `Right of 'b ]
              -> 'c option)
        -> 'c t

      val symmetric_diff :
           'a t
        -> 'a t
        -> data_equal:('a -> 'a -> bool)
        -> (Table.key, 'a) Base__.Map_intf.Symmetric_diff_element.t
           Base__.Sequence.t

      val fold_symmetric_diff :
           'a t
        -> 'a t
        -> data_equal:('a -> 'a -> bool)
        -> init:'c
        -> f:
             (   'c
              -> (Table.key, 'a) Base__.Map_intf.Symmetric_diff_element.t
              -> 'c)
        -> 'c

      val min_elt : 'a t -> (Table.key * 'a) option

      val min_elt_exn : 'a t -> Table.key * 'a

      val max_elt : 'a t -> (Table.key * 'a) option

      val max_elt_exn : 'a t -> Table.key * 'a

      val for_all : 'a t -> f:('a -> bool) -> bool

      val for_alli : 'a t -> f:(key:Table.key -> data:'a -> bool) -> bool

      val exists : 'a t -> f:('a -> bool) -> bool

      val existsi : 'a t -> f:(key:Table.key -> data:'a -> bool) -> bool

      val count : 'a t -> f:('a -> bool) -> int

      val counti : 'a t -> f:(key:Table.key -> data:'a -> bool) -> int

      val split : 'a t -> Table.key -> 'a t * (Table.key * 'a) option * 'a t

      val append :
           lower_part:'a t
        -> upper_part:'a t
        -> [ `Ok of 'a t | `Overlapping_key_ranges ]

      val subrange :
           'a t
        -> lower_bound:Table.key Base__.Maybe_bound.t
        -> upper_bound:Table.key Base__.Maybe_bound.t
        -> 'a t

      val fold_range_inclusive :
           'a t
        -> min:Table.key
        -> max:Table.key
        -> init:'b
        -> f:(key:Table.key -> data:'a -> 'b -> 'b)
        -> 'b

      val range_to_alist :
        'a t -> min:Table.key -> max:Table.key -> (Table.key * 'a) list

      val closest_key :
           'a t
        -> [ `Greater_or_equal_to
           | `Greater_than
           | `Less_or_equal_to
           | `Less_than ]
        -> Table.key
        -> (Table.key * 'a) option

      val nth : 'a t -> int -> (Table.key * 'a) option

      val nth_exn : 'a t -> int -> Table.key * 'a

      val rank : 'a t -> Table.key -> int option

      val to_tree : 'a t -> 'a t

      val to_sequence :
           ?order:[ `Decreasing_key | `Increasing_key ]
        -> ?keys_greater_or_equal_to:Table.key
        -> ?keys_less_or_equal_to:Table.key
        -> 'a t
        -> (Table.key * 'a) Base__.Sequence.t

      val binary_search :
           'a t
        -> compare:(key:Table.key -> data:'a -> 'key -> int)
        -> [ `First_equal_to
           | `First_greater_than_or_equal_to
           | `First_strictly_greater_than
           | `Last_equal_to
           | `Last_less_than_or_equal_to
           | `Last_strictly_less_than ]
        -> 'key
        -> (Table.key * 'a) option

      val binary_search_segmented :
           'a t
        -> segment_of:(key:Table.key -> data:'a -> [ `Left | `Right ])
        -> [ `First_on_right | `Last_on_left ]
        -> (Table.key * 'a) option

      val key_set : 'a t -> (Table.key, comparator_witness) Base.Set.t

      val quickcheck_observer :
           Table.key Core_kernel__.Quickcheck.Observer.t
        -> 'v Core_kernel__.Quickcheck.Observer.t
        -> 'v t Core_kernel__.Quickcheck.Observer.t

      val quickcheck_shrinker :
           Table.key Core_kernel__.Quickcheck.Shrinker.t
        -> 'v Core_kernel__.Quickcheck.Shrinker.t
        -> 'v t Core_kernel__.Quickcheck.Shrinker.t

      module Provide_of_sexp : functor
        (K : sig
           val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> Table.key
         end)
        -> sig
        val t_of_sexp :
             (Ppx_sexp_conv_lib.Sexp.t -> 'v_x__001_)
          -> Ppx_sexp_conv_lib.Sexp.t
          -> 'v_x__001_ t
      end

      val t_of_sexp : (Base__.Sexp.t -> 'a) -> Base__.Sexp.t -> 'a t

      val sexp_of_t : ('a -> Base__.Sexp.t) -> 'a t -> Base__.Sexp.t
    end

    type 'a t = (Table.key, 'a, comparator_witness) Core_kernel__.Map_intf.Map.t

    val compare :
         ('a -> 'a -> Core_kernel__.Import.int)
      -> 'a t
      -> 'a t
      -> Core_kernel__.Import.int

    val empty : 'a t

    val singleton : Table.key -> 'a -> 'a t

    val of_alist :
      (Table.key * 'a) list -> [ `Duplicate_key of Table.key | `Ok of 'a t ]

    val of_alist_or_error : (Table.key * 'a) list -> 'a t Base__.Or_error.t

    val of_alist_exn : (Table.key * 'a) list -> 'a t

    val of_alist_multi : (Table.key * 'a) list -> 'a list t

    val of_alist_fold :
      (Table.key * 'a) list -> init:'b -> f:('b -> 'a -> 'b) -> 'b t

    val of_alist_reduce : (Table.key * 'a) list -> f:('a -> 'a -> 'a) -> 'a t

    val of_sorted_array : (Table.key * 'a) array -> 'a t Base__.Or_error.t

    val of_sorted_array_unchecked : (Table.key * 'a) array -> 'a t

    val of_increasing_iterator_unchecked :
      len:int -> f:(int -> Table.key * 'a) -> 'a t

    val of_increasing_sequence :
      (Table.key * 'a) Base__.Sequence.t -> 'a t Base__.Or_error.t

    val of_sequence :
         (Table.key * 'a) Base__.Sequence.t
      -> [ `Duplicate_key of Table.key | `Ok of 'a t ]

    val of_sequence_or_error :
      (Table.key * 'a) Base__.Sequence.t -> 'a t Base__.Or_error.t

    val of_sequence_exn : (Table.key * 'a) Base__.Sequence.t -> 'a t

    val of_sequence_multi : (Table.key * 'a) Base__.Sequence.t -> 'a list t

    val of_sequence_fold :
         (Table.key * 'a) Base__.Sequence.t
      -> init:'b
      -> f:('b -> 'a -> 'b)
      -> 'b t

    val of_sequence_reduce :
      (Table.key * 'a) Base__.Sequence.t -> f:('a -> 'a -> 'a) -> 'a t

    val of_iteri :
         iteri:(f:(key:Table.key -> data:'v -> unit) -> unit)
      -> [ `Duplicate_key of Table.key | `Ok of 'v t ]

    val of_tree : 'a Tree.t -> 'a t

    val of_hashtbl_exn : (Table.key, 'a) Table.hashtbl -> 'a t

    val of_key_set :
      (Table.key, comparator_witness) Base.Set.t -> f:(Table.key -> 'v) -> 'v t

    val quickcheck_generator :
         Table.key Core_kernel__.Quickcheck.Generator.t
      -> 'a Core_kernel__.Quickcheck.Generator.t
      -> 'a t Core_kernel__.Quickcheck.Generator.t

    val invariants : 'a t -> bool

    val is_empty : 'a t -> bool

    val length : 'a t -> int

    val add :
      'a t -> key:Table.key -> data:'a -> 'a t Base__.Map_intf.Or_duplicate.t

    val add_exn : 'a t -> key:Table.key -> data:'a -> 'a t

    val set : 'a t -> key:Table.key -> data:'a -> 'a t

    val add_multi : 'a list t -> key:Table.key -> data:'a -> 'a list t

    val remove_multi : 'a list t -> Table.key -> 'a list t

    val find_multi : 'a list t -> Table.key -> 'a list

    val change : 'a t -> Table.key -> f:('a option -> 'a option) -> 'a t

    val update : 'a t -> Table.key -> f:('a option -> 'a) -> 'a t

    val find : 'a t -> Table.key -> 'a option

    val find_exn : 'a t -> Table.key -> 'a

    val remove : 'a t -> Table.key -> 'a t

    val mem : 'a t -> Table.key -> bool

    val iter_keys : 'a t -> f:(Table.key -> unit) -> unit

    val iter : 'a t -> f:('a -> unit) -> unit

    val iteri : 'a t -> f:(key:Table.key -> data:'a -> unit) -> unit

    val iteri_until :
         'a t
      -> f:(key:Table.key -> data:'a -> Base__.Map_intf.Continue_or_stop.t)
      -> Base__.Map_intf.Finished_or_unfinished.t

    val iter2 :
         'a t
      -> 'b t
      -> f:
           (   key:Table.key
            -> data:[ `Both of 'a * 'b | `Left of 'a | `Right of 'b ]
            -> unit)
      -> unit

    val map : 'a t -> f:('a -> 'b) -> 'b t

    val mapi : 'a t -> f:(key:Table.key -> data:'a -> 'b) -> 'b t

    val fold : 'a t -> init:'b -> f:(key:Table.key -> data:'a -> 'b -> 'b) -> 'b

    val fold_right :
      'a t -> init:'b -> f:(key:Table.key -> data:'a -> 'b -> 'b) -> 'b

    val fold2 :
         'a t
      -> 'b t
      -> init:'c
      -> f:
           (   key:Table.key
            -> data:[ `Both of 'a * 'b | `Left of 'a | `Right of 'b ]
            -> 'c
            -> 'c)
      -> 'c

    val filter_keys : 'a t -> f:(Table.key -> bool) -> 'a t

    val filter : 'a t -> f:('a -> bool) -> 'a t

    val filteri : 'a t -> f:(key:Table.key -> data:'a -> bool) -> 'a t

    val filter_map : 'a t -> f:('a -> 'b option) -> 'b t

    val filter_mapi : 'a t -> f:(key:Table.key -> data:'a -> 'b option) -> 'b t

    val partition_mapi :
         'a t
      -> f:(key:Table.key -> data:'a -> [ `Fst of 'b | `Snd of 'c ])
      -> 'b t * 'c t

    val partition_map :
      'a t -> f:('a -> [ `Fst of 'b | `Snd of 'c ]) -> 'b t * 'c t

    val partitioni_tf :
      'a t -> f:(key:Table.key -> data:'a -> bool) -> 'a t * 'a t

    val partition_tf : 'a t -> f:('a -> bool) -> 'a t * 'a t

    val compare_direct : ('a -> 'a -> int) -> 'a t -> 'a t -> int

    val equal : ('a -> 'a -> bool) -> 'a t -> 'a t -> bool

    val keys : 'a t -> Table.key list

    val data : 'a t -> 'a list

    val to_alist :
      ?key_order:[ `Decreasing | `Increasing ] -> 'a t -> (Table.key * 'a) list

    val validate :
         name:(Table.key -> string)
      -> 'a Base__.Validate.check
      -> 'a t Base__.Validate.check

    val merge :
         'a t
      -> 'b t
      -> f:
           (   key:Table.key
            -> [ `Both of 'a * 'b | `Left of 'a | `Right of 'b ]
            -> 'c option)
      -> 'c t

    val symmetric_diff :
         'a t
      -> 'a t
      -> data_equal:('a -> 'a -> bool)
      -> (Table.key, 'a) Base__.Map_intf.Symmetric_diff_element.t
         Base__.Sequence.t

    val fold_symmetric_diff :
         'a t
      -> 'a t
      -> data_equal:('a -> 'a -> bool)
      -> init:'c
      -> f:
           (   'c
            -> (Table.key, 'a) Base__.Map_intf.Symmetric_diff_element.t
            -> 'c)
      -> 'c

    val min_elt : 'a t -> (Table.key * 'a) option

    val min_elt_exn : 'a t -> Table.key * 'a

    val max_elt : 'a t -> (Table.key * 'a) option

    val max_elt_exn : 'a t -> Table.key * 'a

    val for_all : 'a t -> f:('a -> bool) -> bool

    val for_alli : 'a t -> f:(key:Table.key -> data:'a -> bool) -> bool

    val exists : 'a t -> f:('a -> bool) -> bool

    val existsi : 'a t -> f:(key:Table.key -> data:'a -> bool) -> bool

    val count : 'a t -> f:('a -> bool) -> int

    val counti : 'a t -> f:(key:Table.key -> data:'a -> bool) -> int

    val split : 'a t -> Table.key -> 'a t * (Table.key * 'a) option * 'a t

    val append :
         lower_part:'a t
      -> upper_part:'a t
      -> [ `Ok of 'a t | `Overlapping_key_ranges ]

    val subrange :
         'a t
      -> lower_bound:Table.key Base__.Maybe_bound.t
      -> upper_bound:Table.key Base__.Maybe_bound.t
      -> 'a t

    val fold_range_inclusive :
         'a t
      -> min:Table.key
      -> max:Table.key
      -> init:'b
      -> f:(key:Table.key -> data:'a -> 'b -> 'b)
      -> 'b

    val range_to_alist :
      'a t -> min:Table.key -> max:Table.key -> (Table.key * 'a) list

    val closest_key :
         'a t
      -> [ `Greater_or_equal_to
         | `Greater_than
         | `Less_or_equal_to
         | `Less_than ]
      -> Table.key
      -> (Table.key * 'a) option

    val nth : 'a t -> int -> (Table.key * 'a) option

    val nth_exn : 'a t -> int -> Table.key * 'a

    val rank : 'a t -> Table.key -> int option

    val to_tree : 'a t -> 'a Tree.t

    val to_sequence :
         ?order:[ `Decreasing_key | `Increasing_key ]
      -> ?keys_greater_or_equal_to:Table.key
      -> ?keys_less_or_equal_to:Table.key
      -> 'a t
      -> (Table.key * 'a) Base__.Sequence.t

    val binary_search :
         'a t
      -> compare:(key:Table.key -> data:'a -> 'key -> int)
      -> [ `First_equal_to
         | `First_greater_than_or_equal_to
         | `First_strictly_greater_than
         | `Last_equal_to
         | `Last_less_than_or_equal_to
         | `Last_strictly_less_than ]
      -> 'key
      -> (Table.key * 'a) option

    val binary_search_segmented :
         'a t
      -> segment_of:(key:Table.key -> data:'a -> [ `Left | `Right ])
      -> [ `First_on_right | `Last_on_left ]
      -> (Table.key * 'a) option

    val key_set : 'a t -> (Table.key, comparator_witness) Base.Set.t

    val quickcheck_observer :
         Table.key Core_kernel__.Quickcheck.Observer.t
      -> 'v Core_kernel__.Quickcheck.Observer.t
      -> 'v t Core_kernel__.Quickcheck.Observer.t

    val quickcheck_shrinker :
         Table.key Core_kernel__.Quickcheck.Shrinker.t
      -> 'v Core_kernel__.Quickcheck.Shrinker.t
      -> 'v t Core_kernel__.Quickcheck.Shrinker.t

    module Provide_of_sexp : functor
      (Key : sig
         val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> Table.key
       end)
      -> sig
      val t_of_sexp :
           (Ppx_sexp_conv_lib.Sexp.t -> 'v_x__002_)
        -> Ppx_sexp_conv_lib.Sexp.t
        -> 'v_x__002_ t
    end

    module Provide_bin_io : functor
      (Key : sig
         val bin_size_t : Table.key Bin_prot.Size.sizer

         val bin_write_t : Table.key Bin_prot.Write.writer

         val bin_read_t : Table.key Bin_prot.Read.reader

         val __bin_read_t__ : (int -> Table.key) Bin_prot.Read.reader

         val bin_shape_t : Bin_prot.Shape.t

         val bin_writer_t : Table.key Bin_prot.Type_class.writer

         val bin_reader_t : Table.key Bin_prot.Type_class.reader

         val bin_t : Table.key Bin_prot.Type_class.t
       end)
      -> sig
      val bin_shape_t : Bin_prot.Shape.t -> Bin_prot.Shape.t

      val bin_size_t : ('a, 'a t) Bin_prot.Size.sizer1

      val bin_write_t : ('a, 'a t) Bin_prot.Write.writer1

      val bin_read_t : ('a, 'a t) Bin_prot.Read.reader1

      val __bin_read_t__ : ('a, int -> 'a t) Bin_prot.Read.reader1

      val bin_writer_t : ('a, 'a t) Bin_prot.Type_class.S1.writer

      val bin_reader_t : ('a, 'a t) Bin_prot.Type_class.S1.reader

      val bin_t : ('a, 'a t) Bin_prot.Type_class.S1.t
    end

    module Provide_hash : functor
      (Key : sig
         val hash_fold_t : Base__.Hash.state -> Table.key -> Base__.Hash.state
       end)
      -> sig
      val hash_fold_t :
           (Ppx_hash_lib.Std.Hash.state -> 'a -> Ppx_hash_lib.Std.Hash.state)
        -> Ppx_hash_lib.Std.Hash.state
        -> 'a t
        -> Ppx_hash_lib.Std.Hash.state
    end

    val t_of_sexp : (Base__.Sexp.t -> 'a) -> Base__.Sexp.t -> 'a t

    val sexp_of_t : ('a -> Base__.Sexp.t) -> 'a t -> Base__.Sexp.t
  end

  module Set : sig
    module Elt : sig
      type t = Table.key

      val t_of_sexp : Sexplib0.Sexp.t -> t

      val sexp_of_t : t -> Sexplib0.Sexp.t

      type comparator_witness = Map.Key.comparator_witness

      val comparator :
        (t, comparator_witness) Core_kernel__.Comparator.comparator
    end

    module Tree : sig
      type t = (Table.key, comparator_witness) Core_kernel__.Set_intf.Tree.t

      val compare : t -> t -> Core_kernel__.Import.int

      type named =
        (Table.key, comparator_witness) Core_kernel__.Set_intf.Tree.Named.t

      val length : t -> int

      val is_empty : t -> bool

      val iter : t -> f:(Table.key -> unit) -> unit

      val fold : t -> init:'accum -> f:('accum -> Table.key -> 'accum) -> 'accum

      val fold_result :
           t
        -> init:'accum
        -> f:('accum -> Table.key -> ('accum, 'e) Base__.Result.t)
        -> ('accum, 'e) Base__.Result.t

      val exists : t -> f:(Table.key -> bool) -> bool

      val for_all : t -> f:(Table.key -> bool) -> bool

      val count : t -> f:(Table.key -> bool) -> int

      val sum :
           (module Base__.Container_intf.Summable with type t = 'sum)
        -> t
        -> f:(Table.key -> 'sum)
        -> 'sum

      val find : t -> f:(Table.key -> bool) -> Table.key option

      val find_map : t -> f:(Table.key -> 'a option) -> 'a option

      val to_list : t -> Table.key list

      val to_array : t -> Table.key array

      val invariants : t -> bool

      val mem : t -> Table.key -> bool

      val add : t -> Table.key -> t

      val remove : t -> Table.key -> t

      val union : t -> t -> t

      val inter : t -> t -> t

      val diff : t -> t -> t

      val symmetric_diff :
        t -> t -> (Table.key, Table.key) Base__.Either.t Base__.Sequence.t

      val compare_direct : t -> t -> int

      val equal : t -> t -> bool

      val is_subset : t -> of_:t -> bool

      module Named : sig
        val is_subset : named -> of_:named -> unit Base__.Or_error.t

        val equal : named -> named -> unit Base__.Or_error.t
      end

      val fold_until :
           t
        -> init:'b
        -> f:
             (   'b
              -> Table.key
              -> ('b, 'final) Base__.Set_intf.Continue_or_stop.t)
        -> finish:('b -> 'final)
        -> 'final

      val fold_right : t -> init:'b -> f:(Table.key -> 'b -> 'b) -> 'b

      val iter2 :
           t
        -> t
        -> f:
             (   [ `Both of Table.key * Table.key
                 | `Left of Table.key
                 | `Right of Table.key ]
              -> unit)
        -> unit

      val filter : t -> f:(Table.key -> bool) -> t

      val partition_tf : t -> f:(Table.key -> bool) -> t * t

      val elements : t -> Table.key list

      val min_elt : t -> Table.key option

      val min_elt_exn : t -> Table.key

      val max_elt : t -> Table.key option

      val max_elt_exn : t -> Table.key

      val choose : t -> Table.key option

      val choose_exn : t -> Table.key

      val split : t -> Table.key -> t * Table.key option * t

      val group_by : t -> equiv:(Table.key -> Table.key -> bool) -> t list

      val find_exn : t -> f:(Table.key -> bool) -> Table.key

      val nth : t -> int -> Table.key option

      val remove_index : t -> int -> t

      val to_tree : t -> t

      val to_sequence :
           ?order:[ `Decreasing | `Increasing ]
        -> ?greater_or_equal_to:Table.key
        -> ?less_or_equal_to:Table.key
        -> t
        -> Table.key Base__.Sequence.t

      val binary_search :
           t
        -> compare:(Table.key -> 'key -> int)
        -> [ `First_equal_to
           | `First_greater_than_or_equal_to
           | `First_strictly_greater_than
           | `Last_equal_to
           | `Last_less_than_or_equal_to
           | `Last_strictly_less_than ]
        -> 'key
        -> Table.key option

      val binary_search_segmented :
           t
        -> segment_of:(Table.key -> [ `Left | `Right ])
        -> [ `First_on_right | `Last_on_left ]
        -> Table.key option

      val merge_to_sequence :
           ?order:[ `Decreasing | `Increasing ]
        -> ?greater_or_equal_to:Table.key
        -> ?less_or_equal_to:Table.key
        -> t
        -> t
        -> (Table.key, Table.key) Base__.Set_intf.Merge_to_sequence_element.t
           Base__.Sequence.t

      val to_map :
           t
        -> f:(Table.key -> 'data)
        -> (Table.key, 'data, comparator_witness) Base.Map.t

      val quickcheck_observer :
           Table.key Core_kernel__.Quickcheck.Observer.t
        -> t Core_kernel__.Quickcheck.Observer.t

      val quickcheck_shrinker :
           Table.key Core_kernel__.Quickcheck.Shrinker.t
        -> t Core_kernel__.Quickcheck.Shrinker.t

      val empty : t

      val singleton : Table.key -> t

      val union_list : t list -> t

      val of_list : Table.key list -> t

      val of_array : Table.key array -> t

      val of_sorted_array : Table.key array -> t Base__.Or_error.t

      val of_sorted_array_unchecked : Table.key array -> t

      val of_increasing_iterator_unchecked :
        len:int -> f:(int -> Table.key) -> t

      val stable_dedup_list : Table.key list -> Table.key list

      val map :
        ('a, 'b) Core_kernel__.Set_intf.Tree.t -> f:('a -> Table.key) -> t

      val filter_map :
           ('a, 'b) Core_kernel__.Set_intf.Tree.t
        -> f:('a -> Table.key option)
        -> t

      val of_tree : t -> t

      val of_hash_set : Table.key Core_kernel__.Hash_set.t -> t

      val of_hashtbl_keys : (Table.key, 'a) Table.hashtbl -> t

      val of_map_keys : (Table.key, 'a, comparator_witness) Base.Map.t -> t

      val quickcheck_generator :
           Table.key Core_kernel__.Quickcheck.Generator.t
        -> t Core_kernel__.Quickcheck.Generator.t

      module Provide_of_sexp : functor
        (Elt : sig
           val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> Table.key
         end)
        -> sig
        val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> t
      end

      val t_of_sexp : Base__.Sexp.t -> t

      val sexp_of_t : t -> Base__.Sexp.t
    end

    type t = (Table.key, comparator_witness) Base.Set.t

    val compare : t -> t -> Core_kernel__.Import.int

    type named = (Table.key, comparator_witness) Core_kernel__.Set_intf.Named.t

    val length : t -> int

    val is_empty : t -> bool

    val iter : t -> f:(Table.key -> unit) -> unit

    val fold : t -> init:'accum -> f:('accum -> Table.key -> 'accum) -> 'accum

    val fold_result :
         t
      -> init:'accum
      -> f:('accum -> Table.key -> ('accum, 'e) Base__.Result.t)
      -> ('accum, 'e) Base__.Result.t

    val exists : t -> f:(Table.key -> bool) -> bool

    val for_all : t -> f:(Table.key -> bool) -> bool

    val count : t -> f:(Table.key -> bool) -> int

    val sum :
         (module Base__.Container_intf.Summable with type t = 'sum)
      -> t
      -> f:(Table.key -> 'sum)
      -> 'sum

    val find : t -> f:(Table.key -> bool) -> Table.key option

    val find_map : t -> f:(Table.key -> 'a option) -> 'a option

    val to_list : t -> Table.key list

    val to_array : t -> Table.key array

    val invariants : t -> bool

    val mem : t -> Table.key -> bool

    val add : t -> Table.key -> t

    val remove : t -> Table.key -> t

    val union : t -> t -> t

    val inter : t -> t -> t

    val diff : t -> t -> t

    val symmetric_diff :
      t -> t -> (Table.key, Table.key) Base__.Either.t Base__.Sequence.t

    val compare_direct : t -> t -> int

    val equal : t -> t -> bool

    val is_subset : t -> of_:t -> bool

    module Named : sig
      val is_subset : named -> of_:named -> unit Base__.Or_error.t

      val equal : named -> named -> unit Base__.Or_error.t
    end

    val fold_until :
         t
      -> init:'b
      -> f:('b -> Table.key -> ('b, 'final) Base__.Set_intf.Continue_or_stop.t)
      -> finish:('b -> 'final)
      -> 'final

    val fold_right : t -> init:'b -> f:(Table.key -> 'b -> 'b) -> 'b

    val iter2 :
         t
      -> t
      -> f:
           (   [ `Both of Table.key * Table.key
               | `Left of Table.key
               | `Right of Table.key ]
            -> unit)
      -> unit

    val filter : t -> f:(Table.key -> bool) -> t

    val partition_tf : t -> f:(Table.key -> bool) -> t * t

    val elements : t -> Table.key list

    val min_elt : t -> Table.key option

    val min_elt_exn : t -> Table.key

    val max_elt : t -> Table.key option

    val max_elt_exn : t -> Table.key

    val choose : t -> Table.key option

    val choose_exn : t -> Table.key

    val split : t -> Table.key -> t * Table.key option * t

    val group_by : t -> equiv:(Table.key -> Table.key -> bool) -> t list

    val find_exn : t -> f:(Table.key -> bool) -> Table.key

    val nth : t -> int -> Table.key option

    val remove_index : t -> int -> t

    val to_tree : t -> Tree.t

    val to_sequence :
         ?order:[ `Decreasing | `Increasing ]
      -> ?greater_or_equal_to:Table.key
      -> ?less_or_equal_to:Table.key
      -> t
      -> Table.key Base__.Sequence.t

    val binary_search :
         t
      -> compare:(Table.key -> 'key -> int)
      -> [ `First_equal_to
         | `First_greater_than_or_equal_to
         | `First_strictly_greater_than
         | `Last_equal_to
         | `Last_less_than_or_equal_to
         | `Last_strictly_less_than ]
      -> 'key
      -> Table.key option

    val binary_search_segmented :
         t
      -> segment_of:(Table.key -> [ `Left | `Right ])
      -> [ `First_on_right | `Last_on_left ]
      -> Table.key option

    val merge_to_sequence :
         ?order:[ `Decreasing | `Increasing ]
      -> ?greater_or_equal_to:Table.key
      -> ?less_or_equal_to:Table.key
      -> t
      -> t
      -> (Table.key, Table.key) Base__.Set_intf.Merge_to_sequence_element.t
         Base__.Sequence.t

    val to_map :
         t
      -> f:(Table.key -> 'data)
      -> (Table.key, 'data, comparator_witness) Base.Map.t

    val quickcheck_observer :
         Table.key Core_kernel__.Quickcheck.Observer.t
      -> t Core_kernel__.Quickcheck.Observer.t

    val quickcheck_shrinker :
         Table.key Core_kernel__.Quickcheck.Shrinker.t
      -> t Core_kernel__.Quickcheck.Shrinker.t

    val empty : t

    val singleton : Table.key -> t

    val union_list : t list -> t

    val of_list : Table.key list -> t

    val of_array : Table.key array -> t

    val of_sorted_array : Table.key array -> t Base__.Or_error.t

    val of_sorted_array_unchecked : Table.key array -> t

    val of_increasing_iterator_unchecked : len:int -> f:(int -> Table.key) -> t

    val stable_dedup_list : Table.key list -> Table.key list

    val map : ('a, 'b) Base.Set.t -> f:('a -> Table.key) -> t

    val filter_map : ('a, 'b) Base.Set.t -> f:('a -> Table.key option) -> t

    val of_tree : Tree.t -> t

    val of_hash_set : Table.key Core_kernel__.Hash_set.t -> t

    val of_hashtbl_keys : (Table.key, 'a) Table.hashtbl -> t

    val of_map_keys : (Table.key, 'a, comparator_witness) Base.Map.t -> t

    val quickcheck_generator :
         Table.key Core_kernel__.Quickcheck.Generator.t
      -> t Core_kernel__.Quickcheck.Generator.t

    module Provide_of_sexp : functor
      (Elt : sig
         val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> Table.key
       end)
      -> sig
      val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> t
    end

    module Provide_bin_io : functor
      (Elt : sig
         val bin_size_t : Table.key Bin_prot.Size.sizer

         val bin_write_t : Table.key Bin_prot.Write.writer

         val bin_read_t : Table.key Bin_prot.Read.reader

         val __bin_read_t__ : (int -> Table.key) Bin_prot.Read.reader

         val bin_shape_t : Bin_prot.Shape.t

         val bin_writer_t : Table.key Bin_prot.Type_class.writer

         val bin_reader_t : Table.key Bin_prot.Type_class.reader

         val bin_t : Table.key Bin_prot.Type_class.t
       end)
      -> sig
      val bin_size_t : t Bin_prot.Size.sizer

      val bin_write_t : t Bin_prot.Write.writer

      val bin_read_t : t Bin_prot.Read.reader

      val __bin_read_t__ : (int -> t) Bin_prot.Read.reader

      val bin_shape_t : Bin_prot.Shape.t

      val bin_writer_t : t Bin_prot.Type_class.writer

      val bin_reader_t : t Bin_prot.Type_class.reader

      val bin_t : t Bin_prot.Type_class.t
    end

    module Provide_hash : functor
      (Elt : sig
         val hash_fold_t : Base__.Hash.state -> Table.key -> Base__.Hash.state
       end)
      -> sig
      val hash_fold_t :
        Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state

      val hash : t -> Ppx_hash_lib.Std.Hash.hash_value
    end

    val t_of_sexp : Base__.Sexp.t -> t

    val sexp_of_t : t -> Base__.Sexp.t
  end
end

module Stable : sig
  module V1 : sig
    type t = User_command.Stable.V1.t Poly.t

    val to_yojson : t -> Yojson.Safe.t

    val of_yojson : Yojson.Safe.t -> t Ppx_deriving_yojson_runtime.error_or

    val version : int

    val __versioned__ : unit

    val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> t

    val sexp_of_t : t -> Ppx_sexp_conv_lib.Sexp.t

    val compare : t -> t -> int

    val equal : t -> t -> bool

    val hash_fold_t :
      Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state

    val hash : t -> Ppx_hash_lib.Std.Hash.hash_value

    val to_latest : 'a -> 'a

    module With_version : sig
      type typ = t

      val bin_shape_typ : Core.Bin_prot.Shape.t

      val bin_size_typ : typ Core.Bin_prot.Size.sizer

      val bin_write_typ : typ Core.Bin_prot.Write.writer

      val bin_writer_typ : typ Core.Bin_prot.Type_class.writer

      val __bin_read_typ__ : (int -> typ) Core.Bin_prot.Read.reader

      val bin_read_typ : typ Core.Bin_prot.Read.reader

      val bin_reader_typ : typ Core.Bin_prot.Type_class.reader

      val bin_typ : typ Core.Bin_prot.Type_class.t

      type t = { version : int; t : typ }

      val bin_shape_t : Core.Bin_prot.Shape.t

      val bin_size_t : t Core.Bin_prot.Size.sizer

      val bin_write_t : t Core.Bin_prot.Write.writer

      val bin_writer_t : t Core.Bin_prot.Type_class.writer

      val __bin_read_t__ : (int -> t) Core.Bin_prot.Read.reader

      val bin_read_t : t Core.Bin_prot.Read.reader

      val bin_reader_t : t Core.Bin_prot.Type_class.reader

      val bin_t : t Core.Bin_prot.Type_class.t

      val create : typ -> t
    end

    val bin_read_t : Bin_prot.Common.buf -> pos_ref:Bin_prot.Common.pos_ref -> t

    val __bin_read_t__ :
      Bin_prot.Common.buf -> pos_ref:Bin_prot.Common.pos_ref -> int -> t

    val bin_size_t : t -> int

    val bin_write_t :
      Bin_prot.Common.buf -> pos:Bin_prot.Common.pos -> t -> Bin_prot.Common.pos

    val bin_shape_t : Core.Bin_prot.Shape.t

    val bin_reader_t : t Core.Bin_prot.Type_class.reader

    val bin_writer_t : t Core.Bin_prot.Type_class.writer

    val bin_t : t Core.Bin_prot.Type_class.t

    val __ :
      (Bin_prot.Common.buf -> pos_ref:Bin_prot.Common.pos_ref -> t)
      * (Bin_prot.Common.buf -> pos_ref:Bin_prot.Common.pos_ref -> int -> t)
      * (t -> int)
      * (   Bin_prot.Common.buf
         -> pos:Bin_prot.Common.pos
         -> t
         -> Bin_prot.Common.pos)
      * Core.Bin_prot.Shape.t
      * t Core.Bin_prot.Type_class.reader
      * t Core.Bin_prot.Type_class.writer
      * t Core.Bin_prot.Type_class.t
  end

  module Latest = V1

  val versions :
    (int * (Core_kernel.Bigstring.t -> pos_ref:int Core.ref -> Latest.t)) array

  val bin_read_to_latest_opt :
       Bin_prot.Common.buf
    -> pos_ref:Bin_prot.Common.pos Core_kernel.ref
    -> Latest.t option

  val __ :
       Bin_prot.Common.buf
    -> pos_ref:Bin_prot.Common.pos Core_kernel.ref
    -> Latest.t option
end

type t = Stable.Latest.t

val to_yojson : t -> Yojson.Safe.t

val of_yojson : Yojson.Safe.t -> t Ppx_deriving_yojson_runtime.error_or

val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> t

val sexp_of_t : t -> Ppx_sexp_conv_lib.Sexp.t

val hash_fold_t :
  Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state

val hash : t -> Ppx_hash_lib.Std.Hash.hash_value

val hashable : t Core_kernel__.Hashtbl.Hashable.t

module Table : sig
  type key = t

  type ('a, 'b) hashtbl = ('a, 'b) Valid.Table.hashtbl

  type 'b t = (key, 'b) hashtbl

  val sexp_of_t :
    ('b -> Ppx_sexp_conv_lib.Sexp.t) -> 'b t -> Ppx_sexp_conv_lib.Sexp.t

  type ('a, 'b) t_ = 'b t

  type 'a key_ = key

  val hashable : key Core_kernel__.Hashtbl_intf.Hashable.t

  val invariant : 'a Base__.Invariant_intf.inv -> 'a t Base__.Invariant_intf.inv

  val create :
    ( key
    , 'b
    , unit -> 'b t )
    Core_kernel__.Hashtbl_intf.create_options_without_hashable

  val of_alist :
    ( key
    , 'b
    , (key * 'b) list -> [ `Duplicate_key of key | `Ok of 'b t ] )
    Core_kernel__.Hashtbl_intf.create_options_without_hashable

  val of_alist_report_all_dups :
    ( key
    , 'b
    , (key * 'b) list -> [ `Duplicate_keys of key list | `Ok of 'b t ] )
    Core_kernel__.Hashtbl_intf.create_options_without_hashable

  val of_alist_or_error :
    ( key
    , 'b
    , (key * 'b) list -> 'b t Base__.Or_error.t )
    Core_kernel__.Hashtbl_intf.create_options_without_hashable

  val of_alist_exn :
    ( key
    , 'b
    , (key * 'b) list -> 'b t )
    Core_kernel__.Hashtbl_intf.create_options_without_hashable

  val of_alist_multi :
    ( key
    , 'b list
    , (key * 'b) list -> 'b list t )
    Core_kernel__.Hashtbl_intf.create_options_without_hashable

  val create_mapped :
    ( key
    , 'b
    ,    get_key:('r -> key)
      -> get_data:('r -> 'b)
      -> 'r list
      -> [ `Duplicate_keys of key list | `Ok of 'b t ] )
    Core_kernel__.Hashtbl_intf.create_options_without_hashable

  val create_with_key :
    ( key
    , 'r
    ,    get_key:('r -> key)
      -> 'r list
      -> [ `Duplicate_keys of key list | `Ok of 'r t ] )
    Core_kernel__.Hashtbl_intf.create_options_without_hashable

  val create_with_key_or_error :
    ( key
    , 'r
    , get_key:('r -> key) -> 'r list -> 'r t Base__.Or_error.t )
    Core_kernel__.Hashtbl_intf.create_options_without_hashable

  val create_with_key_exn :
    ( key
    , 'r
    , get_key:('r -> key) -> 'r list -> 'r t )
    Core_kernel__.Hashtbl_intf.create_options_without_hashable

  val group :
    ( key
    , 'b
    ,    get_key:('r -> key)
      -> get_data:('r -> 'b)
      -> combine:('b -> 'b -> 'b)
      -> 'r list
      -> 'b t )
    Core_kernel__.Hashtbl_intf.create_options_without_hashable

  val sexp_of_key : 'a t -> key -> Base__.Sexp.t

  val clear : 'a t -> unit

  val copy : 'b t -> 'b t

  val fold : 'b t -> init:'c -> f:(key:key -> data:'b -> 'c -> 'c) -> 'c

  val iter_keys : 'a t -> f:(key -> unit) -> unit

  val iter : 'b t -> f:('b -> unit) -> unit

  val iteri : 'b t -> f:(key:key -> data:'b -> unit) -> unit

  val existsi : 'b t -> f:(key:key -> data:'b -> bool) -> bool

  val exists : 'b t -> f:('b -> bool) -> bool

  val for_alli : 'b t -> f:(key:key -> data:'b -> bool) -> bool

  val for_all : 'b t -> f:('b -> bool) -> bool

  val counti : 'b t -> f:(key:key -> data:'b -> bool) -> int

  val count : 'b t -> f:('b -> bool) -> int

  val length : 'a t -> int

  val is_empty : 'a t -> bool

  val mem : 'a t -> key -> bool

  val remove : 'a t -> key -> unit

  val choose : 'b t -> (key * 'b) option

  val choose_exn : 'b t -> key * 'b

  val set : 'b t -> key:key -> data:'b -> unit

  val add : 'b t -> key:key -> data:'b -> [ `Duplicate | `Ok ]

  val add_exn : 'b t -> key:key -> data:'b -> unit

  val change : 'b t -> key -> f:('b option -> 'b option) -> unit

  val update : 'b t -> key -> f:('b option -> 'b) -> unit

  val map : 'b t -> f:('b -> 'c) -> 'c t

  val mapi : 'b t -> f:(key:key -> data:'b -> 'c) -> 'c t

  val filter_map : 'b t -> f:('b -> 'c option) -> 'c t

  val filter_mapi : 'b t -> f:(key:key -> data:'b -> 'c option) -> 'c t

  val filter_keys : 'b t -> f:(key -> bool) -> 'b t

  val filter : 'b t -> f:('b -> bool) -> 'b t

  val filteri : 'b t -> f:(key:key -> data:'b -> bool) -> 'b t

  val partition_map :
    'b t -> f:('b -> [ `Fst of 'c | `Snd of 'd ]) -> 'c t * 'd t

  val partition_mapi :
    'b t -> f:(key:key -> data:'b -> [ `Fst of 'c | `Snd of 'd ]) -> 'c t * 'd t

  val partition_tf : 'b t -> f:('b -> bool) -> 'b t * 'b t

  val partitioni_tf : 'b t -> f:(key:key -> data:'b -> bool) -> 'b t * 'b t

  val find_or_add : 'b t -> key -> default:(unit -> 'b) -> 'b

  val findi_or_add : 'b t -> key -> default:(key -> 'b) -> 'b

  val find : 'b t -> key -> 'b option

  val find_exn : 'b t -> key -> 'b

  val find_and_call :
    'b t -> key -> if_found:('b -> 'c) -> if_not_found:(key -> 'c) -> 'c

  val findi_and_call :
       'b t
    -> key
    -> if_found:(key:key -> data:'b -> 'c)
    -> if_not_found:(key -> 'c)
    -> 'c

  val find_and_remove : 'b t -> key -> 'b option

  val merge :
       'a t
    -> 'b t
    -> f:
         (   key:key
          -> [ `Both of 'a * 'b | `Left of 'a | `Right of 'b ]
          -> 'c option)
    -> 'c t

  type 'a merge_into_action =
        'a Core_kernel__Hashable.Make(Stable.V1).Table.merge_into_action =
    | Remove
    | Set_to of 'a

  val merge_into :
       src:'a t
    -> dst:'b t
    -> f:(key:key -> 'a -> 'b option -> 'b merge_into_action)
    -> unit

  val keys : 'a t -> key list

  val data : 'b t -> 'b list

  val filter_keys_inplace : 'a t -> f:(key -> bool) -> unit

  val filter_inplace : 'b t -> f:('b -> bool) -> unit

  val filteri_inplace : 'b t -> f:(key:key -> data:'b -> bool) -> unit

  val map_inplace : 'b t -> f:('b -> 'b) -> unit

  val mapi_inplace : 'b t -> f:(key:key -> data:'b -> 'b) -> unit

  val filter_map_inplace : 'b t -> f:('b -> 'b option) -> unit

  val filter_mapi_inplace : 'b t -> f:(key:key -> data:'b -> 'b option) -> unit

  val equal : 'b t -> 'b t -> ('b -> 'b -> bool) -> bool

  val similar : 'b1 t -> 'b2 t -> ('b1 -> 'b2 -> bool) -> bool

  val to_alist : 'b t -> (key * 'b) list

  val validate :
       name:(key -> string)
    -> 'b Base__.Validate.check
    -> 'b t Base__.Validate.check

  val incr : ?by:int -> ?remove_if_zero:bool -> int t -> key -> unit

  val decr : ?by:int -> ?remove_if_zero:bool -> int t -> key -> unit

  val add_multi : 'b list t -> key:key -> data:'b -> unit

  val remove_multi : 'a list t -> key -> unit

  val find_multi : 'b list t -> key -> 'b list

  module Provide_of_sexp : functor
    (Key : sig
       val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> key
     end)
    -> sig
    val t_of_sexp :
         (Ppx_sexp_conv_lib.Sexp.t -> 'v_x__001_)
      -> Ppx_sexp_conv_lib.Sexp.t
      -> 'v_x__001_ t
  end

  module Provide_bin_io : functor
    (Key : sig
       val bin_size_t : key Bin_prot.Size.sizer

       val bin_write_t : key Bin_prot.Write.writer

       val bin_read_t : key Bin_prot.Read.reader

       val __bin_read_t__ : (int -> key) Bin_prot.Read.reader

       val bin_shape_t : Bin_prot.Shape.t

       val bin_writer_t : key Bin_prot.Type_class.writer

       val bin_reader_t : key Bin_prot.Type_class.reader

       val bin_t : key Bin_prot.Type_class.t
     end)
    -> sig
    val bin_shape_t : Bin_prot.Shape.t -> Bin_prot.Shape.t

    val bin_size_t : ('a, 'a t) Bin_prot.Size.sizer1

    val bin_write_t : ('a, 'a t) Bin_prot.Write.writer1

    val bin_read_t : ('a, 'a t) Bin_prot.Read.reader1

    val __bin_read_t__ : ('a, int -> 'a t) Bin_prot.Read.reader1

    val bin_writer_t : ('a, 'a t) Bin_prot.Type_class.S1.writer

    val bin_reader_t : ('a, 'a t) Bin_prot.Type_class.S1.reader

    val bin_t : ('a, 'a t) Bin_prot.Type_class.S1.t
  end

  val t_of_sexp :
       (Ppx_sexp_conv_lib.Sexp.t -> 'v_x__002_)
    -> Ppx_sexp_conv_lib.Sexp.t
    -> 'v_x__002_ t
end

module Hash_set : sig
  type elt = t

  type t = elt Core_kernel__.Hash_set.t

  val sexp_of_t : t -> Ppx_sexp_conv_lib.Sexp.t

  type 'a t_ = t

  type 'a elt_ = elt

  val create :
    ( 'a
    , unit -> t )
    Core_kernel__.Hash_set_intf.create_options_without_first_class_module

  val of_list :
    ( 'a
    , elt list -> t )
    Core_kernel__.Hash_set_intf.create_options_without_first_class_module

  module Provide_of_sexp : functor
    (X : sig
       val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> elt
     end)
    -> sig
    val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> t
  end

  module Provide_bin_io : functor
    (X : sig
       val bin_size_t : elt Bin_prot.Size.sizer

       val bin_write_t : elt Bin_prot.Write.writer

       val bin_read_t : elt Bin_prot.Read.reader

       val __bin_read_t__ : (int -> elt) Bin_prot.Read.reader

       val bin_shape_t : Bin_prot.Shape.t

       val bin_writer_t : elt Bin_prot.Type_class.writer

       val bin_reader_t : elt Bin_prot.Type_class.reader

       val bin_t : elt Bin_prot.Type_class.t
     end)
    -> sig
    val bin_size_t : t Bin_prot.Size.sizer

    val bin_write_t : t Bin_prot.Write.writer

    val bin_read_t : t Bin_prot.Read.reader

    val __bin_read_t__ : (int -> t) Bin_prot.Read.reader

    val bin_shape_t : Bin_prot.Shape.t

    val bin_writer_t : t Bin_prot.Type_class.writer

    val bin_reader_t : t Bin_prot.Type_class.reader

    val bin_t : t Bin_prot.Type_class.t
  end

  val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> t
end

module Hash_queue : sig
  type key = t

  val length : ('a, 'b) Core_kernel__.Hash_queue.t -> int

  val is_empty : ('a, 'b) Core_kernel__.Hash_queue.t -> bool

  val iter : ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> unit) -> unit

  val fold :
       ('b, 'a) Core_kernel__.Hash_queue.t
    -> init:'accum
    -> f:('accum -> 'a -> 'accum)
    -> 'accum

  val fold_result :
       ('b, 'a) Core_kernel__.Hash_queue.t
    -> init:'accum
    -> f:('accum -> 'a -> ('accum, 'e) Base__.Result.t)
    -> ('accum, 'e) Base__.Result.t

  val fold_until :
       ('b, 'a) Core_kernel__.Hash_queue.t
    -> init:'accum
    -> f:
         (   'accum
          -> 'a
          -> ('accum, 'final) Base__.Container_intf.Continue_or_stop.t)
    -> finish:('accum -> 'final)
    -> 'final

  val exists : ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> bool) -> bool

  val for_all : ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> bool) -> bool

  val count : ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> bool) -> int

  val sum :
       (module Base__.Container_intf.Summable with type t = 'sum)
    -> ('b, 'a) Core_kernel__.Hash_queue.t
    -> f:('a -> 'sum)
    -> 'sum

  val find : ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> bool) -> 'a option

  val find_map :
    ('c, 'a) Core_kernel__.Hash_queue.t -> f:('a -> 'b option) -> 'b option

  val to_list : ('b, 'a) Core_kernel__.Hash_queue.t -> 'a list

  val to_array : ('b, 'a) Core_kernel__.Hash_queue.t -> 'a array

  val min_elt :
       ('b, 'a) Core_kernel__.Hash_queue.t
    -> compare:('a -> 'a -> int)
    -> 'a option

  val max_elt :
       ('b, 'a) Core_kernel__.Hash_queue.t
    -> compare:('a -> 'a -> int)
    -> 'a option

  val invariant :
    ('key, 'data) Core_kernel__.Hash_queue.t -> Core_kernel__.Import.unit

  val create :
       ?growth_allowed:Core_kernel__.Import.bool
    -> ?size:Core_kernel__.Import.int
    -> Core_kernel__.Import.unit
    -> (t, 'data) Core_kernel__.Hash_queue.t

  val clear :
    ('key, 'data) Core_kernel__.Hash_queue.t -> Core_kernel__.Import.unit

  val mem :
       ('key, 'data) Core_kernel__.Hash_queue.t
    -> 'key
    -> Core_kernel__.Import.bool

  val lookup :
       ('key, 'data) Core_kernel__.Hash_queue.t
    -> 'key
    -> 'data Core_kernel__.Import.option

  val lookup_exn : ('key, 'data) Core_kernel__.Hash_queue.t -> 'key -> 'data

  val enqueue :
       ('key, 'data) Core_kernel__.Hash_queue.t
    -> [ `back | `front ]
    -> 'key
    -> 'data
    -> [ `Key_already_present | `Ok ]

  val enqueue_exn :
       ('key, 'data) Core_kernel__.Hash_queue.t
    -> [ `back | `front ]
    -> 'key
    -> 'data
    -> Core_kernel__.Import.unit

  val enqueue_back :
       ('key, 'data) Core_kernel__.Hash_queue.t
    -> 'key
    -> 'data
    -> [ `Key_already_present | `Ok ]

  val enqueue_back_exn :
       ('key, 'data) Core_kernel__.Hash_queue.t
    -> 'key
    -> 'data
    -> Core_kernel__.Import.unit

  val enqueue_front :
       ('key, 'data) Core_kernel__.Hash_queue.t
    -> 'key
    -> 'data
    -> [ `Key_already_present | `Ok ]

  val enqueue_front_exn :
       ('key, 'data) Core_kernel__.Hash_queue.t
    -> 'key
    -> 'data
    -> Core_kernel__.Import.unit

  val lookup_and_move_to_back :
       ('key, 'data) Core_kernel__.Hash_queue.t
    -> 'key
    -> 'data Core_kernel__.Import.option

  val lookup_and_move_to_back_exn :
    ('key, 'data) Core_kernel__.Hash_queue.t -> 'key -> 'data

  val lookup_and_move_to_front :
       ('key, 'data) Core_kernel__.Hash_queue.t
    -> 'key
    -> 'data Core_kernel__.Import.option

  val lookup_and_move_to_front_exn :
    ('key, 'data) Core_kernel__.Hash_queue.t -> 'key -> 'data

  val first :
       ('key, 'data) Core_kernel__.Hash_queue.t
    -> 'data Core_kernel__.Import.option

  val first_with_key :
       ('key, 'data) Core_kernel__.Hash_queue.t
    -> ('key * 'data) Core_kernel__.Import.option

  val keys :
    ('key, 'data) Core_kernel__.Hash_queue.t -> 'key Core_kernel__.Import.list

  val dequeue :
       ('key, 'data) Core_kernel__.Hash_queue.t
    -> [ `back | `front ]
    -> 'data Core_kernel__.Import.option

  val dequeue_exn :
    ('key, 'data) Core_kernel__.Hash_queue.t -> [ `back | `front ] -> 'data

  val dequeue_back :
       ('key, 'data) Core_kernel__.Hash_queue.t
    -> 'data Core_kernel__.Import.option

  val dequeue_back_exn : ('key, 'data) Core_kernel__.Hash_queue.t -> 'data

  val dequeue_front :
       ('key, 'data) Core_kernel__.Hash_queue.t
    -> 'data Core_kernel__.Import.option

  val dequeue_front_exn : ('key, 'data) Core_kernel__.Hash_queue.t -> 'data

  val dequeue_with_key :
       ('key, 'data) Core_kernel__.Hash_queue.t
    -> [ `back | `front ]
    -> ('key * 'data) Core_kernel__.Import.option

  val dequeue_with_key_exn :
       ('key, 'data) Core_kernel__.Hash_queue.t
    -> [ `back | `front ]
    -> 'key * 'data

  val dequeue_back_with_key :
       ('key, 'data) Core_kernel__.Hash_queue.t
    -> ('key * 'data) Core_kernel__.Import.option

  val dequeue_back_with_key_exn :
    ('key, 'data) Core_kernel__.Hash_queue.t -> 'key * 'data

  val dequeue_front_with_key :
       ('key, 'data) Core_kernel__.Hash_queue.t
    -> ('key * 'data) Core_kernel__.Import.option

  val dequeue_front_with_key_exn :
    ('key, 'data) Core_kernel__.Hash_queue.t -> 'key * 'data

  val dequeue_all :
       ('key, 'data) Core_kernel__.Hash_queue.t
    -> f:('data -> Core_kernel__.Import.unit)
    -> Core_kernel__.Import.unit

  val remove :
    ('key, 'data) Core_kernel__.Hash_queue.t -> 'key -> [ `No_such_key | `Ok ]

  val remove_exn :
       ('key, 'data) Core_kernel__.Hash_queue.t
    -> 'key
    -> Core_kernel__.Import.unit

  val replace :
       ('key, 'data) Core_kernel__.Hash_queue.t
    -> 'key
    -> 'data
    -> [ `No_such_key | `Ok ]

  val replace_exn :
       ('key, 'data) Core_kernel__.Hash_queue.t
    -> 'key
    -> 'data
    -> Core_kernel__.Import.unit

  val drop :
       ?n:Core_kernel__.Import.int
    -> ('key, 'data) Core_kernel__.Hash_queue.t
    -> [ `back | `front ]
    -> Core_kernel__.Import.unit

  val drop_front :
       ?n:Core_kernel__.Import.int
    -> ('key, 'data) Core_kernel__.Hash_queue.t
    -> Core_kernel__.Import.unit

  val drop_back :
       ?n:Core_kernel__.Import.int
    -> ('key, 'data) Core_kernel__.Hash_queue.t
    -> Core_kernel__.Import.unit

  val iteri :
       ('key, 'data) Core_kernel__.Hash_queue.t
    -> f:(key:'key -> data:'data -> Core_kernel__.Import.unit)
    -> Core_kernel__.Import.unit

  val foldi :
       ('key, 'data) Core_kernel__.Hash_queue.t
    -> init:'b
    -> f:('b -> key:'key -> data:'data -> 'b)
    -> 'b

  type 'data t = (key, 'data) Core_kernel__.Hash_queue.t

  val sexp_of_t :
    ('data -> Ppx_sexp_conv_lib.Sexp.t) -> 'data t -> Ppx_sexp_conv_lib.Sexp.t
end

val ( >= ) : t -> t -> bool

val ( <= ) : t -> t -> bool

val ( = ) : t -> t -> bool

val ( > ) : t -> t -> bool

val ( < ) : t -> t -> bool

val ( <> ) : t -> t -> bool

val equal : t -> t -> bool

val compare : t -> t -> int

val min : t -> t -> t

val max : t -> t -> t

val ascending : t -> t -> int

val descending : t -> t -> int

val between : t -> low:t -> high:t -> bool

val clamp_exn : t -> min:t -> max:t -> t

val clamp : t -> min:t -> max:t -> t Base__.Or_error.t

type comparator_witness =
  Core_kernel__Comparable.Make(Stable.V1).comparator_witness

val comparator : (t, comparator_witness) Base__.Comparator.comparator

val validate_lbound : min:t Base__.Maybe_bound.t -> t Base__.Validate.check

val validate_ubound : max:t Base__.Maybe_bound.t -> t Base__.Validate.check

val validate_bound :
     min:t Base__.Maybe_bound.t
  -> max:t Base__.Maybe_bound.t
  -> t Base__.Validate.check

module Replace_polymorphic_compare : sig
  val ( >= ) : t -> t -> bool

  val ( <= ) : t -> t -> bool

  val ( = ) : t -> t -> bool

  val ( > ) : t -> t -> bool

  val ( < ) : t -> t -> bool

  val ( <> ) : t -> t -> bool

  val equal : t -> t -> bool

  val compare : t -> t -> int

  val min : t -> t -> t

  val max : t -> t -> t
end

module Map : sig
  module Key : sig
    type t = Table.key

    val t_of_sexp : Sexplib0.Sexp.t -> t

    val sexp_of_t : t -> Sexplib0.Sexp.t

    type comparator_witness =
      Core_kernel__Comparable.Make(Stable.V1).comparator_witness

    val comparator : (t, comparator_witness) Core_kernel__.Comparator.comparator
  end

  module Tree : sig
    type 'a t =
      (Table.key, 'a, comparator_witness) Core_kernel__.Map_intf.Tree.t

    val empty : 'a t

    val singleton : Table.key -> 'a -> 'a t

    val of_alist :
      (Table.key * 'a) list -> [ `Duplicate_key of Table.key | `Ok of 'a t ]

    val of_alist_or_error : (Table.key * 'a) list -> 'a t Base__.Or_error.t

    val of_alist_exn : (Table.key * 'a) list -> 'a t

    val of_alist_multi : (Table.key * 'a) list -> 'a list t

    val of_alist_fold :
      (Table.key * 'a) list -> init:'b -> f:('b -> 'a -> 'b) -> 'b t

    val of_alist_reduce : (Table.key * 'a) list -> f:('a -> 'a -> 'a) -> 'a t

    val of_sorted_array : (Table.key * 'a) array -> 'a t Base__.Or_error.t

    val of_sorted_array_unchecked : (Table.key * 'a) array -> 'a t

    val of_increasing_iterator_unchecked :
      len:int -> f:(int -> Table.key * 'a) -> 'a t

    val of_increasing_sequence :
      (Table.key * 'a) Base__.Sequence.t -> 'a t Base__.Or_error.t

    val of_sequence :
         (Table.key * 'a) Base__.Sequence.t
      -> [ `Duplicate_key of Table.key | `Ok of 'a t ]

    val of_sequence_or_error :
      (Table.key * 'a) Base__.Sequence.t -> 'a t Base__.Or_error.t

    val of_sequence_exn : (Table.key * 'a) Base__.Sequence.t -> 'a t

    val of_sequence_multi : (Table.key * 'a) Base__.Sequence.t -> 'a list t

    val of_sequence_fold :
         (Table.key * 'a) Base__.Sequence.t
      -> init:'b
      -> f:('b -> 'a -> 'b)
      -> 'b t

    val of_sequence_reduce :
      (Table.key * 'a) Base__.Sequence.t -> f:('a -> 'a -> 'a) -> 'a t

    val of_iteri :
         iteri:(f:(key:Table.key -> data:'v -> unit) -> unit)
      -> [ `Duplicate_key of Table.key | `Ok of 'v t ]

    val of_tree : 'a t -> 'a t

    val of_hashtbl_exn : (Table.key, 'a) Table.hashtbl -> 'a t

    val of_key_set :
      (Table.key, comparator_witness) Base.Set.t -> f:(Table.key -> 'v) -> 'v t

    val quickcheck_generator :
         Table.key Core_kernel__.Quickcheck.Generator.t
      -> 'a Core_kernel__.Quickcheck.Generator.t
      -> 'a t Core_kernel__.Quickcheck.Generator.t

    val invariants : 'a t -> bool

    val is_empty : 'a t -> bool

    val length : 'a t -> int

    val add :
      'a t -> key:Table.key -> data:'a -> 'a t Base__.Map_intf.Or_duplicate.t

    val add_exn : 'a t -> key:Table.key -> data:'a -> 'a t

    val set : 'a t -> key:Table.key -> data:'a -> 'a t

    val add_multi : 'a list t -> key:Table.key -> data:'a -> 'a list t

    val remove_multi : 'a list t -> Table.key -> 'a list t

    val find_multi : 'a list t -> Table.key -> 'a list

    val change : 'a t -> Table.key -> f:('a option -> 'a option) -> 'a t

    val update : 'a t -> Table.key -> f:('a option -> 'a) -> 'a t

    val find : 'a t -> Table.key -> 'a option

    val find_exn : 'a t -> Table.key -> 'a

    val remove : 'a t -> Table.key -> 'a t

    val mem : 'a t -> Table.key -> bool

    val iter_keys : 'a t -> f:(Table.key -> unit) -> unit

    val iter : 'a t -> f:('a -> unit) -> unit

    val iteri : 'a t -> f:(key:Table.key -> data:'a -> unit) -> unit

    val iteri_until :
         'a t
      -> f:(key:Table.key -> data:'a -> Base__.Map_intf.Continue_or_stop.t)
      -> Base__.Map_intf.Finished_or_unfinished.t

    val iter2 :
         'a t
      -> 'b t
      -> f:
           (   key:Table.key
            -> data:[ `Both of 'a * 'b | `Left of 'a | `Right of 'b ]
            -> unit)
      -> unit

    val map : 'a t -> f:('a -> 'b) -> 'b t

    val mapi : 'a t -> f:(key:Table.key -> data:'a -> 'b) -> 'b t

    val fold : 'a t -> init:'b -> f:(key:Table.key -> data:'a -> 'b -> 'b) -> 'b

    val fold_right :
      'a t -> init:'b -> f:(key:Table.key -> data:'a -> 'b -> 'b) -> 'b

    val fold2 :
         'a t
      -> 'b t
      -> init:'c
      -> f:
           (   key:Table.key
            -> data:[ `Both of 'a * 'b | `Left of 'a | `Right of 'b ]
            -> 'c
            -> 'c)
      -> 'c

    val filter_keys : 'a t -> f:(Table.key -> bool) -> 'a t

    val filter : 'a t -> f:('a -> bool) -> 'a t

    val filteri : 'a t -> f:(key:Table.key -> data:'a -> bool) -> 'a t

    val filter_map : 'a t -> f:('a -> 'b option) -> 'b t

    val filter_mapi : 'a t -> f:(key:Table.key -> data:'a -> 'b option) -> 'b t

    val partition_mapi :
         'a t
      -> f:(key:Table.key -> data:'a -> [ `Fst of 'b | `Snd of 'c ])
      -> 'b t * 'c t

    val partition_map :
      'a t -> f:('a -> [ `Fst of 'b | `Snd of 'c ]) -> 'b t * 'c t

    val partitioni_tf :
      'a t -> f:(key:Table.key -> data:'a -> bool) -> 'a t * 'a t

    val partition_tf : 'a t -> f:('a -> bool) -> 'a t * 'a t

    val compare_direct : ('a -> 'a -> int) -> 'a t -> 'a t -> int

    val equal : ('a -> 'a -> bool) -> 'a t -> 'a t -> bool

    val keys : 'a t -> Table.key list

    val data : 'a t -> 'a list

    val to_alist :
      ?key_order:[ `Decreasing | `Increasing ] -> 'a t -> (Table.key * 'a) list

    val validate :
         name:(Table.key -> string)
      -> 'a Base__.Validate.check
      -> 'a t Base__.Validate.check

    val merge :
         'a t
      -> 'b t
      -> f:
           (   key:Table.key
            -> [ `Both of 'a * 'b | `Left of 'a | `Right of 'b ]
            -> 'c option)
      -> 'c t

    val symmetric_diff :
         'a t
      -> 'a t
      -> data_equal:('a -> 'a -> bool)
      -> (Table.key, 'a) Base__.Map_intf.Symmetric_diff_element.t
         Base__.Sequence.t

    val fold_symmetric_diff :
         'a t
      -> 'a t
      -> data_equal:('a -> 'a -> bool)
      -> init:'c
      -> f:
           (   'c
            -> (Table.key, 'a) Base__.Map_intf.Symmetric_diff_element.t
            -> 'c)
      -> 'c

    val min_elt : 'a t -> (Table.key * 'a) option

    val min_elt_exn : 'a t -> Table.key * 'a

    val max_elt : 'a t -> (Table.key * 'a) option

    val max_elt_exn : 'a t -> Table.key * 'a

    val for_all : 'a t -> f:('a -> bool) -> bool

    val for_alli : 'a t -> f:(key:Table.key -> data:'a -> bool) -> bool

    val exists : 'a t -> f:('a -> bool) -> bool

    val existsi : 'a t -> f:(key:Table.key -> data:'a -> bool) -> bool

    val count : 'a t -> f:('a -> bool) -> int

    val counti : 'a t -> f:(key:Table.key -> data:'a -> bool) -> int

    val split : 'a t -> Table.key -> 'a t * (Table.key * 'a) option * 'a t

    val append :
         lower_part:'a t
      -> upper_part:'a t
      -> [ `Ok of 'a t | `Overlapping_key_ranges ]

    val subrange :
         'a t
      -> lower_bound:Table.key Base__.Maybe_bound.t
      -> upper_bound:Table.key Base__.Maybe_bound.t
      -> 'a t

    val fold_range_inclusive :
         'a t
      -> min:Table.key
      -> max:Table.key
      -> init:'b
      -> f:(key:Table.key -> data:'a -> 'b -> 'b)
      -> 'b

    val range_to_alist :
      'a t -> min:Table.key -> max:Table.key -> (Table.key * 'a) list

    val closest_key :
         'a t
      -> [ `Greater_or_equal_to
         | `Greater_than
         | `Less_or_equal_to
         | `Less_than ]
      -> Table.key
      -> (Table.key * 'a) option

    val nth : 'a t -> int -> (Table.key * 'a) option

    val nth_exn : 'a t -> int -> Table.key * 'a

    val rank : 'a t -> Table.key -> int option

    val to_tree : 'a t -> 'a t

    val to_sequence :
         ?order:[ `Decreasing_key | `Increasing_key ]
      -> ?keys_greater_or_equal_to:Table.key
      -> ?keys_less_or_equal_to:Table.key
      -> 'a t
      -> (Table.key * 'a) Base__.Sequence.t

    val binary_search :
         'a t
      -> compare:(key:Table.key -> data:'a -> 'key -> int)
      -> [ `First_equal_to
         | `First_greater_than_or_equal_to
         | `First_strictly_greater_than
         | `Last_equal_to
         | `Last_less_than_or_equal_to
         | `Last_strictly_less_than ]
      -> 'key
      -> (Table.key * 'a) option

    val binary_search_segmented :
         'a t
      -> segment_of:(key:Table.key -> data:'a -> [ `Left | `Right ])
      -> [ `First_on_right | `Last_on_left ]
      -> (Table.key * 'a) option

    val key_set : 'a t -> (Table.key, comparator_witness) Base.Set.t

    val quickcheck_observer :
         Table.key Core_kernel__.Quickcheck.Observer.t
      -> 'v Core_kernel__.Quickcheck.Observer.t
      -> 'v t Core_kernel__.Quickcheck.Observer.t

    val quickcheck_shrinker :
         Table.key Core_kernel__.Quickcheck.Shrinker.t
      -> 'v Core_kernel__.Quickcheck.Shrinker.t
      -> 'v t Core_kernel__.Quickcheck.Shrinker.t

    module Provide_of_sexp : functor
      (K : sig
         val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> Table.key
       end)
      -> sig
      val t_of_sexp :
           (Ppx_sexp_conv_lib.Sexp.t -> 'v_x__001_)
        -> Ppx_sexp_conv_lib.Sexp.t
        -> 'v_x__001_ t
    end

    val t_of_sexp : (Base__.Sexp.t -> 'a) -> Base__.Sexp.t -> 'a t

    val sexp_of_t : ('a -> Base__.Sexp.t) -> 'a t -> Base__.Sexp.t
  end

  type 'a t = (Table.key, 'a, comparator_witness) Core_kernel__.Map_intf.Map.t

  val compare :
       ('a -> 'a -> Core_kernel__.Import.int)
    -> 'a t
    -> 'a t
    -> Core_kernel__.Import.int

  val empty : 'a t

  val singleton : Table.key -> 'a -> 'a t

  val of_alist :
    (Table.key * 'a) list -> [ `Duplicate_key of Table.key | `Ok of 'a t ]

  val of_alist_or_error : (Table.key * 'a) list -> 'a t Base__.Or_error.t

  val of_alist_exn : (Table.key * 'a) list -> 'a t

  val of_alist_multi : (Table.key * 'a) list -> 'a list t

  val of_alist_fold :
    (Table.key * 'a) list -> init:'b -> f:('b -> 'a -> 'b) -> 'b t

  val of_alist_reduce : (Table.key * 'a) list -> f:('a -> 'a -> 'a) -> 'a t

  val of_sorted_array : (Table.key * 'a) array -> 'a t Base__.Or_error.t

  val of_sorted_array_unchecked : (Table.key * 'a) array -> 'a t

  val of_increasing_iterator_unchecked :
    len:int -> f:(int -> Table.key * 'a) -> 'a t

  val of_increasing_sequence :
    (Table.key * 'a) Base__.Sequence.t -> 'a t Base__.Or_error.t

  val of_sequence :
       (Table.key * 'a) Base__.Sequence.t
    -> [ `Duplicate_key of Table.key | `Ok of 'a t ]

  val of_sequence_or_error :
    (Table.key * 'a) Base__.Sequence.t -> 'a t Base__.Or_error.t

  val of_sequence_exn : (Table.key * 'a) Base__.Sequence.t -> 'a t

  val of_sequence_multi : (Table.key * 'a) Base__.Sequence.t -> 'a list t

  val of_sequence_fold :
    (Table.key * 'a) Base__.Sequence.t -> init:'b -> f:('b -> 'a -> 'b) -> 'b t

  val of_sequence_reduce :
    (Table.key * 'a) Base__.Sequence.t -> f:('a -> 'a -> 'a) -> 'a t

  val of_iteri :
       iteri:(f:(key:Table.key -> data:'v -> unit) -> unit)
    -> [ `Duplicate_key of Table.key | `Ok of 'v t ]

  val of_tree : 'a Tree.t -> 'a t

  val of_hashtbl_exn : (Table.key, 'a) Table.hashtbl -> 'a t

  val of_key_set :
    (Table.key, comparator_witness) Base.Set.t -> f:(Table.key -> 'v) -> 'v t

  val quickcheck_generator :
       Table.key Core_kernel__.Quickcheck.Generator.t
    -> 'a Core_kernel__.Quickcheck.Generator.t
    -> 'a t Core_kernel__.Quickcheck.Generator.t

  val invariants : 'a t -> bool

  val is_empty : 'a t -> bool

  val length : 'a t -> int

  val add :
    'a t -> key:Table.key -> data:'a -> 'a t Base__.Map_intf.Or_duplicate.t

  val add_exn : 'a t -> key:Table.key -> data:'a -> 'a t

  val set : 'a t -> key:Table.key -> data:'a -> 'a t

  val add_multi : 'a list t -> key:Table.key -> data:'a -> 'a list t

  val remove_multi : 'a list t -> Table.key -> 'a list t

  val find_multi : 'a list t -> Table.key -> 'a list

  val change : 'a t -> Table.key -> f:('a option -> 'a option) -> 'a t

  val update : 'a t -> Table.key -> f:('a option -> 'a) -> 'a t

  val find : 'a t -> Table.key -> 'a option

  val find_exn : 'a t -> Table.key -> 'a

  val remove : 'a t -> Table.key -> 'a t

  val mem : 'a t -> Table.key -> bool

  val iter_keys : 'a t -> f:(Table.key -> unit) -> unit

  val iter : 'a t -> f:('a -> unit) -> unit

  val iteri : 'a t -> f:(key:Table.key -> data:'a -> unit) -> unit

  val iteri_until :
       'a t
    -> f:(key:Table.key -> data:'a -> Base__.Map_intf.Continue_or_stop.t)
    -> Base__.Map_intf.Finished_or_unfinished.t

  val iter2 :
       'a t
    -> 'b t
    -> f:
         (   key:Table.key
          -> data:[ `Both of 'a * 'b | `Left of 'a | `Right of 'b ]
          -> unit)
    -> unit

  val map : 'a t -> f:('a -> 'b) -> 'b t

  val mapi : 'a t -> f:(key:Table.key -> data:'a -> 'b) -> 'b t

  val fold : 'a t -> init:'b -> f:(key:Table.key -> data:'a -> 'b -> 'b) -> 'b

  val fold_right :
    'a t -> init:'b -> f:(key:Table.key -> data:'a -> 'b -> 'b) -> 'b

  val fold2 :
       'a t
    -> 'b t
    -> init:'c
    -> f:
         (   key:Table.key
          -> data:[ `Both of 'a * 'b | `Left of 'a | `Right of 'b ]
          -> 'c
          -> 'c)
    -> 'c

  val filter_keys : 'a t -> f:(Table.key -> bool) -> 'a t

  val filter : 'a t -> f:('a -> bool) -> 'a t

  val filteri : 'a t -> f:(key:Table.key -> data:'a -> bool) -> 'a t

  val filter_map : 'a t -> f:('a -> 'b option) -> 'b t

  val filter_mapi : 'a t -> f:(key:Table.key -> data:'a -> 'b option) -> 'b t

  val partition_mapi :
       'a t
    -> f:(key:Table.key -> data:'a -> [ `Fst of 'b | `Snd of 'c ])
    -> 'b t * 'c t

  val partition_map :
    'a t -> f:('a -> [ `Fst of 'b | `Snd of 'c ]) -> 'b t * 'c t

  val partitioni_tf :
    'a t -> f:(key:Table.key -> data:'a -> bool) -> 'a t * 'a t

  val partition_tf : 'a t -> f:('a -> bool) -> 'a t * 'a t

  val compare_direct : ('a -> 'a -> int) -> 'a t -> 'a t -> int

  val equal : ('a -> 'a -> bool) -> 'a t -> 'a t -> bool

  val keys : 'a t -> Table.key list

  val data : 'a t -> 'a list

  val to_alist :
    ?key_order:[ `Decreasing | `Increasing ] -> 'a t -> (Table.key * 'a) list

  val validate :
       name:(Table.key -> string)
    -> 'a Base__.Validate.check
    -> 'a t Base__.Validate.check

  val merge :
       'a t
    -> 'b t
    -> f:
         (   key:Table.key
          -> [ `Both of 'a * 'b | `Left of 'a | `Right of 'b ]
          -> 'c option)
    -> 'c t

  val symmetric_diff :
       'a t
    -> 'a t
    -> data_equal:('a -> 'a -> bool)
    -> (Table.key, 'a) Base__.Map_intf.Symmetric_diff_element.t
       Base__.Sequence.t

  val fold_symmetric_diff :
       'a t
    -> 'a t
    -> data_equal:('a -> 'a -> bool)
    -> init:'c
    -> f:('c -> (Table.key, 'a) Base__.Map_intf.Symmetric_diff_element.t -> 'c)
    -> 'c

  val min_elt : 'a t -> (Table.key * 'a) option

  val min_elt_exn : 'a t -> Table.key * 'a

  val max_elt : 'a t -> (Table.key * 'a) option

  val max_elt_exn : 'a t -> Table.key * 'a

  val for_all : 'a t -> f:('a -> bool) -> bool

  val for_alli : 'a t -> f:(key:Table.key -> data:'a -> bool) -> bool

  val exists : 'a t -> f:('a -> bool) -> bool

  val existsi : 'a t -> f:(key:Table.key -> data:'a -> bool) -> bool

  val count : 'a t -> f:('a -> bool) -> int

  val counti : 'a t -> f:(key:Table.key -> data:'a -> bool) -> int

  val split : 'a t -> Table.key -> 'a t * (Table.key * 'a) option * 'a t

  val append :
       lower_part:'a t
    -> upper_part:'a t
    -> [ `Ok of 'a t | `Overlapping_key_ranges ]

  val subrange :
       'a t
    -> lower_bound:Table.key Base__.Maybe_bound.t
    -> upper_bound:Table.key Base__.Maybe_bound.t
    -> 'a t

  val fold_range_inclusive :
       'a t
    -> min:Table.key
    -> max:Table.key
    -> init:'b
    -> f:(key:Table.key -> data:'a -> 'b -> 'b)
    -> 'b

  val range_to_alist :
    'a t -> min:Table.key -> max:Table.key -> (Table.key * 'a) list

  val closest_key :
       'a t
    -> [ `Greater_or_equal_to | `Greater_than | `Less_or_equal_to | `Less_than ]
    -> Table.key
    -> (Table.key * 'a) option

  val nth : 'a t -> int -> (Table.key * 'a) option

  val nth_exn : 'a t -> int -> Table.key * 'a

  val rank : 'a t -> Table.key -> int option

  val to_tree : 'a t -> 'a Tree.t

  val to_sequence :
       ?order:[ `Decreasing_key | `Increasing_key ]
    -> ?keys_greater_or_equal_to:Table.key
    -> ?keys_less_or_equal_to:Table.key
    -> 'a t
    -> (Table.key * 'a) Base__.Sequence.t

  val binary_search :
       'a t
    -> compare:(key:Table.key -> data:'a -> 'key -> int)
    -> [ `First_equal_to
       | `First_greater_than_or_equal_to
       | `First_strictly_greater_than
       | `Last_equal_to
       | `Last_less_than_or_equal_to
       | `Last_strictly_less_than ]
    -> 'key
    -> (Table.key * 'a) option

  val binary_search_segmented :
       'a t
    -> segment_of:(key:Table.key -> data:'a -> [ `Left | `Right ])
    -> [ `First_on_right | `Last_on_left ]
    -> (Table.key * 'a) option

  val key_set : 'a t -> (Table.key, comparator_witness) Base.Set.t

  val quickcheck_observer :
       Table.key Core_kernel__.Quickcheck.Observer.t
    -> 'v Core_kernel__.Quickcheck.Observer.t
    -> 'v t Core_kernel__.Quickcheck.Observer.t

  val quickcheck_shrinker :
       Table.key Core_kernel__.Quickcheck.Shrinker.t
    -> 'v Core_kernel__.Quickcheck.Shrinker.t
    -> 'v t Core_kernel__.Quickcheck.Shrinker.t

  module Provide_of_sexp : functor
    (Key : sig
       val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> Table.key
     end)
    -> sig
    val t_of_sexp :
         (Ppx_sexp_conv_lib.Sexp.t -> 'v_x__002_)
      -> Ppx_sexp_conv_lib.Sexp.t
      -> 'v_x__002_ t
  end

  module Provide_bin_io : functor
    (Key : sig
       val bin_size_t : Table.key Bin_prot.Size.sizer

       val bin_write_t : Table.key Bin_prot.Write.writer

       val bin_read_t : Table.key Bin_prot.Read.reader

       val __bin_read_t__ : (int -> Table.key) Bin_prot.Read.reader

       val bin_shape_t : Bin_prot.Shape.t

       val bin_writer_t : Table.key Bin_prot.Type_class.writer

       val bin_reader_t : Table.key Bin_prot.Type_class.reader

       val bin_t : Table.key Bin_prot.Type_class.t
     end)
    -> sig
    val bin_shape_t : Bin_prot.Shape.t -> Bin_prot.Shape.t

    val bin_size_t : ('a, 'a t) Bin_prot.Size.sizer1

    val bin_write_t : ('a, 'a t) Bin_prot.Write.writer1

    val bin_read_t : ('a, 'a t) Bin_prot.Read.reader1

    val __bin_read_t__ : ('a, int -> 'a t) Bin_prot.Read.reader1

    val bin_writer_t : ('a, 'a t) Bin_prot.Type_class.S1.writer

    val bin_reader_t : ('a, 'a t) Bin_prot.Type_class.S1.reader

    val bin_t : ('a, 'a t) Bin_prot.Type_class.S1.t
  end

  module Provide_hash : functor
    (Key : sig
       val hash_fold_t : Base__.Hash.state -> Table.key -> Base__.Hash.state
     end)
    -> sig
    val hash_fold_t :
         (Ppx_hash_lib.Std.Hash.state -> 'a -> Ppx_hash_lib.Std.Hash.state)
      -> Ppx_hash_lib.Std.Hash.state
      -> 'a t
      -> Ppx_hash_lib.Std.Hash.state
  end

  val t_of_sexp : (Base__.Sexp.t -> 'a) -> Base__.Sexp.t -> 'a t

  val sexp_of_t : ('a -> Base__.Sexp.t) -> 'a t -> Base__.Sexp.t
end

module Set : sig
  module Elt : sig
    type t = Table.key

    val t_of_sexp : Sexplib0.Sexp.t -> t

    val sexp_of_t : t -> Sexplib0.Sexp.t

    type comparator_witness = Map.Key.comparator_witness

    val comparator : (t, comparator_witness) Core_kernel__.Comparator.comparator
  end

  module Tree : sig
    type t = (Table.key, comparator_witness) Core_kernel__.Set_intf.Tree.t

    val compare : t -> t -> Core_kernel__.Import.int

    type named =
      (Table.key, comparator_witness) Core_kernel__.Set_intf.Tree.Named.t

    val length : t -> int

    val is_empty : t -> bool

    val iter : t -> f:(Table.key -> unit) -> unit

    val fold : t -> init:'accum -> f:('accum -> Table.key -> 'accum) -> 'accum

    val fold_result :
         t
      -> init:'accum
      -> f:('accum -> Table.key -> ('accum, 'e) Base__.Result.t)
      -> ('accum, 'e) Base__.Result.t

    val exists : t -> f:(Table.key -> bool) -> bool

    val for_all : t -> f:(Table.key -> bool) -> bool

    val count : t -> f:(Table.key -> bool) -> int

    val sum :
         (module Base__.Container_intf.Summable with type t = 'sum)
      -> t
      -> f:(Table.key -> 'sum)
      -> 'sum

    val find : t -> f:(Table.key -> bool) -> Table.key option

    val find_map : t -> f:(Table.key -> 'a option) -> 'a option

    val to_list : t -> Table.key list

    val to_array : t -> Table.key array

    val invariants : t -> bool

    val mem : t -> Table.key -> bool

    val add : t -> Table.key -> t

    val remove : t -> Table.key -> t

    val union : t -> t -> t

    val inter : t -> t -> t

    val diff : t -> t -> t

    val symmetric_diff :
      t -> t -> (Table.key, Table.key) Base__.Either.t Base__.Sequence.t

    val compare_direct : t -> t -> int

    val equal : t -> t -> bool

    val is_subset : t -> of_:t -> bool

    module Named : sig
      val is_subset : named -> of_:named -> unit Base__.Or_error.t

      val equal : named -> named -> unit Base__.Or_error.t
    end

    val fold_until :
         t
      -> init:'b
      -> f:('b -> Table.key -> ('b, 'final) Base__.Set_intf.Continue_or_stop.t)
      -> finish:('b -> 'final)
      -> 'final

    val fold_right : t -> init:'b -> f:(Table.key -> 'b -> 'b) -> 'b

    val iter2 :
         t
      -> t
      -> f:
           (   [ `Both of Table.key * Table.key
               | `Left of Table.key
               | `Right of Table.key ]
            -> unit)
      -> unit

    val filter : t -> f:(Table.key -> bool) -> t

    val partition_tf : t -> f:(Table.key -> bool) -> t * t

    val elements : t -> Table.key list

    val min_elt : t -> Table.key option

    val min_elt_exn : t -> Table.key

    val max_elt : t -> Table.key option

    val max_elt_exn : t -> Table.key

    val choose : t -> Table.key option

    val choose_exn : t -> Table.key

    val split : t -> Table.key -> t * Table.key option * t

    val group_by : t -> equiv:(Table.key -> Table.key -> bool) -> t list

    val find_exn : t -> f:(Table.key -> bool) -> Table.key

    val nth : t -> int -> Table.key option

    val remove_index : t -> int -> t

    val to_tree : t -> t

    val to_sequence :
         ?order:[ `Decreasing | `Increasing ]
      -> ?greater_or_equal_to:Table.key
      -> ?less_or_equal_to:Table.key
      -> t
      -> Table.key Base__.Sequence.t

    val binary_search :
         t
      -> compare:(Table.key -> 'key -> int)
      -> [ `First_equal_to
         | `First_greater_than_or_equal_to
         | `First_strictly_greater_than
         | `Last_equal_to
         | `Last_less_than_or_equal_to
         | `Last_strictly_less_than ]
      -> 'key
      -> Table.key option

    val binary_search_segmented :
         t
      -> segment_of:(Table.key -> [ `Left | `Right ])
      -> [ `First_on_right | `Last_on_left ]
      -> Table.key option

    val merge_to_sequence :
         ?order:[ `Decreasing | `Increasing ]
      -> ?greater_or_equal_to:Table.key
      -> ?less_or_equal_to:Table.key
      -> t
      -> t
      -> (Table.key, Table.key) Base__.Set_intf.Merge_to_sequence_element.t
         Base__.Sequence.t

    val to_map :
         t
      -> f:(Table.key -> 'data)
      -> (Table.key, 'data, comparator_witness) Base.Map.t

    val quickcheck_observer :
         Table.key Core_kernel__.Quickcheck.Observer.t
      -> t Core_kernel__.Quickcheck.Observer.t

    val quickcheck_shrinker :
         Table.key Core_kernel__.Quickcheck.Shrinker.t
      -> t Core_kernel__.Quickcheck.Shrinker.t

    val empty : t

    val singleton : Table.key -> t

    val union_list : t list -> t

    val of_list : Table.key list -> t

    val of_array : Table.key array -> t

    val of_sorted_array : Table.key array -> t Base__.Or_error.t

    val of_sorted_array_unchecked : Table.key array -> t

    val of_increasing_iterator_unchecked : len:int -> f:(int -> Table.key) -> t

    val stable_dedup_list : Table.key list -> Table.key list

    val map : ('a, 'b) Core_kernel__.Set_intf.Tree.t -> f:('a -> Table.key) -> t

    val filter_map :
      ('a, 'b) Core_kernel__.Set_intf.Tree.t -> f:('a -> Table.key option) -> t

    val of_tree : t -> t

    val of_hash_set : Table.key Core_kernel__.Hash_set.t -> t

    val of_hashtbl_keys : (Table.key, 'a) Table.hashtbl -> t

    val of_map_keys : (Table.key, 'a, comparator_witness) Base.Map.t -> t

    val quickcheck_generator :
         Table.key Core_kernel__.Quickcheck.Generator.t
      -> t Core_kernel__.Quickcheck.Generator.t

    module Provide_of_sexp : functor
      (Elt : sig
         val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> Table.key
       end)
      -> sig
      val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> t
    end

    val t_of_sexp : Base__.Sexp.t -> t

    val sexp_of_t : t -> Base__.Sexp.t
  end

  type t = (Table.key, comparator_witness) Base.Set.t

  val compare : t -> t -> Core_kernel__.Import.int

  type named = (Table.key, comparator_witness) Core_kernel__.Set_intf.Named.t

  val length : t -> int

  val is_empty : t -> bool

  val iter : t -> f:(Table.key -> unit) -> unit

  val fold : t -> init:'accum -> f:('accum -> Table.key -> 'accum) -> 'accum

  val fold_result :
       t
    -> init:'accum
    -> f:('accum -> Table.key -> ('accum, 'e) Base__.Result.t)
    -> ('accum, 'e) Base__.Result.t

  val exists : t -> f:(Table.key -> bool) -> bool

  val for_all : t -> f:(Table.key -> bool) -> bool

  val count : t -> f:(Table.key -> bool) -> int

  val sum :
       (module Base__.Container_intf.Summable with type t = 'sum)
    -> t
    -> f:(Table.key -> 'sum)
    -> 'sum

  val find : t -> f:(Table.key -> bool) -> Table.key option

  val find_map : t -> f:(Table.key -> 'a option) -> 'a option

  val to_list : t -> Table.key list

  val to_array : t -> Table.key array

  val invariants : t -> bool

  val mem : t -> Table.key -> bool

  val add : t -> Table.key -> t

  val remove : t -> Table.key -> t

  val union : t -> t -> t

  val inter : t -> t -> t

  val diff : t -> t -> t

  val symmetric_diff :
    t -> t -> (Table.key, Table.key) Base__.Either.t Base__.Sequence.t

  val compare_direct : t -> t -> int

  val equal : t -> t -> bool

  val is_subset : t -> of_:t -> bool

  module Named : sig
    val is_subset : named -> of_:named -> unit Base__.Or_error.t

    val equal : named -> named -> unit Base__.Or_error.t
  end

  val fold_until :
       t
    -> init:'b
    -> f:('b -> Table.key -> ('b, 'final) Base__.Set_intf.Continue_or_stop.t)
    -> finish:('b -> 'final)
    -> 'final

  val fold_right : t -> init:'b -> f:(Table.key -> 'b -> 'b) -> 'b

  val iter2 :
       t
    -> t
    -> f:
         (   [ `Both of Table.key * Table.key
             | `Left of Table.key
             | `Right of Table.key ]
          -> unit)
    -> unit

  val filter : t -> f:(Table.key -> bool) -> t

  val partition_tf : t -> f:(Table.key -> bool) -> t * t

  val elements : t -> Table.key list

  val min_elt : t -> Table.key option

  val min_elt_exn : t -> Table.key

  val max_elt : t -> Table.key option

  val max_elt_exn : t -> Table.key

  val choose : t -> Table.key option

  val choose_exn : t -> Table.key

  val split : t -> Table.key -> t * Table.key option * t

  val group_by : t -> equiv:(Table.key -> Table.key -> bool) -> t list

  val find_exn : t -> f:(Table.key -> bool) -> Table.key

  val nth : t -> int -> Table.key option

  val remove_index : t -> int -> t

  val to_tree : t -> Tree.t

  val to_sequence :
       ?order:[ `Decreasing | `Increasing ]
    -> ?greater_or_equal_to:Table.key
    -> ?less_or_equal_to:Table.key
    -> t
    -> Table.key Base__.Sequence.t

  val binary_search :
       t
    -> compare:(Table.key -> 'key -> int)
    -> [ `First_equal_to
       | `First_greater_than_or_equal_to
       | `First_strictly_greater_than
       | `Last_equal_to
       | `Last_less_than_or_equal_to
       | `Last_strictly_less_than ]
    -> 'key
    -> Table.key option

  val binary_search_segmented :
       t
    -> segment_of:(Table.key -> [ `Left | `Right ])
    -> [ `First_on_right | `Last_on_left ]
    -> Table.key option

  val merge_to_sequence :
       ?order:[ `Decreasing | `Increasing ]
    -> ?greater_or_equal_to:Table.key
    -> ?less_or_equal_to:Table.key
    -> t
    -> t
    -> (Table.key, Table.key) Base__.Set_intf.Merge_to_sequence_element.t
       Base__.Sequence.t

  val to_map :
       t
    -> f:(Table.key -> 'data)
    -> (Table.key, 'data, comparator_witness) Base.Map.t

  val quickcheck_observer :
       Table.key Core_kernel__.Quickcheck.Observer.t
    -> t Core_kernel__.Quickcheck.Observer.t

  val quickcheck_shrinker :
       Table.key Core_kernel__.Quickcheck.Shrinker.t
    -> t Core_kernel__.Quickcheck.Shrinker.t

  val empty : t

  val singleton : Table.key -> t

  val union_list : t list -> t

  val of_list : Table.key list -> t

  val of_array : Table.key array -> t

  val of_sorted_array : Table.key array -> t Base__.Or_error.t

  val of_sorted_array_unchecked : Table.key array -> t

  val of_increasing_iterator_unchecked : len:int -> f:(int -> Table.key) -> t

  val stable_dedup_list : Table.key list -> Table.key list

  val map : ('a, 'b) Base.Set.t -> f:('a -> Table.key) -> t

  val filter_map : ('a, 'b) Base.Set.t -> f:('a -> Table.key option) -> t

  val of_tree : Tree.t -> t

  val of_hash_set : Table.key Core_kernel__.Hash_set.t -> t

  val of_hashtbl_keys : (Table.key, 'a) Table.hashtbl -> t

  val of_map_keys : (Table.key, 'a, comparator_witness) Base.Map.t -> t

  val quickcheck_generator :
       Table.key Core_kernel__.Quickcheck.Generator.t
    -> t Core_kernel__.Quickcheck.Generator.t

  module Provide_of_sexp : functor
    (Elt : sig
       val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> Table.key
     end)
    -> sig
    val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> t
  end

  module Provide_bin_io : functor
    (Elt : sig
       val bin_size_t : Table.key Bin_prot.Size.sizer

       val bin_write_t : Table.key Bin_prot.Write.writer

       val bin_read_t : Table.key Bin_prot.Read.reader

       val __bin_read_t__ : (int -> Table.key) Bin_prot.Read.reader

       val bin_shape_t : Bin_prot.Shape.t

       val bin_writer_t : Table.key Bin_prot.Type_class.writer

       val bin_reader_t : Table.key Bin_prot.Type_class.reader

       val bin_t : Table.key Bin_prot.Type_class.t
     end)
    -> sig
    val bin_size_t : t Bin_prot.Size.sizer

    val bin_write_t : t Bin_prot.Write.writer

    val bin_read_t : t Bin_prot.Read.reader

    val __bin_read_t__ : (int -> t) Bin_prot.Read.reader

    val bin_shape_t : Bin_prot.Shape.t

    val bin_writer_t : t Bin_prot.Type_class.writer

    val bin_reader_t : t Bin_prot.Type_class.reader

    val bin_t : t Bin_prot.Type_class.t
  end

  module Provide_hash : functor
    (Elt : sig
       val hash_fold_t : Base__.Hash.state -> Table.key -> Base__.Hash.state
     end)
    -> sig
    val hash_fold_t :
      Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state

    val hash : t -> Ppx_hash_lib.Std.Hash.hash_value
  end

  val t_of_sexp : Base__.Sexp.t -> t

  val sexp_of_t : t -> Base__.Sexp.t
end

type 'command t_ = 'command Poly.t =
  | Command of 'command
  | Fee_transfer of Fee_transfer.t
  | Coinbase of Coinbase.t

val forget : Valid.t -> t

val fee_excess : t -> Fee_excess.t Core.Or_error.t

val supply_increase :
  'a t_ -> (Currency.Amount.Stable.Latest.t, Core_kernel__.Error.t) Core._result

val public_keys : t -> Import.Public_key.Compressed.t list

val accounts_accessed :
  next_available_token:Token_id.t -> t -> Account_id.t list

val next_available_token : t -> Token_id.t -> Token_id.t

val fee_payer_pk : t -> Import.Public_key.Compressed.t
