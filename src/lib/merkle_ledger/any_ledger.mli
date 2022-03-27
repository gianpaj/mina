module type S = sig
  type key

  type token_id

  type token_id_set

  type account_id

  type account_id_set

  type account

  type hash

  module Location : Location_intf.S

  type witness

  val sexp_of_witness : witness -> Ppx_sexp_conv_lib.Sexp.t

  module type Base_intf = sig
    type index = int

    type t

    module Addr : sig
      type t = Location.Addr.t

      val to_yojson : t -> Yojson.Safe.t

      val t_of_sexp : Sexplib0.Sexp.t -> t

      val sexp_of_t : t -> Sexplib0.Sexp.t

      val equal : t -> t -> bool

      val compare : t -> t -> index

      module Stable : sig
        module V1 : sig
          type nonrec t = t

          val to_yojson : t -> Yojson.Safe.t

          val t_of_sexp : Sexplib0.Sexp.t -> t

          val sexp_of_t : t -> Sexplib0.Sexp.t

          val bin_size_t : t Bin_prot.Size.sizer

          val bin_write_t : t Bin_prot.Write.writer

          val bin_read_t : t Bin_prot.Read.reader

          val __bin_read_t__ : (index -> t) Bin_prot.Read.reader

          val bin_shape_t : Bin_prot.Shape.t

          val bin_writer_t : t Bin_prot.Type_class.writer

          val bin_reader_t : t Bin_prot.Type_class.reader

          val bin_t : t Bin_prot.Type_class.t

          val hash_fold_t :
            Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state

          val hash : t -> Ppx_hash_lib.Std.Hash.hash_value

          val equal : t -> t -> bool

          val compare : t -> t -> index

          val __versioned__ : unit
        end

        module Latest : sig
          type nonrec t = t

          val to_yojson : t -> Yojson.Safe.t

          val t_of_sexp : Sexplib0.Sexp.t -> t

          val sexp_of_t : t -> Sexplib0.Sexp.t

          val bin_size_t : t Bin_prot.Size.sizer

          val bin_write_t : t Bin_prot.Write.writer

          val bin_read_t : t Bin_prot.Read.reader

          val __bin_read_t__ : (index -> t) Bin_prot.Read.reader

          val bin_shape_t : Bin_prot.Shape.t

          val bin_writer_t : t Bin_prot.Type_class.writer

          val bin_reader_t : t Bin_prot.Type_class.reader

          val bin_t : t Bin_prot.Type_class.t

          val hash_fold_t :
            Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state

          val hash : t -> Ppx_hash_lib.Std.Hash.hash_value

          val equal : t -> t -> bool

          val compare : t -> t -> index

          val __versioned__ : unit
        end
      end

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

        val counti : 'b t -> f:(key:key -> data:'b -> bool) -> index

        val count : 'b t -> f:('b -> bool) -> index

        val length : 'a t -> index

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

        val partitioni_tf :
          'b t -> f:(key:key -> data:'b -> bool) -> 'b t * 'b t

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

        type 'a merge_into_action = 'a Location.Addr.Table.merge_into_action =
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

        val incr : ?by:index -> ?remove_if_zero:bool -> index t -> key -> unit

        val decr : ?by:index -> ?remove_if_zero:bool -> index t -> key -> unit

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

             val __bin_read_t__ : (index -> key) Bin_prot.Read.reader

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

          val __bin_read_t__ : ('a, index -> 'a t) Bin_prot.Read.reader1

          val bin_writer_t : ('a, 'a t) Bin_prot.Type_class.S1.writer

          val bin_reader_t : ('a, 'a t) Bin_prot.Type_class.S1.reader

          val bin_t : ('a, 'a t) Bin_prot.Type_class.S1.t
        end

        val t_of_sexp :
             (Ppx_sexp_conv_lib.Sexp.t -> 'v_x__002_)
          -> Ppx_sexp_conv_lib.Sexp.t
          -> 'v_x__002_ t

        val bin_shape_t : Bin_prot.Shape.t -> Bin_prot.Shape.t

        val bin_size_t : ('a, 'a t) Bin_prot.Size.sizer1

        val bin_write_t : ('a, 'a t) Bin_prot.Write.writer1

        val bin_read_t : ('a, 'a t) Bin_prot.Read.reader1

        val __bin_read_t__ : ('a, index -> 'a t) Bin_prot.Read.reader1

        val bin_writer_t : ('a, 'a t) Bin_prot.Type_class.S1.writer

        val bin_reader_t : ('a, 'a t) Bin_prot.Type_class.S1.reader

        val bin_t : ('a, 'a t) Bin_prot.Type_class.S1.t
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

             val __bin_read_t__ : (index -> elt) Bin_prot.Read.reader

             val bin_shape_t : Bin_prot.Shape.t

             val bin_writer_t : elt Bin_prot.Type_class.writer

             val bin_reader_t : elt Bin_prot.Type_class.reader

             val bin_t : elt Bin_prot.Type_class.t
           end)
          -> sig
          val bin_size_t : t Bin_prot.Size.sizer

          val bin_write_t : t Bin_prot.Write.writer

          val bin_read_t : t Bin_prot.Read.reader

          val __bin_read_t__ : (index -> t) Bin_prot.Read.reader

          val bin_shape_t : Bin_prot.Shape.t

          val bin_writer_t : t Bin_prot.Type_class.writer

          val bin_reader_t : t Bin_prot.Type_class.reader

          val bin_t : t Bin_prot.Type_class.t
        end

        val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> t

        val bin_size_t : t Bin_prot.Size.sizer

        val bin_write_t : t Bin_prot.Write.writer

        val bin_read_t : t Bin_prot.Read.reader

        val __bin_read_t__ : (index -> t) Bin_prot.Read.reader

        val bin_shape_t : Bin_prot.Shape.t

        val bin_writer_t : t Bin_prot.Type_class.writer

        val bin_reader_t : t Bin_prot.Type_class.reader

        val bin_t : t Bin_prot.Type_class.t
      end

      module Hash_queue : sig
        type key = t

        val length : ('a, 'b) Core_kernel__.Hash_queue.t -> index

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

        val exists :
          ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> bool) -> bool

        val for_all :
          ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> bool) -> bool

        val count :
          ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> bool) -> index

        val sum :
             (module Base__.Container_intf.Summable with type t = 'sum)
          -> ('b, 'a) Core_kernel__.Hash_queue.t
          -> f:('a -> 'sum)
          -> 'sum

        val find :
          ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> bool) -> 'a option

        val find_map :
             ('c, 'a) Core_kernel__.Hash_queue.t
          -> f:('a -> 'b option)
          -> 'b option

        val to_list : ('b, 'a) Core_kernel__.Hash_queue.t -> 'a list

        val to_array : ('b, 'a) Core_kernel__.Hash_queue.t -> 'a array

        val min_elt :
             ('b, 'a) Core_kernel__.Hash_queue.t
          -> compare:('a -> 'a -> index)
          -> 'a option

        val max_elt :
             ('b, 'a) Core_kernel__.Hash_queue.t
          -> compare:('a -> 'a -> index)
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

        val lookup_exn :
          ('key, 'data) Core_kernel__.Hash_queue.t -> 'key -> 'data

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
             ('key, 'data) Core_kernel__.Hash_queue.t
          -> 'key Core_kernel__.Import.list

        val dequeue :
             ('key, 'data) Core_kernel__.Hash_queue.t
          -> [ `back | `front ]
          -> 'data Core_kernel__.Import.option

        val dequeue_exn :
             ('key, 'data) Core_kernel__.Hash_queue.t
          -> [ `back | `front ]
          -> 'data

        val dequeue_back :
             ('key, 'data) Core_kernel__.Hash_queue.t
          -> 'data Core_kernel__.Import.option

        val dequeue_back_exn : ('key, 'data) Core_kernel__.Hash_queue.t -> 'data

        val dequeue_front :
             ('key, 'data) Core_kernel__.Hash_queue.t
          -> 'data Core_kernel__.Import.option

        val dequeue_front_exn :
          ('key, 'data) Core_kernel__.Hash_queue.t -> 'data

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
             ('key, 'data) Core_kernel__.Hash_queue.t
          -> 'key
          -> [ `No_such_key | `Ok ]

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
             ('data -> Ppx_sexp_conv_lib.Sexp.t)
          -> 'data t
          -> Ppx_sexp_conv_lib.Sexp.t
      end

      val of_byte_string : string -> t

      val of_directions : Direction.t list -> t

      val root : unit -> t

      val slice : t -> index -> index -> t

      val get : t -> index -> index

      val copy : t -> t

      val parent : t -> t Core_kernel.Or_error.t

      val child :
        ledger_depth:index -> t -> Direction.t -> t Core_kernel.Or_error.t

      val child_exn : ledger_depth:index -> t -> Direction.t -> t

      val parent_exn : t -> t

      val dirs_from_root : t -> Direction.t list

      val sibling : t -> t

      val next : t -> t Core_kernel.Option.t

      val prev : t -> t Core_kernel.Option.t

      val is_leaf : ledger_depth:index -> t -> bool

      val is_parent_of : t -> maybe_child:t -> bool

      val serialize : ledger_depth:index -> t -> Core_kernel.Bigstring.t

      val to_string : t -> string

      val pp : Format.formatter -> t -> unit

      module Range : sig
        type nonrec t = t * t

        val fold :
             ?stop:[ `Exclusive | `Inclusive ]
          -> t
          -> init:'a
          -> f:(Table.key -> 'a -> 'a)
          -> 'a

        val subtree_range : ledger_depth:index -> Table.key -> t

        val subtree_range_seq :
          ledger_depth:index -> Table.key -> Table.key Core_kernel.Sequence.t
      end

      val depth : t -> index

      val height : ledger_depth:index -> t -> index

      val to_int : t -> index

      val of_int_exn : ledger_depth:index -> index -> t
    end

    module Path : sig
      type elem = [ `Left of hash | `Right of hash ]

      val sexp_of_elem : elem -> Ppx_sexp_conv_lib.Sexp.t

      val elem_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> elem

      val __elem_of_sexp__ : Ppx_sexp_conv_lib.Sexp.t -> elem

      val equal_elem : elem -> elem -> bool

      val elem_hash : elem -> hash

      type t = elem list

      val t_of_sexp : Sexplib0.Sexp.t -> t

      val sexp_of_t : t -> Sexplib0.Sexp.t

      val equal : t -> t -> bool

      val implied_root : t -> hash -> hash

      val check_path : t -> hash -> hash -> bool
    end

    module Location : sig
      module Addr : sig
        type t = Addr.t

        val to_yojson : t -> Yojson.Safe.t

        val t_of_sexp : Sexplib0.Sexp.t -> t

        val sexp_of_t : t -> Sexplib0.Sexp.t

        val equal : t -> t -> bool

        val compare : t -> t -> index

        module Stable : sig
          module V1 : sig
            type nonrec t = t

            val to_yojson : t -> Yojson.Safe.t

            val t_of_sexp : Sexplib0.Sexp.t -> t

            val sexp_of_t : t -> Sexplib0.Sexp.t

            val bin_size_t : t Bin_prot.Size.sizer

            val bin_write_t : t Bin_prot.Write.writer

            val bin_read_t : t Bin_prot.Read.reader

            val __bin_read_t__ : (index -> t) Bin_prot.Read.reader

            val bin_shape_t : Bin_prot.Shape.t

            val bin_writer_t : t Bin_prot.Type_class.writer

            val bin_reader_t : t Bin_prot.Type_class.reader

            val bin_t : t Bin_prot.Type_class.t

            val hash_fold_t :
              Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state

            val hash : t -> Ppx_hash_lib.Std.Hash.hash_value

            val equal : t -> t -> bool

            val compare : t -> t -> index

            val __versioned__ : unit
          end

          module Latest : sig
            type nonrec t = t

            val to_yojson : t -> Yojson.Safe.t

            val t_of_sexp : Sexplib0.Sexp.t -> t

            val sexp_of_t : t -> Sexplib0.Sexp.t

            val bin_size_t : t Bin_prot.Size.sizer

            val bin_write_t : t Bin_prot.Write.writer

            val bin_read_t : t Bin_prot.Read.reader

            val __bin_read_t__ : (index -> t) Bin_prot.Read.reader

            val bin_shape_t : Bin_prot.Shape.t

            val bin_writer_t : t Bin_prot.Type_class.writer

            val bin_reader_t : t Bin_prot.Type_class.reader

            val bin_t : t Bin_prot.Type_class.t

            val hash_fold_t :
              Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state

            val hash : t -> Ppx_hash_lib.Std.Hash.hash_value

            val equal : t -> t -> bool

            val compare : t -> t -> index

            val __versioned__ : unit
          end
        end

        val hash_fold_t :
          Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state

        val hash : t -> Ppx_hash_lib.Std.Hash.hash_value

        val hashable : t Core_kernel__.Hashtbl.Hashable.t

        module Table : sig
          type key = t

          type ('a, 'b) hashtbl = ('a, 'b) Addr.Table.hashtbl

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
            , (key * 'b) list -> [ `Duplicate_keys of key list | `Ok of 'b t ]
            )
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

          val counti : 'b t -> f:(key:key -> data:'b -> bool) -> index

          val count : 'b t -> f:('b -> bool) -> index

          val length : 'a t -> index

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

          val partitioni_tf :
            'b t -> f:(key:key -> data:'b -> bool) -> 'b t * 'b t

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

          type 'a merge_into_action = 'a Addr.Table.merge_into_action =
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

          val incr : ?by:index -> ?remove_if_zero:bool -> index t -> key -> unit

          val decr : ?by:index -> ?remove_if_zero:bool -> index t -> key -> unit

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

               val __bin_read_t__ : (index -> key) Bin_prot.Read.reader

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

            val __bin_read_t__ : ('a, index -> 'a t) Bin_prot.Read.reader1

            val bin_writer_t : ('a, 'a t) Bin_prot.Type_class.S1.writer

            val bin_reader_t : ('a, 'a t) Bin_prot.Type_class.S1.reader

            val bin_t : ('a, 'a t) Bin_prot.Type_class.S1.t
          end

          val t_of_sexp :
               (Ppx_sexp_conv_lib.Sexp.t -> 'v_x__002_)
            -> Ppx_sexp_conv_lib.Sexp.t
            -> 'v_x__002_ t

          val bin_shape_t : Bin_prot.Shape.t -> Bin_prot.Shape.t

          val bin_size_t : ('a, 'a t) Bin_prot.Size.sizer1

          val bin_write_t : ('a, 'a t) Bin_prot.Write.writer1

          val bin_read_t : ('a, 'a t) Bin_prot.Read.reader1

          val __bin_read_t__ : ('a, index -> 'a t) Bin_prot.Read.reader1

          val bin_writer_t : ('a, 'a t) Bin_prot.Type_class.S1.writer

          val bin_reader_t : ('a, 'a t) Bin_prot.Type_class.S1.reader

          val bin_t : ('a, 'a t) Bin_prot.Type_class.S1.t
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
            Core_kernel__.Hash_set_intf
            .create_options_without_first_class_module

          val of_list :
            ( 'a
            , elt list -> t )
            Core_kernel__.Hash_set_intf
            .create_options_without_first_class_module

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

               val __bin_read_t__ : (index -> elt) Bin_prot.Read.reader

               val bin_shape_t : Bin_prot.Shape.t

               val bin_writer_t : elt Bin_prot.Type_class.writer

               val bin_reader_t : elt Bin_prot.Type_class.reader

               val bin_t : elt Bin_prot.Type_class.t
             end)
            -> sig
            val bin_size_t : t Bin_prot.Size.sizer

            val bin_write_t : t Bin_prot.Write.writer

            val bin_read_t : t Bin_prot.Read.reader

            val __bin_read_t__ : (index -> t) Bin_prot.Read.reader

            val bin_shape_t : Bin_prot.Shape.t

            val bin_writer_t : t Bin_prot.Type_class.writer

            val bin_reader_t : t Bin_prot.Type_class.reader

            val bin_t : t Bin_prot.Type_class.t
          end

          val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> t

          val bin_size_t : t Bin_prot.Size.sizer

          val bin_write_t : t Bin_prot.Write.writer

          val bin_read_t : t Bin_prot.Read.reader

          val __bin_read_t__ : (index -> t) Bin_prot.Read.reader

          val bin_shape_t : Bin_prot.Shape.t

          val bin_writer_t : t Bin_prot.Type_class.writer

          val bin_reader_t : t Bin_prot.Type_class.reader

          val bin_t : t Bin_prot.Type_class.t
        end

        module Hash_queue : sig
          type key = t

          val length : ('a, 'b) Core_kernel__.Hash_queue.t -> index

          val is_empty : ('a, 'b) Core_kernel__.Hash_queue.t -> bool

          val iter :
            ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> unit) -> unit

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

          val exists :
            ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> bool) -> bool

          val for_all :
            ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> bool) -> bool

          val count :
            ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> bool) -> index

          val sum :
               (module Base__.Container_intf.Summable with type t = 'sum)
            -> ('b, 'a) Core_kernel__.Hash_queue.t
            -> f:('a -> 'sum)
            -> 'sum

          val find :
            ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> bool) -> 'a option

          val find_map :
               ('c, 'a) Core_kernel__.Hash_queue.t
            -> f:('a -> 'b option)
            -> 'b option

          val to_list : ('b, 'a) Core_kernel__.Hash_queue.t -> 'a list

          val to_array : ('b, 'a) Core_kernel__.Hash_queue.t -> 'a array

          val min_elt :
               ('b, 'a) Core_kernel__.Hash_queue.t
            -> compare:('a -> 'a -> index)
            -> 'a option

          val max_elt :
               ('b, 'a) Core_kernel__.Hash_queue.t
            -> compare:('a -> 'a -> index)
            -> 'a option

          val invariant :
               ('key, 'data) Core_kernel__.Hash_queue.t
            -> Core_kernel__.Import.unit

          val create :
               ?growth_allowed:Core_kernel__.Import.bool
            -> ?size:Core_kernel__.Import.int
            -> Core_kernel__.Import.unit
            -> (t, 'data) Core_kernel__.Hash_queue.t

          val clear :
               ('key, 'data) Core_kernel__.Hash_queue.t
            -> Core_kernel__.Import.unit

          val mem :
               ('key, 'data) Core_kernel__.Hash_queue.t
            -> 'key
            -> Core_kernel__.Import.bool

          val lookup :
               ('key, 'data) Core_kernel__.Hash_queue.t
            -> 'key
            -> 'data Core_kernel__.Import.option

          val lookup_exn :
            ('key, 'data) Core_kernel__.Hash_queue.t -> 'key -> 'data

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
               ('key, 'data) Core_kernel__.Hash_queue.t
            -> 'key Core_kernel__.Import.list

          val dequeue :
               ('key, 'data) Core_kernel__.Hash_queue.t
            -> [ `back | `front ]
            -> 'data Core_kernel__.Import.option

          val dequeue_exn :
               ('key, 'data) Core_kernel__.Hash_queue.t
            -> [ `back | `front ]
            -> 'data

          val dequeue_back :
               ('key, 'data) Core_kernel__.Hash_queue.t
            -> 'data Core_kernel__.Import.option

          val dequeue_back_exn :
            ('key, 'data) Core_kernel__.Hash_queue.t -> 'data

          val dequeue_front :
               ('key, 'data) Core_kernel__.Hash_queue.t
            -> 'data Core_kernel__.Import.option

          val dequeue_front_exn :
            ('key, 'data) Core_kernel__.Hash_queue.t -> 'data

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
               ('key, 'data) Core_kernel__.Hash_queue.t
            -> 'key
            -> [ `No_such_key | `Ok ]

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
               ('data -> Ppx_sexp_conv_lib.Sexp.t)
            -> 'data t
            -> Ppx_sexp_conv_lib.Sexp.t
        end

        val of_byte_string : string -> t

        val of_directions : Direction.t list -> t

        val root : unit -> t

        val slice : t -> index -> index -> t

        val get : t -> index -> index

        val copy : t -> t

        val parent : t -> t Core_kernel.Or_error.t

        val child :
          ledger_depth:index -> t -> Direction.t -> t Core_kernel.Or_error.t

        val child_exn : ledger_depth:index -> t -> Direction.t -> t

        val parent_exn : t -> t

        val dirs_from_root : t -> Direction.t list

        val sibling : t -> t

        val next : t -> t Core_kernel.Option.t

        val prev : t -> t Core_kernel.Option.t

        val is_leaf : ledger_depth:index -> t -> bool

        val is_parent_of : t -> maybe_child:t -> bool

        val serialize : ledger_depth:index -> t -> Core_kernel.Bigstring.t

        val to_string : t -> string

        val pp : Format.formatter -> t -> unit

        module Range : sig
          type nonrec t = t * t

          val fold :
               ?stop:[ `Exclusive | `Inclusive ]
            -> t
            -> init:'a
            -> f:(Table.key -> 'a -> 'a)
            -> 'a

          val subtree_range : ledger_depth:index -> Table.key -> t

          val subtree_range_seq :
            ledger_depth:index -> Table.key -> Table.key Core_kernel.Sequence.t
        end

        val depth : t -> index

        val height : ledger_depth:index -> t -> index

        val to_int : t -> index

        val of_int_exn : ledger_depth:index -> index -> t
      end

      module Prefix : sig
        val generic : Unsigned.UInt8.t

        val account : Unsigned.UInt8.t

        val hash : ledger_depth:index -> index -> Unsigned.UInt8.t
      end

      type t = Location.t =
        | Generic of Core.Bigstring.t
        | Account of Addr.t
        | Hash of Addr.t

      val t_of_sexp : Sexplib0.Sexp.t -> t

      val sexp_of_t : t -> Sexplib0.Sexp.t

      val hash_fold_t :
        Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state

      val hash : t -> Ppx_hash_lib.Std.Hash.hash_value

      val is_generic : t -> bool

      val is_account : t -> bool

      val is_hash : t -> bool

      val height : ledger_depth:index -> t -> index

      val root_hash : t

      val last_direction : Addr.t -> Direction.t

      val build_generic : Core.Bigstring.t -> t

      val parse :
        ledger_depth:index -> Core.Bigstring.t -> (t, unit) Core.Result.t

      val prefix_bigstring :
        Unsigned.UInt8.t -> Core.Bigstring.t -> Core.Bigstring.t

      val to_path_exn : t -> Addr.t

      val serialize : ledger_depth:index -> t -> Core.Bigstring.t

      val parent : t -> t

      val next : t -> t Core.Option.t

      val prev : t -> t Core.Option.t

      val sibling : t -> t

      val order_siblings : t -> 'a -> 'a -> 'a * 'a

      val ( >= ) : t -> t -> bool

      val ( <= ) : t -> t -> bool

      val ( = ) : t -> t -> bool

      val ( > ) : t -> t -> bool

      val ( < ) : t -> t -> bool

      val ( <> ) : t -> t -> bool

      val equal : t -> t -> bool

      val compare : t -> t -> index

      val min : t -> t -> t

      val max : t -> t -> t

      val ascending : t -> t -> index

      val descending : t -> t -> index

      val between : t -> low:t -> high:t -> bool

      val clamp_exn : t -> min:t -> max:t -> t

      val clamp : t -> min:t -> max:t -> t Base__.Or_error.t

      type comparator_witness = Location.comparator_witness

      val comparator : (t, comparator_witness) Base__.Comparator.comparator

      val validate_lbound :
        min:t Base__.Maybe_bound.t -> t Base__.Validate.check

      val validate_ubound :
        max:t Base__.Maybe_bound.t -> t Base__.Validate.check

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

        val compare : t -> t -> index

        val min : t -> t -> t

        val max : t -> t -> t
      end

      module Map : sig
        module Key : sig
          type t = Location.t

          val t_of_sexp : Sexplib0.Sexp.t -> t

          val sexp_of_t : t -> Sexplib0.Sexp.t

          type comparator_witness = Location.comparator_witness

          val comparator :
            (t, comparator_witness) Core_kernel__.Comparator.comparator
        end

        module Tree : sig
          type 'a t =
            (Key.t, 'a, comparator_witness) Core_kernel__.Map_intf.Tree.t

          val empty : 'a t

          val singleton : Key.t -> 'a -> 'a t

          val of_alist :
            (Key.t * 'a) list -> [ `Duplicate_key of Key.t | `Ok of 'a t ]

          val of_alist_or_error : (Key.t * 'a) list -> 'a t Base__.Or_error.t

          val of_alist_exn : (Key.t * 'a) list -> 'a t

          val of_alist_multi : (Key.t * 'a) list -> 'a list t

          val of_alist_fold :
            (Key.t * 'a) list -> init:'b -> f:('b -> 'a -> 'b) -> 'b t

          val of_alist_reduce : (Key.t * 'a) list -> f:('a -> 'a -> 'a) -> 'a t

          val of_sorted_array : (Key.t * 'a) array -> 'a t Base__.Or_error.t

          val of_sorted_array_unchecked : (Key.t * 'a) array -> 'a t

          val of_increasing_iterator_unchecked :
            len:index -> f:(index -> Key.t * 'a) -> 'a t

          val of_increasing_sequence :
            (Key.t * 'a) Base__.Sequence.t -> 'a t Base__.Or_error.t

          val of_sequence :
               (Key.t * 'a) Base__.Sequence.t
            -> [ `Duplicate_key of Key.t | `Ok of 'a t ]

          val of_sequence_or_error :
            (Key.t * 'a) Base__.Sequence.t -> 'a t Base__.Or_error.t

          val of_sequence_exn : (Key.t * 'a) Base__.Sequence.t -> 'a t

          val of_sequence_multi : (Key.t * 'a) Base__.Sequence.t -> 'a list t

          val of_sequence_fold :
               (Key.t * 'a) Base__.Sequence.t
            -> init:'b
            -> f:('b -> 'a -> 'b)
            -> 'b t

          val of_sequence_reduce :
            (Key.t * 'a) Base__.Sequence.t -> f:('a -> 'a -> 'a) -> 'a t

          val of_iteri :
               iteri:(f:(key:Key.t -> data:'v -> unit) -> unit)
            -> [ `Duplicate_key of Key.t | `Ok of 'v t ]

          val of_tree : 'a t -> 'a t

          val of_hashtbl_exn : (Key.t, 'a) Addr.Table.hashtbl -> 'a t

          val of_key_set :
            (Key.t, comparator_witness) Base.Set.t -> f:(Key.t -> 'v) -> 'v t

          val quickcheck_generator :
               Key.t Core_kernel__.Quickcheck.Generator.t
            -> 'a Core_kernel__.Quickcheck.Generator.t
            -> 'a t Core_kernel__.Quickcheck.Generator.t

          val invariants : 'a t -> bool

          val is_empty : 'a t -> bool

          val length : 'a t -> index

          val add :
            'a t -> key:Key.t -> data:'a -> 'a t Base__.Map_intf.Or_duplicate.t

          val add_exn : 'a t -> key:Key.t -> data:'a -> 'a t

          val set : 'a t -> key:Key.t -> data:'a -> 'a t

          val add_multi : 'a list t -> key:Key.t -> data:'a -> 'a list t

          val remove_multi : 'a list t -> Key.t -> 'a list t

          val find_multi : 'a list t -> Key.t -> 'a list

          val change : 'a t -> Key.t -> f:('a option -> 'a option) -> 'a t

          val update : 'a t -> Key.t -> f:('a option -> 'a) -> 'a t

          val find : 'a t -> Key.t -> 'a option

          val find_exn : 'a t -> Key.t -> 'a

          val remove : 'a t -> Key.t -> 'a t

          val mem : 'a t -> Key.t -> bool

          val iter_keys : 'a t -> f:(Key.t -> unit) -> unit

          val iter : 'a t -> f:('a -> unit) -> unit

          val iteri : 'a t -> f:(key:Key.t -> data:'a -> unit) -> unit

          val iteri_until :
               'a t
            -> f:(key:Key.t -> data:'a -> Base__.Map_intf.Continue_or_stop.t)
            -> Base__.Map_intf.Finished_or_unfinished.t

          val iter2 :
               'a t
            -> 'b t
            -> f:
                 (   key:Key.t
                  -> data:[ `Both of 'a * 'b | `Left of 'a | `Right of 'b ]
                  -> unit)
            -> unit

          val map : 'a t -> f:('a -> 'b) -> 'b t

          val mapi : 'a t -> f:(key:Key.t -> data:'a -> 'b) -> 'b t

          val fold :
            'a t -> init:'b -> f:(key:Key.t -> data:'a -> 'b -> 'b) -> 'b

          val fold_right :
            'a t -> init:'b -> f:(key:Key.t -> data:'a -> 'b -> 'b) -> 'b

          val fold2 :
               'a t
            -> 'b t
            -> init:'c
            -> f:
                 (   key:Key.t
                  -> data:[ `Both of 'a * 'b | `Left of 'a | `Right of 'b ]
                  -> 'c
                  -> 'c)
            -> 'c

          val filter_keys : 'a t -> f:(Key.t -> bool) -> 'a t

          val filter : 'a t -> f:('a -> bool) -> 'a t

          val filteri : 'a t -> f:(key:Key.t -> data:'a -> bool) -> 'a t

          val filter_map : 'a t -> f:('a -> 'b option) -> 'b t

          val filter_mapi :
            'a t -> f:(key:Key.t -> data:'a -> 'b option) -> 'b t

          val partition_mapi :
               'a t
            -> f:(key:Key.t -> data:'a -> [ `Fst of 'b | `Snd of 'c ])
            -> 'b t * 'c t

          val partition_map :
            'a t -> f:('a -> [ `Fst of 'b | `Snd of 'c ]) -> 'b t * 'c t

          val partitioni_tf :
            'a t -> f:(key:Key.t -> data:'a -> bool) -> 'a t * 'a t

          val partition_tf : 'a t -> f:('a -> bool) -> 'a t * 'a t

          val compare_direct : ('a -> 'a -> index) -> 'a t -> 'a t -> index

          val equal : ('a -> 'a -> bool) -> 'a t -> 'a t -> bool

          val keys : 'a t -> Key.t list

          val data : 'a t -> 'a list

          val to_alist :
               ?key_order:[ `Decreasing | `Increasing ]
            -> 'a t
            -> (Key.t * 'a) list

          val validate :
               name:(Key.t -> string)
            -> 'a Base__.Validate.check
            -> 'a t Base__.Validate.check

          val merge :
               'a t
            -> 'b t
            -> f:
                 (   key:Key.t
                  -> [ `Both of 'a * 'b | `Left of 'a | `Right of 'b ]
                  -> 'c option)
            -> 'c t

          val symmetric_diff :
               'a t
            -> 'a t
            -> data_equal:('a -> 'a -> bool)
            -> (Key.t, 'a) Base__.Map_intf.Symmetric_diff_element.t
               Base__.Sequence.t

          val fold_symmetric_diff :
               'a t
            -> 'a t
            -> data_equal:('a -> 'a -> bool)
            -> init:'c
            -> f:
                 (   'c
                  -> (Key.t, 'a) Base__.Map_intf.Symmetric_diff_element.t
                  -> 'c)
            -> 'c

          val min_elt : 'a t -> (Key.t * 'a) option

          val min_elt_exn : 'a t -> Key.t * 'a

          val max_elt : 'a t -> (Key.t * 'a) option

          val max_elt_exn : 'a t -> Key.t * 'a

          val for_all : 'a t -> f:('a -> bool) -> bool

          val for_alli : 'a t -> f:(key:Key.t -> data:'a -> bool) -> bool

          val exists : 'a t -> f:('a -> bool) -> bool

          val existsi : 'a t -> f:(key:Key.t -> data:'a -> bool) -> bool

          val count : 'a t -> f:('a -> bool) -> index

          val counti : 'a t -> f:(key:Key.t -> data:'a -> bool) -> index

          val split : 'a t -> Key.t -> 'a t * (Key.t * 'a) option * 'a t

          val append :
               lower_part:'a t
            -> upper_part:'a t
            -> [ `Ok of 'a t | `Overlapping_key_ranges ]

          val subrange :
               'a t
            -> lower_bound:Key.t Base__.Maybe_bound.t
            -> upper_bound:Key.t Base__.Maybe_bound.t
            -> 'a t

          val fold_range_inclusive :
               'a t
            -> min:Key.t
            -> max:Key.t
            -> init:'b
            -> f:(key:Key.t -> data:'a -> 'b -> 'b)
            -> 'b

          val range_to_alist :
            'a t -> min:Key.t -> max:Key.t -> (Key.t * 'a) list

          val closest_key :
               'a t
            -> [ `Greater_or_equal_to
               | `Greater_than
               | `Less_or_equal_to
               | `Less_than ]
            -> Key.t
            -> (Key.t * 'a) option

          val nth : 'a t -> index -> (Key.t * 'a) option

          val nth_exn : 'a t -> index -> Key.t * 'a

          val rank : 'a t -> Key.t -> index option

          val to_tree : 'a t -> 'a t

          val to_sequence :
               ?order:[ `Decreasing_key | `Increasing_key ]
            -> ?keys_greater_or_equal_to:Key.t
            -> ?keys_less_or_equal_to:Key.t
            -> 'a t
            -> (Key.t * 'a) Base__.Sequence.t

          val binary_search :
               'a t
            -> compare:(key:Key.t -> data:'a -> 'key -> index)
            -> [ `First_equal_to
               | `First_greater_than_or_equal_to
               | `First_strictly_greater_than
               | `Last_equal_to
               | `Last_less_than_or_equal_to
               | `Last_strictly_less_than ]
            -> 'key
            -> (Key.t * 'a) option

          val binary_search_segmented :
               'a t
            -> segment_of:(key:Key.t -> data:'a -> [ `Left | `Right ])
            -> [ `First_on_right | `Last_on_left ]
            -> (Key.t * 'a) option

          val key_set : 'a t -> (Key.t, comparator_witness) Base.Set.t

          val quickcheck_observer :
               Key.t Core_kernel__.Quickcheck.Observer.t
            -> 'v Core_kernel__.Quickcheck.Observer.t
            -> 'v t Core_kernel__.Quickcheck.Observer.t

          val quickcheck_shrinker :
               Key.t Core_kernel__.Quickcheck.Shrinker.t
            -> 'v Core_kernel__.Quickcheck.Shrinker.t
            -> 'v t Core_kernel__.Quickcheck.Shrinker.t

          module Provide_of_sexp : functor
            (K : sig
               val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> Key.t
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

        type 'a t = (Key.t, 'a, comparator_witness) Core_kernel__.Map_intf.Map.t

        val compare :
             ('a -> 'a -> Core_kernel__.Import.int)
          -> 'a t
          -> 'a t
          -> Core_kernel__.Import.int

        val empty : 'a t

        val singleton : Key.t -> 'a -> 'a t

        val of_alist :
          (Key.t * 'a) list -> [ `Duplicate_key of Key.t | `Ok of 'a t ]

        val of_alist_or_error : (Key.t * 'a) list -> 'a t Base__.Or_error.t

        val of_alist_exn : (Key.t * 'a) list -> 'a t

        val of_alist_multi : (Key.t * 'a) list -> 'a list t

        val of_alist_fold :
          (Key.t * 'a) list -> init:'b -> f:('b -> 'a -> 'b) -> 'b t

        val of_alist_reduce : (Key.t * 'a) list -> f:('a -> 'a -> 'a) -> 'a t

        val of_sorted_array : (Key.t * 'a) array -> 'a t Base__.Or_error.t

        val of_sorted_array_unchecked : (Key.t * 'a) array -> 'a t

        val of_increasing_iterator_unchecked :
          len:index -> f:(index -> Key.t * 'a) -> 'a t

        val of_increasing_sequence :
          (Key.t * 'a) Base__.Sequence.t -> 'a t Base__.Or_error.t

        val of_sequence :
             (Key.t * 'a) Base__.Sequence.t
          -> [ `Duplicate_key of Key.t | `Ok of 'a t ]

        val of_sequence_or_error :
          (Key.t * 'a) Base__.Sequence.t -> 'a t Base__.Or_error.t

        val of_sequence_exn : (Key.t * 'a) Base__.Sequence.t -> 'a t

        val of_sequence_multi : (Key.t * 'a) Base__.Sequence.t -> 'a list t

        val of_sequence_fold :
             (Key.t * 'a) Base__.Sequence.t
          -> init:'b
          -> f:('b -> 'a -> 'b)
          -> 'b t

        val of_sequence_reduce :
          (Key.t * 'a) Base__.Sequence.t -> f:('a -> 'a -> 'a) -> 'a t

        val of_iteri :
             iteri:(f:(key:Key.t -> data:'v -> unit) -> unit)
          -> [ `Duplicate_key of Key.t | `Ok of 'v t ]

        val of_tree : 'a Tree.t -> 'a t

        val of_hashtbl_exn : (Key.t, 'a) Addr.Table.hashtbl -> 'a t

        val of_key_set :
          (Key.t, comparator_witness) Base.Set.t -> f:(Key.t -> 'v) -> 'v t

        val quickcheck_generator :
             Key.t Core_kernel__.Quickcheck.Generator.t
          -> 'a Core_kernel__.Quickcheck.Generator.t
          -> 'a t Core_kernel__.Quickcheck.Generator.t

        val invariants : 'a t -> bool

        val is_empty : 'a t -> bool

        val length : 'a t -> index

        val add :
          'a t -> key:Key.t -> data:'a -> 'a t Base__.Map_intf.Or_duplicate.t

        val add_exn : 'a t -> key:Key.t -> data:'a -> 'a t

        val set : 'a t -> key:Key.t -> data:'a -> 'a t

        val add_multi : 'a list t -> key:Key.t -> data:'a -> 'a list t

        val remove_multi : 'a list t -> Key.t -> 'a list t

        val find_multi : 'a list t -> Key.t -> 'a list

        val change : 'a t -> Key.t -> f:('a option -> 'a option) -> 'a t

        val update : 'a t -> Key.t -> f:('a option -> 'a) -> 'a t

        val find : 'a t -> Key.t -> 'a option

        val find_exn : 'a t -> Key.t -> 'a

        val remove : 'a t -> Key.t -> 'a t

        val mem : 'a t -> Key.t -> bool

        val iter_keys : 'a t -> f:(Key.t -> unit) -> unit

        val iter : 'a t -> f:('a -> unit) -> unit

        val iteri : 'a t -> f:(key:Key.t -> data:'a -> unit) -> unit

        val iteri_until :
             'a t
          -> f:(key:Key.t -> data:'a -> Base__.Map_intf.Continue_or_stop.t)
          -> Base__.Map_intf.Finished_or_unfinished.t

        val iter2 :
             'a t
          -> 'b t
          -> f:
               (   key:Key.t
                -> data:[ `Both of 'a * 'b | `Left of 'a | `Right of 'b ]
                -> unit)
          -> unit

        val map : 'a t -> f:('a -> 'b) -> 'b t

        val mapi : 'a t -> f:(key:Key.t -> data:'a -> 'b) -> 'b t

        val fold : 'a t -> init:'b -> f:(key:Key.t -> data:'a -> 'b -> 'b) -> 'b

        val fold_right :
          'a t -> init:'b -> f:(key:Key.t -> data:'a -> 'b -> 'b) -> 'b

        val fold2 :
             'a t
          -> 'b t
          -> init:'c
          -> f:
               (   key:Key.t
                -> data:[ `Both of 'a * 'b | `Left of 'a | `Right of 'b ]
                -> 'c
                -> 'c)
          -> 'c

        val filter_keys : 'a t -> f:(Key.t -> bool) -> 'a t

        val filter : 'a t -> f:('a -> bool) -> 'a t

        val filteri : 'a t -> f:(key:Key.t -> data:'a -> bool) -> 'a t

        val filter_map : 'a t -> f:('a -> 'b option) -> 'b t

        val filter_mapi : 'a t -> f:(key:Key.t -> data:'a -> 'b option) -> 'b t

        val partition_mapi :
             'a t
          -> f:(key:Key.t -> data:'a -> [ `Fst of 'b | `Snd of 'c ])
          -> 'b t * 'c t

        val partition_map :
          'a t -> f:('a -> [ `Fst of 'b | `Snd of 'c ]) -> 'b t * 'c t

        val partitioni_tf :
          'a t -> f:(key:Key.t -> data:'a -> bool) -> 'a t * 'a t

        val partition_tf : 'a t -> f:('a -> bool) -> 'a t * 'a t

        val compare_direct : ('a -> 'a -> index) -> 'a t -> 'a t -> index

        val equal : ('a -> 'a -> bool) -> 'a t -> 'a t -> bool

        val keys : 'a t -> Key.t list

        val data : 'a t -> 'a list

        val to_alist :
          ?key_order:[ `Decreasing | `Increasing ] -> 'a t -> (Key.t * 'a) list

        val validate :
             name:(Key.t -> string)
          -> 'a Base__.Validate.check
          -> 'a t Base__.Validate.check

        val merge :
             'a t
          -> 'b t
          -> f:
               (   key:Key.t
                -> [ `Both of 'a * 'b | `Left of 'a | `Right of 'b ]
                -> 'c option)
          -> 'c t

        val symmetric_diff :
             'a t
          -> 'a t
          -> data_equal:('a -> 'a -> bool)
          -> (Key.t, 'a) Base__.Map_intf.Symmetric_diff_element.t
             Base__.Sequence.t

        val fold_symmetric_diff :
             'a t
          -> 'a t
          -> data_equal:('a -> 'a -> bool)
          -> init:'c
          -> f:
               (   'c
                -> (Key.t, 'a) Base__.Map_intf.Symmetric_diff_element.t
                -> 'c)
          -> 'c

        val min_elt : 'a t -> (Key.t * 'a) option

        val min_elt_exn : 'a t -> Key.t * 'a

        val max_elt : 'a t -> (Key.t * 'a) option

        val max_elt_exn : 'a t -> Key.t * 'a

        val for_all : 'a t -> f:('a -> bool) -> bool

        val for_alli : 'a t -> f:(key:Key.t -> data:'a -> bool) -> bool

        val exists : 'a t -> f:('a -> bool) -> bool

        val existsi : 'a t -> f:(key:Key.t -> data:'a -> bool) -> bool

        val count : 'a t -> f:('a -> bool) -> index

        val counti : 'a t -> f:(key:Key.t -> data:'a -> bool) -> index

        val split : 'a t -> Key.t -> 'a t * (Key.t * 'a) option * 'a t

        val append :
             lower_part:'a t
          -> upper_part:'a t
          -> [ `Ok of 'a t | `Overlapping_key_ranges ]

        val subrange :
             'a t
          -> lower_bound:Key.t Base__.Maybe_bound.t
          -> upper_bound:Key.t Base__.Maybe_bound.t
          -> 'a t

        val fold_range_inclusive :
             'a t
          -> min:Key.t
          -> max:Key.t
          -> init:'b
          -> f:(key:Key.t -> data:'a -> 'b -> 'b)
          -> 'b

        val range_to_alist : 'a t -> min:Key.t -> max:Key.t -> (Key.t * 'a) list

        val closest_key :
             'a t
          -> [ `Greater_or_equal_to
             | `Greater_than
             | `Less_or_equal_to
             | `Less_than ]
          -> Key.t
          -> (Key.t * 'a) option

        val nth : 'a t -> index -> (Key.t * 'a) option

        val nth_exn : 'a t -> index -> Key.t * 'a

        val rank : 'a t -> Key.t -> index option

        val to_tree : 'a t -> 'a Tree.t

        val to_sequence :
             ?order:[ `Decreasing_key | `Increasing_key ]
          -> ?keys_greater_or_equal_to:Key.t
          -> ?keys_less_or_equal_to:Key.t
          -> 'a t
          -> (Key.t * 'a) Base__.Sequence.t

        val binary_search :
             'a t
          -> compare:(key:Key.t -> data:'a -> 'key -> index)
          -> [ `First_equal_to
             | `First_greater_than_or_equal_to
             | `First_strictly_greater_than
             | `Last_equal_to
             | `Last_less_than_or_equal_to
             | `Last_strictly_less_than ]
          -> 'key
          -> (Key.t * 'a) option

        val binary_search_segmented :
             'a t
          -> segment_of:(key:Key.t -> data:'a -> [ `Left | `Right ])
          -> [ `First_on_right | `Last_on_left ]
          -> (Key.t * 'a) option

        val key_set : 'a t -> (Key.t, comparator_witness) Base.Set.t

        val quickcheck_observer :
             Key.t Core_kernel__.Quickcheck.Observer.t
          -> 'v Core_kernel__.Quickcheck.Observer.t
          -> 'v t Core_kernel__.Quickcheck.Observer.t

        val quickcheck_shrinker :
             Key.t Core_kernel__.Quickcheck.Shrinker.t
          -> 'v Core_kernel__.Quickcheck.Shrinker.t
          -> 'v t Core_kernel__.Quickcheck.Shrinker.t

        module Provide_of_sexp : functor
          (Key : sig
             val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> Key.t
           end)
          -> sig
          val t_of_sexp :
               (Ppx_sexp_conv_lib.Sexp.t -> 'v_x__002_)
            -> Ppx_sexp_conv_lib.Sexp.t
            -> 'v_x__002_ t
        end

        module Provide_bin_io : functor
          (Key : sig
             val bin_size_t : Key.t Bin_prot.Size.sizer

             val bin_write_t : Key.t Bin_prot.Write.writer

             val bin_read_t : Key.t Bin_prot.Read.reader

             val __bin_read_t__ : (index -> Key.t) Bin_prot.Read.reader

             val bin_shape_t : Bin_prot.Shape.t

             val bin_writer_t : Key.t Bin_prot.Type_class.writer

             val bin_reader_t : Key.t Bin_prot.Type_class.reader

             val bin_t : Key.t Bin_prot.Type_class.t
           end)
          -> sig
          val bin_shape_t : Bin_prot.Shape.t -> Bin_prot.Shape.t

          val bin_size_t : ('a, 'a t) Bin_prot.Size.sizer1

          val bin_write_t : ('a, 'a t) Bin_prot.Write.writer1

          val bin_read_t : ('a, 'a t) Bin_prot.Read.reader1

          val __bin_read_t__ : ('a, index -> 'a t) Bin_prot.Read.reader1

          val bin_writer_t : ('a, 'a t) Bin_prot.Type_class.S1.writer

          val bin_reader_t : ('a, 'a t) Bin_prot.Type_class.S1.reader

          val bin_t : ('a, 'a t) Bin_prot.Type_class.S1.t
        end

        module Provide_hash : functor
          (Key : sig
             val hash_fold_t : Base__.Hash.state -> Key.t -> Base__.Hash.state
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
          type t = Map.Key.t

          val t_of_sexp : Sexplib0.Sexp.t -> t

          val sexp_of_t : t -> Sexplib0.Sexp.t

          type comparator_witness = Map.Key.comparator_witness

          val comparator :
            (t, comparator_witness) Core_kernel__.Comparator.comparator
        end

        module Tree : sig
          type t = (Elt.t, comparator_witness) Core_kernel__.Set_intf.Tree.t

          val compare : t -> t -> Core_kernel__.Import.int

          type named =
            (Elt.t, comparator_witness) Core_kernel__.Set_intf.Tree.Named.t

          val length : t -> index

          val is_empty : t -> bool

          val iter : t -> f:(Elt.t -> unit) -> unit

          val fold : t -> init:'accum -> f:('accum -> Elt.t -> 'accum) -> 'accum

          val fold_result :
               t
            -> init:'accum
            -> f:('accum -> Elt.t -> ('accum, 'e) Base__.Result.t)
            -> ('accum, 'e) Base__.Result.t

          val exists : t -> f:(Elt.t -> bool) -> bool

          val for_all : t -> f:(Elt.t -> bool) -> bool

          val count : t -> f:(Elt.t -> bool) -> index

          val sum :
               (module Base__.Container_intf.Summable with type t = 'sum)
            -> t
            -> f:(Elt.t -> 'sum)
            -> 'sum

          val find : t -> f:(Elt.t -> bool) -> Elt.t option

          val find_map : t -> f:(Elt.t -> 'a option) -> 'a option

          val to_list : t -> Elt.t list

          val to_array : t -> Elt.t array

          val invariants : t -> bool

          val mem : t -> Elt.t -> bool

          val add : t -> Elt.t -> t

          val remove : t -> Elt.t -> t

          val union : t -> t -> t

          val inter : t -> t -> t

          val diff : t -> t -> t

          val symmetric_diff :
            t -> t -> (Elt.t, Elt.t) Base__.Either.t Base__.Sequence.t

          val compare_direct : t -> t -> index

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
                  -> Elt.t
                  -> ('b, 'final) Base__.Set_intf.Continue_or_stop.t)
            -> finish:('b -> 'final)
            -> 'final

          val fold_right : t -> init:'b -> f:(Elt.t -> 'b -> 'b) -> 'b

          val iter2 :
               t
            -> t
            -> f:
                 (   [ `Both of Elt.t * Elt.t
                     | `Left of Elt.t
                     | `Right of Elt.t ]
                  -> unit)
            -> unit

          val filter : t -> f:(Elt.t -> bool) -> t

          val partition_tf : t -> f:(Elt.t -> bool) -> t * t

          val elements : t -> Elt.t list

          val min_elt : t -> Elt.t option

          val min_elt_exn : t -> Elt.t

          val max_elt : t -> Elt.t option

          val max_elt_exn : t -> Elt.t

          val choose : t -> Elt.t option

          val choose_exn : t -> Elt.t

          val split : t -> Elt.t -> t * Elt.t option * t

          val group_by : t -> equiv:(Elt.t -> Elt.t -> bool) -> t list

          val find_exn : t -> f:(Elt.t -> bool) -> Elt.t

          val nth : t -> index -> Elt.t option

          val remove_index : t -> index -> t

          val to_tree : t -> t

          val to_sequence :
               ?order:[ `Decreasing | `Increasing ]
            -> ?greater_or_equal_to:Elt.t
            -> ?less_or_equal_to:Elt.t
            -> t
            -> Elt.t Base__.Sequence.t

          val binary_search :
               t
            -> compare:(Elt.t -> 'key -> index)
            -> [ `First_equal_to
               | `First_greater_than_or_equal_to
               | `First_strictly_greater_than
               | `Last_equal_to
               | `Last_less_than_or_equal_to
               | `Last_strictly_less_than ]
            -> 'key
            -> Elt.t option

          val binary_search_segmented :
               t
            -> segment_of:(Elt.t -> [ `Left | `Right ])
            -> [ `First_on_right | `Last_on_left ]
            -> Elt.t option

          val merge_to_sequence :
               ?order:[ `Decreasing | `Increasing ]
            -> ?greater_or_equal_to:Elt.t
            -> ?less_or_equal_to:Elt.t
            -> t
            -> t
            -> (Elt.t, Elt.t) Base__.Set_intf.Merge_to_sequence_element.t
               Base__.Sequence.t

          val to_map :
               t
            -> f:(Elt.t -> 'data)
            -> (Elt.t, 'data, comparator_witness) Base.Map.t

          val quickcheck_observer :
               Elt.t Core_kernel__.Quickcheck.Observer.t
            -> t Core_kernel__.Quickcheck.Observer.t

          val quickcheck_shrinker :
               Elt.t Core_kernel__.Quickcheck.Shrinker.t
            -> t Core_kernel__.Quickcheck.Shrinker.t

          val empty : t

          val singleton : Elt.t -> t

          val union_list : t list -> t

          val of_list : Elt.t list -> t

          val of_array : Elt.t array -> t

          val of_sorted_array : Elt.t array -> t Base__.Or_error.t

          val of_sorted_array_unchecked : Elt.t array -> t

          val of_increasing_iterator_unchecked :
            len:index -> f:(index -> Elt.t) -> t

          val stable_dedup_list : Elt.t list -> Elt.t list

          val map :
            ('a, 'b) Core_kernel__.Set_intf.Tree.t -> f:('a -> Elt.t) -> t

          val filter_map :
               ('a, 'b) Core_kernel__.Set_intf.Tree.t
            -> f:('a -> Elt.t option)
            -> t

          val of_tree : t -> t

          val of_hash_set : Elt.t Core_kernel__.Hash_set.t -> t

          val of_hashtbl_keys : (Elt.t, 'a) Addr.Table.hashtbl -> t

          val of_map_keys : (Elt.t, 'a, comparator_witness) Base.Map.t -> t

          val quickcheck_generator :
               Elt.t Core_kernel__.Quickcheck.Generator.t
            -> t Core_kernel__.Quickcheck.Generator.t

          module Provide_of_sexp : functor
            (Elt : sig
               val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> Elt.t
             end)
            -> sig
            val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> t
          end

          val t_of_sexp : Base__.Sexp.t -> t

          val sexp_of_t : t -> Base__.Sexp.t
        end

        type t = (Elt.t, comparator_witness) Base.Set.t

        val compare : t -> t -> Core_kernel__.Import.int

        type named = (Elt.t, comparator_witness) Core_kernel__.Set_intf.Named.t

        val length : t -> index

        val is_empty : t -> bool

        val iter : t -> f:(Elt.t -> unit) -> unit

        val fold : t -> init:'accum -> f:('accum -> Elt.t -> 'accum) -> 'accum

        val fold_result :
             t
          -> init:'accum
          -> f:('accum -> Elt.t -> ('accum, 'e) Base__.Result.t)
          -> ('accum, 'e) Base__.Result.t

        val exists : t -> f:(Elt.t -> bool) -> bool

        val for_all : t -> f:(Elt.t -> bool) -> bool

        val count : t -> f:(Elt.t -> bool) -> index

        val sum :
             (module Base__.Container_intf.Summable with type t = 'sum)
          -> t
          -> f:(Elt.t -> 'sum)
          -> 'sum

        val find : t -> f:(Elt.t -> bool) -> Elt.t option

        val find_map : t -> f:(Elt.t -> 'a option) -> 'a option

        val to_list : t -> Elt.t list

        val to_array : t -> Elt.t array

        val invariants : t -> bool

        val mem : t -> Elt.t -> bool

        val add : t -> Elt.t -> t

        val remove : t -> Elt.t -> t

        val union : t -> t -> t

        val inter : t -> t -> t

        val diff : t -> t -> t

        val symmetric_diff :
          t -> t -> (Elt.t, Elt.t) Base__.Either.t Base__.Sequence.t

        val compare_direct : t -> t -> index

        val equal : t -> t -> bool

        val is_subset : t -> of_:t -> bool

        module Named : sig
          val is_subset : named -> of_:named -> unit Base__.Or_error.t

          val equal : named -> named -> unit Base__.Or_error.t
        end

        val fold_until :
             t
          -> init:'b
          -> f:('b -> Elt.t -> ('b, 'final) Base__.Set_intf.Continue_or_stop.t)
          -> finish:('b -> 'final)
          -> 'final

        val fold_right : t -> init:'b -> f:(Elt.t -> 'b -> 'b) -> 'b

        val iter2 :
             t
          -> t
          -> f:
               (   [ `Both of Elt.t * Elt.t | `Left of Elt.t | `Right of Elt.t ]
                -> unit)
          -> unit

        val filter : t -> f:(Elt.t -> bool) -> t

        val partition_tf : t -> f:(Elt.t -> bool) -> t * t

        val elements : t -> Elt.t list

        val min_elt : t -> Elt.t option

        val min_elt_exn : t -> Elt.t

        val max_elt : t -> Elt.t option

        val max_elt_exn : t -> Elt.t

        val choose : t -> Elt.t option

        val choose_exn : t -> Elt.t

        val split : t -> Elt.t -> t * Elt.t option * t

        val group_by : t -> equiv:(Elt.t -> Elt.t -> bool) -> t list

        val find_exn : t -> f:(Elt.t -> bool) -> Elt.t

        val nth : t -> index -> Elt.t option

        val remove_index : t -> index -> t

        val to_tree : t -> Tree.t

        val to_sequence :
             ?order:[ `Decreasing | `Increasing ]
          -> ?greater_or_equal_to:Elt.t
          -> ?less_or_equal_to:Elt.t
          -> t
          -> Elt.t Base__.Sequence.t

        val binary_search :
             t
          -> compare:(Elt.t -> 'key -> index)
          -> [ `First_equal_to
             | `First_greater_than_or_equal_to
             | `First_strictly_greater_than
             | `Last_equal_to
             | `Last_less_than_or_equal_to
             | `Last_strictly_less_than ]
          -> 'key
          -> Elt.t option

        val binary_search_segmented :
             t
          -> segment_of:(Elt.t -> [ `Left | `Right ])
          -> [ `First_on_right | `Last_on_left ]
          -> Elt.t option

        val merge_to_sequence :
             ?order:[ `Decreasing | `Increasing ]
          -> ?greater_or_equal_to:Elt.t
          -> ?less_or_equal_to:Elt.t
          -> t
          -> t
          -> (Elt.t, Elt.t) Base__.Set_intf.Merge_to_sequence_element.t
             Base__.Sequence.t

        val to_map :
             t
          -> f:(Elt.t -> 'data)
          -> (Elt.t, 'data, comparator_witness) Base.Map.t

        val quickcheck_observer :
             Elt.t Core_kernel__.Quickcheck.Observer.t
          -> t Core_kernel__.Quickcheck.Observer.t

        val quickcheck_shrinker :
             Elt.t Core_kernel__.Quickcheck.Shrinker.t
          -> t Core_kernel__.Quickcheck.Shrinker.t

        val empty : t

        val singleton : Elt.t -> t

        val union_list : t list -> t

        val of_list : Elt.t list -> t

        val of_array : Elt.t array -> t

        val of_sorted_array : Elt.t array -> t Base__.Or_error.t

        val of_sorted_array_unchecked : Elt.t array -> t

        val of_increasing_iterator_unchecked :
          len:index -> f:(index -> Elt.t) -> t

        val stable_dedup_list : Elt.t list -> Elt.t list

        val map : ('a, 'b) Base.Set.t -> f:('a -> Elt.t) -> t

        val filter_map : ('a, 'b) Base.Set.t -> f:('a -> Elt.t option) -> t

        val of_tree : Tree.t -> t

        val of_hash_set : Elt.t Core_kernel__.Hash_set.t -> t

        val of_hashtbl_keys : (Elt.t, 'a) Addr.Table.hashtbl -> t

        val of_map_keys : (Elt.t, 'a, comparator_witness) Base.Map.t -> t

        val quickcheck_generator :
             Elt.t Core_kernel__.Quickcheck.Generator.t
          -> t Core_kernel__.Quickcheck.Generator.t

        module Provide_of_sexp : functor
          (Elt : sig
             val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> Elt.t
           end)
          -> sig
          val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> t
        end

        module Provide_bin_io : functor
          (Elt : sig
             val bin_size_t : Elt.t Bin_prot.Size.sizer

             val bin_write_t : Elt.t Bin_prot.Write.writer

             val bin_read_t : Elt.t Bin_prot.Read.reader

             val __bin_read_t__ : (index -> Elt.t) Bin_prot.Read.reader

             val bin_shape_t : Bin_prot.Shape.t

             val bin_writer_t : Elt.t Bin_prot.Type_class.writer

             val bin_reader_t : Elt.t Bin_prot.Type_class.reader

             val bin_t : Elt.t Bin_prot.Type_class.t
           end)
          -> sig
          val bin_size_t : t Bin_prot.Size.sizer

          val bin_write_t : t Bin_prot.Write.writer

          val bin_read_t : t Bin_prot.Read.reader

          val __bin_read_t__ : (index -> t) Bin_prot.Read.reader

          val bin_shape_t : Bin_prot.Shape.t

          val bin_writer_t : t Bin_prot.Type_class.writer

          val bin_reader_t : t Bin_prot.Type_class.reader

          val bin_t : t Bin_prot.Type_class.t
        end

        module Provide_hash : functor
          (Elt : sig
             val hash_fold_t : Base__.Hash.state -> Elt.t -> Base__.Hash.state
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

    val t_of_sexp : Sexplib0.Sexp.t -> t

    val sexp_of_t : t -> Sexplib0.Sexp.t

    type path = Path.t

    val depth : t -> index

    val num_accounts : t -> index

    val merkle_path_at_addr_exn : t -> Addr.t -> path

    val get_inner_hash_at_addr_exn : t -> Addr.t -> hash

    val set_inner_hash_at_addr_exn : t -> Addr.t -> hash -> unit

    val set_all_accounts_rooted_at_exn : t -> Addr.t -> account list -> unit

    val set_batch_accounts : t -> (Addr.t * account) list -> unit

    val get_all_accounts_rooted_at_exn : t -> Addr.t -> (Addr.t * account) list

    val make_space_for : t -> index -> unit

    val to_list : t -> account list

    val iteri : t -> f:(index -> account -> unit) -> unit

    val foldi :
      t -> init:'accum -> f:(Addr.t -> 'accum -> account -> 'accum) -> 'accum

    val foldi_with_ignored_accounts :
         t
      -> account_id_set
      -> init:'accum
      -> f:(Addr.t -> 'accum -> account -> 'accum)
      -> 'accum

    val fold_until :
         t
      -> init:'accum
      -> f:('accum -> account -> ('accum, 'stop) Base.Continue_or_stop.t)
      -> finish:('accum -> 'stop)
      -> 'stop

    val accounts : t -> account_id_set

    val token_owner : t -> token_id -> key option

    val token_owners : t -> account_id_set

    val tokens : t -> key -> token_id_set

    val next_available_token : t -> token_id

    val set_next_available_token : t -> token_id -> unit

    val location_of_account : t -> account_id -> Location.t option

    val location_of_account_batch :
      t -> account_id list -> (account_id * Location.t option) list

    val get_or_create_account :
         t
      -> account_id
      -> account
      -> ([ `Added | `Existed ] * Location.t) Core.Or_error.t

    val close : t -> unit

    val last_filled : t -> Location.t option

    val get_uuid : t -> Uuid.t

    val get_directory : t -> string option

    val get : t -> Location.t -> account option

    val get_batch : t -> Location.t list -> (Location.t * account option) list

    val set : t -> Location.t -> account -> unit

    val set_batch : t -> (Location.t * account) list -> unit

    val get_at_index_exn : t -> index -> account

    val set_at_index_exn : t -> index -> account -> unit

    val index_of_account_exn : t -> account_id -> index

    val merkle_root : t -> hash

    val merkle_path : t -> Location.t -> path

    val merkle_path_at_index_exn : t -> index -> path

    val remove_accounts_exn : t -> account_id list -> unit

    val detached_signal : t -> unit Async.Deferred.t
  end

  val cast : (module Base_intf with type t = 'a) -> 'a -> witness

  module M : sig
    type index = int

    type t = witness

    module Addr : sig
      type t = Location.Addr.t

      val to_yojson : t -> Yojson.Safe.t

      val t_of_sexp : Sexplib0.Sexp.t -> t

      val sexp_of_t : t -> Sexplib0.Sexp.t

      val equal : t -> t -> bool

      val compare : t -> t -> index

      module Stable : sig
        module V1 : sig
          type nonrec t = t

          val to_yojson : t -> Yojson.Safe.t

          val t_of_sexp : Sexplib0.Sexp.t -> t

          val sexp_of_t : t -> Sexplib0.Sexp.t

          val bin_size_t : t Bin_prot.Size.sizer

          val bin_write_t : t Bin_prot.Write.writer

          val bin_read_t : t Bin_prot.Read.reader

          val __bin_read_t__ : (index -> t) Bin_prot.Read.reader

          val bin_shape_t : Bin_prot.Shape.t

          val bin_writer_t : t Bin_prot.Type_class.writer

          val bin_reader_t : t Bin_prot.Type_class.reader

          val bin_t : t Bin_prot.Type_class.t

          val hash_fold_t :
            Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state

          val hash : t -> Ppx_hash_lib.Std.Hash.hash_value

          val equal : t -> t -> bool

          val compare : t -> t -> index

          val __versioned__ : unit
        end

        module Latest : sig
          type nonrec t = t

          val to_yojson : t -> Yojson.Safe.t

          val t_of_sexp : Sexplib0.Sexp.t -> t

          val sexp_of_t : t -> Sexplib0.Sexp.t

          val bin_size_t : t Bin_prot.Size.sizer

          val bin_write_t : t Bin_prot.Write.writer

          val bin_read_t : t Bin_prot.Read.reader

          val __bin_read_t__ : (index -> t) Bin_prot.Read.reader

          val bin_shape_t : Bin_prot.Shape.t

          val bin_writer_t : t Bin_prot.Type_class.writer

          val bin_reader_t : t Bin_prot.Type_class.reader

          val bin_t : t Bin_prot.Type_class.t

          val hash_fold_t :
            Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state

          val hash : t -> Ppx_hash_lib.Std.Hash.hash_value

          val equal : t -> t -> bool

          val compare : t -> t -> index

          val __versioned__ : unit
        end
      end

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

        val counti : 'b t -> f:(key:key -> data:'b -> bool) -> index

        val count : 'b t -> f:('b -> bool) -> index

        val length : 'a t -> index

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

        val partitioni_tf :
          'b t -> f:(key:key -> data:'b -> bool) -> 'b t * 'b t

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

        type 'a merge_into_action = 'a Location.Addr.Table.merge_into_action =
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

        val incr : ?by:index -> ?remove_if_zero:bool -> index t -> key -> unit

        val decr : ?by:index -> ?remove_if_zero:bool -> index t -> key -> unit

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

             val __bin_read_t__ : (index -> key) Bin_prot.Read.reader

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

          val __bin_read_t__ : ('a, index -> 'a t) Bin_prot.Read.reader1

          val bin_writer_t : ('a, 'a t) Bin_prot.Type_class.S1.writer

          val bin_reader_t : ('a, 'a t) Bin_prot.Type_class.S1.reader

          val bin_t : ('a, 'a t) Bin_prot.Type_class.S1.t
        end

        val t_of_sexp :
             (Ppx_sexp_conv_lib.Sexp.t -> 'v_x__002_)
          -> Ppx_sexp_conv_lib.Sexp.t
          -> 'v_x__002_ t

        val bin_shape_t : Bin_prot.Shape.t -> Bin_prot.Shape.t

        val bin_size_t : ('a, 'a t) Bin_prot.Size.sizer1

        val bin_write_t : ('a, 'a t) Bin_prot.Write.writer1

        val bin_read_t : ('a, 'a t) Bin_prot.Read.reader1

        val __bin_read_t__ : ('a, index -> 'a t) Bin_prot.Read.reader1

        val bin_writer_t : ('a, 'a t) Bin_prot.Type_class.S1.writer

        val bin_reader_t : ('a, 'a t) Bin_prot.Type_class.S1.reader

        val bin_t : ('a, 'a t) Bin_prot.Type_class.S1.t
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

             val __bin_read_t__ : (index -> elt) Bin_prot.Read.reader

             val bin_shape_t : Bin_prot.Shape.t

             val bin_writer_t : elt Bin_prot.Type_class.writer

             val bin_reader_t : elt Bin_prot.Type_class.reader

             val bin_t : elt Bin_prot.Type_class.t
           end)
          -> sig
          val bin_size_t : t Bin_prot.Size.sizer

          val bin_write_t : t Bin_prot.Write.writer

          val bin_read_t : t Bin_prot.Read.reader

          val __bin_read_t__ : (index -> t) Bin_prot.Read.reader

          val bin_shape_t : Bin_prot.Shape.t

          val bin_writer_t : t Bin_prot.Type_class.writer

          val bin_reader_t : t Bin_prot.Type_class.reader

          val bin_t : t Bin_prot.Type_class.t
        end

        val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> t

        val bin_size_t : t Bin_prot.Size.sizer

        val bin_write_t : t Bin_prot.Write.writer

        val bin_read_t : t Bin_prot.Read.reader

        val __bin_read_t__ : (index -> t) Bin_prot.Read.reader

        val bin_shape_t : Bin_prot.Shape.t

        val bin_writer_t : t Bin_prot.Type_class.writer

        val bin_reader_t : t Bin_prot.Type_class.reader

        val bin_t : t Bin_prot.Type_class.t
      end

      module Hash_queue : sig
        type key = t

        val length : ('a, 'b) Core_kernel__.Hash_queue.t -> index

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

        val exists :
          ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> bool) -> bool

        val for_all :
          ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> bool) -> bool

        val count :
          ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> bool) -> index

        val sum :
             (module Base__.Container_intf.Summable with type t = 'sum)
          -> ('b, 'a) Core_kernel__.Hash_queue.t
          -> f:('a -> 'sum)
          -> 'sum

        val find :
          ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> bool) -> 'a option

        val find_map :
             ('c, 'a) Core_kernel__.Hash_queue.t
          -> f:('a -> 'b option)
          -> 'b option

        val to_list : ('b, 'a) Core_kernel__.Hash_queue.t -> 'a list

        val to_array : ('b, 'a) Core_kernel__.Hash_queue.t -> 'a array

        val min_elt :
             ('b, 'a) Core_kernel__.Hash_queue.t
          -> compare:('a -> 'a -> index)
          -> 'a option

        val max_elt :
             ('b, 'a) Core_kernel__.Hash_queue.t
          -> compare:('a -> 'a -> index)
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

        val lookup_exn :
          ('key, 'data) Core_kernel__.Hash_queue.t -> 'key -> 'data

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
             ('key, 'data) Core_kernel__.Hash_queue.t
          -> 'key Core_kernel__.Import.list

        val dequeue :
             ('key, 'data) Core_kernel__.Hash_queue.t
          -> [ `back | `front ]
          -> 'data Core_kernel__.Import.option

        val dequeue_exn :
             ('key, 'data) Core_kernel__.Hash_queue.t
          -> [ `back | `front ]
          -> 'data

        val dequeue_back :
             ('key, 'data) Core_kernel__.Hash_queue.t
          -> 'data Core_kernel__.Import.option

        val dequeue_back_exn : ('key, 'data) Core_kernel__.Hash_queue.t -> 'data

        val dequeue_front :
             ('key, 'data) Core_kernel__.Hash_queue.t
          -> 'data Core_kernel__.Import.option

        val dequeue_front_exn :
          ('key, 'data) Core_kernel__.Hash_queue.t -> 'data

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
             ('key, 'data) Core_kernel__.Hash_queue.t
          -> 'key
          -> [ `No_such_key | `Ok ]

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
             ('data -> Ppx_sexp_conv_lib.Sexp.t)
          -> 'data t
          -> Ppx_sexp_conv_lib.Sexp.t
      end

      val of_byte_string : string -> t

      val of_directions : Direction.t list -> t

      val root : unit -> t

      val slice : t -> index -> index -> t

      val get : t -> index -> index

      val copy : t -> t

      val parent : t -> t Core_kernel.Or_error.t

      val child :
        ledger_depth:index -> t -> Direction.t -> t Core_kernel.Or_error.t

      val child_exn : ledger_depth:index -> t -> Direction.t -> t

      val parent_exn : t -> t

      val dirs_from_root : t -> Direction.t list

      val sibling : t -> t

      val next : t -> t Core_kernel.Option.t

      val prev : t -> t Core_kernel.Option.t

      val is_leaf : ledger_depth:index -> t -> bool

      val is_parent_of : t -> maybe_child:t -> bool

      val serialize : ledger_depth:index -> t -> Core_kernel.Bigstring.t

      val to_string : t -> string

      val pp : Format.formatter -> t -> unit

      module Range : sig
        type nonrec t = t * t

        val fold :
             ?stop:[ `Exclusive | `Inclusive ]
          -> t
          -> init:'a
          -> f:(Table.key -> 'a -> 'a)
          -> 'a

        val subtree_range : ledger_depth:index -> Table.key -> t

        val subtree_range_seq :
          ledger_depth:index -> Table.key -> Table.key Core_kernel.Sequence.t
      end

      val depth : t -> index

      val height : ledger_depth:index -> t -> index

      val to_int : t -> index

      val of_int_exn : ledger_depth:index -> index -> t
    end

    module Path : sig
      type elem = [ `Left of hash | `Right of hash ]

      val sexp_of_elem : elem -> Ppx_sexp_conv_lib.Sexp.t

      val elem_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> elem

      val __elem_of_sexp__ : Ppx_sexp_conv_lib.Sexp.t -> elem

      val equal_elem : elem -> elem -> bool

      val elem_hash : elem -> hash

      type t = elem list

      val t_of_sexp : Sexplib0.Sexp.t -> t

      val sexp_of_t : t -> Sexplib0.Sexp.t

      val equal : t -> t -> bool

      val implied_root : t -> hash -> hash

      val check_path : t -> hash -> hash -> bool
    end

    module Location : sig
      module Addr : sig
        type t = Addr.t

        val to_yojson : t -> Yojson.Safe.t

        val t_of_sexp : Sexplib0.Sexp.t -> t

        val sexp_of_t : t -> Sexplib0.Sexp.t

        val equal : t -> t -> bool

        val compare : t -> t -> index

        module Stable : sig
          module V1 : sig
            type nonrec t = t

            val to_yojson : t -> Yojson.Safe.t

            val t_of_sexp : Sexplib0.Sexp.t -> t

            val sexp_of_t : t -> Sexplib0.Sexp.t

            val bin_size_t : t Bin_prot.Size.sizer

            val bin_write_t : t Bin_prot.Write.writer

            val bin_read_t : t Bin_prot.Read.reader

            val __bin_read_t__ : (index -> t) Bin_prot.Read.reader

            val bin_shape_t : Bin_prot.Shape.t

            val bin_writer_t : t Bin_prot.Type_class.writer

            val bin_reader_t : t Bin_prot.Type_class.reader

            val bin_t : t Bin_prot.Type_class.t

            val hash_fold_t :
              Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state

            val hash : t -> Ppx_hash_lib.Std.Hash.hash_value

            val equal : t -> t -> bool

            val compare : t -> t -> index

            val __versioned__ : unit
          end

          module Latest : sig
            type nonrec t = t

            val to_yojson : t -> Yojson.Safe.t

            val t_of_sexp : Sexplib0.Sexp.t -> t

            val sexp_of_t : t -> Sexplib0.Sexp.t

            val bin_size_t : t Bin_prot.Size.sizer

            val bin_write_t : t Bin_prot.Write.writer

            val bin_read_t : t Bin_prot.Read.reader

            val __bin_read_t__ : (index -> t) Bin_prot.Read.reader

            val bin_shape_t : Bin_prot.Shape.t

            val bin_writer_t : t Bin_prot.Type_class.writer

            val bin_reader_t : t Bin_prot.Type_class.reader

            val bin_t : t Bin_prot.Type_class.t

            val hash_fold_t :
              Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state

            val hash : t -> Ppx_hash_lib.Std.Hash.hash_value

            val equal : t -> t -> bool

            val compare : t -> t -> index

            val __versioned__ : unit
          end
        end

        val hash_fold_t :
          Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state

        val hash : t -> Ppx_hash_lib.Std.Hash.hash_value

        val hashable : t Core_kernel__.Hashtbl.Hashable.t

        module Table : sig
          type key = t

          type ('a, 'b) hashtbl = ('a, 'b) Addr.Table.hashtbl

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
            , (key * 'b) list -> [ `Duplicate_keys of key list | `Ok of 'b t ]
            )
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

          val counti : 'b t -> f:(key:key -> data:'b -> bool) -> index

          val count : 'b t -> f:('b -> bool) -> index

          val length : 'a t -> index

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

          val partitioni_tf :
            'b t -> f:(key:key -> data:'b -> bool) -> 'b t * 'b t

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

          type 'a merge_into_action = 'a Addr.Table.merge_into_action =
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

          val incr : ?by:index -> ?remove_if_zero:bool -> index t -> key -> unit

          val decr : ?by:index -> ?remove_if_zero:bool -> index t -> key -> unit

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

               val __bin_read_t__ : (index -> key) Bin_prot.Read.reader

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

            val __bin_read_t__ : ('a, index -> 'a t) Bin_prot.Read.reader1

            val bin_writer_t : ('a, 'a t) Bin_prot.Type_class.S1.writer

            val bin_reader_t : ('a, 'a t) Bin_prot.Type_class.S1.reader

            val bin_t : ('a, 'a t) Bin_prot.Type_class.S1.t
          end

          val t_of_sexp :
               (Ppx_sexp_conv_lib.Sexp.t -> 'v_x__002_)
            -> Ppx_sexp_conv_lib.Sexp.t
            -> 'v_x__002_ t

          val bin_shape_t : Bin_prot.Shape.t -> Bin_prot.Shape.t

          val bin_size_t : ('a, 'a t) Bin_prot.Size.sizer1

          val bin_write_t : ('a, 'a t) Bin_prot.Write.writer1

          val bin_read_t : ('a, 'a t) Bin_prot.Read.reader1

          val __bin_read_t__ : ('a, index -> 'a t) Bin_prot.Read.reader1

          val bin_writer_t : ('a, 'a t) Bin_prot.Type_class.S1.writer

          val bin_reader_t : ('a, 'a t) Bin_prot.Type_class.S1.reader

          val bin_t : ('a, 'a t) Bin_prot.Type_class.S1.t
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
            Core_kernel__.Hash_set_intf
            .create_options_without_first_class_module

          val of_list :
            ( 'a
            , elt list -> t )
            Core_kernel__.Hash_set_intf
            .create_options_without_first_class_module

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

               val __bin_read_t__ : (index -> elt) Bin_prot.Read.reader

               val bin_shape_t : Bin_prot.Shape.t

               val bin_writer_t : elt Bin_prot.Type_class.writer

               val bin_reader_t : elt Bin_prot.Type_class.reader

               val bin_t : elt Bin_prot.Type_class.t
             end)
            -> sig
            val bin_size_t : t Bin_prot.Size.sizer

            val bin_write_t : t Bin_prot.Write.writer

            val bin_read_t : t Bin_prot.Read.reader

            val __bin_read_t__ : (index -> t) Bin_prot.Read.reader

            val bin_shape_t : Bin_prot.Shape.t

            val bin_writer_t : t Bin_prot.Type_class.writer

            val bin_reader_t : t Bin_prot.Type_class.reader

            val bin_t : t Bin_prot.Type_class.t
          end

          val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> t

          val bin_size_t : t Bin_prot.Size.sizer

          val bin_write_t : t Bin_prot.Write.writer

          val bin_read_t : t Bin_prot.Read.reader

          val __bin_read_t__ : (index -> t) Bin_prot.Read.reader

          val bin_shape_t : Bin_prot.Shape.t

          val bin_writer_t : t Bin_prot.Type_class.writer

          val bin_reader_t : t Bin_prot.Type_class.reader

          val bin_t : t Bin_prot.Type_class.t
        end

        module Hash_queue : sig
          type key = t

          val length : ('a, 'b) Core_kernel__.Hash_queue.t -> index

          val is_empty : ('a, 'b) Core_kernel__.Hash_queue.t -> bool

          val iter :
            ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> unit) -> unit

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

          val exists :
            ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> bool) -> bool

          val for_all :
            ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> bool) -> bool

          val count :
            ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> bool) -> index

          val sum :
               (module Base__.Container_intf.Summable with type t = 'sum)
            -> ('b, 'a) Core_kernel__.Hash_queue.t
            -> f:('a -> 'sum)
            -> 'sum

          val find :
            ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> bool) -> 'a option

          val find_map :
               ('c, 'a) Core_kernel__.Hash_queue.t
            -> f:('a -> 'b option)
            -> 'b option

          val to_list : ('b, 'a) Core_kernel__.Hash_queue.t -> 'a list

          val to_array : ('b, 'a) Core_kernel__.Hash_queue.t -> 'a array

          val min_elt :
               ('b, 'a) Core_kernel__.Hash_queue.t
            -> compare:('a -> 'a -> index)
            -> 'a option

          val max_elt :
               ('b, 'a) Core_kernel__.Hash_queue.t
            -> compare:('a -> 'a -> index)
            -> 'a option

          val invariant :
               ('key, 'data) Core_kernel__.Hash_queue.t
            -> Core_kernel__.Import.unit

          val create :
               ?growth_allowed:Core_kernel__.Import.bool
            -> ?size:Core_kernel__.Import.int
            -> Core_kernel__.Import.unit
            -> (t, 'data) Core_kernel__.Hash_queue.t

          val clear :
               ('key, 'data) Core_kernel__.Hash_queue.t
            -> Core_kernel__.Import.unit

          val mem :
               ('key, 'data) Core_kernel__.Hash_queue.t
            -> 'key
            -> Core_kernel__.Import.bool

          val lookup :
               ('key, 'data) Core_kernel__.Hash_queue.t
            -> 'key
            -> 'data Core_kernel__.Import.option

          val lookup_exn :
            ('key, 'data) Core_kernel__.Hash_queue.t -> 'key -> 'data

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
               ('key, 'data) Core_kernel__.Hash_queue.t
            -> 'key Core_kernel__.Import.list

          val dequeue :
               ('key, 'data) Core_kernel__.Hash_queue.t
            -> [ `back | `front ]
            -> 'data Core_kernel__.Import.option

          val dequeue_exn :
               ('key, 'data) Core_kernel__.Hash_queue.t
            -> [ `back | `front ]
            -> 'data

          val dequeue_back :
               ('key, 'data) Core_kernel__.Hash_queue.t
            -> 'data Core_kernel__.Import.option

          val dequeue_back_exn :
            ('key, 'data) Core_kernel__.Hash_queue.t -> 'data

          val dequeue_front :
               ('key, 'data) Core_kernel__.Hash_queue.t
            -> 'data Core_kernel__.Import.option

          val dequeue_front_exn :
            ('key, 'data) Core_kernel__.Hash_queue.t -> 'data

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
               ('key, 'data) Core_kernel__.Hash_queue.t
            -> 'key
            -> [ `No_such_key | `Ok ]

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
               ('data -> Ppx_sexp_conv_lib.Sexp.t)
            -> 'data t
            -> Ppx_sexp_conv_lib.Sexp.t
        end

        val of_byte_string : string -> t

        val of_directions : Direction.t list -> t

        val root : unit -> t

        val slice : t -> index -> index -> t

        val get : t -> index -> index

        val copy : t -> t

        val parent : t -> t Core_kernel.Or_error.t

        val child :
          ledger_depth:index -> t -> Direction.t -> t Core_kernel.Or_error.t

        val child_exn : ledger_depth:index -> t -> Direction.t -> t

        val parent_exn : t -> t

        val dirs_from_root : t -> Direction.t list

        val sibling : t -> t

        val next : t -> t Core_kernel.Option.t

        val prev : t -> t Core_kernel.Option.t

        val is_leaf : ledger_depth:index -> t -> bool

        val is_parent_of : t -> maybe_child:t -> bool

        val serialize : ledger_depth:index -> t -> Core_kernel.Bigstring.t

        val to_string : t -> string

        val pp : Format.formatter -> t -> unit

        module Range : sig
          type nonrec t = t * t

          val fold :
               ?stop:[ `Exclusive | `Inclusive ]
            -> t
            -> init:'a
            -> f:(Table.key -> 'a -> 'a)
            -> 'a

          val subtree_range : ledger_depth:index -> Table.key -> t

          val subtree_range_seq :
            ledger_depth:index -> Table.key -> Table.key Core_kernel.Sequence.t
        end

        val depth : t -> index

        val height : ledger_depth:index -> t -> index

        val to_int : t -> index

        val of_int_exn : ledger_depth:index -> index -> t
      end

      module Prefix : sig
        val generic : Unsigned.UInt8.t

        val account : Unsigned.UInt8.t

        val hash : ledger_depth:index -> index -> Unsigned.UInt8.t
      end

      type t = Location.t =
        | Generic of Core.Bigstring.t
        | Account of Addr.t
        | Hash of Addr.t

      val t_of_sexp : Sexplib0.Sexp.t -> t

      val sexp_of_t : t -> Sexplib0.Sexp.t

      val hash_fold_t :
        Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state

      val hash : t -> Ppx_hash_lib.Std.Hash.hash_value

      val is_generic : t -> bool

      val is_account : t -> bool

      val is_hash : t -> bool

      val height : ledger_depth:index -> t -> index

      val root_hash : t

      val last_direction : Addr.t -> Direction.t

      val build_generic : Core.Bigstring.t -> t

      val parse :
        ledger_depth:index -> Core.Bigstring.t -> (t, unit) Core.Result.t

      val prefix_bigstring :
        Unsigned.UInt8.t -> Core.Bigstring.t -> Core.Bigstring.t

      val to_path_exn : t -> Addr.t

      val serialize : ledger_depth:index -> t -> Core.Bigstring.t

      val parent : t -> t

      val next : t -> t Core.Option.t

      val prev : t -> t Core.Option.t

      val sibling : t -> t

      val order_siblings : t -> 'a -> 'a -> 'a * 'a

      val ( >= ) : t -> t -> bool

      val ( <= ) : t -> t -> bool

      val ( = ) : t -> t -> bool

      val ( > ) : t -> t -> bool

      val ( < ) : t -> t -> bool

      val ( <> ) : t -> t -> bool

      val equal : t -> t -> bool

      val compare : t -> t -> index

      val min : t -> t -> t

      val max : t -> t -> t

      val ascending : t -> t -> index

      val descending : t -> t -> index

      val between : t -> low:t -> high:t -> bool

      val clamp_exn : t -> min:t -> max:t -> t

      val clamp : t -> min:t -> max:t -> t Base__.Or_error.t

      type comparator_witness = Location.comparator_witness

      val comparator : (t, comparator_witness) Base__.Comparator.comparator

      val validate_lbound :
        min:t Base__.Maybe_bound.t -> t Base__.Validate.check

      val validate_ubound :
        max:t Base__.Maybe_bound.t -> t Base__.Validate.check

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

        val compare : t -> t -> index

        val min : t -> t -> t

        val max : t -> t -> t
      end

      module Map : sig
        module Key : sig
          type t = Location.t

          val t_of_sexp : Sexplib0.Sexp.t -> t

          val sexp_of_t : t -> Sexplib0.Sexp.t

          type comparator_witness = Location.comparator_witness

          val comparator :
            (t, comparator_witness) Core_kernel__.Comparator.comparator
        end

        module Tree : sig
          type 'a t =
            (Key.t, 'a, comparator_witness) Core_kernel__.Map_intf.Tree.t

          val empty : 'a t

          val singleton : Key.t -> 'a -> 'a t

          val of_alist :
            (Key.t * 'a) list -> [ `Duplicate_key of Key.t | `Ok of 'a t ]

          val of_alist_or_error : (Key.t * 'a) list -> 'a t Base__.Or_error.t

          val of_alist_exn : (Key.t * 'a) list -> 'a t

          val of_alist_multi : (Key.t * 'a) list -> 'a list t

          val of_alist_fold :
            (Key.t * 'a) list -> init:'b -> f:('b -> 'a -> 'b) -> 'b t

          val of_alist_reduce : (Key.t * 'a) list -> f:('a -> 'a -> 'a) -> 'a t

          val of_sorted_array : (Key.t * 'a) array -> 'a t Base__.Or_error.t

          val of_sorted_array_unchecked : (Key.t * 'a) array -> 'a t

          val of_increasing_iterator_unchecked :
            len:index -> f:(index -> Key.t * 'a) -> 'a t

          val of_increasing_sequence :
            (Key.t * 'a) Base__.Sequence.t -> 'a t Base__.Or_error.t

          val of_sequence :
               (Key.t * 'a) Base__.Sequence.t
            -> [ `Duplicate_key of Key.t | `Ok of 'a t ]

          val of_sequence_or_error :
            (Key.t * 'a) Base__.Sequence.t -> 'a t Base__.Or_error.t

          val of_sequence_exn : (Key.t * 'a) Base__.Sequence.t -> 'a t

          val of_sequence_multi : (Key.t * 'a) Base__.Sequence.t -> 'a list t

          val of_sequence_fold :
               (Key.t * 'a) Base__.Sequence.t
            -> init:'b
            -> f:('b -> 'a -> 'b)
            -> 'b t

          val of_sequence_reduce :
            (Key.t * 'a) Base__.Sequence.t -> f:('a -> 'a -> 'a) -> 'a t

          val of_iteri :
               iteri:(f:(key:Key.t -> data:'v -> unit) -> unit)
            -> [ `Duplicate_key of Key.t | `Ok of 'v t ]

          val of_tree : 'a t -> 'a t

          val of_hashtbl_exn : (Key.t, 'a) Addr.Table.hashtbl -> 'a t

          val of_key_set :
            (Key.t, comparator_witness) Base.Set.t -> f:(Key.t -> 'v) -> 'v t

          val quickcheck_generator :
               Key.t Core_kernel__.Quickcheck.Generator.t
            -> 'a Core_kernel__.Quickcheck.Generator.t
            -> 'a t Core_kernel__.Quickcheck.Generator.t

          val invariants : 'a t -> bool

          val is_empty : 'a t -> bool

          val length : 'a t -> index

          val add :
            'a t -> key:Key.t -> data:'a -> 'a t Base__.Map_intf.Or_duplicate.t

          val add_exn : 'a t -> key:Key.t -> data:'a -> 'a t

          val set : 'a t -> key:Key.t -> data:'a -> 'a t

          val add_multi : 'a list t -> key:Key.t -> data:'a -> 'a list t

          val remove_multi : 'a list t -> Key.t -> 'a list t

          val find_multi : 'a list t -> Key.t -> 'a list

          val change : 'a t -> Key.t -> f:('a option -> 'a option) -> 'a t

          val update : 'a t -> Key.t -> f:('a option -> 'a) -> 'a t

          val find : 'a t -> Key.t -> 'a option

          val find_exn : 'a t -> Key.t -> 'a

          val remove : 'a t -> Key.t -> 'a t

          val mem : 'a t -> Key.t -> bool

          val iter_keys : 'a t -> f:(Key.t -> unit) -> unit

          val iter : 'a t -> f:('a -> unit) -> unit

          val iteri : 'a t -> f:(key:Key.t -> data:'a -> unit) -> unit

          val iteri_until :
               'a t
            -> f:(key:Key.t -> data:'a -> Base__.Map_intf.Continue_or_stop.t)
            -> Base__.Map_intf.Finished_or_unfinished.t

          val iter2 :
               'a t
            -> 'b t
            -> f:
                 (   key:Key.t
                  -> data:[ `Both of 'a * 'b | `Left of 'a | `Right of 'b ]
                  -> unit)
            -> unit

          val map : 'a t -> f:('a -> 'b) -> 'b t

          val mapi : 'a t -> f:(key:Key.t -> data:'a -> 'b) -> 'b t

          val fold :
            'a t -> init:'b -> f:(key:Key.t -> data:'a -> 'b -> 'b) -> 'b

          val fold_right :
            'a t -> init:'b -> f:(key:Key.t -> data:'a -> 'b -> 'b) -> 'b

          val fold2 :
               'a t
            -> 'b t
            -> init:'c
            -> f:
                 (   key:Key.t
                  -> data:[ `Both of 'a * 'b | `Left of 'a | `Right of 'b ]
                  -> 'c
                  -> 'c)
            -> 'c

          val filter_keys : 'a t -> f:(Key.t -> bool) -> 'a t

          val filter : 'a t -> f:('a -> bool) -> 'a t

          val filteri : 'a t -> f:(key:Key.t -> data:'a -> bool) -> 'a t

          val filter_map : 'a t -> f:('a -> 'b option) -> 'b t

          val filter_mapi :
            'a t -> f:(key:Key.t -> data:'a -> 'b option) -> 'b t

          val partition_mapi :
               'a t
            -> f:(key:Key.t -> data:'a -> [ `Fst of 'b | `Snd of 'c ])
            -> 'b t * 'c t

          val partition_map :
            'a t -> f:('a -> [ `Fst of 'b | `Snd of 'c ]) -> 'b t * 'c t

          val partitioni_tf :
            'a t -> f:(key:Key.t -> data:'a -> bool) -> 'a t * 'a t

          val partition_tf : 'a t -> f:('a -> bool) -> 'a t * 'a t

          val compare_direct : ('a -> 'a -> index) -> 'a t -> 'a t -> index

          val equal : ('a -> 'a -> bool) -> 'a t -> 'a t -> bool

          val keys : 'a t -> Key.t list

          val data : 'a t -> 'a list

          val to_alist :
               ?key_order:[ `Decreasing | `Increasing ]
            -> 'a t
            -> (Key.t * 'a) list

          val validate :
               name:(Key.t -> string)
            -> 'a Base__.Validate.check
            -> 'a t Base__.Validate.check

          val merge :
               'a t
            -> 'b t
            -> f:
                 (   key:Key.t
                  -> [ `Both of 'a * 'b | `Left of 'a | `Right of 'b ]
                  -> 'c option)
            -> 'c t

          val symmetric_diff :
               'a t
            -> 'a t
            -> data_equal:('a -> 'a -> bool)
            -> (Key.t, 'a) Base__.Map_intf.Symmetric_diff_element.t
               Base__.Sequence.t

          val fold_symmetric_diff :
               'a t
            -> 'a t
            -> data_equal:('a -> 'a -> bool)
            -> init:'c
            -> f:
                 (   'c
                  -> (Key.t, 'a) Base__.Map_intf.Symmetric_diff_element.t
                  -> 'c)
            -> 'c

          val min_elt : 'a t -> (Key.t * 'a) option

          val min_elt_exn : 'a t -> Key.t * 'a

          val max_elt : 'a t -> (Key.t * 'a) option

          val max_elt_exn : 'a t -> Key.t * 'a

          val for_all : 'a t -> f:('a -> bool) -> bool

          val for_alli : 'a t -> f:(key:Key.t -> data:'a -> bool) -> bool

          val exists : 'a t -> f:('a -> bool) -> bool

          val existsi : 'a t -> f:(key:Key.t -> data:'a -> bool) -> bool

          val count : 'a t -> f:('a -> bool) -> index

          val counti : 'a t -> f:(key:Key.t -> data:'a -> bool) -> index

          val split : 'a t -> Key.t -> 'a t * (Key.t * 'a) option * 'a t

          val append :
               lower_part:'a t
            -> upper_part:'a t
            -> [ `Ok of 'a t | `Overlapping_key_ranges ]

          val subrange :
               'a t
            -> lower_bound:Key.t Base__.Maybe_bound.t
            -> upper_bound:Key.t Base__.Maybe_bound.t
            -> 'a t

          val fold_range_inclusive :
               'a t
            -> min:Key.t
            -> max:Key.t
            -> init:'b
            -> f:(key:Key.t -> data:'a -> 'b -> 'b)
            -> 'b

          val range_to_alist :
            'a t -> min:Key.t -> max:Key.t -> (Key.t * 'a) list

          val closest_key :
               'a t
            -> [ `Greater_or_equal_to
               | `Greater_than
               | `Less_or_equal_to
               | `Less_than ]
            -> Key.t
            -> (Key.t * 'a) option

          val nth : 'a t -> index -> (Key.t * 'a) option

          val nth_exn : 'a t -> index -> Key.t * 'a

          val rank : 'a t -> Key.t -> index option

          val to_tree : 'a t -> 'a t

          val to_sequence :
               ?order:[ `Decreasing_key | `Increasing_key ]
            -> ?keys_greater_or_equal_to:Key.t
            -> ?keys_less_or_equal_to:Key.t
            -> 'a t
            -> (Key.t * 'a) Base__.Sequence.t

          val binary_search :
               'a t
            -> compare:(key:Key.t -> data:'a -> 'key -> index)
            -> [ `First_equal_to
               | `First_greater_than_or_equal_to
               | `First_strictly_greater_than
               | `Last_equal_to
               | `Last_less_than_or_equal_to
               | `Last_strictly_less_than ]
            -> 'key
            -> (Key.t * 'a) option

          val binary_search_segmented :
               'a t
            -> segment_of:(key:Key.t -> data:'a -> [ `Left | `Right ])
            -> [ `First_on_right | `Last_on_left ]
            -> (Key.t * 'a) option

          val key_set : 'a t -> (Key.t, comparator_witness) Base.Set.t

          val quickcheck_observer :
               Key.t Core_kernel__.Quickcheck.Observer.t
            -> 'v Core_kernel__.Quickcheck.Observer.t
            -> 'v t Core_kernel__.Quickcheck.Observer.t

          val quickcheck_shrinker :
               Key.t Core_kernel__.Quickcheck.Shrinker.t
            -> 'v Core_kernel__.Quickcheck.Shrinker.t
            -> 'v t Core_kernel__.Quickcheck.Shrinker.t

          module Provide_of_sexp : functor
            (K : sig
               val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> Key.t
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

        type 'a t = (Key.t, 'a, comparator_witness) Core_kernel__.Map_intf.Map.t

        val compare :
             ('a -> 'a -> Core_kernel__.Import.int)
          -> 'a t
          -> 'a t
          -> Core_kernel__.Import.int

        val empty : 'a t

        val singleton : Key.t -> 'a -> 'a t

        val of_alist :
          (Key.t * 'a) list -> [ `Duplicate_key of Key.t | `Ok of 'a t ]

        val of_alist_or_error : (Key.t * 'a) list -> 'a t Base__.Or_error.t

        val of_alist_exn : (Key.t * 'a) list -> 'a t

        val of_alist_multi : (Key.t * 'a) list -> 'a list t

        val of_alist_fold :
          (Key.t * 'a) list -> init:'b -> f:('b -> 'a -> 'b) -> 'b t

        val of_alist_reduce : (Key.t * 'a) list -> f:('a -> 'a -> 'a) -> 'a t

        val of_sorted_array : (Key.t * 'a) array -> 'a t Base__.Or_error.t

        val of_sorted_array_unchecked : (Key.t * 'a) array -> 'a t

        val of_increasing_iterator_unchecked :
          len:index -> f:(index -> Key.t * 'a) -> 'a t

        val of_increasing_sequence :
          (Key.t * 'a) Base__.Sequence.t -> 'a t Base__.Or_error.t

        val of_sequence :
             (Key.t * 'a) Base__.Sequence.t
          -> [ `Duplicate_key of Key.t | `Ok of 'a t ]

        val of_sequence_or_error :
          (Key.t * 'a) Base__.Sequence.t -> 'a t Base__.Or_error.t

        val of_sequence_exn : (Key.t * 'a) Base__.Sequence.t -> 'a t

        val of_sequence_multi : (Key.t * 'a) Base__.Sequence.t -> 'a list t

        val of_sequence_fold :
             (Key.t * 'a) Base__.Sequence.t
          -> init:'b
          -> f:('b -> 'a -> 'b)
          -> 'b t

        val of_sequence_reduce :
          (Key.t * 'a) Base__.Sequence.t -> f:('a -> 'a -> 'a) -> 'a t

        val of_iteri :
             iteri:(f:(key:Key.t -> data:'v -> unit) -> unit)
          -> [ `Duplicate_key of Key.t | `Ok of 'v t ]

        val of_tree : 'a Tree.t -> 'a t

        val of_hashtbl_exn : (Key.t, 'a) Addr.Table.hashtbl -> 'a t

        val of_key_set :
          (Key.t, comparator_witness) Base.Set.t -> f:(Key.t -> 'v) -> 'v t

        val quickcheck_generator :
             Key.t Core_kernel__.Quickcheck.Generator.t
          -> 'a Core_kernel__.Quickcheck.Generator.t
          -> 'a t Core_kernel__.Quickcheck.Generator.t

        val invariants : 'a t -> bool

        val is_empty : 'a t -> bool

        val length : 'a t -> index

        val add :
          'a t -> key:Key.t -> data:'a -> 'a t Base__.Map_intf.Or_duplicate.t

        val add_exn : 'a t -> key:Key.t -> data:'a -> 'a t

        val set : 'a t -> key:Key.t -> data:'a -> 'a t

        val add_multi : 'a list t -> key:Key.t -> data:'a -> 'a list t

        val remove_multi : 'a list t -> Key.t -> 'a list t

        val find_multi : 'a list t -> Key.t -> 'a list

        val change : 'a t -> Key.t -> f:('a option -> 'a option) -> 'a t

        val update : 'a t -> Key.t -> f:('a option -> 'a) -> 'a t

        val find : 'a t -> Key.t -> 'a option

        val find_exn : 'a t -> Key.t -> 'a

        val remove : 'a t -> Key.t -> 'a t

        val mem : 'a t -> Key.t -> bool

        val iter_keys : 'a t -> f:(Key.t -> unit) -> unit

        val iter : 'a t -> f:('a -> unit) -> unit

        val iteri : 'a t -> f:(key:Key.t -> data:'a -> unit) -> unit

        val iteri_until :
             'a t
          -> f:(key:Key.t -> data:'a -> Base__.Map_intf.Continue_or_stop.t)
          -> Base__.Map_intf.Finished_or_unfinished.t

        val iter2 :
             'a t
          -> 'b t
          -> f:
               (   key:Key.t
                -> data:[ `Both of 'a * 'b | `Left of 'a | `Right of 'b ]
                -> unit)
          -> unit

        val map : 'a t -> f:('a -> 'b) -> 'b t

        val mapi : 'a t -> f:(key:Key.t -> data:'a -> 'b) -> 'b t

        val fold : 'a t -> init:'b -> f:(key:Key.t -> data:'a -> 'b -> 'b) -> 'b

        val fold_right :
          'a t -> init:'b -> f:(key:Key.t -> data:'a -> 'b -> 'b) -> 'b

        val fold2 :
             'a t
          -> 'b t
          -> init:'c
          -> f:
               (   key:Key.t
                -> data:[ `Both of 'a * 'b | `Left of 'a | `Right of 'b ]
                -> 'c
                -> 'c)
          -> 'c

        val filter_keys : 'a t -> f:(Key.t -> bool) -> 'a t

        val filter : 'a t -> f:('a -> bool) -> 'a t

        val filteri : 'a t -> f:(key:Key.t -> data:'a -> bool) -> 'a t

        val filter_map : 'a t -> f:('a -> 'b option) -> 'b t

        val filter_mapi : 'a t -> f:(key:Key.t -> data:'a -> 'b option) -> 'b t

        val partition_mapi :
             'a t
          -> f:(key:Key.t -> data:'a -> [ `Fst of 'b | `Snd of 'c ])
          -> 'b t * 'c t

        val partition_map :
          'a t -> f:('a -> [ `Fst of 'b | `Snd of 'c ]) -> 'b t * 'c t

        val partitioni_tf :
          'a t -> f:(key:Key.t -> data:'a -> bool) -> 'a t * 'a t

        val partition_tf : 'a t -> f:('a -> bool) -> 'a t * 'a t

        val compare_direct : ('a -> 'a -> index) -> 'a t -> 'a t -> index

        val equal : ('a -> 'a -> bool) -> 'a t -> 'a t -> bool

        val keys : 'a t -> Key.t list

        val data : 'a t -> 'a list

        val to_alist :
          ?key_order:[ `Decreasing | `Increasing ] -> 'a t -> (Key.t * 'a) list

        val validate :
             name:(Key.t -> string)
          -> 'a Base__.Validate.check
          -> 'a t Base__.Validate.check

        val merge :
             'a t
          -> 'b t
          -> f:
               (   key:Key.t
                -> [ `Both of 'a * 'b | `Left of 'a | `Right of 'b ]
                -> 'c option)
          -> 'c t

        val symmetric_diff :
             'a t
          -> 'a t
          -> data_equal:('a -> 'a -> bool)
          -> (Key.t, 'a) Base__.Map_intf.Symmetric_diff_element.t
             Base__.Sequence.t

        val fold_symmetric_diff :
             'a t
          -> 'a t
          -> data_equal:('a -> 'a -> bool)
          -> init:'c
          -> f:
               (   'c
                -> (Key.t, 'a) Base__.Map_intf.Symmetric_diff_element.t
                -> 'c)
          -> 'c

        val min_elt : 'a t -> (Key.t * 'a) option

        val min_elt_exn : 'a t -> Key.t * 'a

        val max_elt : 'a t -> (Key.t * 'a) option

        val max_elt_exn : 'a t -> Key.t * 'a

        val for_all : 'a t -> f:('a -> bool) -> bool

        val for_alli : 'a t -> f:(key:Key.t -> data:'a -> bool) -> bool

        val exists : 'a t -> f:('a -> bool) -> bool

        val existsi : 'a t -> f:(key:Key.t -> data:'a -> bool) -> bool

        val count : 'a t -> f:('a -> bool) -> index

        val counti : 'a t -> f:(key:Key.t -> data:'a -> bool) -> index

        val split : 'a t -> Key.t -> 'a t * (Key.t * 'a) option * 'a t

        val append :
             lower_part:'a t
          -> upper_part:'a t
          -> [ `Ok of 'a t | `Overlapping_key_ranges ]

        val subrange :
             'a t
          -> lower_bound:Key.t Base__.Maybe_bound.t
          -> upper_bound:Key.t Base__.Maybe_bound.t
          -> 'a t

        val fold_range_inclusive :
             'a t
          -> min:Key.t
          -> max:Key.t
          -> init:'b
          -> f:(key:Key.t -> data:'a -> 'b -> 'b)
          -> 'b

        val range_to_alist : 'a t -> min:Key.t -> max:Key.t -> (Key.t * 'a) list

        val closest_key :
             'a t
          -> [ `Greater_or_equal_to
             | `Greater_than
             | `Less_or_equal_to
             | `Less_than ]
          -> Key.t
          -> (Key.t * 'a) option

        val nth : 'a t -> index -> (Key.t * 'a) option

        val nth_exn : 'a t -> index -> Key.t * 'a

        val rank : 'a t -> Key.t -> index option

        val to_tree : 'a t -> 'a Tree.t

        val to_sequence :
             ?order:[ `Decreasing_key | `Increasing_key ]
          -> ?keys_greater_or_equal_to:Key.t
          -> ?keys_less_or_equal_to:Key.t
          -> 'a t
          -> (Key.t * 'a) Base__.Sequence.t

        val binary_search :
             'a t
          -> compare:(key:Key.t -> data:'a -> 'key -> index)
          -> [ `First_equal_to
             | `First_greater_than_or_equal_to
             | `First_strictly_greater_than
             | `Last_equal_to
             | `Last_less_than_or_equal_to
             | `Last_strictly_less_than ]
          -> 'key
          -> (Key.t * 'a) option

        val binary_search_segmented :
             'a t
          -> segment_of:(key:Key.t -> data:'a -> [ `Left | `Right ])
          -> [ `First_on_right | `Last_on_left ]
          -> (Key.t * 'a) option

        val key_set : 'a t -> (Key.t, comparator_witness) Base.Set.t

        val quickcheck_observer :
             Key.t Core_kernel__.Quickcheck.Observer.t
          -> 'v Core_kernel__.Quickcheck.Observer.t
          -> 'v t Core_kernel__.Quickcheck.Observer.t

        val quickcheck_shrinker :
             Key.t Core_kernel__.Quickcheck.Shrinker.t
          -> 'v Core_kernel__.Quickcheck.Shrinker.t
          -> 'v t Core_kernel__.Quickcheck.Shrinker.t

        module Provide_of_sexp : functor
          (Key : sig
             val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> Key.t
           end)
          -> sig
          val t_of_sexp :
               (Ppx_sexp_conv_lib.Sexp.t -> 'v_x__002_)
            -> Ppx_sexp_conv_lib.Sexp.t
            -> 'v_x__002_ t
        end

        module Provide_bin_io : functor
          (Key : sig
             val bin_size_t : Key.t Bin_prot.Size.sizer

             val bin_write_t : Key.t Bin_prot.Write.writer

             val bin_read_t : Key.t Bin_prot.Read.reader

             val __bin_read_t__ : (index -> Key.t) Bin_prot.Read.reader

             val bin_shape_t : Bin_prot.Shape.t

             val bin_writer_t : Key.t Bin_prot.Type_class.writer

             val bin_reader_t : Key.t Bin_prot.Type_class.reader

             val bin_t : Key.t Bin_prot.Type_class.t
           end)
          -> sig
          val bin_shape_t : Bin_prot.Shape.t -> Bin_prot.Shape.t

          val bin_size_t : ('a, 'a t) Bin_prot.Size.sizer1

          val bin_write_t : ('a, 'a t) Bin_prot.Write.writer1

          val bin_read_t : ('a, 'a t) Bin_prot.Read.reader1

          val __bin_read_t__ : ('a, index -> 'a t) Bin_prot.Read.reader1

          val bin_writer_t : ('a, 'a t) Bin_prot.Type_class.S1.writer

          val bin_reader_t : ('a, 'a t) Bin_prot.Type_class.S1.reader

          val bin_t : ('a, 'a t) Bin_prot.Type_class.S1.t
        end

        module Provide_hash : functor
          (Key : sig
             val hash_fold_t : Base__.Hash.state -> Key.t -> Base__.Hash.state
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
          type t = Map.Key.t

          val t_of_sexp : Sexplib0.Sexp.t -> t

          val sexp_of_t : t -> Sexplib0.Sexp.t

          type comparator_witness = Map.Key.comparator_witness

          val comparator :
            (t, comparator_witness) Core_kernel__.Comparator.comparator
        end

        module Tree : sig
          type t = (Elt.t, comparator_witness) Core_kernel__.Set_intf.Tree.t

          val compare : t -> t -> Core_kernel__.Import.int

          type named =
            (Elt.t, comparator_witness) Core_kernel__.Set_intf.Tree.Named.t

          val length : t -> index

          val is_empty : t -> bool

          val iter : t -> f:(Elt.t -> unit) -> unit

          val fold : t -> init:'accum -> f:('accum -> Elt.t -> 'accum) -> 'accum

          val fold_result :
               t
            -> init:'accum
            -> f:('accum -> Elt.t -> ('accum, 'e) Base__.Result.t)
            -> ('accum, 'e) Base__.Result.t

          val exists : t -> f:(Elt.t -> bool) -> bool

          val for_all : t -> f:(Elt.t -> bool) -> bool

          val count : t -> f:(Elt.t -> bool) -> index

          val sum :
               (module Base__.Container_intf.Summable with type t = 'sum)
            -> t
            -> f:(Elt.t -> 'sum)
            -> 'sum

          val find : t -> f:(Elt.t -> bool) -> Elt.t option

          val find_map : t -> f:(Elt.t -> 'a option) -> 'a option

          val to_list : t -> Elt.t list

          val to_array : t -> Elt.t array

          val invariants : t -> bool

          val mem : t -> Elt.t -> bool

          val add : t -> Elt.t -> t

          val remove : t -> Elt.t -> t

          val union : t -> t -> t

          val inter : t -> t -> t

          val diff : t -> t -> t

          val symmetric_diff :
            t -> t -> (Elt.t, Elt.t) Base__.Either.t Base__.Sequence.t

          val compare_direct : t -> t -> index

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
                  -> Elt.t
                  -> ('b, 'final) Base__.Set_intf.Continue_or_stop.t)
            -> finish:('b -> 'final)
            -> 'final

          val fold_right : t -> init:'b -> f:(Elt.t -> 'b -> 'b) -> 'b

          val iter2 :
               t
            -> t
            -> f:
                 (   [ `Both of Elt.t * Elt.t
                     | `Left of Elt.t
                     | `Right of Elt.t ]
                  -> unit)
            -> unit

          val filter : t -> f:(Elt.t -> bool) -> t

          val partition_tf : t -> f:(Elt.t -> bool) -> t * t

          val elements : t -> Elt.t list

          val min_elt : t -> Elt.t option

          val min_elt_exn : t -> Elt.t

          val max_elt : t -> Elt.t option

          val max_elt_exn : t -> Elt.t

          val choose : t -> Elt.t option

          val choose_exn : t -> Elt.t

          val split : t -> Elt.t -> t * Elt.t option * t

          val group_by : t -> equiv:(Elt.t -> Elt.t -> bool) -> t list

          val find_exn : t -> f:(Elt.t -> bool) -> Elt.t

          val nth : t -> index -> Elt.t option

          val remove_index : t -> index -> t

          val to_tree : t -> t

          val to_sequence :
               ?order:[ `Decreasing | `Increasing ]
            -> ?greater_or_equal_to:Elt.t
            -> ?less_or_equal_to:Elt.t
            -> t
            -> Elt.t Base__.Sequence.t

          val binary_search :
               t
            -> compare:(Elt.t -> 'key -> index)
            -> [ `First_equal_to
               | `First_greater_than_or_equal_to
               | `First_strictly_greater_than
               | `Last_equal_to
               | `Last_less_than_or_equal_to
               | `Last_strictly_less_than ]
            -> 'key
            -> Elt.t option

          val binary_search_segmented :
               t
            -> segment_of:(Elt.t -> [ `Left | `Right ])
            -> [ `First_on_right | `Last_on_left ]
            -> Elt.t option

          val merge_to_sequence :
               ?order:[ `Decreasing | `Increasing ]
            -> ?greater_or_equal_to:Elt.t
            -> ?less_or_equal_to:Elt.t
            -> t
            -> t
            -> (Elt.t, Elt.t) Base__.Set_intf.Merge_to_sequence_element.t
               Base__.Sequence.t

          val to_map :
               t
            -> f:(Elt.t -> 'data)
            -> (Elt.t, 'data, comparator_witness) Base.Map.t

          val quickcheck_observer :
               Elt.t Core_kernel__.Quickcheck.Observer.t
            -> t Core_kernel__.Quickcheck.Observer.t

          val quickcheck_shrinker :
               Elt.t Core_kernel__.Quickcheck.Shrinker.t
            -> t Core_kernel__.Quickcheck.Shrinker.t

          val empty : t

          val singleton : Elt.t -> t

          val union_list : t list -> t

          val of_list : Elt.t list -> t

          val of_array : Elt.t array -> t

          val of_sorted_array : Elt.t array -> t Base__.Or_error.t

          val of_sorted_array_unchecked : Elt.t array -> t

          val of_increasing_iterator_unchecked :
            len:index -> f:(index -> Elt.t) -> t

          val stable_dedup_list : Elt.t list -> Elt.t list

          val map :
            ('a, 'b) Core_kernel__.Set_intf.Tree.t -> f:('a -> Elt.t) -> t

          val filter_map :
               ('a, 'b) Core_kernel__.Set_intf.Tree.t
            -> f:('a -> Elt.t option)
            -> t

          val of_tree : t -> t

          val of_hash_set : Elt.t Core_kernel__.Hash_set.t -> t

          val of_hashtbl_keys : (Elt.t, 'a) Addr.Table.hashtbl -> t

          val of_map_keys : (Elt.t, 'a, comparator_witness) Base.Map.t -> t

          val quickcheck_generator :
               Elt.t Core_kernel__.Quickcheck.Generator.t
            -> t Core_kernel__.Quickcheck.Generator.t

          module Provide_of_sexp : functor
            (Elt : sig
               val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> Elt.t
             end)
            -> sig
            val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> t
          end

          val t_of_sexp : Base__.Sexp.t -> t

          val sexp_of_t : t -> Base__.Sexp.t
        end

        type t = (Elt.t, comparator_witness) Base.Set.t

        val compare : t -> t -> Core_kernel__.Import.int

        type named = (Elt.t, comparator_witness) Core_kernel__.Set_intf.Named.t

        val length : t -> index

        val is_empty : t -> bool

        val iter : t -> f:(Elt.t -> unit) -> unit

        val fold : t -> init:'accum -> f:('accum -> Elt.t -> 'accum) -> 'accum

        val fold_result :
             t
          -> init:'accum
          -> f:('accum -> Elt.t -> ('accum, 'e) Base__.Result.t)
          -> ('accum, 'e) Base__.Result.t

        val exists : t -> f:(Elt.t -> bool) -> bool

        val for_all : t -> f:(Elt.t -> bool) -> bool

        val count : t -> f:(Elt.t -> bool) -> index

        val sum :
             (module Base__.Container_intf.Summable with type t = 'sum)
          -> t
          -> f:(Elt.t -> 'sum)
          -> 'sum

        val find : t -> f:(Elt.t -> bool) -> Elt.t option

        val find_map : t -> f:(Elt.t -> 'a option) -> 'a option

        val to_list : t -> Elt.t list

        val to_array : t -> Elt.t array

        val invariants : t -> bool

        val mem : t -> Elt.t -> bool

        val add : t -> Elt.t -> t

        val remove : t -> Elt.t -> t

        val union : t -> t -> t

        val inter : t -> t -> t

        val diff : t -> t -> t

        val symmetric_diff :
          t -> t -> (Elt.t, Elt.t) Base__.Either.t Base__.Sequence.t

        val compare_direct : t -> t -> index

        val equal : t -> t -> bool

        val is_subset : t -> of_:t -> bool

        module Named : sig
          val is_subset : named -> of_:named -> unit Base__.Or_error.t

          val equal : named -> named -> unit Base__.Or_error.t
        end

        val fold_until :
             t
          -> init:'b
          -> f:('b -> Elt.t -> ('b, 'final) Base__.Set_intf.Continue_or_stop.t)
          -> finish:('b -> 'final)
          -> 'final

        val fold_right : t -> init:'b -> f:(Elt.t -> 'b -> 'b) -> 'b

        val iter2 :
             t
          -> t
          -> f:
               (   [ `Both of Elt.t * Elt.t | `Left of Elt.t | `Right of Elt.t ]
                -> unit)
          -> unit

        val filter : t -> f:(Elt.t -> bool) -> t

        val partition_tf : t -> f:(Elt.t -> bool) -> t * t

        val elements : t -> Elt.t list

        val min_elt : t -> Elt.t option

        val min_elt_exn : t -> Elt.t

        val max_elt : t -> Elt.t option

        val max_elt_exn : t -> Elt.t

        val choose : t -> Elt.t option

        val choose_exn : t -> Elt.t

        val split : t -> Elt.t -> t * Elt.t option * t

        val group_by : t -> equiv:(Elt.t -> Elt.t -> bool) -> t list

        val find_exn : t -> f:(Elt.t -> bool) -> Elt.t

        val nth : t -> index -> Elt.t option

        val remove_index : t -> index -> t

        val to_tree : t -> Tree.t

        val to_sequence :
             ?order:[ `Decreasing | `Increasing ]
          -> ?greater_or_equal_to:Elt.t
          -> ?less_or_equal_to:Elt.t
          -> t
          -> Elt.t Base__.Sequence.t

        val binary_search :
             t
          -> compare:(Elt.t -> 'key -> index)
          -> [ `First_equal_to
             | `First_greater_than_or_equal_to
             | `First_strictly_greater_than
             | `Last_equal_to
             | `Last_less_than_or_equal_to
             | `Last_strictly_less_than ]
          -> 'key
          -> Elt.t option

        val binary_search_segmented :
             t
          -> segment_of:(Elt.t -> [ `Left | `Right ])
          -> [ `First_on_right | `Last_on_left ]
          -> Elt.t option

        val merge_to_sequence :
             ?order:[ `Decreasing | `Increasing ]
          -> ?greater_or_equal_to:Elt.t
          -> ?less_or_equal_to:Elt.t
          -> t
          -> t
          -> (Elt.t, Elt.t) Base__.Set_intf.Merge_to_sequence_element.t
             Base__.Sequence.t

        val to_map :
             t
          -> f:(Elt.t -> 'data)
          -> (Elt.t, 'data, comparator_witness) Base.Map.t

        val quickcheck_observer :
             Elt.t Core_kernel__.Quickcheck.Observer.t
          -> t Core_kernel__.Quickcheck.Observer.t

        val quickcheck_shrinker :
             Elt.t Core_kernel__.Quickcheck.Shrinker.t
          -> t Core_kernel__.Quickcheck.Shrinker.t

        val empty : t

        val singleton : Elt.t -> t

        val union_list : t list -> t

        val of_list : Elt.t list -> t

        val of_array : Elt.t array -> t

        val of_sorted_array : Elt.t array -> t Base__.Or_error.t

        val of_sorted_array_unchecked : Elt.t array -> t

        val of_increasing_iterator_unchecked :
          len:index -> f:(index -> Elt.t) -> t

        val stable_dedup_list : Elt.t list -> Elt.t list

        val map : ('a, 'b) Base.Set.t -> f:('a -> Elt.t) -> t

        val filter_map : ('a, 'b) Base.Set.t -> f:('a -> Elt.t option) -> t

        val of_tree : Tree.t -> t

        val of_hash_set : Elt.t Core_kernel__.Hash_set.t -> t

        val of_hashtbl_keys : (Elt.t, 'a) Addr.Table.hashtbl -> t

        val of_map_keys : (Elt.t, 'a, comparator_witness) Base.Map.t -> t

        val quickcheck_generator :
             Elt.t Core_kernel__.Quickcheck.Generator.t
          -> t Core_kernel__.Quickcheck.Generator.t

        module Provide_of_sexp : functor
          (Elt : sig
             val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> Elt.t
           end)
          -> sig
          val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> t
        end

        module Provide_bin_io : functor
          (Elt : sig
             val bin_size_t : Elt.t Bin_prot.Size.sizer

             val bin_write_t : Elt.t Bin_prot.Write.writer

             val bin_read_t : Elt.t Bin_prot.Read.reader

             val __bin_read_t__ : (index -> Elt.t) Bin_prot.Read.reader

             val bin_shape_t : Bin_prot.Shape.t

             val bin_writer_t : Elt.t Bin_prot.Type_class.writer

             val bin_reader_t : Elt.t Bin_prot.Type_class.reader

             val bin_t : Elt.t Bin_prot.Type_class.t
           end)
          -> sig
          val bin_size_t : t Bin_prot.Size.sizer

          val bin_write_t : t Bin_prot.Write.writer

          val bin_read_t : t Bin_prot.Read.reader

          val __bin_read_t__ : (index -> t) Bin_prot.Read.reader

          val bin_shape_t : Bin_prot.Shape.t

          val bin_writer_t : t Bin_prot.Type_class.writer

          val bin_reader_t : t Bin_prot.Type_class.reader

          val bin_t : t Bin_prot.Type_class.t
        end

        module Provide_hash : functor
          (Elt : sig
             val hash_fold_t : Base__.Hash.state -> Elt.t -> Base__.Hash.state
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

    val t_of_sexp : Sexplib0.Sexp.t -> witness

    val sexp_of_t : witness -> Sexplib0.Sexp.t

    type path = Path.t

    val depth : witness -> index

    val num_accounts : witness -> index

    val merkle_path_at_addr_exn : witness -> Addr.t -> path

    val get_inner_hash_at_addr_exn : witness -> Addr.t -> hash

    val set_inner_hash_at_addr_exn : witness -> Addr.t -> hash -> unit

    val set_all_accounts_rooted_at_exn :
      witness -> Addr.t -> account list -> unit

    val set_batch_accounts : witness -> (Addr.t * account) list -> unit

    val get_all_accounts_rooted_at_exn :
      witness -> Addr.t -> (Addr.t * account) list

    val make_space_for : witness -> index -> unit

    val to_list : witness -> account list

    val iteri : witness -> f:(index -> account -> unit) -> unit

    val foldi :
         witness
      -> init:'accum
      -> f:(Addr.t -> 'accum -> account -> 'accum)
      -> 'accum

    val foldi_with_ignored_accounts :
         witness
      -> account_id_set
      -> init:'accum
      -> f:(Addr.t -> 'accum -> account -> 'accum)
      -> 'accum

    val fold_until :
         witness
      -> init:'accum
      -> f:('accum -> account -> ('accum, 'stop) Base.Continue_or_stop.t)
      -> finish:('accum -> 'stop)
      -> 'stop

    val accounts : witness -> account_id_set

    val token_owner : witness -> token_id -> key option

    val token_owners : witness -> account_id_set

    val tokens : witness -> key -> token_id_set

    val next_available_token : witness -> token_id

    val set_next_available_token : witness -> token_id -> unit

    val location_of_account : witness -> account_id -> Location.t option

    val location_of_account_batch :
      witness -> account_id list -> (account_id * Location.t option) list

    val get_or_create_account :
         witness
      -> account_id
      -> account
      -> ([ `Added | `Existed ] * Location.t) Core.Or_error.t

    val close : witness -> unit

    val last_filled : witness -> Location.t option

    val get_uuid : witness -> Uuid.t

    val get_directory : witness -> string option

    val get : witness -> Location.t -> account option

    val get_batch :
      witness -> Location.t list -> (Location.t * account option) list

    val set : witness -> Location.t -> account -> unit

    val set_batch : witness -> (Location.t * account) list -> unit

    val get_at_index_exn : witness -> index -> account

    val set_at_index_exn : witness -> index -> account -> unit

    val index_of_account_exn : witness -> account_id -> index

    val merkle_root : witness -> hash

    val merkle_path : witness -> Location.t -> path

    val merkle_path_at_index_exn : witness -> index -> path

    val remove_accounts_exn : witness -> account_id list -> unit

    val detached_signal : witness -> unit Async.Deferred.t
  end
end

module type Inputs_intf = sig
  module Key : Intf.Key

  module Token_id : Intf.Token_id

  module Account_id : sig
    module Stable : sig
      module V1 : sig
        type t

        val bin_size_t : t Bin_prot.Size.sizer

        val bin_write_t : t Bin_prot.Write.writer

        val bin_read_t : t Bin_prot.Read.reader

        val __bin_read_t__ : (int -> t) Bin_prot.Read.reader

        val bin_shape_t : Bin_prot.Shape.t

        val bin_writer_t : t Bin_prot.Type_class.writer

        val bin_reader_t : t Bin_prot.Type_class.reader

        val bin_t : t Bin_prot.Type_class.t

        val __versioned__ : unit

        val t_of_sexp : Sexplib0.Sexp.t -> t

        val sexp_of_t : t -> Sexplib0.Sexp.t
      end

      module Latest = V1

      val versions :
        (int * (Core_kernel.Bigstring.t -> pos_ref:int Core.ref -> V1.t)) array

      val bin_read_to_latest_opt :
        Core.Bin_prot.Common.buf -> pos_ref:int Core.ref -> V1.t option
    end

    type t = Stable.V1.t

    val t_of_sexp : Sexplib0.Sexp.t -> t

    val sexp_of_t : t -> Sexplib0.Sexp.t

    val public_key : t -> Key.t

    val token_id : t -> Token_id.t

    val create : Key.t -> Token_id.t -> t

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

      type 'a merge_into_action = Remove | Set_to of 'a

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

      val bin_shape_t : Bin_prot.Shape.t -> Bin_prot.Shape.t

      val bin_size_t : ('a, 'a t) Bin_prot.Size.sizer1

      val bin_write_t : ('a, 'a t) Bin_prot.Write.writer1

      val bin_read_t : ('a, 'a t) Bin_prot.Read.reader1

      val __bin_read_t__ : ('a, int -> 'a t) Bin_prot.Read.reader1

      val bin_writer_t : ('a, 'a t) Bin_prot.Type_class.S1.writer

      val bin_reader_t : ('a, 'a t) Bin_prot.Type_class.S1.reader

      val bin_t : ('a, 'a t) Bin_prot.Type_class.S1.t
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

      val bin_size_t : t Bin_prot.Size.sizer

      val bin_write_t : t Bin_prot.Write.writer

      val bin_read_t : t Bin_prot.Read.reader

      val __bin_read_t__ : (int -> t) Bin_prot.Read.reader

      val bin_shape_t : Bin_prot.Shape.t

      val bin_writer_t : t Bin_prot.Type_class.writer

      val bin_reader_t : t Bin_prot.Type_class.reader

      val bin_t : t Bin_prot.Type_class.t
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

      val for_all :
        ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> bool) -> bool

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
           ('key, 'data) Core_kernel__.Hash_queue.t
        -> 'key Core_kernel__.Import.list

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
           ('key, 'data) Core_kernel__.Hash_queue.t
        -> 'key
        -> [ `No_such_key | `Ok ]

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
           ('data -> Ppx_sexp_conv_lib.Sexp.t)
        -> 'data t
        -> Ppx_sexp_conv_lib.Sexp.t
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

    type comparator_witness

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

        type comparator_witness_ := comparator_witness

        type comparator_witness = comparator_witness_

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

        val of_alist_reduce :
          (Table.key * 'a) list -> f:('a -> 'a -> 'a) -> 'a t

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
             'a t
          -> key:Table.key
          -> data:'a
          -> 'a t Base__.Map_intf.Or_duplicate.t

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

      type 'a t =
        (Table.key, 'a, comparator_witness) Core_kernel__.Map_intf.Map.t

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

        val fold :
          t -> init:'accum -> f:('accum -> Table.key -> 'accum) -> 'accum

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

      type named =
        (Table.key, comparator_witness) Core_kernel__.Set_intf.Named.t

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

      val of_increasing_iterator_unchecked :
        len:int -> f:(int -> Table.key) -> t

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

  module Balance : Intf.Balance

  module Account : sig
    type t

    val bin_size_t : t Bin_prot.Size.sizer

    val bin_write_t : t Bin_prot.Write.writer

    val bin_read_t : t Bin_prot.Read.reader

    val __bin_read_t__ : (int -> t) Bin_prot.Read.reader

    val bin_shape_t : Bin_prot.Shape.t

    val bin_writer_t : t Bin_prot.Type_class.writer

    val bin_reader_t : t Bin_prot.Type_class.reader

    val bin_t : t Bin_prot.Type_class.t

    val equal : t -> t -> bool

    val t_of_sexp : Sexplib0.Sexp.t -> t

    val sexp_of_t : t -> Sexplib0.Sexp.t

    val compare : t -> t -> int

    val token : t -> Token_id.t

    val identifier : t -> Account_id.t

    val balance : t -> Balance.t

    val token_owner : t -> bool

    val empty : t
  end

  module Hash : sig
    type t

    val to_yojson : t -> Yojson.Safe.t

    val of_yojson : Yojson.Safe.t -> t Ppx_deriving_yojson_runtime.error_or

    val bin_size_t : t Bin_prot.Size.sizer

    val bin_write_t : t Bin_prot.Write.writer

    val bin_read_t : t Bin_prot.Read.reader

    val __bin_read_t__ : (int -> t) Bin_prot.Read.reader

    val bin_shape_t : Bin_prot.Shape.t

    val bin_writer_t : t Bin_prot.Type_class.writer

    val bin_reader_t : t Bin_prot.Type_class.reader

    val bin_t : t Bin_prot.Type_class.t

    val compare : t -> t -> int

    val equal : t -> t -> bool

    val t_of_sexp : Sexplib0.Sexp.t -> t

    val sexp_of_t : t -> Sexplib0.Sexp.t

    val to_base58_check : t -> string

    val hash_fold_t :
      Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state

    val hash : t -> Ppx_hash_lib.Std.Hash.hash_value

    val hashable : t Core_kernel__.Hashtbl.Hashable.t

    module Table : sig
      type key = t

      type ('a, 'b) hashtbl = ('a, 'b) Account_id.Table.hashtbl

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

      type 'a merge_into_action = Remove | Set_to of 'a

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

      val bin_shape_t : Bin_prot.Shape.t -> Bin_prot.Shape.t

      val bin_size_t : ('a, 'a t) Bin_prot.Size.sizer1

      val bin_write_t : ('a, 'a t) Bin_prot.Write.writer1

      val bin_read_t : ('a, 'a t) Bin_prot.Read.reader1

      val __bin_read_t__ : ('a, int -> 'a t) Bin_prot.Read.reader1

      val bin_writer_t : ('a, 'a t) Bin_prot.Type_class.S1.writer

      val bin_reader_t : ('a, 'a t) Bin_prot.Type_class.S1.reader

      val bin_t : ('a, 'a t) Bin_prot.Type_class.S1.t
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

      val bin_size_t : t Bin_prot.Size.sizer

      val bin_write_t : t Bin_prot.Write.writer

      val bin_read_t : t Bin_prot.Read.reader

      val __bin_read_t__ : (int -> t) Bin_prot.Read.reader

      val bin_shape_t : Bin_prot.Shape.t

      val bin_writer_t : t Bin_prot.Type_class.writer

      val bin_reader_t : t Bin_prot.Type_class.reader

      val bin_t : t Bin_prot.Type_class.t
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

      val for_all :
        ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> bool) -> bool

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
           ('key, 'data) Core_kernel__.Hash_queue.t
        -> 'key Core_kernel__.Import.list

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
           ('key, 'data) Core_kernel__.Hash_queue.t
        -> 'key
        -> [ `No_such_key | `Ok ]

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
           ('data -> Ppx_sexp_conv_lib.Sexp.t)
        -> 'data t
        -> Ppx_sexp_conv_lib.Sexp.t
    end

    val merge : height:int -> t -> t -> t

    val hash_account : Account.t -> t

    val empty_account : t
  end

  module Location : Location_intf.S
end

module Make_base : functor
  (Inputs : sig
     module Key : sig
       type t

       val t_of_sexp : Sexplib0.Sexp.t -> t

       val sexp_of_t : t -> Sexplib0.Sexp.t

       module Stable : sig
         module V1 : sig
           type t_ := t

           type t = t_

           val t_of_sexp : Sexplib0.Sexp.t -> t

           val sexp_of_t : t -> Sexplib0.Sexp.t

           val bin_size_t : t Bin_prot.Size.sizer

           val bin_write_t : t Bin_prot.Write.writer

           val bin_read_t : t Bin_prot.Read.reader

           val __bin_read_t__ : (int -> t) Bin_prot.Read.reader

           val bin_shape_t : Bin_prot.Shape.t

           val bin_writer_t : t Bin_prot.Type_class.writer

           val bin_reader_t : t Bin_prot.Type_class.reader

           val bin_t : t Bin_prot.Type_class.t
         end

         module Latest : sig
           type t = V1.t

           val t_of_sexp : Sexplib0.Sexp.t -> t

           val sexp_of_t : t -> Sexplib0.Sexp.t

           val bin_size_t : t Bin_prot.Size.sizer

           val bin_write_t : t Bin_prot.Write.writer

           val bin_read_t : t Bin_prot.Read.reader

           val __bin_read_t__ : (int -> t) Bin_prot.Read.reader

           val bin_shape_t : Bin_prot.Shape.t

           val bin_writer_t : t Bin_prot.Type_class.writer

           val bin_reader_t : t Bin_prot.Type_class.reader

           val bin_t : t Bin_prot.Type_class.t
         end
       end

       val empty : t

       val to_string : t -> string

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
           , (key * 'b) list -> [ `Duplicate_keys of key list | `Ok of 'b t ]
           )
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

         val partitioni_tf :
           'b t -> f:(key:key -> data:'b -> bool) -> 'b t * 'b t

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

         type 'a merge_into_action = Remove | Set_to of 'a

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

         val bin_shape_t : Bin_prot.Shape.t -> Bin_prot.Shape.t

         val bin_size_t : ('a, 'a t) Bin_prot.Size.sizer1

         val bin_write_t : ('a, 'a t) Bin_prot.Write.writer1

         val bin_read_t : ('a, 'a t) Bin_prot.Read.reader1

         val __bin_read_t__ : ('a, int -> 'a t) Bin_prot.Read.reader1

         val bin_writer_t : ('a, 'a t) Bin_prot.Type_class.S1.writer

         val bin_reader_t : ('a, 'a t) Bin_prot.Type_class.S1.reader

         val bin_t : ('a, 'a t) Bin_prot.Type_class.S1.t
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

         val bin_size_t : t Bin_prot.Size.sizer

         val bin_write_t : t Bin_prot.Write.writer

         val bin_read_t : t Bin_prot.Read.reader

         val __bin_read_t__ : (int -> t) Bin_prot.Read.reader

         val bin_shape_t : Bin_prot.Shape.t

         val bin_writer_t : t Bin_prot.Type_class.writer

         val bin_reader_t : t Bin_prot.Type_class.reader

         val bin_t : t Bin_prot.Type_class.t
       end

       module Hash_queue : sig
         type key = t

         val length : ('a, 'b) Core_kernel__.Hash_queue.t -> int

         val is_empty : ('a, 'b) Core_kernel__.Hash_queue.t -> bool

         val iter :
           ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> unit) -> unit

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

         val exists :
           ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> bool) -> bool

         val for_all :
           ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> bool) -> bool

         val count :
           ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> bool) -> int

         val sum :
              (module Base__.Container_intf.Summable with type t = 'sum)
           -> ('b, 'a) Core_kernel__.Hash_queue.t
           -> f:('a -> 'sum)
           -> 'sum

         val find :
           ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> bool) -> 'a option

         val find_map :
              ('c, 'a) Core_kernel__.Hash_queue.t
           -> f:('a -> 'b option)
           -> 'b option

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

         val lookup_exn :
           ('key, 'data) Core_kernel__.Hash_queue.t -> 'key -> 'data

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
              ('key, 'data) Core_kernel__.Hash_queue.t
           -> 'key Core_kernel__.Import.list

         val dequeue :
              ('key, 'data) Core_kernel__.Hash_queue.t
           -> [ `back | `front ]
           -> 'data Core_kernel__.Import.option

         val dequeue_exn :
              ('key, 'data) Core_kernel__.Hash_queue.t
           -> [ `back | `front ]
           -> 'data

         val dequeue_back :
              ('key, 'data) Core_kernel__.Hash_queue.t
           -> 'data Core_kernel__.Import.option

         val dequeue_back_exn :
           ('key, 'data) Core_kernel__.Hash_queue.t -> 'data

         val dequeue_front :
              ('key, 'data) Core_kernel__.Hash_queue.t
           -> 'data Core_kernel__.Import.option

         val dequeue_front_exn :
           ('key, 'data) Core_kernel__.Hash_queue.t -> 'data

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
              ('key, 'data) Core_kernel__.Hash_queue.t
           -> 'key
           -> [ `No_such_key | `Ok ]

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
              ('data -> Ppx_sexp_conv_lib.Sexp.t)
           -> 'data t
           -> Ppx_sexp_conv_lib.Sexp.t
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

       type comparator_witness

       val comparator : (t, comparator_witness) Base__.Comparator.comparator

       val validate_lbound :
         min:t Base__.Maybe_bound.t -> t Base__.Validate.check

       val validate_ubound :
         max:t Base__.Maybe_bound.t -> t Base__.Validate.check

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

           type comparator_witness_ := comparator_witness

           type comparator_witness = comparator_witness_

           val comparator :
             (t, comparator_witness) Core_kernel__.Comparator.comparator
         end

         module Tree : sig
           type 'a t =
             (Table.key, 'a, comparator_witness) Core_kernel__.Map_intf.Tree.t

           val empty : 'a t

           val singleton : Table.key -> 'a -> 'a t

           val of_alist :
                (Table.key * 'a) list
             -> [ `Duplicate_key of Table.key | `Ok of 'a t ]

           val of_alist_or_error :
             (Table.key * 'a) list -> 'a t Base__.Or_error.t

           val of_alist_exn : (Table.key * 'a) list -> 'a t

           val of_alist_multi : (Table.key * 'a) list -> 'a list t

           val of_alist_fold :
             (Table.key * 'a) list -> init:'b -> f:('b -> 'a -> 'b) -> 'b t

           val of_alist_reduce :
             (Table.key * 'a) list -> f:('a -> 'a -> 'a) -> 'a t

           val of_sorted_array :
             (Table.key * 'a) array -> 'a t Base__.Or_error.t

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

           val of_sequence_multi :
             (Table.key * 'a) Base__.Sequence.t -> 'a list t

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
                'a t
             -> key:Table.key
             -> data:'a
             -> 'a t Base__.Map_intf.Or_duplicate.t

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
             -> f:
                  (   key:Table.key
                   -> data:'a
                   -> Base__.Map_intf.Continue_or_stop.t)
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

           val split :
             'a t -> Table.key -> 'a t * (Table.key * 'a) option * 'a t

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

         type 'a t =
           (Table.key, 'a, comparator_witness) Core_kernel__.Map_intf.Map.t

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

         val of_alist_reduce :
           (Table.key * 'a) list -> f:('a -> 'a -> 'a) -> 'a t

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
              'a t
           -> key:Table.key
           -> data:'a
           -> 'a t Base__.Map_intf.Or_duplicate.t

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
              val hash_fold_t :
                Base__.Hash.state -> Table.key -> Base__.Hash.state
            end)
           -> sig
           val hash_fold_t :
                (   Ppx_hash_lib.Std.Hash.state
                 -> 'a
                 -> Ppx_hash_lib.Std.Hash.state)
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
           type t =
             (Table.key, comparator_witness) Core_kernel__.Set_intf.Tree.t

           val compare : t -> t -> Core_kernel__.Import.int

           type named =
             (Table.key, comparator_witness) Core_kernel__.Set_intf.Tree.Named.t

           val length : t -> int

           val is_empty : t -> bool

           val iter : t -> f:(Table.key -> unit) -> unit

           val fold :
             t -> init:'accum -> f:('accum -> Table.key -> 'accum) -> 'accum

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
             -> ( Table.key
                , Table.key )
                Base__.Set_intf.Merge_to_sequence_element.t
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

         type named =
           (Table.key, comparator_witness) Core_kernel__.Set_intf.Named.t

         val length : t -> int

         val is_empty : t -> bool

         val iter : t -> f:(Table.key -> unit) -> unit

         val fold :
           t -> init:'accum -> f:('accum -> Table.key -> 'accum) -> 'accum

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

         val of_increasing_iterator_unchecked :
           len:int -> f:(int -> Table.key) -> t

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
              val hash_fold_t :
                Base__.Hash.state -> Table.key -> Base__.Hash.state
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

     module Token_id : Intf.Token_id

     module Account_id : sig
       module Stable : sig
         module V1 : sig
           type t

           val bin_size_t : t Bin_prot.Size.sizer

           val bin_write_t : t Bin_prot.Write.writer

           val bin_read_t : t Bin_prot.Read.reader

           val __bin_read_t__ : (int -> t) Bin_prot.Read.reader

           val bin_shape_t : Bin_prot.Shape.t

           val bin_writer_t : t Bin_prot.Type_class.writer

           val bin_reader_t : t Bin_prot.Type_class.reader

           val bin_t : t Bin_prot.Type_class.t

           val __versioned__ : unit

           val t_of_sexp : Sexplib0.Sexp.t -> t

           val sexp_of_t : t -> Sexplib0.Sexp.t
         end

         module Latest : sig
           type t = V1.t

           val bin_size_t : t Bin_prot.Size.sizer

           val bin_write_t : t Bin_prot.Write.writer

           val bin_read_t : t Bin_prot.Read.reader

           val __bin_read_t__ : (int -> t) Bin_prot.Read.reader

           val bin_shape_t : Bin_prot.Shape.t

           val bin_writer_t : t Bin_prot.Type_class.writer

           val bin_reader_t : t Bin_prot.Type_class.reader

           val bin_t : t Bin_prot.Type_class.t

           val __versioned__ : unit

           val t_of_sexp : Sexplib0.Sexp.t -> t

           val sexp_of_t : t -> Sexplib0.Sexp.t
         end

         val versions :
           (int * (Core_kernel.Bigstring.t -> pos_ref:int Core.ref -> V1.t))
           array

         val bin_read_to_latest_opt :
           Core.Bin_prot.Common.buf -> pos_ref:int Core.ref -> V1.t option
       end

       type t = Stable.V1.t

       val t_of_sexp : Sexplib0.Sexp.t -> t

       val sexp_of_t : t -> Sexplib0.Sexp.t

       val public_key : t -> Key.t

       val token_id : t -> Token_id.t

       val create : Key.t -> Token_id.t -> t

       val hash_fold_t :
         Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state

       val hash : t -> Ppx_hash_lib.Std.Hash.hash_value

       val hashable : t Core_kernel__.Hashtbl.Hashable.t

       module Table : sig
         type key = t

         type ('a, 'b) hashtbl = ('a, 'b) Key.Table.hashtbl

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
           , (key * 'b) list -> [ `Duplicate_keys of key list | `Ok of 'b t ]
           )
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

         val partitioni_tf :
           'b t -> f:(key:key -> data:'b -> bool) -> 'b t * 'b t

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

         type 'a merge_into_action = Remove | Set_to of 'a

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

         val bin_shape_t : Bin_prot.Shape.t -> Bin_prot.Shape.t

         val bin_size_t : ('a, 'a t) Bin_prot.Size.sizer1

         val bin_write_t : ('a, 'a t) Bin_prot.Write.writer1

         val bin_read_t : ('a, 'a t) Bin_prot.Read.reader1

         val __bin_read_t__ : ('a, int -> 'a t) Bin_prot.Read.reader1

         val bin_writer_t : ('a, 'a t) Bin_prot.Type_class.S1.writer

         val bin_reader_t : ('a, 'a t) Bin_prot.Type_class.S1.reader

         val bin_t : ('a, 'a t) Bin_prot.Type_class.S1.t
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

         val bin_size_t : t Bin_prot.Size.sizer

         val bin_write_t : t Bin_prot.Write.writer

         val bin_read_t : t Bin_prot.Read.reader

         val __bin_read_t__ : (int -> t) Bin_prot.Read.reader

         val bin_shape_t : Bin_prot.Shape.t

         val bin_writer_t : t Bin_prot.Type_class.writer

         val bin_reader_t : t Bin_prot.Type_class.reader

         val bin_t : t Bin_prot.Type_class.t
       end

       module Hash_queue : sig
         type key = t

         val length : ('a, 'b) Core_kernel__.Hash_queue.t -> int

         val is_empty : ('a, 'b) Core_kernel__.Hash_queue.t -> bool

         val iter :
           ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> unit) -> unit

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

         val exists :
           ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> bool) -> bool

         val for_all :
           ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> bool) -> bool

         val count :
           ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> bool) -> int

         val sum :
              (module Base__.Container_intf.Summable with type t = 'sum)
           -> ('b, 'a) Core_kernel__.Hash_queue.t
           -> f:('a -> 'sum)
           -> 'sum

         val find :
           ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> bool) -> 'a option

         val find_map :
              ('c, 'a) Core_kernel__.Hash_queue.t
           -> f:('a -> 'b option)
           -> 'b option

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

         val lookup_exn :
           ('key, 'data) Core_kernel__.Hash_queue.t -> 'key -> 'data

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
              ('key, 'data) Core_kernel__.Hash_queue.t
           -> 'key Core_kernel__.Import.list

         val dequeue :
              ('key, 'data) Core_kernel__.Hash_queue.t
           -> [ `back | `front ]
           -> 'data Core_kernel__.Import.option

         val dequeue_exn :
              ('key, 'data) Core_kernel__.Hash_queue.t
           -> [ `back | `front ]
           -> 'data

         val dequeue_back :
              ('key, 'data) Core_kernel__.Hash_queue.t
           -> 'data Core_kernel__.Import.option

         val dequeue_back_exn :
           ('key, 'data) Core_kernel__.Hash_queue.t -> 'data

         val dequeue_front :
              ('key, 'data) Core_kernel__.Hash_queue.t
           -> 'data Core_kernel__.Import.option

         val dequeue_front_exn :
           ('key, 'data) Core_kernel__.Hash_queue.t -> 'data

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
              ('key, 'data) Core_kernel__.Hash_queue.t
           -> 'key
           -> [ `No_such_key | `Ok ]

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
              ('data -> Ppx_sexp_conv_lib.Sexp.t)
           -> 'data t
           -> Ppx_sexp_conv_lib.Sexp.t
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

       type comparator_witness

       val comparator : (t, comparator_witness) Base__.Comparator.comparator

       val validate_lbound :
         min:t Base__.Maybe_bound.t -> t Base__.Validate.check

       val validate_ubound :
         max:t Base__.Maybe_bound.t -> t Base__.Validate.check

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

           type comparator_witness_ := comparator_witness

           type comparator_witness = comparator_witness_

           val comparator :
             (t, comparator_witness) Core_kernel__.Comparator.comparator
         end

         module Tree : sig
           type 'a t =
             (Table.key, 'a, comparator_witness) Core_kernel__.Map_intf.Tree.t

           val empty : 'a t

           val singleton : Table.key -> 'a -> 'a t

           val of_alist :
                (Table.key * 'a) list
             -> [ `Duplicate_key of Table.key | `Ok of 'a t ]

           val of_alist_or_error :
             (Table.key * 'a) list -> 'a t Base__.Or_error.t

           val of_alist_exn : (Table.key * 'a) list -> 'a t

           val of_alist_multi : (Table.key * 'a) list -> 'a list t

           val of_alist_fold :
             (Table.key * 'a) list -> init:'b -> f:('b -> 'a -> 'b) -> 'b t

           val of_alist_reduce :
             (Table.key * 'a) list -> f:('a -> 'a -> 'a) -> 'a t

           val of_sorted_array :
             (Table.key * 'a) array -> 'a t Base__.Or_error.t

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

           val of_sequence_multi :
             (Table.key * 'a) Base__.Sequence.t -> 'a list t

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
                'a t
             -> key:Table.key
             -> data:'a
             -> 'a t Base__.Map_intf.Or_duplicate.t

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
             -> f:
                  (   key:Table.key
                   -> data:'a
                   -> Base__.Map_intf.Continue_or_stop.t)
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

           val split :
             'a t -> Table.key -> 'a t * (Table.key * 'a) option * 'a t

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

         type 'a t =
           (Table.key, 'a, comparator_witness) Core_kernel__.Map_intf.Map.t

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

         val of_alist_reduce :
           (Table.key * 'a) list -> f:('a -> 'a -> 'a) -> 'a t

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
              'a t
           -> key:Table.key
           -> data:'a
           -> 'a t Base__.Map_intf.Or_duplicate.t

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
              val hash_fold_t :
                Base__.Hash.state -> Table.key -> Base__.Hash.state
            end)
           -> sig
           val hash_fold_t :
                (   Ppx_hash_lib.Std.Hash.state
                 -> 'a
                 -> Ppx_hash_lib.Std.Hash.state)
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
           type t =
             (Table.key, comparator_witness) Core_kernel__.Set_intf.Tree.t

           val compare : t -> t -> Core_kernel__.Import.int

           type named =
             (Table.key, comparator_witness) Core_kernel__.Set_intf.Tree.Named.t

           val length : t -> int

           val is_empty : t -> bool

           val iter : t -> f:(Table.key -> unit) -> unit

           val fold :
             t -> init:'accum -> f:('accum -> Table.key -> 'accum) -> 'accum

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
             -> ( Table.key
                , Table.key )
                Base__.Set_intf.Merge_to_sequence_element.t
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

         type named =
           (Table.key, comparator_witness) Core_kernel__.Set_intf.Named.t

         val length : t -> int

         val is_empty : t -> bool

         val iter : t -> f:(Table.key -> unit) -> unit

         val fold :
           t -> init:'accum -> f:('accum -> Table.key -> 'accum) -> 'accum

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

         val of_increasing_iterator_unchecked :
           len:int -> f:(int -> Table.key) -> t

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
              val hash_fold_t :
                Base__.Hash.state -> Table.key -> Base__.Hash.state
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

     module Balance : Intf.Balance

     module Account : sig
       type t

       val bin_size_t : t Bin_prot.Size.sizer

       val bin_write_t : t Bin_prot.Write.writer

       val bin_read_t : t Bin_prot.Read.reader

       val __bin_read_t__ : (int -> t) Bin_prot.Read.reader

       val bin_shape_t : Bin_prot.Shape.t

       val bin_writer_t : t Bin_prot.Type_class.writer

       val bin_reader_t : t Bin_prot.Type_class.reader

       val bin_t : t Bin_prot.Type_class.t

       val equal : t -> t -> bool

       val t_of_sexp : Sexplib0.Sexp.t -> t

       val sexp_of_t : t -> Sexplib0.Sexp.t

       val compare : t -> t -> int

       val token : t -> Token_id.t

       val identifier : t -> Account_id.t

       val balance : t -> Balance.t

       val token_owner : t -> bool

       val empty : t
     end

     module Hash : sig
       type t

       val to_yojson : t -> Yojson.Safe.t

       val of_yojson : Yojson.Safe.t -> t Ppx_deriving_yojson_runtime.error_or

       val bin_size_t : t Bin_prot.Size.sizer

       val bin_write_t : t Bin_prot.Write.writer

       val bin_read_t : t Bin_prot.Read.reader

       val __bin_read_t__ : (int -> t) Bin_prot.Read.reader

       val bin_shape_t : Bin_prot.Shape.t

       val bin_writer_t : t Bin_prot.Type_class.writer

       val bin_reader_t : t Bin_prot.Type_class.reader

       val bin_t : t Bin_prot.Type_class.t

       val compare : t -> t -> int

       val equal : t -> t -> bool

       val t_of_sexp : Sexplib0.Sexp.t -> t

       val sexp_of_t : t -> Sexplib0.Sexp.t

       val to_base58_check : t -> string

       val hash_fold_t :
         Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state

       val hash : t -> Ppx_hash_lib.Std.Hash.hash_value

       val hashable : t Core_kernel__.Hashtbl.Hashable.t

       module Table : sig
         type key = t

         type ('a, 'b) hashtbl = ('a, 'b) Key.Table.hashtbl

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
           , (key * 'b) list -> [ `Duplicate_keys of key list | `Ok of 'b t ]
           )
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

         val partitioni_tf :
           'b t -> f:(key:key -> data:'b -> bool) -> 'b t * 'b t

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

         type 'a merge_into_action = Remove | Set_to of 'a

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

         val bin_shape_t : Bin_prot.Shape.t -> Bin_prot.Shape.t

         val bin_size_t : ('a, 'a t) Bin_prot.Size.sizer1

         val bin_write_t : ('a, 'a t) Bin_prot.Write.writer1

         val bin_read_t : ('a, 'a t) Bin_prot.Read.reader1

         val __bin_read_t__ : ('a, int -> 'a t) Bin_prot.Read.reader1

         val bin_writer_t : ('a, 'a t) Bin_prot.Type_class.S1.writer

         val bin_reader_t : ('a, 'a t) Bin_prot.Type_class.S1.reader

         val bin_t : ('a, 'a t) Bin_prot.Type_class.S1.t
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

         val bin_size_t : t Bin_prot.Size.sizer

         val bin_write_t : t Bin_prot.Write.writer

         val bin_read_t : t Bin_prot.Read.reader

         val __bin_read_t__ : (int -> t) Bin_prot.Read.reader

         val bin_shape_t : Bin_prot.Shape.t

         val bin_writer_t : t Bin_prot.Type_class.writer

         val bin_reader_t : t Bin_prot.Type_class.reader

         val bin_t : t Bin_prot.Type_class.t
       end

       module Hash_queue : sig
         type key = t

         val length : ('a, 'b) Core_kernel__.Hash_queue.t -> int

         val is_empty : ('a, 'b) Core_kernel__.Hash_queue.t -> bool

         val iter :
           ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> unit) -> unit

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

         val exists :
           ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> bool) -> bool

         val for_all :
           ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> bool) -> bool

         val count :
           ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> bool) -> int

         val sum :
              (module Base__.Container_intf.Summable with type t = 'sum)
           -> ('b, 'a) Core_kernel__.Hash_queue.t
           -> f:('a -> 'sum)
           -> 'sum

         val find :
           ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> bool) -> 'a option

         val find_map :
              ('c, 'a) Core_kernel__.Hash_queue.t
           -> f:('a -> 'b option)
           -> 'b option

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

         val lookup_exn :
           ('key, 'data) Core_kernel__.Hash_queue.t -> 'key -> 'data

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
              ('key, 'data) Core_kernel__.Hash_queue.t
           -> 'key Core_kernel__.Import.list

         val dequeue :
              ('key, 'data) Core_kernel__.Hash_queue.t
           -> [ `back | `front ]
           -> 'data Core_kernel__.Import.option

         val dequeue_exn :
              ('key, 'data) Core_kernel__.Hash_queue.t
           -> [ `back | `front ]
           -> 'data

         val dequeue_back :
              ('key, 'data) Core_kernel__.Hash_queue.t
           -> 'data Core_kernel__.Import.option

         val dequeue_back_exn :
           ('key, 'data) Core_kernel__.Hash_queue.t -> 'data

         val dequeue_front :
              ('key, 'data) Core_kernel__.Hash_queue.t
           -> 'data Core_kernel__.Import.option

         val dequeue_front_exn :
           ('key, 'data) Core_kernel__.Hash_queue.t -> 'data

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
              ('key, 'data) Core_kernel__.Hash_queue.t
           -> 'key
           -> [ `No_such_key | `Ok ]

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
              ('data -> Ppx_sexp_conv_lib.Sexp.t)
           -> 'data t
           -> Ppx_sexp_conv_lib.Sexp.t
       end

       val merge : height:int -> t -> t -> t

       val hash_account : Account.t -> t

       val empty_account : t
     end

     module Location : Location_intf.S
   end)
  -> sig
  module Location : sig
    module Addr : sig
      type t = Inputs.Location.Addr.t

      val to_yojson : t -> Yojson.Safe.t

      val t_of_sexp : Sexplib0.Sexp.t -> t

      val sexp_of_t : t -> Sexplib0.Sexp.t

      val equal : t -> t -> bool

      val compare : t -> t -> int

      module Stable : sig
        module V1 : sig
          type nonrec t = t

          val to_yojson : t -> Yojson.Safe.t

          val t_of_sexp : Sexplib0.Sexp.t -> t

          val sexp_of_t : t -> Sexplib0.Sexp.t

          val bin_size_t : t Bin_prot.Size.sizer

          val bin_write_t : t Bin_prot.Write.writer

          val bin_read_t : t Bin_prot.Read.reader

          val __bin_read_t__ : (int -> t) Bin_prot.Read.reader

          val bin_shape_t : Bin_prot.Shape.t

          val bin_writer_t : t Bin_prot.Type_class.writer

          val bin_reader_t : t Bin_prot.Type_class.reader

          val bin_t : t Bin_prot.Type_class.t

          val hash_fold_t :
            Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state

          val hash : t -> Ppx_hash_lib.Std.Hash.hash_value

          val equal : t -> t -> bool

          val compare : t -> t -> int

          val __versioned__ : unit
        end

        module Latest : sig
          type nonrec t = t

          val to_yojson : t -> Yojson.Safe.t

          val t_of_sexp : Sexplib0.Sexp.t -> t

          val sexp_of_t : t -> Sexplib0.Sexp.t

          val bin_size_t : t Bin_prot.Size.sizer

          val bin_write_t : t Bin_prot.Write.writer

          val bin_read_t : t Bin_prot.Read.reader

          val __bin_read_t__ : (int -> t) Bin_prot.Read.reader

          val bin_shape_t : Bin_prot.Shape.t

          val bin_writer_t : t Bin_prot.Type_class.writer

          val bin_reader_t : t Bin_prot.Type_class.reader

          val bin_t : t Bin_prot.Type_class.t

          val hash_fold_t :
            Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state

          val hash : t -> Ppx_hash_lib.Std.Hash.hash_value

          val equal : t -> t -> bool

          val compare : t -> t -> int

          val __versioned__ : unit
        end
      end

      val hash_fold_t :
        Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state

      val hash : t -> Ppx_hash_lib.Std.Hash.hash_value

      val hashable : t Core_kernel__.Hashtbl.Hashable.t

      module Table : sig
        type key = t

        type ('a, 'b) hashtbl = ('a, 'b) Inputs.Key.Table.hashtbl

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

        val partitioni_tf :
          'b t -> f:(key:key -> data:'b -> bool) -> 'b t * 'b t

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
              'a Inputs.Location.Addr.Table.merge_into_action =
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

        val bin_shape_t : Bin_prot.Shape.t -> Bin_prot.Shape.t

        val bin_size_t : ('a, 'a t) Bin_prot.Size.sizer1

        val bin_write_t : ('a, 'a t) Bin_prot.Write.writer1

        val bin_read_t : ('a, 'a t) Bin_prot.Read.reader1

        val __bin_read_t__ : ('a, int -> 'a t) Bin_prot.Read.reader1

        val bin_writer_t : ('a, 'a t) Bin_prot.Type_class.S1.writer

        val bin_reader_t : ('a, 'a t) Bin_prot.Type_class.S1.reader

        val bin_t : ('a, 'a t) Bin_prot.Type_class.S1.t
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

        val bin_size_t : t Bin_prot.Size.sizer

        val bin_write_t : t Bin_prot.Write.writer

        val bin_read_t : t Bin_prot.Read.reader

        val __bin_read_t__ : (int -> t) Bin_prot.Read.reader

        val bin_shape_t : Bin_prot.Shape.t

        val bin_writer_t : t Bin_prot.Type_class.writer

        val bin_reader_t : t Bin_prot.Type_class.reader

        val bin_t : t Bin_prot.Type_class.t
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

        val exists :
          ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> bool) -> bool

        val for_all :
          ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> bool) -> bool

        val count : ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> bool) -> int

        val sum :
             (module Base__.Container_intf.Summable with type t = 'sum)
          -> ('b, 'a) Core_kernel__.Hash_queue.t
          -> f:('a -> 'sum)
          -> 'sum

        val find :
          ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> bool) -> 'a option

        val find_map :
             ('c, 'a) Core_kernel__.Hash_queue.t
          -> f:('a -> 'b option)
          -> 'b option

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

        val lookup_exn :
          ('key, 'data) Core_kernel__.Hash_queue.t -> 'key -> 'data

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
             ('key, 'data) Core_kernel__.Hash_queue.t
          -> 'key Core_kernel__.Import.list

        val dequeue :
             ('key, 'data) Core_kernel__.Hash_queue.t
          -> [ `back | `front ]
          -> 'data Core_kernel__.Import.option

        val dequeue_exn :
             ('key, 'data) Core_kernel__.Hash_queue.t
          -> [ `back | `front ]
          -> 'data

        val dequeue_back :
             ('key, 'data) Core_kernel__.Hash_queue.t
          -> 'data Core_kernel__.Import.option

        val dequeue_back_exn : ('key, 'data) Core_kernel__.Hash_queue.t -> 'data

        val dequeue_front :
             ('key, 'data) Core_kernel__.Hash_queue.t
          -> 'data Core_kernel__.Import.option

        val dequeue_front_exn :
          ('key, 'data) Core_kernel__.Hash_queue.t -> 'data

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
             ('key, 'data) Core_kernel__.Hash_queue.t
          -> 'key
          -> [ `No_such_key | `Ok ]

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
             ('data -> Ppx_sexp_conv_lib.Sexp.t)
          -> 'data t
          -> Ppx_sexp_conv_lib.Sexp.t
      end

      val of_byte_string : string -> t

      val of_directions : Direction.t list -> t

      val root : unit -> t

      val slice : t -> int -> int -> t

      val get : t -> int -> int

      val copy : t -> t

      val parent : t -> t Core_kernel.Or_error.t

      val child :
        ledger_depth:int -> t -> Direction.t -> t Core_kernel.Or_error.t

      val child_exn : ledger_depth:int -> t -> Direction.t -> t

      val parent_exn : t -> t

      val dirs_from_root : t -> Direction.t list

      val sibling : t -> t

      val next : t -> t Core_kernel.Option.t

      val prev : t -> t Core_kernel.Option.t

      val is_leaf : ledger_depth:int -> t -> bool

      val is_parent_of : t -> maybe_child:t -> bool

      val serialize : ledger_depth:int -> t -> Core_kernel.Bigstring.t

      val to_string : t -> string

      val pp : Format.formatter -> t -> unit

      module Range : sig
        type nonrec t = t * t

        val fold :
             ?stop:[ `Exclusive | `Inclusive ]
          -> t
          -> init:'a
          -> f:(Table.key -> 'a -> 'a)
          -> 'a

        val subtree_range : ledger_depth:int -> Table.key -> t

        val subtree_range_seq :
          ledger_depth:int -> Table.key -> Table.key Core_kernel.Sequence.t
      end

      val depth : t -> int

      val height : ledger_depth:int -> t -> int

      val to_int : t -> int

      val of_int_exn : ledger_depth:int -> int -> t
    end

    module Prefix : sig
      val generic : Unsigned.UInt8.t

      val account : Unsigned.UInt8.t

      val hash : ledger_depth:int -> int -> Unsigned.UInt8.t
    end

    type t = Inputs.Location.t =
      | Generic of Core.Bigstring.t
      | Account of Addr.t
      | Hash of Addr.t

    val t_of_sexp : Sexplib0.Sexp.t -> t

    val sexp_of_t : t -> Sexplib0.Sexp.t

    val hash_fold_t :
      Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state

    val hash : t -> Ppx_hash_lib.Std.Hash.hash_value

    val is_generic : t -> bool

    val is_account : t -> bool

    val is_hash : t -> bool

    val height : ledger_depth:int -> t -> int

    val root_hash : t

    val last_direction : Addr.t -> Direction.t

    val build_generic : Core.Bigstring.t -> t

    val parse : ledger_depth:int -> Core.Bigstring.t -> (t, unit) Core.Result.t

    val prefix_bigstring :
      Unsigned.UInt8.t -> Core.Bigstring.t -> Core.Bigstring.t

    val to_path_exn : t -> Addr.t

    val serialize : ledger_depth:int -> t -> Core.Bigstring.t

    val parent : t -> t

    val next : t -> t Core.Option.t

    val prev : t -> t Core.Option.t

    val sibling : t -> t

    val order_siblings : t -> 'a -> 'a -> 'a * 'a

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

    type comparator_witness = Inputs.Location.comparator_witness

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
        type t = Inputs.Location.t

        val t_of_sexp : Sexplib0.Sexp.t -> t

        val sexp_of_t : t -> Sexplib0.Sexp.t

        type comparator_witness = Inputs.Location.comparator_witness

        val comparator :
          (t, comparator_witness) Core_kernel__.Comparator.comparator
      end

      module Tree : sig
        type 'a t =
          (Key.t, 'a, comparator_witness) Core_kernel__.Map_intf.Tree.t

        val empty : 'a t

        val singleton : Key.t -> 'a -> 'a t

        val of_alist :
          (Key.t * 'a) list -> [ `Duplicate_key of Key.t | `Ok of 'a t ]

        val of_alist_or_error : (Key.t * 'a) list -> 'a t Base__.Or_error.t

        val of_alist_exn : (Key.t * 'a) list -> 'a t

        val of_alist_multi : (Key.t * 'a) list -> 'a list t

        val of_alist_fold :
          (Key.t * 'a) list -> init:'b -> f:('b -> 'a -> 'b) -> 'b t

        val of_alist_reduce : (Key.t * 'a) list -> f:('a -> 'a -> 'a) -> 'a t

        val of_sorted_array : (Key.t * 'a) array -> 'a t Base__.Or_error.t

        val of_sorted_array_unchecked : (Key.t * 'a) array -> 'a t

        val of_increasing_iterator_unchecked :
          len:int -> f:(int -> Key.t * 'a) -> 'a t

        val of_increasing_sequence :
          (Key.t * 'a) Base__.Sequence.t -> 'a t Base__.Or_error.t

        val of_sequence :
             (Key.t * 'a) Base__.Sequence.t
          -> [ `Duplicate_key of Key.t | `Ok of 'a t ]

        val of_sequence_or_error :
          (Key.t * 'a) Base__.Sequence.t -> 'a t Base__.Or_error.t

        val of_sequence_exn : (Key.t * 'a) Base__.Sequence.t -> 'a t

        val of_sequence_multi : (Key.t * 'a) Base__.Sequence.t -> 'a list t

        val of_sequence_fold :
             (Key.t * 'a) Base__.Sequence.t
          -> init:'b
          -> f:('b -> 'a -> 'b)
          -> 'b t

        val of_sequence_reduce :
          (Key.t * 'a) Base__.Sequence.t -> f:('a -> 'a -> 'a) -> 'a t

        val of_iteri :
             iteri:(f:(key:Key.t -> data:'v -> unit) -> unit)
          -> [ `Duplicate_key of Key.t | `Ok of 'v t ]

        val of_tree : 'a t -> 'a t

        val of_hashtbl_exn : (Key.t, 'a) Addr.Table.hashtbl -> 'a t

        val of_key_set :
          (Key.t, comparator_witness) Base.Set.t -> f:(Key.t -> 'v) -> 'v t

        val quickcheck_generator :
             Key.t Core_kernel__.Quickcheck.Generator.t
          -> 'a Core_kernel__.Quickcheck.Generator.t
          -> 'a t Core_kernel__.Quickcheck.Generator.t

        val invariants : 'a t -> bool

        val is_empty : 'a t -> bool

        val length : 'a t -> int

        val add :
          'a t -> key:Key.t -> data:'a -> 'a t Base__.Map_intf.Or_duplicate.t

        val add_exn : 'a t -> key:Key.t -> data:'a -> 'a t

        val set : 'a t -> key:Key.t -> data:'a -> 'a t

        val add_multi : 'a list t -> key:Key.t -> data:'a -> 'a list t

        val remove_multi : 'a list t -> Key.t -> 'a list t

        val find_multi : 'a list t -> Key.t -> 'a list

        val change : 'a t -> Key.t -> f:('a option -> 'a option) -> 'a t

        val update : 'a t -> Key.t -> f:('a option -> 'a) -> 'a t

        val find : 'a t -> Key.t -> 'a option

        val find_exn : 'a t -> Key.t -> 'a

        val remove : 'a t -> Key.t -> 'a t

        val mem : 'a t -> Key.t -> bool

        val iter_keys : 'a t -> f:(Key.t -> unit) -> unit

        val iter : 'a t -> f:('a -> unit) -> unit

        val iteri : 'a t -> f:(key:Key.t -> data:'a -> unit) -> unit

        val iteri_until :
             'a t
          -> f:(key:Key.t -> data:'a -> Base__.Map_intf.Continue_or_stop.t)
          -> Base__.Map_intf.Finished_or_unfinished.t

        val iter2 :
             'a t
          -> 'b t
          -> f:
               (   key:Key.t
                -> data:[ `Both of 'a * 'b | `Left of 'a | `Right of 'b ]
                -> unit)
          -> unit

        val map : 'a t -> f:('a -> 'b) -> 'b t

        val mapi : 'a t -> f:(key:Key.t -> data:'a -> 'b) -> 'b t

        val fold : 'a t -> init:'b -> f:(key:Key.t -> data:'a -> 'b -> 'b) -> 'b

        val fold_right :
          'a t -> init:'b -> f:(key:Key.t -> data:'a -> 'b -> 'b) -> 'b

        val fold2 :
             'a t
          -> 'b t
          -> init:'c
          -> f:
               (   key:Key.t
                -> data:[ `Both of 'a * 'b | `Left of 'a | `Right of 'b ]
                -> 'c
                -> 'c)
          -> 'c

        val filter_keys : 'a t -> f:(Key.t -> bool) -> 'a t

        val filter : 'a t -> f:('a -> bool) -> 'a t

        val filteri : 'a t -> f:(key:Key.t -> data:'a -> bool) -> 'a t

        val filter_map : 'a t -> f:('a -> 'b option) -> 'b t

        val filter_mapi : 'a t -> f:(key:Key.t -> data:'a -> 'b option) -> 'b t

        val partition_mapi :
             'a t
          -> f:(key:Key.t -> data:'a -> [ `Fst of 'b | `Snd of 'c ])
          -> 'b t * 'c t

        val partition_map :
          'a t -> f:('a -> [ `Fst of 'b | `Snd of 'c ]) -> 'b t * 'c t

        val partitioni_tf :
          'a t -> f:(key:Key.t -> data:'a -> bool) -> 'a t * 'a t

        val partition_tf : 'a t -> f:('a -> bool) -> 'a t * 'a t

        val compare_direct : ('a -> 'a -> int) -> 'a t -> 'a t -> int

        val equal : ('a -> 'a -> bool) -> 'a t -> 'a t -> bool

        val keys : 'a t -> Key.t list

        val data : 'a t -> 'a list

        val to_alist :
          ?key_order:[ `Decreasing | `Increasing ] -> 'a t -> (Key.t * 'a) list

        val validate :
             name:(Key.t -> string)
          -> 'a Base__.Validate.check
          -> 'a t Base__.Validate.check

        val merge :
             'a t
          -> 'b t
          -> f:
               (   key:Key.t
                -> [ `Both of 'a * 'b | `Left of 'a | `Right of 'b ]
                -> 'c option)
          -> 'c t

        val symmetric_diff :
             'a t
          -> 'a t
          -> data_equal:('a -> 'a -> bool)
          -> (Key.t, 'a) Base__.Map_intf.Symmetric_diff_element.t
             Base__.Sequence.t

        val fold_symmetric_diff :
             'a t
          -> 'a t
          -> data_equal:('a -> 'a -> bool)
          -> init:'c
          -> f:
               (   'c
                -> (Key.t, 'a) Base__.Map_intf.Symmetric_diff_element.t
                -> 'c)
          -> 'c

        val min_elt : 'a t -> (Key.t * 'a) option

        val min_elt_exn : 'a t -> Key.t * 'a

        val max_elt : 'a t -> (Key.t * 'a) option

        val max_elt_exn : 'a t -> Key.t * 'a

        val for_all : 'a t -> f:('a -> bool) -> bool

        val for_alli : 'a t -> f:(key:Key.t -> data:'a -> bool) -> bool

        val exists : 'a t -> f:('a -> bool) -> bool

        val existsi : 'a t -> f:(key:Key.t -> data:'a -> bool) -> bool

        val count : 'a t -> f:('a -> bool) -> int

        val counti : 'a t -> f:(key:Key.t -> data:'a -> bool) -> int

        val split : 'a t -> Key.t -> 'a t * (Key.t * 'a) option * 'a t

        val append :
             lower_part:'a t
          -> upper_part:'a t
          -> [ `Ok of 'a t | `Overlapping_key_ranges ]

        val subrange :
             'a t
          -> lower_bound:Key.t Base__.Maybe_bound.t
          -> upper_bound:Key.t Base__.Maybe_bound.t
          -> 'a t

        val fold_range_inclusive :
             'a t
          -> min:Key.t
          -> max:Key.t
          -> init:'b
          -> f:(key:Key.t -> data:'a -> 'b -> 'b)
          -> 'b

        val range_to_alist : 'a t -> min:Key.t -> max:Key.t -> (Key.t * 'a) list

        val closest_key :
             'a t
          -> [ `Greater_or_equal_to
             | `Greater_than
             | `Less_or_equal_to
             | `Less_than ]
          -> Key.t
          -> (Key.t * 'a) option

        val nth : 'a t -> int -> (Key.t * 'a) option

        val nth_exn : 'a t -> int -> Key.t * 'a

        val rank : 'a t -> Key.t -> int option

        val to_tree : 'a t -> 'a t

        val to_sequence :
             ?order:[ `Decreasing_key | `Increasing_key ]
          -> ?keys_greater_or_equal_to:Key.t
          -> ?keys_less_or_equal_to:Key.t
          -> 'a t
          -> (Key.t * 'a) Base__.Sequence.t

        val binary_search :
             'a t
          -> compare:(key:Key.t -> data:'a -> 'key -> int)
          -> [ `First_equal_to
             | `First_greater_than_or_equal_to
             | `First_strictly_greater_than
             | `Last_equal_to
             | `Last_less_than_or_equal_to
             | `Last_strictly_less_than ]
          -> 'key
          -> (Key.t * 'a) option

        val binary_search_segmented :
             'a t
          -> segment_of:(key:Key.t -> data:'a -> [ `Left | `Right ])
          -> [ `First_on_right | `Last_on_left ]
          -> (Key.t * 'a) option

        val key_set : 'a t -> (Key.t, comparator_witness) Base.Set.t

        val quickcheck_observer :
             Key.t Core_kernel__.Quickcheck.Observer.t
          -> 'v Core_kernel__.Quickcheck.Observer.t
          -> 'v t Core_kernel__.Quickcheck.Observer.t

        val quickcheck_shrinker :
             Key.t Core_kernel__.Quickcheck.Shrinker.t
          -> 'v Core_kernel__.Quickcheck.Shrinker.t
          -> 'v t Core_kernel__.Quickcheck.Shrinker.t

        module Provide_of_sexp : functor
          (K : sig
             val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> Key.t
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

      type 'a t = (Key.t, 'a, comparator_witness) Core_kernel__.Map_intf.Map.t

      val compare :
           ('a -> 'a -> Core_kernel__.Import.int)
        -> 'a t
        -> 'a t
        -> Core_kernel__.Import.int

      val empty : 'a t

      val singleton : Key.t -> 'a -> 'a t

      val of_alist :
        (Key.t * 'a) list -> [ `Duplicate_key of Key.t | `Ok of 'a t ]

      val of_alist_or_error : (Key.t * 'a) list -> 'a t Base__.Or_error.t

      val of_alist_exn : (Key.t * 'a) list -> 'a t

      val of_alist_multi : (Key.t * 'a) list -> 'a list t

      val of_alist_fold :
        (Key.t * 'a) list -> init:'b -> f:('b -> 'a -> 'b) -> 'b t

      val of_alist_reduce : (Key.t * 'a) list -> f:('a -> 'a -> 'a) -> 'a t

      val of_sorted_array : (Key.t * 'a) array -> 'a t Base__.Or_error.t

      val of_sorted_array_unchecked : (Key.t * 'a) array -> 'a t

      val of_increasing_iterator_unchecked :
        len:int -> f:(int -> Key.t * 'a) -> 'a t

      val of_increasing_sequence :
        (Key.t * 'a) Base__.Sequence.t -> 'a t Base__.Or_error.t

      val of_sequence :
           (Key.t * 'a) Base__.Sequence.t
        -> [ `Duplicate_key of Key.t | `Ok of 'a t ]

      val of_sequence_or_error :
        (Key.t * 'a) Base__.Sequence.t -> 'a t Base__.Or_error.t

      val of_sequence_exn : (Key.t * 'a) Base__.Sequence.t -> 'a t

      val of_sequence_multi : (Key.t * 'a) Base__.Sequence.t -> 'a list t

      val of_sequence_fold :
        (Key.t * 'a) Base__.Sequence.t -> init:'b -> f:('b -> 'a -> 'b) -> 'b t

      val of_sequence_reduce :
        (Key.t * 'a) Base__.Sequence.t -> f:('a -> 'a -> 'a) -> 'a t

      val of_iteri :
           iteri:(f:(key:Key.t -> data:'v -> unit) -> unit)
        -> [ `Duplicate_key of Key.t | `Ok of 'v t ]

      val of_tree : 'a Tree.t -> 'a t

      val of_hashtbl_exn : (Key.t, 'a) Addr.Table.hashtbl -> 'a t

      val of_key_set :
        (Key.t, comparator_witness) Base.Set.t -> f:(Key.t -> 'v) -> 'v t

      val quickcheck_generator :
           Key.t Core_kernel__.Quickcheck.Generator.t
        -> 'a Core_kernel__.Quickcheck.Generator.t
        -> 'a t Core_kernel__.Quickcheck.Generator.t

      val invariants : 'a t -> bool

      val is_empty : 'a t -> bool

      val length : 'a t -> int

      val add :
        'a t -> key:Key.t -> data:'a -> 'a t Base__.Map_intf.Or_duplicate.t

      val add_exn : 'a t -> key:Key.t -> data:'a -> 'a t

      val set : 'a t -> key:Key.t -> data:'a -> 'a t

      val add_multi : 'a list t -> key:Key.t -> data:'a -> 'a list t

      val remove_multi : 'a list t -> Key.t -> 'a list t

      val find_multi : 'a list t -> Key.t -> 'a list

      val change : 'a t -> Key.t -> f:('a option -> 'a option) -> 'a t

      val update : 'a t -> Key.t -> f:('a option -> 'a) -> 'a t

      val find : 'a t -> Key.t -> 'a option

      val find_exn : 'a t -> Key.t -> 'a

      val remove : 'a t -> Key.t -> 'a t

      val mem : 'a t -> Key.t -> bool

      val iter_keys : 'a t -> f:(Key.t -> unit) -> unit

      val iter : 'a t -> f:('a -> unit) -> unit

      val iteri : 'a t -> f:(key:Key.t -> data:'a -> unit) -> unit

      val iteri_until :
           'a t
        -> f:(key:Key.t -> data:'a -> Base__.Map_intf.Continue_or_stop.t)
        -> Base__.Map_intf.Finished_or_unfinished.t

      val iter2 :
           'a t
        -> 'b t
        -> f:
             (   key:Key.t
              -> data:[ `Both of 'a * 'b | `Left of 'a | `Right of 'b ]
              -> unit)
        -> unit

      val map : 'a t -> f:('a -> 'b) -> 'b t

      val mapi : 'a t -> f:(key:Key.t -> data:'a -> 'b) -> 'b t

      val fold : 'a t -> init:'b -> f:(key:Key.t -> data:'a -> 'b -> 'b) -> 'b

      val fold_right :
        'a t -> init:'b -> f:(key:Key.t -> data:'a -> 'b -> 'b) -> 'b

      val fold2 :
           'a t
        -> 'b t
        -> init:'c
        -> f:
             (   key:Key.t
              -> data:[ `Both of 'a * 'b | `Left of 'a | `Right of 'b ]
              -> 'c
              -> 'c)
        -> 'c

      val filter_keys : 'a t -> f:(Key.t -> bool) -> 'a t

      val filter : 'a t -> f:('a -> bool) -> 'a t

      val filteri : 'a t -> f:(key:Key.t -> data:'a -> bool) -> 'a t

      val filter_map : 'a t -> f:('a -> 'b option) -> 'b t

      val filter_mapi : 'a t -> f:(key:Key.t -> data:'a -> 'b option) -> 'b t

      val partition_mapi :
           'a t
        -> f:(key:Key.t -> data:'a -> [ `Fst of 'b | `Snd of 'c ])
        -> 'b t * 'c t

      val partition_map :
        'a t -> f:('a -> [ `Fst of 'b | `Snd of 'c ]) -> 'b t * 'c t

      val partitioni_tf :
        'a t -> f:(key:Key.t -> data:'a -> bool) -> 'a t * 'a t

      val partition_tf : 'a t -> f:('a -> bool) -> 'a t * 'a t

      val compare_direct : ('a -> 'a -> int) -> 'a t -> 'a t -> int

      val equal : ('a -> 'a -> bool) -> 'a t -> 'a t -> bool

      val keys : 'a t -> Key.t list

      val data : 'a t -> 'a list

      val to_alist :
        ?key_order:[ `Decreasing | `Increasing ] -> 'a t -> (Key.t * 'a) list

      val validate :
           name:(Key.t -> string)
        -> 'a Base__.Validate.check
        -> 'a t Base__.Validate.check

      val merge :
           'a t
        -> 'b t
        -> f:
             (   key:Key.t
              -> [ `Both of 'a * 'b | `Left of 'a | `Right of 'b ]
              -> 'c option)
        -> 'c t

      val symmetric_diff :
           'a t
        -> 'a t
        -> data_equal:('a -> 'a -> bool)
        -> (Key.t, 'a) Base__.Map_intf.Symmetric_diff_element.t
           Base__.Sequence.t

      val fold_symmetric_diff :
           'a t
        -> 'a t
        -> data_equal:('a -> 'a -> bool)
        -> init:'c
        -> f:('c -> (Key.t, 'a) Base__.Map_intf.Symmetric_diff_element.t -> 'c)
        -> 'c

      val min_elt : 'a t -> (Key.t * 'a) option

      val min_elt_exn : 'a t -> Key.t * 'a

      val max_elt : 'a t -> (Key.t * 'a) option

      val max_elt_exn : 'a t -> Key.t * 'a

      val for_all : 'a t -> f:('a -> bool) -> bool

      val for_alli : 'a t -> f:(key:Key.t -> data:'a -> bool) -> bool

      val exists : 'a t -> f:('a -> bool) -> bool

      val existsi : 'a t -> f:(key:Key.t -> data:'a -> bool) -> bool

      val count : 'a t -> f:('a -> bool) -> int

      val counti : 'a t -> f:(key:Key.t -> data:'a -> bool) -> int

      val split : 'a t -> Key.t -> 'a t * (Key.t * 'a) option * 'a t

      val append :
           lower_part:'a t
        -> upper_part:'a t
        -> [ `Ok of 'a t | `Overlapping_key_ranges ]

      val subrange :
           'a t
        -> lower_bound:Key.t Base__.Maybe_bound.t
        -> upper_bound:Key.t Base__.Maybe_bound.t
        -> 'a t

      val fold_range_inclusive :
           'a t
        -> min:Key.t
        -> max:Key.t
        -> init:'b
        -> f:(key:Key.t -> data:'a -> 'b -> 'b)
        -> 'b

      val range_to_alist : 'a t -> min:Key.t -> max:Key.t -> (Key.t * 'a) list

      val closest_key :
           'a t
        -> [ `Greater_or_equal_to
           | `Greater_than
           | `Less_or_equal_to
           | `Less_than ]
        -> Key.t
        -> (Key.t * 'a) option

      val nth : 'a t -> int -> (Key.t * 'a) option

      val nth_exn : 'a t -> int -> Key.t * 'a

      val rank : 'a t -> Key.t -> int option

      val to_tree : 'a t -> 'a Tree.t

      val to_sequence :
           ?order:[ `Decreasing_key | `Increasing_key ]
        -> ?keys_greater_or_equal_to:Key.t
        -> ?keys_less_or_equal_to:Key.t
        -> 'a t
        -> (Key.t * 'a) Base__.Sequence.t

      val binary_search :
           'a t
        -> compare:(key:Key.t -> data:'a -> 'key -> int)
        -> [ `First_equal_to
           | `First_greater_than_or_equal_to
           | `First_strictly_greater_than
           | `Last_equal_to
           | `Last_less_than_or_equal_to
           | `Last_strictly_less_than ]
        -> 'key
        -> (Key.t * 'a) option

      val binary_search_segmented :
           'a t
        -> segment_of:(key:Key.t -> data:'a -> [ `Left | `Right ])
        -> [ `First_on_right | `Last_on_left ]
        -> (Key.t * 'a) option

      val key_set : 'a t -> (Key.t, comparator_witness) Base.Set.t

      val quickcheck_observer :
           Key.t Core_kernel__.Quickcheck.Observer.t
        -> 'v Core_kernel__.Quickcheck.Observer.t
        -> 'v t Core_kernel__.Quickcheck.Observer.t

      val quickcheck_shrinker :
           Key.t Core_kernel__.Quickcheck.Shrinker.t
        -> 'v Core_kernel__.Quickcheck.Shrinker.t
        -> 'v t Core_kernel__.Quickcheck.Shrinker.t

      module Provide_of_sexp : functor
        (Key : sig
           val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> Key.t
         end)
        -> sig
        val t_of_sexp :
             (Ppx_sexp_conv_lib.Sexp.t -> 'v_x__002_)
          -> Ppx_sexp_conv_lib.Sexp.t
          -> 'v_x__002_ t
      end

      module Provide_bin_io : functor
        (Key : sig
           val bin_size_t : Key.t Bin_prot.Size.sizer

           val bin_write_t : Key.t Bin_prot.Write.writer

           val bin_read_t : Key.t Bin_prot.Read.reader

           val __bin_read_t__ : (int -> Key.t) Bin_prot.Read.reader

           val bin_shape_t : Bin_prot.Shape.t

           val bin_writer_t : Key.t Bin_prot.Type_class.writer

           val bin_reader_t : Key.t Bin_prot.Type_class.reader

           val bin_t : Key.t Bin_prot.Type_class.t
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
           val hash_fold_t : Base__.Hash.state -> Key.t -> Base__.Hash.state
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
        type t = Map.Key.t

        val t_of_sexp : Sexplib0.Sexp.t -> t

        val sexp_of_t : t -> Sexplib0.Sexp.t

        type comparator_witness = Map.Key.comparator_witness

        val comparator :
          (t, comparator_witness) Core_kernel__.Comparator.comparator
      end

      module Tree : sig
        type t = (Elt.t, comparator_witness) Core_kernel__.Set_intf.Tree.t

        val compare : t -> t -> Core_kernel__.Import.int

        type named =
          (Elt.t, comparator_witness) Core_kernel__.Set_intf.Tree.Named.t

        val length : t -> int

        val is_empty : t -> bool

        val iter : t -> f:(Elt.t -> unit) -> unit

        val fold : t -> init:'accum -> f:('accum -> Elt.t -> 'accum) -> 'accum

        val fold_result :
             t
          -> init:'accum
          -> f:('accum -> Elt.t -> ('accum, 'e) Base__.Result.t)
          -> ('accum, 'e) Base__.Result.t

        val exists : t -> f:(Elt.t -> bool) -> bool

        val for_all : t -> f:(Elt.t -> bool) -> bool

        val count : t -> f:(Elt.t -> bool) -> int

        val sum :
             (module Base__.Container_intf.Summable with type t = 'sum)
          -> t
          -> f:(Elt.t -> 'sum)
          -> 'sum

        val find : t -> f:(Elt.t -> bool) -> Elt.t option

        val find_map : t -> f:(Elt.t -> 'a option) -> 'a option

        val to_list : t -> Elt.t list

        val to_array : t -> Elt.t array

        val invariants : t -> bool

        val mem : t -> Elt.t -> bool

        val add : t -> Elt.t -> t

        val remove : t -> Elt.t -> t

        val union : t -> t -> t

        val inter : t -> t -> t

        val diff : t -> t -> t

        val symmetric_diff :
          t -> t -> (Elt.t, Elt.t) Base__.Either.t Base__.Sequence.t

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
          -> f:('b -> Elt.t -> ('b, 'final) Base__.Set_intf.Continue_or_stop.t)
          -> finish:('b -> 'final)
          -> 'final

        val fold_right : t -> init:'b -> f:(Elt.t -> 'b -> 'b) -> 'b

        val iter2 :
             t
          -> t
          -> f:
               (   [ `Both of Elt.t * Elt.t | `Left of Elt.t | `Right of Elt.t ]
                -> unit)
          -> unit

        val filter : t -> f:(Elt.t -> bool) -> t

        val partition_tf : t -> f:(Elt.t -> bool) -> t * t

        val elements : t -> Elt.t list

        val min_elt : t -> Elt.t option

        val min_elt_exn : t -> Elt.t

        val max_elt : t -> Elt.t option

        val max_elt_exn : t -> Elt.t

        val choose : t -> Elt.t option

        val choose_exn : t -> Elt.t

        val split : t -> Elt.t -> t * Elt.t option * t

        val group_by : t -> equiv:(Elt.t -> Elt.t -> bool) -> t list

        val find_exn : t -> f:(Elt.t -> bool) -> Elt.t

        val nth : t -> int -> Elt.t option

        val remove_index : t -> int -> t

        val to_tree : t -> t

        val to_sequence :
             ?order:[ `Decreasing | `Increasing ]
          -> ?greater_or_equal_to:Elt.t
          -> ?less_or_equal_to:Elt.t
          -> t
          -> Elt.t Base__.Sequence.t

        val binary_search :
             t
          -> compare:(Elt.t -> 'key -> int)
          -> [ `First_equal_to
             | `First_greater_than_or_equal_to
             | `First_strictly_greater_than
             | `Last_equal_to
             | `Last_less_than_or_equal_to
             | `Last_strictly_less_than ]
          -> 'key
          -> Elt.t option

        val binary_search_segmented :
             t
          -> segment_of:(Elt.t -> [ `Left | `Right ])
          -> [ `First_on_right | `Last_on_left ]
          -> Elt.t option

        val merge_to_sequence :
             ?order:[ `Decreasing | `Increasing ]
          -> ?greater_or_equal_to:Elt.t
          -> ?less_or_equal_to:Elt.t
          -> t
          -> t
          -> (Elt.t, Elt.t) Base__.Set_intf.Merge_to_sequence_element.t
             Base__.Sequence.t

        val to_map :
             t
          -> f:(Elt.t -> 'data)
          -> (Elt.t, 'data, comparator_witness) Base.Map.t

        val quickcheck_observer :
             Elt.t Core_kernel__.Quickcheck.Observer.t
          -> t Core_kernel__.Quickcheck.Observer.t

        val quickcheck_shrinker :
             Elt.t Core_kernel__.Quickcheck.Shrinker.t
          -> t Core_kernel__.Quickcheck.Shrinker.t

        val empty : t

        val singleton : Elt.t -> t

        val union_list : t list -> t

        val of_list : Elt.t list -> t

        val of_array : Elt.t array -> t

        val of_sorted_array : Elt.t array -> t Base__.Or_error.t

        val of_sorted_array_unchecked : Elt.t array -> t

        val of_increasing_iterator_unchecked : len:int -> f:(int -> Elt.t) -> t

        val stable_dedup_list : Elt.t list -> Elt.t list

        val map : ('a, 'b) Core_kernel__.Set_intf.Tree.t -> f:('a -> Elt.t) -> t

        val filter_map :
          ('a, 'b) Core_kernel__.Set_intf.Tree.t -> f:('a -> Elt.t option) -> t

        val of_tree : t -> t

        val of_hash_set : Elt.t Core_kernel__.Hash_set.t -> t

        val of_hashtbl_keys : (Elt.t, 'a) Addr.Table.hashtbl -> t

        val of_map_keys : (Elt.t, 'a, comparator_witness) Base.Map.t -> t

        val quickcheck_generator :
             Elt.t Core_kernel__.Quickcheck.Generator.t
          -> t Core_kernel__.Quickcheck.Generator.t

        module Provide_of_sexp : functor
          (Elt : sig
             val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> Elt.t
           end)
          -> sig
          val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> t
        end

        val t_of_sexp : Base__.Sexp.t -> t

        val sexp_of_t : t -> Base__.Sexp.t
      end

      type t = (Elt.t, comparator_witness) Base.Set.t

      val compare : t -> t -> Core_kernel__.Import.int

      type named = (Elt.t, comparator_witness) Core_kernel__.Set_intf.Named.t

      val length : t -> int

      val is_empty : t -> bool

      val iter : t -> f:(Elt.t -> unit) -> unit

      val fold : t -> init:'accum -> f:('accum -> Elt.t -> 'accum) -> 'accum

      val fold_result :
           t
        -> init:'accum
        -> f:('accum -> Elt.t -> ('accum, 'e) Base__.Result.t)
        -> ('accum, 'e) Base__.Result.t

      val exists : t -> f:(Elt.t -> bool) -> bool

      val for_all : t -> f:(Elt.t -> bool) -> bool

      val count : t -> f:(Elt.t -> bool) -> int

      val sum :
           (module Base__.Container_intf.Summable with type t = 'sum)
        -> t
        -> f:(Elt.t -> 'sum)
        -> 'sum

      val find : t -> f:(Elt.t -> bool) -> Elt.t option

      val find_map : t -> f:(Elt.t -> 'a option) -> 'a option

      val to_list : t -> Elt.t list

      val to_array : t -> Elt.t array

      val invariants : t -> bool

      val mem : t -> Elt.t -> bool

      val add : t -> Elt.t -> t

      val remove : t -> Elt.t -> t

      val union : t -> t -> t

      val inter : t -> t -> t

      val diff : t -> t -> t

      val symmetric_diff :
        t -> t -> (Elt.t, Elt.t) Base__.Either.t Base__.Sequence.t

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
        -> f:('b -> Elt.t -> ('b, 'final) Base__.Set_intf.Continue_or_stop.t)
        -> finish:('b -> 'final)
        -> 'final

      val fold_right : t -> init:'b -> f:(Elt.t -> 'b -> 'b) -> 'b

      val iter2 :
           t
        -> t
        -> f:
             (   [ `Both of Elt.t * Elt.t | `Left of Elt.t | `Right of Elt.t ]
              -> unit)
        -> unit

      val filter : t -> f:(Elt.t -> bool) -> t

      val partition_tf : t -> f:(Elt.t -> bool) -> t * t

      val elements : t -> Elt.t list

      val min_elt : t -> Elt.t option

      val min_elt_exn : t -> Elt.t

      val max_elt : t -> Elt.t option

      val max_elt_exn : t -> Elt.t

      val choose : t -> Elt.t option

      val choose_exn : t -> Elt.t

      val split : t -> Elt.t -> t * Elt.t option * t

      val group_by : t -> equiv:(Elt.t -> Elt.t -> bool) -> t list

      val find_exn : t -> f:(Elt.t -> bool) -> Elt.t

      val nth : t -> int -> Elt.t option

      val remove_index : t -> int -> t

      val to_tree : t -> Tree.t

      val to_sequence :
           ?order:[ `Decreasing | `Increasing ]
        -> ?greater_or_equal_to:Elt.t
        -> ?less_or_equal_to:Elt.t
        -> t
        -> Elt.t Base__.Sequence.t

      val binary_search :
           t
        -> compare:(Elt.t -> 'key -> int)
        -> [ `First_equal_to
           | `First_greater_than_or_equal_to
           | `First_strictly_greater_than
           | `Last_equal_to
           | `Last_less_than_or_equal_to
           | `Last_strictly_less_than ]
        -> 'key
        -> Elt.t option

      val binary_search_segmented :
           t
        -> segment_of:(Elt.t -> [ `Left | `Right ])
        -> [ `First_on_right | `Last_on_left ]
        -> Elt.t option

      val merge_to_sequence :
           ?order:[ `Decreasing | `Increasing ]
        -> ?greater_or_equal_to:Elt.t
        -> ?less_or_equal_to:Elt.t
        -> t
        -> t
        -> (Elt.t, Elt.t) Base__.Set_intf.Merge_to_sequence_element.t
           Base__.Sequence.t

      val to_map :
        t -> f:(Elt.t -> 'data) -> (Elt.t, 'data, comparator_witness) Base.Map.t

      val quickcheck_observer :
           Elt.t Core_kernel__.Quickcheck.Observer.t
        -> t Core_kernel__.Quickcheck.Observer.t

      val quickcheck_shrinker :
           Elt.t Core_kernel__.Quickcheck.Shrinker.t
        -> t Core_kernel__.Quickcheck.Shrinker.t

      val empty : t

      val singleton : Elt.t -> t

      val union_list : t list -> t

      val of_list : Elt.t list -> t

      val of_array : Elt.t array -> t

      val of_sorted_array : Elt.t array -> t Base__.Or_error.t

      val of_sorted_array_unchecked : Elt.t array -> t

      val of_increasing_iterator_unchecked : len:int -> f:(int -> Elt.t) -> t

      val stable_dedup_list : Elt.t list -> Elt.t list

      val map : ('a, 'b) Base.Set.t -> f:('a -> Elt.t) -> t

      val filter_map : ('a, 'b) Base.Set.t -> f:('a -> Elt.t option) -> t

      val of_tree : Tree.t -> t

      val of_hash_set : Elt.t Core_kernel__.Hash_set.t -> t

      val of_hashtbl_keys : (Elt.t, 'a) Addr.Table.hashtbl -> t

      val of_map_keys : (Elt.t, 'a, comparator_witness) Base.Map.t -> t

      val quickcheck_generator :
           Elt.t Core_kernel__.Quickcheck.Generator.t
        -> t Core_kernel__.Quickcheck.Generator.t

      module Provide_of_sexp : functor
        (Elt : sig
           val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> Elt.t
         end)
        -> sig
        val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> t
      end

      module Provide_bin_io : functor
        (Elt : sig
           val bin_size_t : Elt.t Bin_prot.Size.sizer

           val bin_write_t : Elt.t Bin_prot.Write.writer

           val bin_read_t : Elt.t Bin_prot.Read.reader

           val __bin_read_t__ : (int -> Elt.t) Bin_prot.Read.reader

           val bin_shape_t : Bin_prot.Shape.t

           val bin_writer_t : Elt.t Bin_prot.Type_class.writer

           val bin_reader_t : Elt.t Bin_prot.Type_class.reader

           val bin_t : Elt.t Bin_prot.Type_class.t
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
           val hash_fold_t : Base__.Hash.state -> Elt.t -> Base__.Hash.state
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

  type witness

  val sexp_of_witness : witness -> Ppx_sexp_conv_lib.Sexp.t

  module type Base_intf = sig
    type index = int

    type t

    module Addr : sig
      type t = Location.Addr.t

      val to_yojson : t -> Yojson.Safe.t

      val t_of_sexp : Sexplib0.Sexp.t -> t

      val sexp_of_t : t -> Sexplib0.Sexp.t

      val equal : t -> t -> bool

      val compare : t -> t -> index

      module Stable : sig
        module V1 : sig
          type nonrec t = t

          val to_yojson : t -> Yojson.Safe.t

          val t_of_sexp : Sexplib0.Sexp.t -> t

          val sexp_of_t : t -> Sexplib0.Sexp.t

          val bin_size_t : t Bin_prot.Size.sizer

          val bin_write_t : t Bin_prot.Write.writer

          val bin_read_t : t Bin_prot.Read.reader

          val __bin_read_t__ : (index -> t) Bin_prot.Read.reader

          val bin_shape_t : Bin_prot.Shape.t

          val bin_writer_t : t Bin_prot.Type_class.writer

          val bin_reader_t : t Bin_prot.Type_class.reader

          val bin_t : t Bin_prot.Type_class.t

          val hash_fold_t :
            Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state

          val hash : t -> Ppx_hash_lib.Std.Hash.hash_value

          val equal : t -> t -> bool

          val compare : t -> t -> index

          val __versioned__ : unit
        end

        module Latest : sig
          type nonrec t = t

          val to_yojson : t -> Yojson.Safe.t

          val t_of_sexp : Sexplib0.Sexp.t -> t

          val sexp_of_t : t -> Sexplib0.Sexp.t

          val bin_size_t : t Bin_prot.Size.sizer

          val bin_write_t : t Bin_prot.Write.writer

          val bin_read_t : t Bin_prot.Read.reader

          val __bin_read_t__ : (index -> t) Bin_prot.Read.reader

          val bin_shape_t : Bin_prot.Shape.t

          val bin_writer_t : t Bin_prot.Type_class.writer

          val bin_reader_t : t Bin_prot.Type_class.reader

          val bin_t : t Bin_prot.Type_class.t

          val hash_fold_t :
            Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state

          val hash : t -> Ppx_hash_lib.Std.Hash.hash_value

          val equal : t -> t -> bool

          val compare : t -> t -> index

          val __versioned__ : unit
        end
      end

      val hash_fold_t :
        Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state

      val hash : t -> Ppx_hash_lib.Std.Hash.hash_value

      val hashable : t Core_kernel__.Hashtbl.Hashable.t

      module Table : sig
        type key = t

        type ('a, 'b) hashtbl = ('a, 'b) Location.Addr.Table.hashtbl

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

        val counti : 'b t -> f:(key:key -> data:'b -> bool) -> index

        val count : 'b t -> f:('b -> bool) -> index

        val length : 'a t -> index

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

        val partitioni_tf :
          'b t -> f:(key:key -> data:'b -> bool) -> 'b t * 'b t

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

        type 'a merge_into_action = 'a Location.Addr.Table.merge_into_action =
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

        val incr : ?by:index -> ?remove_if_zero:bool -> index t -> key -> unit

        val decr : ?by:index -> ?remove_if_zero:bool -> index t -> key -> unit

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

             val __bin_read_t__ : (index -> key) Bin_prot.Read.reader

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

          val __bin_read_t__ : ('a, index -> 'a t) Bin_prot.Read.reader1

          val bin_writer_t : ('a, 'a t) Bin_prot.Type_class.S1.writer

          val bin_reader_t : ('a, 'a t) Bin_prot.Type_class.S1.reader

          val bin_t : ('a, 'a t) Bin_prot.Type_class.S1.t
        end

        val t_of_sexp :
             (Ppx_sexp_conv_lib.Sexp.t -> 'v_x__002_)
          -> Ppx_sexp_conv_lib.Sexp.t
          -> 'v_x__002_ t

        val bin_shape_t : Bin_prot.Shape.t -> Bin_prot.Shape.t

        val bin_size_t : ('a, 'a t) Bin_prot.Size.sizer1

        val bin_write_t : ('a, 'a t) Bin_prot.Write.writer1

        val bin_read_t : ('a, 'a t) Bin_prot.Read.reader1

        val __bin_read_t__ : ('a, index -> 'a t) Bin_prot.Read.reader1

        val bin_writer_t : ('a, 'a t) Bin_prot.Type_class.S1.writer

        val bin_reader_t : ('a, 'a t) Bin_prot.Type_class.S1.reader

        val bin_t : ('a, 'a t) Bin_prot.Type_class.S1.t
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

             val __bin_read_t__ : (index -> elt) Bin_prot.Read.reader

             val bin_shape_t : Bin_prot.Shape.t

             val bin_writer_t : elt Bin_prot.Type_class.writer

             val bin_reader_t : elt Bin_prot.Type_class.reader

             val bin_t : elt Bin_prot.Type_class.t
           end)
          -> sig
          val bin_size_t : t Bin_prot.Size.sizer

          val bin_write_t : t Bin_prot.Write.writer

          val bin_read_t : t Bin_prot.Read.reader

          val __bin_read_t__ : (index -> t) Bin_prot.Read.reader

          val bin_shape_t : Bin_prot.Shape.t

          val bin_writer_t : t Bin_prot.Type_class.writer

          val bin_reader_t : t Bin_prot.Type_class.reader

          val bin_t : t Bin_prot.Type_class.t
        end

        val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> t

        val bin_size_t : t Bin_prot.Size.sizer

        val bin_write_t : t Bin_prot.Write.writer

        val bin_read_t : t Bin_prot.Read.reader

        val __bin_read_t__ : (index -> t) Bin_prot.Read.reader

        val bin_shape_t : Bin_prot.Shape.t

        val bin_writer_t : t Bin_prot.Type_class.writer

        val bin_reader_t : t Bin_prot.Type_class.reader

        val bin_t : t Bin_prot.Type_class.t
      end

      module Hash_queue : sig
        type key = t

        val length : ('a, 'b) Core_kernel__.Hash_queue.t -> index

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

        val exists :
          ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> bool) -> bool

        val for_all :
          ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> bool) -> bool

        val count :
          ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> bool) -> index

        val sum :
             (module Base__.Container_intf.Summable with type t = 'sum)
          -> ('b, 'a) Core_kernel__.Hash_queue.t
          -> f:('a -> 'sum)
          -> 'sum

        val find :
          ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> bool) -> 'a option

        val find_map :
             ('c, 'a) Core_kernel__.Hash_queue.t
          -> f:('a -> 'b option)
          -> 'b option

        val to_list : ('b, 'a) Core_kernel__.Hash_queue.t -> 'a list

        val to_array : ('b, 'a) Core_kernel__.Hash_queue.t -> 'a array

        val min_elt :
             ('b, 'a) Core_kernel__.Hash_queue.t
          -> compare:('a -> 'a -> index)
          -> 'a option

        val max_elt :
             ('b, 'a) Core_kernel__.Hash_queue.t
          -> compare:('a -> 'a -> index)
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

        val lookup_exn :
          ('key, 'data) Core_kernel__.Hash_queue.t -> 'key -> 'data

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
             ('key, 'data) Core_kernel__.Hash_queue.t
          -> 'key Core_kernel__.Import.list

        val dequeue :
             ('key, 'data) Core_kernel__.Hash_queue.t
          -> [ `back | `front ]
          -> 'data Core_kernel__.Import.option

        val dequeue_exn :
             ('key, 'data) Core_kernel__.Hash_queue.t
          -> [ `back | `front ]
          -> 'data

        val dequeue_back :
             ('key, 'data) Core_kernel__.Hash_queue.t
          -> 'data Core_kernel__.Import.option

        val dequeue_back_exn : ('key, 'data) Core_kernel__.Hash_queue.t -> 'data

        val dequeue_front :
             ('key, 'data) Core_kernel__.Hash_queue.t
          -> 'data Core_kernel__.Import.option

        val dequeue_front_exn :
          ('key, 'data) Core_kernel__.Hash_queue.t -> 'data

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
             ('key, 'data) Core_kernel__.Hash_queue.t
          -> 'key
          -> [ `No_such_key | `Ok ]

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
             ('data -> Ppx_sexp_conv_lib.Sexp.t)
          -> 'data t
          -> Ppx_sexp_conv_lib.Sexp.t
      end

      val of_byte_string : string -> t

      val of_directions : Direction.t list -> t

      val root : unit -> t

      val slice : t -> index -> index -> t

      val get : t -> index -> index

      val copy : t -> t

      val parent : t -> t Core_kernel.Or_error.t

      val child :
        ledger_depth:index -> t -> Direction.t -> t Core_kernel.Or_error.t

      val child_exn : ledger_depth:index -> t -> Direction.t -> t

      val parent_exn : t -> t

      val dirs_from_root : t -> Direction.t list

      val sibling : t -> t

      val next : t -> t Core_kernel.Option.t

      val prev : t -> t Core_kernel.Option.t

      val is_leaf : ledger_depth:index -> t -> bool

      val is_parent_of : t -> maybe_child:t -> bool

      val serialize : ledger_depth:index -> t -> Core_kernel.Bigstring.t

      val to_string : t -> string

      val pp : Format.formatter -> t -> unit

      module Range : sig
        type nonrec t = t * t

        val fold :
             ?stop:[ `Exclusive | `Inclusive ]
          -> t
          -> init:'a
          -> f:(Table.key -> 'a -> 'a)
          -> 'a

        val subtree_range : ledger_depth:index -> Table.key -> t

        val subtree_range_seq :
          ledger_depth:index -> Table.key -> Table.key Core_kernel.Sequence.t
      end

      val depth : t -> index

      val height : ledger_depth:index -> t -> index

      val to_int : t -> index

      val of_int_exn : ledger_depth:index -> index -> t
    end

    module Path : sig
      type elem = [ `Left of Inputs.Hash.t | `Right of Inputs.Hash.t ]

      val sexp_of_elem : elem -> Ppx_sexp_conv_lib.Sexp.t

      val elem_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> elem

      val __elem_of_sexp__ : Ppx_sexp_conv_lib.Sexp.t -> elem

      val equal_elem : elem -> elem -> bool

      val elem_hash : elem -> Inputs.Hash.t

      type t = elem list

      val t_of_sexp : Sexplib0.Sexp.t -> t

      val sexp_of_t : t -> Sexplib0.Sexp.t

      val equal : t -> t -> bool

      val implied_root : t -> Inputs.Hash.t -> Inputs.Hash.t

      val check_path : t -> Inputs.Hash.t -> Inputs.Hash.t -> bool
    end

    module Location : sig
      module Addr : sig
        type t = Addr.t

        val to_yojson : t -> Yojson.Safe.t

        val t_of_sexp : Sexplib0.Sexp.t -> t

        val sexp_of_t : t -> Sexplib0.Sexp.t

        val equal : t -> t -> bool

        val compare : t -> t -> index

        module Stable : sig
          module V1 : sig
            type nonrec t = t

            val to_yojson : t -> Yojson.Safe.t

            val t_of_sexp : Sexplib0.Sexp.t -> t

            val sexp_of_t : t -> Sexplib0.Sexp.t

            val bin_size_t : t Bin_prot.Size.sizer

            val bin_write_t : t Bin_prot.Write.writer

            val bin_read_t : t Bin_prot.Read.reader

            val __bin_read_t__ : (index -> t) Bin_prot.Read.reader

            val bin_shape_t : Bin_prot.Shape.t

            val bin_writer_t : t Bin_prot.Type_class.writer

            val bin_reader_t : t Bin_prot.Type_class.reader

            val bin_t : t Bin_prot.Type_class.t

            val hash_fold_t :
              Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state

            val hash : t -> Ppx_hash_lib.Std.Hash.hash_value

            val equal : t -> t -> bool

            val compare : t -> t -> index

            val __versioned__ : unit
          end

          module Latest : sig
            type nonrec t = t

            val to_yojson : t -> Yojson.Safe.t

            val t_of_sexp : Sexplib0.Sexp.t -> t

            val sexp_of_t : t -> Sexplib0.Sexp.t

            val bin_size_t : t Bin_prot.Size.sizer

            val bin_write_t : t Bin_prot.Write.writer

            val bin_read_t : t Bin_prot.Read.reader

            val __bin_read_t__ : (index -> t) Bin_prot.Read.reader

            val bin_shape_t : Bin_prot.Shape.t

            val bin_writer_t : t Bin_prot.Type_class.writer

            val bin_reader_t : t Bin_prot.Type_class.reader

            val bin_t : t Bin_prot.Type_class.t

            val hash_fold_t :
              Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state

            val hash : t -> Ppx_hash_lib.Std.Hash.hash_value

            val equal : t -> t -> bool

            val compare : t -> t -> index

            val __versioned__ : unit
          end
        end

        val hash_fold_t :
          Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state

        val hash : t -> Ppx_hash_lib.Std.Hash.hash_value

        val hashable : t Core_kernel__.Hashtbl.Hashable.t

        module Table : sig
          type key = t

          type ('a, 'b) hashtbl = ('a, 'b) Addr.Table.hashtbl

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
            , (key * 'b) list -> [ `Duplicate_keys of key list | `Ok of 'b t ]
            )
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

          val counti : 'b t -> f:(key:key -> data:'b -> bool) -> index

          val count : 'b t -> f:('b -> bool) -> index

          val length : 'a t -> index

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

          val partitioni_tf :
            'b t -> f:(key:key -> data:'b -> bool) -> 'b t * 'b t

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

          type 'a merge_into_action = 'a Addr.Table.merge_into_action =
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

          val incr : ?by:index -> ?remove_if_zero:bool -> index t -> key -> unit

          val decr : ?by:index -> ?remove_if_zero:bool -> index t -> key -> unit

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

               val __bin_read_t__ : (index -> key) Bin_prot.Read.reader

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

            val __bin_read_t__ : ('a, index -> 'a t) Bin_prot.Read.reader1

            val bin_writer_t : ('a, 'a t) Bin_prot.Type_class.S1.writer

            val bin_reader_t : ('a, 'a t) Bin_prot.Type_class.S1.reader

            val bin_t : ('a, 'a t) Bin_prot.Type_class.S1.t
          end

          val t_of_sexp :
               (Ppx_sexp_conv_lib.Sexp.t -> 'v_x__002_)
            -> Ppx_sexp_conv_lib.Sexp.t
            -> 'v_x__002_ t

          val bin_shape_t : Bin_prot.Shape.t -> Bin_prot.Shape.t

          val bin_size_t : ('a, 'a t) Bin_prot.Size.sizer1

          val bin_write_t : ('a, 'a t) Bin_prot.Write.writer1

          val bin_read_t : ('a, 'a t) Bin_prot.Read.reader1

          val __bin_read_t__ : ('a, index -> 'a t) Bin_prot.Read.reader1

          val bin_writer_t : ('a, 'a t) Bin_prot.Type_class.S1.writer

          val bin_reader_t : ('a, 'a t) Bin_prot.Type_class.S1.reader

          val bin_t : ('a, 'a t) Bin_prot.Type_class.S1.t
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
            Core_kernel__.Hash_set_intf
            .create_options_without_first_class_module

          val of_list :
            ( 'a
            , elt list -> t )
            Core_kernel__.Hash_set_intf
            .create_options_without_first_class_module

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

               val __bin_read_t__ : (index -> elt) Bin_prot.Read.reader

               val bin_shape_t : Bin_prot.Shape.t

               val bin_writer_t : elt Bin_prot.Type_class.writer

               val bin_reader_t : elt Bin_prot.Type_class.reader

               val bin_t : elt Bin_prot.Type_class.t
             end)
            -> sig
            val bin_size_t : t Bin_prot.Size.sizer

            val bin_write_t : t Bin_prot.Write.writer

            val bin_read_t : t Bin_prot.Read.reader

            val __bin_read_t__ : (index -> t) Bin_prot.Read.reader

            val bin_shape_t : Bin_prot.Shape.t

            val bin_writer_t : t Bin_prot.Type_class.writer

            val bin_reader_t : t Bin_prot.Type_class.reader

            val bin_t : t Bin_prot.Type_class.t
          end

          val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> t

          val bin_size_t : t Bin_prot.Size.sizer

          val bin_write_t : t Bin_prot.Write.writer

          val bin_read_t : t Bin_prot.Read.reader

          val __bin_read_t__ : (index -> t) Bin_prot.Read.reader

          val bin_shape_t : Bin_prot.Shape.t

          val bin_writer_t : t Bin_prot.Type_class.writer

          val bin_reader_t : t Bin_prot.Type_class.reader

          val bin_t : t Bin_prot.Type_class.t
        end

        module Hash_queue : sig
          type key = t

          val length : ('a, 'b) Core_kernel__.Hash_queue.t -> index

          val is_empty : ('a, 'b) Core_kernel__.Hash_queue.t -> bool

          val iter :
            ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> unit) -> unit

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

          val exists :
            ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> bool) -> bool

          val for_all :
            ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> bool) -> bool

          val count :
            ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> bool) -> index

          val sum :
               (module Base__.Container_intf.Summable with type t = 'sum)
            -> ('b, 'a) Core_kernel__.Hash_queue.t
            -> f:('a -> 'sum)
            -> 'sum

          val find :
            ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> bool) -> 'a option

          val find_map :
               ('c, 'a) Core_kernel__.Hash_queue.t
            -> f:('a -> 'b option)
            -> 'b option

          val to_list : ('b, 'a) Core_kernel__.Hash_queue.t -> 'a list

          val to_array : ('b, 'a) Core_kernel__.Hash_queue.t -> 'a array

          val min_elt :
               ('b, 'a) Core_kernel__.Hash_queue.t
            -> compare:('a -> 'a -> index)
            -> 'a option

          val max_elt :
               ('b, 'a) Core_kernel__.Hash_queue.t
            -> compare:('a -> 'a -> index)
            -> 'a option

          val invariant :
               ('key, 'data) Core_kernel__.Hash_queue.t
            -> Core_kernel__.Import.unit

          val create :
               ?growth_allowed:Core_kernel__.Import.bool
            -> ?size:Core_kernel__.Import.int
            -> Core_kernel__.Import.unit
            -> (t, 'data) Core_kernel__.Hash_queue.t

          val clear :
               ('key, 'data) Core_kernel__.Hash_queue.t
            -> Core_kernel__.Import.unit

          val mem :
               ('key, 'data) Core_kernel__.Hash_queue.t
            -> 'key
            -> Core_kernel__.Import.bool

          val lookup :
               ('key, 'data) Core_kernel__.Hash_queue.t
            -> 'key
            -> 'data Core_kernel__.Import.option

          val lookup_exn :
            ('key, 'data) Core_kernel__.Hash_queue.t -> 'key -> 'data

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
               ('key, 'data) Core_kernel__.Hash_queue.t
            -> 'key Core_kernel__.Import.list

          val dequeue :
               ('key, 'data) Core_kernel__.Hash_queue.t
            -> [ `back | `front ]
            -> 'data Core_kernel__.Import.option

          val dequeue_exn :
               ('key, 'data) Core_kernel__.Hash_queue.t
            -> [ `back | `front ]
            -> 'data

          val dequeue_back :
               ('key, 'data) Core_kernel__.Hash_queue.t
            -> 'data Core_kernel__.Import.option

          val dequeue_back_exn :
            ('key, 'data) Core_kernel__.Hash_queue.t -> 'data

          val dequeue_front :
               ('key, 'data) Core_kernel__.Hash_queue.t
            -> 'data Core_kernel__.Import.option

          val dequeue_front_exn :
            ('key, 'data) Core_kernel__.Hash_queue.t -> 'data

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
               ('key, 'data) Core_kernel__.Hash_queue.t
            -> 'key
            -> [ `No_such_key | `Ok ]

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
               ('data -> Ppx_sexp_conv_lib.Sexp.t)
            -> 'data t
            -> Ppx_sexp_conv_lib.Sexp.t
        end

        val of_byte_string : string -> t

        val of_directions : Direction.t list -> t

        val root : unit -> t

        val slice : t -> index -> index -> t

        val get : t -> index -> index

        val copy : t -> t

        val parent : t -> t Core_kernel.Or_error.t

        val child :
          ledger_depth:index -> t -> Direction.t -> t Core_kernel.Or_error.t

        val child_exn : ledger_depth:index -> t -> Direction.t -> t

        val parent_exn : t -> t

        val dirs_from_root : t -> Direction.t list

        val sibling : t -> t

        val next : t -> t Core_kernel.Option.t

        val prev : t -> t Core_kernel.Option.t

        val is_leaf : ledger_depth:index -> t -> bool

        val is_parent_of : t -> maybe_child:t -> bool

        val serialize : ledger_depth:index -> t -> Core_kernel.Bigstring.t

        val to_string : t -> string

        val pp : Format.formatter -> t -> unit

        module Range : sig
          type nonrec t = t * t

          val fold :
               ?stop:[ `Exclusive | `Inclusive ]
            -> t
            -> init:'a
            -> f:(Table.key -> 'a -> 'a)
            -> 'a

          val subtree_range : ledger_depth:index -> Table.key -> t

          val subtree_range_seq :
            ledger_depth:index -> Table.key -> Table.key Core_kernel.Sequence.t
        end

        val depth : t -> index

        val height : ledger_depth:index -> t -> index

        val to_int : t -> index

        val of_int_exn : ledger_depth:index -> index -> t
      end

      module Prefix : sig
        val generic : Unsigned.UInt8.t

        val account : Unsigned.UInt8.t

        val hash : ledger_depth:index -> index -> Unsigned.UInt8.t
      end

      type t = Location.t =
        | Generic of Core.Bigstring.t
        | Account of Addr.t
        | Hash of Addr.t

      val t_of_sexp : Sexplib0.Sexp.t -> t

      val sexp_of_t : t -> Sexplib0.Sexp.t

      val hash_fold_t :
        Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state

      val hash : t -> Ppx_hash_lib.Std.Hash.hash_value

      val is_generic : t -> bool

      val is_account : t -> bool

      val is_hash : t -> bool

      val height : ledger_depth:index -> t -> index

      val root_hash : t

      val last_direction : Addr.t -> Direction.t

      val build_generic : Core.Bigstring.t -> t

      val parse :
        ledger_depth:index -> Core.Bigstring.t -> (t, unit) Core.Result.t

      val prefix_bigstring :
        Unsigned.UInt8.t -> Core.Bigstring.t -> Core.Bigstring.t

      val to_path_exn : t -> Addr.t

      val serialize : ledger_depth:index -> t -> Core.Bigstring.t

      val parent : t -> t

      val next : t -> t Core.Option.t

      val prev : t -> t Core.Option.t

      val sibling : t -> t

      val order_siblings : t -> 'a -> 'a -> 'a * 'a

      val ( >= ) : t -> t -> bool

      val ( <= ) : t -> t -> bool

      val ( = ) : t -> t -> bool

      val ( > ) : t -> t -> bool

      val ( < ) : t -> t -> bool

      val ( <> ) : t -> t -> bool

      val equal : t -> t -> bool

      val compare : t -> t -> index

      val min : t -> t -> t

      val max : t -> t -> t

      val ascending : t -> t -> index

      val descending : t -> t -> index

      val between : t -> low:t -> high:t -> bool

      val clamp_exn : t -> min:t -> max:t -> t

      val clamp : t -> min:t -> max:t -> t Base__.Or_error.t

      type comparator_witness = Location.comparator_witness

      val comparator : (t, comparator_witness) Base__.Comparator.comparator

      val validate_lbound :
        min:t Base__.Maybe_bound.t -> t Base__.Validate.check

      val validate_ubound :
        max:t Base__.Maybe_bound.t -> t Base__.Validate.check

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

        val compare : t -> t -> index

        val min : t -> t -> t

        val max : t -> t -> t
      end

      module Map : sig
        module Key : sig
          type t = Location.t

          val t_of_sexp : Sexplib0.Sexp.t -> t

          val sexp_of_t : t -> Sexplib0.Sexp.t

          type comparator_witness = Location.comparator_witness

          val comparator :
            (t, comparator_witness) Core_kernel__.Comparator.comparator
        end

        module Tree : sig
          type 'a t =
            (Location.t, 'a, comparator_witness) Core_kernel__.Map_intf.Tree.t

          val empty : 'a t

          val singleton : Location.t -> 'a -> 'a t

          val of_alist :
               (Location.t * 'a) list
            -> [ `Duplicate_key of Location.t | `Ok of 'a t ]

          val of_alist_or_error :
            (Location.t * 'a) list -> 'a t Base__.Or_error.t

          val of_alist_exn : (Location.t * 'a) list -> 'a t

          val of_alist_multi : (Location.t * 'a) list -> 'a list t

          val of_alist_fold :
            (Location.t * 'a) list -> init:'b -> f:('b -> 'a -> 'b) -> 'b t

          val of_alist_reduce :
            (Location.t * 'a) list -> f:('a -> 'a -> 'a) -> 'a t

          val of_sorted_array :
            (Location.t * 'a) array -> 'a t Base__.Or_error.t

          val of_sorted_array_unchecked : (Location.t * 'a) array -> 'a t

          val of_increasing_iterator_unchecked :
            len:index -> f:(index -> Location.t * 'a) -> 'a t

          val of_increasing_sequence :
            (Location.t * 'a) Base__.Sequence.t -> 'a t Base__.Or_error.t

          val of_sequence :
               (Location.t * 'a) Base__.Sequence.t
            -> [ `Duplicate_key of Location.t | `Ok of 'a t ]

          val of_sequence_or_error :
            (Location.t * 'a) Base__.Sequence.t -> 'a t Base__.Or_error.t

          val of_sequence_exn : (Location.t * 'a) Base__.Sequence.t -> 'a t

          val of_sequence_multi :
            (Location.t * 'a) Base__.Sequence.t -> 'a list t

          val of_sequence_fold :
               (Location.t * 'a) Base__.Sequence.t
            -> init:'b
            -> f:('b -> 'a -> 'b)
            -> 'b t

          val of_sequence_reduce :
            (Location.t * 'a) Base__.Sequence.t -> f:('a -> 'a -> 'a) -> 'a t

          val of_iteri :
               iteri:(f:(key:Location.t -> data:'v -> unit) -> unit)
            -> [ `Duplicate_key of Location.t | `Ok of 'v t ]

          val of_tree : 'a t -> 'a t

          val of_hashtbl_exn : (Location.t, 'a) Addr.Table.hashtbl -> 'a t

          val of_key_set :
               (Location.t, comparator_witness) Base.Set.t
            -> f:(Location.t -> 'v)
            -> 'v t

          val quickcheck_generator :
               Location.t Core_kernel__.Quickcheck.Generator.t
            -> 'a Core_kernel__.Quickcheck.Generator.t
            -> 'a t Core_kernel__.Quickcheck.Generator.t

          val invariants : 'a t -> bool

          val is_empty : 'a t -> bool

          val length : 'a t -> index

          val add :
               'a t
            -> key:Location.t
            -> data:'a
            -> 'a t Base__.Map_intf.Or_duplicate.t

          val add_exn : 'a t -> key:Location.t -> data:'a -> 'a t

          val set : 'a t -> key:Location.t -> data:'a -> 'a t

          val add_multi : 'a list t -> key:Location.t -> data:'a -> 'a list t

          val remove_multi : 'a list t -> Location.t -> 'a list t

          val find_multi : 'a list t -> Location.t -> 'a list

          val change : 'a t -> Location.t -> f:('a option -> 'a option) -> 'a t

          val update : 'a t -> Location.t -> f:('a option -> 'a) -> 'a t

          val find : 'a t -> Location.t -> 'a option

          val find_exn : 'a t -> Location.t -> 'a

          val remove : 'a t -> Location.t -> 'a t

          val mem : 'a t -> Location.t -> bool

          val iter_keys : 'a t -> f:(Location.t -> unit) -> unit

          val iter : 'a t -> f:('a -> unit) -> unit

          val iteri : 'a t -> f:(key:Location.t -> data:'a -> unit) -> unit

          val iteri_until :
               'a t
            -> f:
                 (   key:Location.t
                  -> data:'a
                  -> Base__.Map_intf.Continue_or_stop.t)
            -> Base__.Map_intf.Finished_or_unfinished.t

          val iter2 :
               'a t
            -> 'b t
            -> f:
                 (   key:Location.t
                  -> data:[ `Both of 'a * 'b | `Left of 'a | `Right of 'b ]
                  -> unit)
            -> unit

          val map : 'a t -> f:('a -> 'b) -> 'b t

          val mapi : 'a t -> f:(key:Location.t -> data:'a -> 'b) -> 'b t

          val fold :
            'a t -> init:'b -> f:(key:Location.t -> data:'a -> 'b -> 'b) -> 'b

          val fold_right :
            'a t -> init:'b -> f:(key:Location.t -> data:'a -> 'b -> 'b) -> 'b

          val fold2 :
               'a t
            -> 'b t
            -> init:'c
            -> f:
                 (   key:Location.t
                  -> data:[ `Both of 'a * 'b | `Left of 'a | `Right of 'b ]
                  -> 'c
                  -> 'c)
            -> 'c

          val filter_keys : 'a t -> f:(Location.t -> bool) -> 'a t

          val filter : 'a t -> f:('a -> bool) -> 'a t

          val filteri : 'a t -> f:(key:Location.t -> data:'a -> bool) -> 'a t

          val filter_map : 'a t -> f:('a -> 'b option) -> 'b t

          val filter_mapi :
            'a t -> f:(key:Location.t -> data:'a -> 'b option) -> 'b t

          val partition_mapi :
               'a t
            -> f:(key:Location.t -> data:'a -> [ `Fst of 'b | `Snd of 'c ])
            -> 'b t * 'c t

          val partition_map :
            'a t -> f:('a -> [ `Fst of 'b | `Snd of 'c ]) -> 'b t * 'c t

          val partitioni_tf :
            'a t -> f:(key:Location.t -> data:'a -> bool) -> 'a t * 'a t

          val partition_tf : 'a t -> f:('a -> bool) -> 'a t * 'a t

          val compare_direct : ('a -> 'a -> index) -> 'a t -> 'a t -> index

          val equal : ('a -> 'a -> bool) -> 'a t -> 'a t -> bool

          val keys : 'a t -> Location.t list

          val data : 'a t -> 'a list

          val to_alist :
               ?key_order:[ `Decreasing | `Increasing ]
            -> 'a t
            -> (Location.t * 'a) list

          val validate :
               name:(Location.t -> string)
            -> 'a Base__.Validate.check
            -> 'a t Base__.Validate.check

          val merge :
               'a t
            -> 'b t
            -> f:
                 (   key:Location.t
                  -> [ `Both of 'a * 'b | `Left of 'a | `Right of 'b ]
                  -> 'c option)
            -> 'c t

          val symmetric_diff :
               'a t
            -> 'a t
            -> data_equal:('a -> 'a -> bool)
            -> (Location.t, 'a) Base__.Map_intf.Symmetric_diff_element.t
               Base__.Sequence.t

          val fold_symmetric_diff :
               'a t
            -> 'a t
            -> data_equal:('a -> 'a -> bool)
            -> init:'c
            -> f:
                 (   'c
                  -> (Location.t, 'a) Base__.Map_intf.Symmetric_diff_element.t
                  -> 'c)
            -> 'c

          val min_elt : 'a t -> (Location.t * 'a) option

          val min_elt_exn : 'a t -> Location.t * 'a

          val max_elt : 'a t -> (Location.t * 'a) option

          val max_elt_exn : 'a t -> Location.t * 'a

          val for_all : 'a t -> f:('a -> bool) -> bool

          val for_alli : 'a t -> f:(key:Location.t -> data:'a -> bool) -> bool

          val exists : 'a t -> f:('a -> bool) -> bool

          val existsi : 'a t -> f:(key:Location.t -> data:'a -> bool) -> bool

          val count : 'a t -> f:('a -> bool) -> index

          val counti : 'a t -> f:(key:Location.t -> data:'a -> bool) -> index

          val split :
            'a t -> Location.t -> 'a t * (Location.t * 'a) option * 'a t

          val append :
               lower_part:'a t
            -> upper_part:'a t
            -> [ `Ok of 'a t | `Overlapping_key_ranges ]

          val subrange :
               'a t
            -> lower_bound:Location.t Base__.Maybe_bound.t
            -> upper_bound:Location.t Base__.Maybe_bound.t
            -> 'a t

          val fold_range_inclusive :
               'a t
            -> min:Location.t
            -> max:Location.t
            -> init:'b
            -> f:(key:Location.t -> data:'a -> 'b -> 'b)
            -> 'b

          val range_to_alist :
            'a t -> min:Location.t -> max:Location.t -> (Location.t * 'a) list

          val closest_key :
               'a t
            -> [ `Greater_or_equal_to
               | `Greater_than
               | `Less_or_equal_to
               | `Less_than ]
            -> Location.t
            -> (Location.t * 'a) option

          val nth : 'a t -> index -> (Location.t * 'a) option

          val nth_exn : 'a t -> index -> Location.t * 'a

          val rank : 'a t -> Location.t -> index option

          val to_tree : 'a t -> 'a t

          val to_sequence :
               ?order:[ `Decreasing_key | `Increasing_key ]
            -> ?keys_greater_or_equal_to:Location.t
            -> ?keys_less_or_equal_to:Location.t
            -> 'a t
            -> (Location.t * 'a) Base__.Sequence.t

          val binary_search :
               'a t
            -> compare:(key:Location.t -> data:'a -> 'key -> index)
            -> [ `First_equal_to
               | `First_greater_than_or_equal_to
               | `First_strictly_greater_than
               | `Last_equal_to
               | `Last_less_than_or_equal_to
               | `Last_strictly_less_than ]
            -> 'key
            -> (Location.t * 'a) option

          val binary_search_segmented :
               'a t
            -> segment_of:(key:Location.t -> data:'a -> [ `Left | `Right ])
            -> [ `First_on_right | `Last_on_left ]
            -> (Location.t * 'a) option

          val key_set : 'a t -> (Location.t, comparator_witness) Base.Set.t

          val quickcheck_observer :
               Location.t Core_kernel__.Quickcheck.Observer.t
            -> 'v Core_kernel__.Quickcheck.Observer.t
            -> 'v t Core_kernel__.Quickcheck.Observer.t

          val quickcheck_shrinker :
               Location.t Core_kernel__.Quickcheck.Shrinker.t
            -> 'v Core_kernel__.Quickcheck.Shrinker.t
            -> 'v t Core_kernel__.Quickcheck.Shrinker.t

          module Provide_of_sexp : functor
            (K : sig
               val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> Location.t
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

        type 'a t =
          (Location.t, 'a, comparator_witness) Core_kernel__.Map_intf.Map.t

        val compare :
             ('a -> 'a -> Core_kernel__.Import.int)
          -> 'a t
          -> 'a t
          -> Core_kernel__.Import.int

        val empty : 'a t

        val singleton : Location.t -> 'a -> 'a t

        val of_alist :
             (Location.t * 'a) list
          -> [ `Duplicate_key of Location.t | `Ok of 'a t ]

        val of_alist_or_error : (Location.t * 'a) list -> 'a t Base__.Or_error.t

        val of_alist_exn : (Location.t * 'a) list -> 'a t

        val of_alist_multi : (Location.t * 'a) list -> 'a list t

        val of_alist_fold :
          (Location.t * 'a) list -> init:'b -> f:('b -> 'a -> 'b) -> 'b t

        val of_alist_reduce :
          (Location.t * 'a) list -> f:('a -> 'a -> 'a) -> 'a t

        val of_sorted_array : (Location.t * 'a) array -> 'a t Base__.Or_error.t

        val of_sorted_array_unchecked : (Location.t * 'a) array -> 'a t

        val of_increasing_iterator_unchecked :
          len:index -> f:(index -> Location.t * 'a) -> 'a t

        val of_increasing_sequence :
          (Location.t * 'a) Base__.Sequence.t -> 'a t Base__.Or_error.t

        val of_sequence :
             (Location.t * 'a) Base__.Sequence.t
          -> [ `Duplicate_key of Location.t | `Ok of 'a t ]

        val of_sequence_or_error :
          (Location.t * 'a) Base__.Sequence.t -> 'a t Base__.Or_error.t

        val of_sequence_exn : (Location.t * 'a) Base__.Sequence.t -> 'a t

        val of_sequence_multi : (Location.t * 'a) Base__.Sequence.t -> 'a list t

        val of_sequence_fold :
             (Location.t * 'a) Base__.Sequence.t
          -> init:'b
          -> f:('b -> 'a -> 'b)
          -> 'b t

        val of_sequence_reduce :
          (Location.t * 'a) Base__.Sequence.t -> f:('a -> 'a -> 'a) -> 'a t

        val of_iteri :
             iteri:(f:(key:Location.t -> data:'v -> unit) -> unit)
          -> [ `Duplicate_key of Location.t | `Ok of 'v t ]

        val of_tree : 'a Tree.t -> 'a t

        val of_hashtbl_exn : (Location.t, 'a) Addr.Table.hashtbl -> 'a t

        val of_key_set :
             (Location.t, comparator_witness) Base.Set.t
          -> f:(Location.t -> 'v)
          -> 'v t

        val quickcheck_generator :
             Location.t Core_kernel__.Quickcheck.Generator.t
          -> 'a Core_kernel__.Quickcheck.Generator.t
          -> 'a t Core_kernel__.Quickcheck.Generator.t

        val invariants : 'a t -> bool

        val is_empty : 'a t -> bool

        val length : 'a t -> index

        val add :
             'a t
          -> key:Location.t
          -> data:'a
          -> 'a t Base__.Map_intf.Or_duplicate.t

        val add_exn : 'a t -> key:Location.t -> data:'a -> 'a t

        val set : 'a t -> key:Location.t -> data:'a -> 'a t

        val add_multi : 'a list t -> key:Location.t -> data:'a -> 'a list t

        val remove_multi : 'a list t -> Location.t -> 'a list t

        val find_multi : 'a list t -> Location.t -> 'a list

        val change : 'a t -> Location.t -> f:('a option -> 'a option) -> 'a t

        val update : 'a t -> Location.t -> f:('a option -> 'a) -> 'a t

        val find : 'a t -> Location.t -> 'a option

        val find_exn : 'a t -> Location.t -> 'a

        val remove : 'a t -> Location.t -> 'a t

        val mem : 'a t -> Location.t -> bool

        val iter_keys : 'a t -> f:(Location.t -> unit) -> unit

        val iter : 'a t -> f:('a -> unit) -> unit

        val iteri : 'a t -> f:(key:Location.t -> data:'a -> unit) -> unit

        val iteri_until :
             'a t
          -> f:(key:Location.t -> data:'a -> Base__.Map_intf.Continue_or_stop.t)
          -> Base__.Map_intf.Finished_or_unfinished.t

        val iter2 :
             'a t
          -> 'b t
          -> f:
               (   key:Location.t
                -> data:[ `Both of 'a * 'b | `Left of 'a | `Right of 'b ]
                -> unit)
          -> unit

        val map : 'a t -> f:('a -> 'b) -> 'b t

        val mapi : 'a t -> f:(key:Location.t -> data:'a -> 'b) -> 'b t

        val fold :
          'a t -> init:'b -> f:(key:Location.t -> data:'a -> 'b -> 'b) -> 'b

        val fold_right :
          'a t -> init:'b -> f:(key:Location.t -> data:'a -> 'b -> 'b) -> 'b

        val fold2 :
             'a t
          -> 'b t
          -> init:'c
          -> f:
               (   key:Location.t
                -> data:[ `Both of 'a * 'b | `Left of 'a | `Right of 'b ]
                -> 'c
                -> 'c)
          -> 'c

        val filter_keys : 'a t -> f:(Location.t -> bool) -> 'a t

        val filter : 'a t -> f:('a -> bool) -> 'a t

        val filteri : 'a t -> f:(key:Location.t -> data:'a -> bool) -> 'a t

        val filter_map : 'a t -> f:('a -> 'b option) -> 'b t

        val filter_mapi :
          'a t -> f:(key:Location.t -> data:'a -> 'b option) -> 'b t

        val partition_mapi :
             'a t
          -> f:(key:Location.t -> data:'a -> [ `Fst of 'b | `Snd of 'c ])
          -> 'b t * 'c t

        val partition_map :
          'a t -> f:('a -> [ `Fst of 'b | `Snd of 'c ]) -> 'b t * 'c t

        val partitioni_tf :
          'a t -> f:(key:Location.t -> data:'a -> bool) -> 'a t * 'a t

        val partition_tf : 'a t -> f:('a -> bool) -> 'a t * 'a t

        val compare_direct : ('a -> 'a -> index) -> 'a t -> 'a t -> index

        val equal : ('a -> 'a -> bool) -> 'a t -> 'a t -> bool

        val keys : 'a t -> Location.t list

        val data : 'a t -> 'a list

        val to_alist :
             ?key_order:[ `Decreasing | `Increasing ]
          -> 'a t
          -> (Location.t * 'a) list

        val validate :
             name:(Location.t -> string)
          -> 'a Base__.Validate.check
          -> 'a t Base__.Validate.check

        val merge :
             'a t
          -> 'b t
          -> f:
               (   key:Location.t
                -> [ `Both of 'a * 'b | `Left of 'a | `Right of 'b ]
                -> 'c option)
          -> 'c t

        val symmetric_diff :
             'a t
          -> 'a t
          -> data_equal:('a -> 'a -> bool)
          -> (Location.t, 'a) Base__.Map_intf.Symmetric_diff_element.t
             Base__.Sequence.t

        val fold_symmetric_diff :
             'a t
          -> 'a t
          -> data_equal:('a -> 'a -> bool)
          -> init:'c
          -> f:
               (   'c
                -> (Location.t, 'a) Base__.Map_intf.Symmetric_diff_element.t
                -> 'c)
          -> 'c

        val min_elt : 'a t -> (Location.t * 'a) option

        val min_elt_exn : 'a t -> Location.t * 'a

        val max_elt : 'a t -> (Location.t * 'a) option

        val max_elt_exn : 'a t -> Location.t * 'a

        val for_all : 'a t -> f:('a -> bool) -> bool

        val for_alli : 'a t -> f:(key:Location.t -> data:'a -> bool) -> bool

        val exists : 'a t -> f:('a -> bool) -> bool

        val existsi : 'a t -> f:(key:Location.t -> data:'a -> bool) -> bool

        val count : 'a t -> f:('a -> bool) -> index

        val counti : 'a t -> f:(key:Location.t -> data:'a -> bool) -> index

        val split : 'a t -> Location.t -> 'a t * (Location.t * 'a) option * 'a t

        val append :
             lower_part:'a t
          -> upper_part:'a t
          -> [ `Ok of 'a t | `Overlapping_key_ranges ]

        val subrange :
             'a t
          -> lower_bound:Location.t Base__.Maybe_bound.t
          -> upper_bound:Location.t Base__.Maybe_bound.t
          -> 'a t

        val fold_range_inclusive :
             'a t
          -> min:Location.t
          -> max:Location.t
          -> init:'b
          -> f:(key:Location.t -> data:'a -> 'b -> 'b)
          -> 'b

        val range_to_alist :
          'a t -> min:Location.t -> max:Location.t -> (Location.t * 'a) list

        val closest_key :
             'a t
          -> [ `Greater_or_equal_to
             | `Greater_than
             | `Less_or_equal_to
             | `Less_than ]
          -> Location.t
          -> (Location.t * 'a) option

        val nth : 'a t -> index -> (Location.t * 'a) option

        val nth_exn : 'a t -> index -> Location.t * 'a

        val rank : 'a t -> Location.t -> index option

        val to_tree : 'a t -> 'a Tree.t

        val to_sequence :
             ?order:[ `Decreasing_key | `Increasing_key ]
          -> ?keys_greater_or_equal_to:Location.t
          -> ?keys_less_or_equal_to:Location.t
          -> 'a t
          -> (Location.t * 'a) Base__.Sequence.t

        val binary_search :
             'a t
          -> compare:(key:Location.t -> data:'a -> 'key -> index)
          -> [ `First_equal_to
             | `First_greater_than_or_equal_to
             | `First_strictly_greater_than
             | `Last_equal_to
             | `Last_less_than_or_equal_to
             | `Last_strictly_less_than ]
          -> 'key
          -> (Location.t * 'a) option

        val binary_search_segmented :
             'a t
          -> segment_of:(key:Location.t -> data:'a -> [ `Left | `Right ])
          -> [ `First_on_right | `Last_on_left ]
          -> (Location.t * 'a) option

        val key_set : 'a t -> (Location.t, comparator_witness) Base.Set.t

        val quickcheck_observer :
             Location.t Core_kernel__.Quickcheck.Observer.t
          -> 'v Core_kernel__.Quickcheck.Observer.t
          -> 'v t Core_kernel__.Quickcheck.Observer.t

        val quickcheck_shrinker :
             Location.t Core_kernel__.Quickcheck.Shrinker.t
          -> 'v Core_kernel__.Quickcheck.Shrinker.t
          -> 'v t Core_kernel__.Quickcheck.Shrinker.t

        module Provide_of_sexp : functor
          (Key : sig
             val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> Location.t
           end)
          -> sig
          val t_of_sexp :
               (Ppx_sexp_conv_lib.Sexp.t -> 'v_x__002_)
            -> Ppx_sexp_conv_lib.Sexp.t
            -> 'v_x__002_ t
        end

        module Provide_bin_io : functor
          (Key : sig
             val bin_size_t : Location.t Bin_prot.Size.sizer

             val bin_write_t : Location.t Bin_prot.Write.writer

             val bin_read_t : Location.t Bin_prot.Read.reader

             val __bin_read_t__ : (index -> Location.t) Bin_prot.Read.reader

             val bin_shape_t : Bin_prot.Shape.t

             val bin_writer_t : Location.t Bin_prot.Type_class.writer

             val bin_reader_t : Location.t Bin_prot.Type_class.reader

             val bin_t : Location.t Bin_prot.Type_class.t
           end)
          -> sig
          val bin_shape_t : Bin_prot.Shape.t -> Bin_prot.Shape.t

          val bin_size_t : ('a, 'a t) Bin_prot.Size.sizer1

          val bin_write_t : ('a, 'a t) Bin_prot.Write.writer1

          val bin_read_t : ('a, 'a t) Bin_prot.Read.reader1

          val __bin_read_t__ : ('a, index -> 'a t) Bin_prot.Read.reader1

          val bin_writer_t : ('a, 'a t) Bin_prot.Type_class.S1.writer

          val bin_reader_t : ('a, 'a t) Bin_prot.Type_class.S1.reader

          val bin_t : ('a, 'a t) Bin_prot.Type_class.S1.t
        end

        module Provide_hash : functor
          (Key : sig
             val hash_fold_t :
               Base__.Hash.state -> Location.t -> Base__.Hash.state
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
          type t = Location.t

          val t_of_sexp : Sexplib0.Sexp.t -> t

          val sexp_of_t : t -> Sexplib0.Sexp.t

          type comparator_witness = Location.comparator_witness

          val comparator :
            (t, comparator_witness) Core_kernel__.Comparator.comparator
        end

        module Tree : sig
          type t =
            (Location.t, comparator_witness) Core_kernel__.Set_intf.Tree.t

          val compare : t -> t -> Core_kernel__.Import.int

          type named =
            (Location.t, comparator_witness) Core_kernel__.Set_intf.Tree.Named.t

          val length : t -> index

          val is_empty : t -> bool

          val iter : t -> f:(Location.t -> unit) -> unit

          val fold :
            t -> init:'accum -> f:('accum -> Location.t -> 'accum) -> 'accum

          val fold_result :
               t
            -> init:'accum
            -> f:('accum -> Location.t -> ('accum, 'e) Base__.Result.t)
            -> ('accum, 'e) Base__.Result.t

          val exists : t -> f:(Location.t -> bool) -> bool

          val for_all : t -> f:(Location.t -> bool) -> bool

          val count : t -> f:(Location.t -> bool) -> index

          val sum :
               (module Base__.Container_intf.Summable with type t = 'sum)
            -> t
            -> f:(Location.t -> 'sum)
            -> 'sum

          val find : t -> f:(Location.t -> bool) -> Location.t option

          val find_map : t -> f:(Location.t -> 'a option) -> 'a option

          val to_list : t -> Location.t list

          val to_array : t -> Location.t array

          val invariants : t -> bool

          val mem : t -> Location.t -> bool

          val add : t -> Location.t -> t

          val remove : t -> Location.t -> t

          val union : t -> t -> t

          val inter : t -> t -> t

          val diff : t -> t -> t

          val symmetric_diff :
            t -> t -> (Location.t, Location.t) Base__.Either.t Base__.Sequence.t

          val compare_direct : t -> t -> index

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
                  -> Location.t
                  -> ('b, 'final) Base__.Set_intf.Continue_or_stop.t)
            -> finish:('b -> 'final)
            -> 'final

          val fold_right : t -> init:'b -> f:(Location.t -> 'b -> 'b) -> 'b

          val iter2 :
               t
            -> t
            -> f:
                 (   [ `Both of Location.t * Location.t
                     | `Left of Location.t
                     | `Right of Location.t ]
                  -> unit)
            -> unit

          val filter : t -> f:(Location.t -> bool) -> t

          val partition_tf : t -> f:(Location.t -> bool) -> t * t

          val elements : t -> Location.t list

          val min_elt : t -> Location.t option

          val min_elt_exn : t -> Location.t

          val max_elt : t -> Location.t option

          val max_elt_exn : t -> Location.t

          val choose : t -> Location.t option

          val choose_exn : t -> Location.t

          val split : t -> Location.t -> t * Location.t option * t

          val group_by : t -> equiv:(Location.t -> Location.t -> bool) -> t list

          val find_exn : t -> f:(Location.t -> bool) -> Location.t

          val nth : t -> index -> Location.t option

          val remove_index : t -> index -> t

          val to_tree : t -> t

          val to_sequence :
               ?order:[ `Decreasing | `Increasing ]
            -> ?greater_or_equal_to:Location.t
            -> ?less_or_equal_to:Location.t
            -> t
            -> Location.t Base__.Sequence.t

          val binary_search :
               t
            -> compare:(Location.t -> 'key -> index)
            -> [ `First_equal_to
               | `First_greater_than_or_equal_to
               | `First_strictly_greater_than
               | `Last_equal_to
               | `Last_less_than_or_equal_to
               | `Last_strictly_less_than ]
            -> 'key
            -> Location.t option

          val binary_search_segmented :
               t
            -> segment_of:(Location.t -> [ `Left | `Right ])
            -> [ `First_on_right | `Last_on_left ]
            -> Location.t option

          val merge_to_sequence :
               ?order:[ `Decreasing | `Increasing ]
            -> ?greater_or_equal_to:Location.t
            -> ?less_or_equal_to:Location.t
            -> t
            -> t
            -> ( Location.t
               , Location.t )
               Base__.Set_intf.Merge_to_sequence_element.t
               Base__.Sequence.t

          val to_map :
               t
            -> f:(Location.t -> 'data)
            -> (Location.t, 'data, comparator_witness) Base.Map.t

          val quickcheck_observer :
               Location.t Core_kernel__.Quickcheck.Observer.t
            -> t Core_kernel__.Quickcheck.Observer.t

          val quickcheck_shrinker :
               Location.t Core_kernel__.Quickcheck.Shrinker.t
            -> t Core_kernel__.Quickcheck.Shrinker.t

          val empty : t

          val singleton : Location.t -> t

          val union_list : t list -> t

          val of_list : Location.t list -> t

          val of_array : Location.t array -> t

          val of_sorted_array : Location.t array -> t Base__.Or_error.t

          val of_sorted_array_unchecked : Location.t array -> t

          val of_increasing_iterator_unchecked :
            len:index -> f:(index -> Location.t) -> t

          val stable_dedup_list : Location.t list -> Location.t list

          val map :
            ('a, 'b) Core_kernel__.Set_intf.Tree.t -> f:('a -> Location.t) -> t

          val filter_map :
               ('a, 'b) Core_kernel__.Set_intf.Tree.t
            -> f:('a -> Location.t option)
            -> t

          val of_tree : t -> t

          val of_hash_set : Location.t Core_kernel__.Hash_set.t -> t

          val of_hashtbl_keys : (Location.t, 'a) Addr.Table.hashtbl -> t

          val of_map_keys : (Location.t, 'a, comparator_witness) Base.Map.t -> t

          val quickcheck_generator :
               Location.t Core_kernel__.Quickcheck.Generator.t
            -> t Core_kernel__.Quickcheck.Generator.t

          module Provide_of_sexp : functor
            (Elt : sig
               val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> Location.t
             end)
            -> sig
            val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> t
          end

          val t_of_sexp : Base__.Sexp.t -> t

          val sexp_of_t : t -> Base__.Sexp.t
        end

        type t = (Location.t, comparator_witness) Base.Set.t

        val compare : t -> t -> Core_kernel__.Import.int

        type named =
          (Location.t, comparator_witness) Core_kernel__.Set_intf.Named.t

        val length : t -> index

        val is_empty : t -> bool

        val iter : t -> f:(Location.t -> unit) -> unit

        val fold :
          t -> init:'accum -> f:('accum -> Location.t -> 'accum) -> 'accum

        val fold_result :
             t
          -> init:'accum
          -> f:('accum -> Location.t -> ('accum, 'e) Base__.Result.t)
          -> ('accum, 'e) Base__.Result.t

        val exists : t -> f:(Location.t -> bool) -> bool

        val for_all : t -> f:(Location.t -> bool) -> bool

        val count : t -> f:(Location.t -> bool) -> index

        val sum :
             (module Base__.Container_intf.Summable with type t = 'sum)
          -> t
          -> f:(Location.t -> 'sum)
          -> 'sum

        val find : t -> f:(Location.t -> bool) -> Location.t option

        val find_map : t -> f:(Location.t -> 'a option) -> 'a option

        val to_list : t -> Location.t list

        val to_array : t -> Location.t array

        val invariants : t -> bool

        val mem : t -> Location.t -> bool

        val add : t -> Location.t -> t

        val remove : t -> Location.t -> t

        val union : t -> t -> t

        val inter : t -> t -> t

        val diff : t -> t -> t

        val symmetric_diff :
          t -> t -> (Location.t, Location.t) Base__.Either.t Base__.Sequence.t

        val compare_direct : t -> t -> index

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
                -> Location.t
                -> ('b, 'final) Base__.Set_intf.Continue_or_stop.t)
          -> finish:('b -> 'final)
          -> 'final

        val fold_right : t -> init:'b -> f:(Location.t -> 'b -> 'b) -> 'b

        val iter2 :
             t
          -> t
          -> f:
               (   [ `Both of Location.t * Location.t
                   | `Left of Location.t
                   | `Right of Location.t ]
                -> unit)
          -> unit

        val filter : t -> f:(Location.t -> bool) -> t

        val partition_tf : t -> f:(Location.t -> bool) -> t * t

        val elements : t -> Location.t list

        val min_elt : t -> Location.t option

        val min_elt_exn : t -> Location.t

        val max_elt : t -> Location.t option

        val max_elt_exn : t -> Location.t

        val choose : t -> Location.t option

        val choose_exn : t -> Location.t

        val split : t -> Location.t -> t * Location.t option * t

        val group_by : t -> equiv:(Location.t -> Location.t -> bool) -> t list

        val find_exn : t -> f:(Location.t -> bool) -> Location.t

        val nth : t -> index -> Location.t option

        val remove_index : t -> index -> t

        val to_tree : t -> Tree.t

        val to_sequence :
             ?order:[ `Decreasing | `Increasing ]
          -> ?greater_or_equal_to:Location.t
          -> ?less_or_equal_to:Location.t
          -> t
          -> Location.t Base__.Sequence.t

        val binary_search :
             t
          -> compare:(Location.t -> 'key -> index)
          -> [ `First_equal_to
             | `First_greater_than_or_equal_to
             | `First_strictly_greater_than
             | `Last_equal_to
             | `Last_less_than_or_equal_to
             | `Last_strictly_less_than ]
          -> 'key
          -> Location.t option

        val binary_search_segmented :
             t
          -> segment_of:(Location.t -> [ `Left | `Right ])
          -> [ `First_on_right | `Last_on_left ]
          -> Location.t option

        val merge_to_sequence :
             ?order:[ `Decreasing | `Increasing ]
          -> ?greater_or_equal_to:Location.t
          -> ?less_or_equal_to:Location.t
          -> t
          -> t
          -> ( Location.t
             , Location.t )
             Base__.Set_intf.Merge_to_sequence_element.t
             Base__.Sequence.t

        val to_map :
             t
          -> f:(Location.t -> 'data)
          -> (Location.t, 'data, comparator_witness) Base.Map.t

        val quickcheck_observer :
             Location.t Core_kernel__.Quickcheck.Observer.t
          -> t Core_kernel__.Quickcheck.Observer.t

        val quickcheck_shrinker :
             Location.t Core_kernel__.Quickcheck.Shrinker.t
          -> t Core_kernel__.Quickcheck.Shrinker.t

        val empty : t

        val singleton : Location.t -> t

        val union_list : t list -> t

        val of_list : Location.t list -> t

        val of_array : Location.t array -> t

        val of_sorted_array : Location.t array -> t Base__.Or_error.t

        val of_sorted_array_unchecked : Location.t array -> t

        val of_increasing_iterator_unchecked :
          len:index -> f:(index -> Location.t) -> t

        val stable_dedup_list : Location.t list -> Location.t list

        val map : ('a, 'b) Base.Set.t -> f:('a -> Location.t) -> t

        val filter_map : ('a, 'b) Base.Set.t -> f:('a -> Location.t option) -> t

        val of_tree : Tree.t -> t

        val of_hash_set : Location.t Core_kernel__.Hash_set.t -> t

        val of_hashtbl_keys : (Location.t, 'a) Addr.Table.hashtbl -> t

        val of_map_keys : (Location.t, 'a, comparator_witness) Base.Map.t -> t

        val quickcheck_generator :
             Location.t Core_kernel__.Quickcheck.Generator.t
          -> t Core_kernel__.Quickcheck.Generator.t

        module Provide_of_sexp : functor
          (Elt : sig
             val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> Location.t
           end)
          -> sig
          val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> t
        end

        module Provide_bin_io : functor
          (Elt : sig
             val bin_size_t : Location.t Bin_prot.Size.sizer

             val bin_write_t : Location.t Bin_prot.Write.writer

             val bin_read_t : Location.t Bin_prot.Read.reader

             val __bin_read_t__ : (index -> Location.t) Bin_prot.Read.reader

             val bin_shape_t : Bin_prot.Shape.t

             val bin_writer_t : Location.t Bin_prot.Type_class.writer

             val bin_reader_t : Location.t Bin_prot.Type_class.reader

             val bin_t : Location.t Bin_prot.Type_class.t
           end)
          -> sig
          val bin_size_t : t Bin_prot.Size.sizer

          val bin_write_t : t Bin_prot.Write.writer

          val bin_read_t : t Bin_prot.Read.reader

          val __bin_read_t__ : (index -> t) Bin_prot.Read.reader

          val bin_shape_t : Bin_prot.Shape.t

          val bin_writer_t : t Bin_prot.Type_class.writer

          val bin_reader_t : t Bin_prot.Type_class.reader

          val bin_t : t Bin_prot.Type_class.t
        end

        module Provide_hash : functor
          (Elt : sig
             val hash_fold_t :
               Base__.Hash.state -> Location.t -> Base__.Hash.state
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

    val t_of_sexp : Sexplib0.Sexp.t -> t

    val sexp_of_t : t -> Sexplib0.Sexp.t

    type path = Path.t

    val depth : t -> index

    val num_accounts : t -> index

    val merkle_path_at_addr_exn : t -> Addr.t -> path

    val get_inner_hash_at_addr_exn : t -> Addr.t -> Inputs.Hash.t

    val set_inner_hash_at_addr_exn : t -> Addr.t -> Inputs.Hash.t -> unit

    val set_all_accounts_rooted_at_exn :
      t -> Addr.t -> Inputs.Account.t list -> unit

    val set_batch_accounts : t -> (Addr.t * Inputs.Account.t) list -> unit

    val get_all_accounts_rooted_at_exn :
      t -> Addr.t -> (Addr.t * Inputs.Account.t) list

    val make_space_for : t -> index -> unit

    val to_list : t -> Inputs.Account.t list

    val iteri : t -> f:(index -> Inputs.Account.t -> unit) -> unit

    val foldi :
         t
      -> init:'accum
      -> f:(Addr.t -> 'accum -> Inputs.Account.t -> 'accum)
      -> 'accum

    val foldi_with_ignored_accounts :
         t
      -> Inputs.Account_id.Set.t
      -> init:'accum
      -> f:(Addr.t -> 'accum -> Inputs.Account.t -> 'accum)
      -> 'accum

    val fold_until :
         t
      -> init:'accum
      -> f:
           (   'accum
            -> Inputs.Account.t
            -> ('accum, 'stop) Base.Continue_or_stop.t)
      -> finish:('accum -> 'stop)
      -> 'stop

    val accounts : t -> Inputs.Account_id.Set.t

    val token_owner : t -> Inputs.Token_id.t -> Inputs.Key.t option

    val token_owners : t -> Inputs.Account_id.Set.t

    val tokens : t -> Inputs.Key.t -> Inputs.Token_id.Set.t

    val next_available_token : t -> Inputs.Token_id.t

    val set_next_available_token : t -> Inputs.Token_id.t -> unit

    val location_of_account : t -> Inputs.Account_id.t -> Location.t option

    val location_of_account_batch :
         t
      -> Inputs.Account_id.t list
      -> (Inputs.Account_id.t * Location.t option) list

    val get_or_create_account :
         t
      -> Inputs.Account_id.t
      -> Inputs.Account.t
      -> ([ `Added | `Existed ] * Location.t) Core.Or_error.t

    val close : t -> unit

    val last_filled : t -> Location.t option

    val get_uuid : t -> Uuid.t

    val get_directory : t -> string option

    val get : t -> Location.t -> Inputs.Account.t option

    val get_batch :
      t -> Location.t list -> (Location.t * Inputs.Account.t option) list

    val set : t -> Location.t -> Inputs.Account.t -> unit

    val set_batch : t -> (Location.t * Inputs.Account.t) list -> unit

    val get_at_index_exn : t -> index -> Inputs.Account.t

    val set_at_index_exn : t -> index -> Inputs.Account.t -> unit

    val index_of_account_exn : t -> Inputs.Account_id.t -> index

    val merkle_root : t -> Inputs.Hash.t

    val merkle_path : t -> Location.t -> path

    val merkle_path_at_index_exn : t -> index -> path

    val remove_accounts_exn : t -> Inputs.Account_id.t list -> unit

    val detached_signal : t -> unit Async.Deferred.t
  end

  val cast : (module Base_intf with type t = 'a) -> 'a -> witness

  module M : sig
    type index = int

    type t = witness

    module Addr : sig
      type t = Location.Addr.t

      val to_yojson : t -> Yojson.Safe.t

      val t_of_sexp : Sexplib0.Sexp.t -> t

      val sexp_of_t : t -> Sexplib0.Sexp.t

      val equal : t -> t -> bool

      val compare : t -> t -> index

      module Stable : sig
        module V1 : sig
          type nonrec t = t

          val to_yojson : t -> Yojson.Safe.t

          val t_of_sexp : Sexplib0.Sexp.t -> t

          val sexp_of_t : t -> Sexplib0.Sexp.t

          val bin_size_t : t Bin_prot.Size.sizer

          val bin_write_t : t Bin_prot.Write.writer

          val bin_read_t : t Bin_prot.Read.reader

          val __bin_read_t__ : (index -> t) Bin_prot.Read.reader

          val bin_shape_t : Bin_prot.Shape.t

          val bin_writer_t : t Bin_prot.Type_class.writer

          val bin_reader_t : t Bin_prot.Type_class.reader

          val bin_t : t Bin_prot.Type_class.t

          val hash_fold_t :
            Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state

          val hash : t -> Ppx_hash_lib.Std.Hash.hash_value

          val equal : t -> t -> bool

          val compare : t -> t -> index

          val __versioned__ : unit
        end

        module Latest : sig
          type nonrec t = t

          val to_yojson : t -> Yojson.Safe.t

          val t_of_sexp : Sexplib0.Sexp.t -> t

          val sexp_of_t : t -> Sexplib0.Sexp.t

          val bin_size_t : t Bin_prot.Size.sizer

          val bin_write_t : t Bin_prot.Write.writer

          val bin_read_t : t Bin_prot.Read.reader

          val __bin_read_t__ : (index -> t) Bin_prot.Read.reader

          val bin_shape_t : Bin_prot.Shape.t

          val bin_writer_t : t Bin_prot.Type_class.writer

          val bin_reader_t : t Bin_prot.Type_class.reader

          val bin_t : t Bin_prot.Type_class.t

          val hash_fold_t :
            Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state

          val hash : t -> Ppx_hash_lib.Std.Hash.hash_value

          val equal : t -> t -> bool

          val compare : t -> t -> index

          val __versioned__ : unit
        end
      end

      val hash_fold_t :
        Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state

      val hash : t -> Ppx_hash_lib.Std.Hash.hash_value

      val hashable : t Core_kernel__.Hashtbl.Hashable.t

      module Table : sig
        type key = t

        type ('a, 'b) hashtbl = ('a, 'b) Location.Addr.Table.hashtbl

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

        val counti : 'b t -> f:(key:key -> data:'b -> bool) -> index

        val count : 'b t -> f:('b -> bool) -> index

        val length : 'a t -> index

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

        val partitioni_tf :
          'b t -> f:(key:key -> data:'b -> bool) -> 'b t * 'b t

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

        type 'a merge_into_action = 'a Location.Addr.Table.merge_into_action =
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

        val incr : ?by:index -> ?remove_if_zero:bool -> index t -> key -> unit

        val decr : ?by:index -> ?remove_if_zero:bool -> index t -> key -> unit

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

             val __bin_read_t__ : (index -> key) Bin_prot.Read.reader

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

          val __bin_read_t__ : ('a, index -> 'a t) Bin_prot.Read.reader1

          val bin_writer_t : ('a, 'a t) Bin_prot.Type_class.S1.writer

          val bin_reader_t : ('a, 'a t) Bin_prot.Type_class.S1.reader

          val bin_t : ('a, 'a t) Bin_prot.Type_class.S1.t
        end

        val t_of_sexp :
             (Ppx_sexp_conv_lib.Sexp.t -> 'v_x__002_)
          -> Ppx_sexp_conv_lib.Sexp.t
          -> 'v_x__002_ t

        val bin_shape_t : Bin_prot.Shape.t -> Bin_prot.Shape.t

        val bin_size_t : ('a, 'a t) Bin_prot.Size.sizer1

        val bin_write_t : ('a, 'a t) Bin_prot.Write.writer1

        val bin_read_t : ('a, 'a t) Bin_prot.Read.reader1

        val __bin_read_t__ : ('a, index -> 'a t) Bin_prot.Read.reader1

        val bin_writer_t : ('a, 'a t) Bin_prot.Type_class.S1.writer

        val bin_reader_t : ('a, 'a t) Bin_prot.Type_class.S1.reader

        val bin_t : ('a, 'a t) Bin_prot.Type_class.S1.t
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

             val __bin_read_t__ : (index -> elt) Bin_prot.Read.reader

             val bin_shape_t : Bin_prot.Shape.t

             val bin_writer_t : elt Bin_prot.Type_class.writer

             val bin_reader_t : elt Bin_prot.Type_class.reader

             val bin_t : elt Bin_prot.Type_class.t
           end)
          -> sig
          val bin_size_t : t Bin_prot.Size.sizer

          val bin_write_t : t Bin_prot.Write.writer

          val bin_read_t : t Bin_prot.Read.reader

          val __bin_read_t__ : (index -> t) Bin_prot.Read.reader

          val bin_shape_t : Bin_prot.Shape.t

          val bin_writer_t : t Bin_prot.Type_class.writer

          val bin_reader_t : t Bin_prot.Type_class.reader

          val bin_t : t Bin_prot.Type_class.t
        end

        val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> t

        val bin_size_t : t Bin_prot.Size.sizer

        val bin_write_t : t Bin_prot.Write.writer

        val bin_read_t : t Bin_prot.Read.reader

        val __bin_read_t__ : (index -> t) Bin_prot.Read.reader

        val bin_shape_t : Bin_prot.Shape.t

        val bin_writer_t : t Bin_prot.Type_class.writer

        val bin_reader_t : t Bin_prot.Type_class.reader

        val bin_t : t Bin_prot.Type_class.t
      end

      module Hash_queue : sig
        type key = t

        val length : ('a, 'b) Core_kernel__.Hash_queue.t -> index

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

        val exists :
          ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> bool) -> bool

        val for_all :
          ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> bool) -> bool

        val count :
          ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> bool) -> index

        val sum :
             (module Base__.Container_intf.Summable with type t = 'sum)
          -> ('b, 'a) Core_kernel__.Hash_queue.t
          -> f:('a -> 'sum)
          -> 'sum

        val find :
          ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> bool) -> 'a option

        val find_map :
             ('c, 'a) Core_kernel__.Hash_queue.t
          -> f:('a -> 'b option)
          -> 'b option

        val to_list : ('b, 'a) Core_kernel__.Hash_queue.t -> 'a list

        val to_array : ('b, 'a) Core_kernel__.Hash_queue.t -> 'a array

        val min_elt :
             ('b, 'a) Core_kernel__.Hash_queue.t
          -> compare:('a -> 'a -> index)
          -> 'a option

        val max_elt :
             ('b, 'a) Core_kernel__.Hash_queue.t
          -> compare:('a -> 'a -> index)
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

        val lookup_exn :
          ('key, 'data) Core_kernel__.Hash_queue.t -> 'key -> 'data

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
             ('key, 'data) Core_kernel__.Hash_queue.t
          -> 'key Core_kernel__.Import.list

        val dequeue :
             ('key, 'data) Core_kernel__.Hash_queue.t
          -> [ `back | `front ]
          -> 'data Core_kernel__.Import.option

        val dequeue_exn :
             ('key, 'data) Core_kernel__.Hash_queue.t
          -> [ `back | `front ]
          -> 'data

        val dequeue_back :
             ('key, 'data) Core_kernel__.Hash_queue.t
          -> 'data Core_kernel__.Import.option

        val dequeue_back_exn : ('key, 'data) Core_kernel__.Hash_queue.t -> 'data

        val dequeue_front :
             ('key, 'data) Core_kernel__.Hash_queue.t
          -> 'data Core_kernel__.Import.option

        val dequeue_front_exn :
          ('key, 'data) Core_kernel__.Hash_queue.t -> 'data

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
             ('key, 'data) Core_kernel__.Hash_queue.t
          -> 'key
          -> [ `No_such_key | `Ok ]

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
             ('data -> Ppx_sexp_conv_lib.Sexp.t)
          -> 'data t
          -> Ppx_sexp_conv_lib.Sexp.t
      end

      val of_byte_string : string -> t

      val of_directions : Direction.t list -> t

      val root : unit -> t

      val slice : t -> index -> index -> t

      val get : t -> index -> index

      val copy : t -> t

      val parent : t -> t Core_kernel.Or_error.t

      val child :
        ledger_depth:index -> t -> Direction.t -> t Core_kernel.Or_error.t

      val child_exn : ledger_depth:index -> t -> Direction.t -> t

      val parent_exn : t -> t

      val dirs_from_root : t -> Direction.t list

      val sibling : t -> t

      val next : t -> t Core_kernel.Option.t

      val prev : t -> t Core_kernel.Option.t

      val is_leaf : ledger_depth:index -> t -> bool

      val is_parent_of : t -> maybe_child:t -> bool

      val serialize : ledger_depth:index -> t -> Core_kernel.Bigstring.t

      val to_string : t -> string

      val pp : Format.formatter -> t -> unit

      module Range : sig
        type nonrec t = t * t

        val fold :
             ?stop:[ `Exclusive | `Inclusive ]
          -> t
          -> init:'a
          -> f:(Table.key -> 'a -> 'a)
          -> 'a

        val subtree_range : ledger_depth:index -> Table.key -> t

        val subtree_range_seq :
          ledger_depth:index -> Table.key -> Table.key Core_kernel.Sequence.t
      end

      val depth : t -> index

      val height : ledger_depth:index -> t -> index

      val to_int : t -> index

      val of_int_exn : ledger_depth:index -> index -> t
    end

    module Path : sig
      type elem = [ `Left of Inputs.Hash.t | `Right of Inputs.Hash.t ]

      val sexp_of_elem : elem -> Ppx_sexp_conv_lib.Sexp.t

      val elem_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> elem

      val __elem_of_sexp__ : Ppx_sexp_conv_lib.Sexp.t -> elem

      val equal_elem : elem -> elem -> bool

      val elem_hash : elem -> Inputs.Hash.t

      type t = elem list

      val t_of_sexp : Sexplib0.Sexp.t -> t

      val sexp_of_t : t -> Sexplib0.Sexp.t

      val equal : t -> t -> bool

      val implied_root : t -> Inputs.Hash.t -> Inputs.Hash.t

      val check_path : t -> Inputs.Hash.t -> Inputs.Hash.t -> bool
    end

    module Location : sig
      module Addr : sig
        type t = Addr.t

        val to_yojson : t -> Yojson.Safe.t

        val t_of_sexp : Sexplib0.Sexp.t -> t

        val sexp_of_t : t -> Sexplib0.Sexp.t

        val equal : t -> t -> bool

        val compare : t -> t -> index

        module Stable : sig
          module V1 : sig
            type nonrec t = t

            val to_yojson : t -> Yojson.Safe.t

            val t_of_sexp : Sexplib0.Sexp.t -> t

            val sexp_of_t : t -> Sexplib0.Sexp.t

            val bin_size_t : t Bin_prot.Size.sizer

            val bin_write_t : t Bin_prot.Write.writer

            val bin_read_t : t Bin_prot.Read.reader

            val __bin_read_t__ : (index -> t) Bin_prot.Read.reader

            val bin_shape_t : Bin_prot.Shape.t

            val bin_writer_t : t Bin_prot.Type_class.writer

            val bin_reader_t : t Bin_prot.Type_class.reader

            val bin_t : t Bin_prot.Type_class.t

            val hash_fold_t :
              Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state

            val hash : t -> Ppx_hash_lib.Std.Hash.hash_value

            val equal : t -> t -> bool

            val compare : t -> t -> index

            val __versioned__ : unit
          end

          module Latest : sig
            type nonrec t = t

            val to_yojson : t -> Yojson.Safe.t

            val t_of_sexp : Sexplib0.Sexp.t -> t

            val sexp_of_t : t -> Sexplib0.Sexp.t

            val bin_size_t : t Bin_prot.Size.sizer

            val bin_write_t : t Bin_prot.Write.writer

            val bin_read_t : t Bin_prot.Read.reader

            val __bin_read_t__ : (index -> t) Bin_prot.Read.reader

            val bin_shape_t : Bin_prot.Shape.t

            val bin_writer_t : t Bin_prot.Type_class.writer

            val bin_reader_t : t Bin_prot.Type_class.reader

            val bin_t : t Bin_prot.Type_class.t

            val hash_fold_t :
              Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state

            val hash : t -> Ppx_hash_lib.Std.Hash.hash_value

            val equal : t -> t -> bool

            val compare : t -> t -> index

            val __versioned__ : unit
          end
        end

        val hash_fold_t :
          Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state

        val hash : t -> Ppx_hash_lib.Std.Hash.hash_value

        val hashable : t Core_kernel__.Hashtbl.Hashable.t

        module Table : sig
          type key = t

          type ('a, 'b) hashtbl = ('a, 'b) Addr.Table.hashtbl

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
            , (key * 'b) list -> [ `Duplicate_keys of key list | `Ok of 'b t ]
            )
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

          val counti : 'b t -> f:(key:key -> data:'b -> bool) -> index

          val count : 'b t -> f:('b -> bool) -> index

          val length : 'a t -> index

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

          val partitioni_tf :
            'b t -> f:(key:key -> data:'b -> bool) -> 'b t * 'b t

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

          type 'a merge_into_action = 'a Addr.Table.merge_into_action =
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

          val incr : ?by:index -> ?remove_if_zero:bool -> index t -> key -> unit

          val decr : ?by:index -> ?remove_if_zero:bool -> index t -> key -> unit

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

               val __bin_read_t__ : (index -> key) Bin_prot.Read.reader

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

            val __bin_read_t__ : ('a, index -> 'a t) Bin_prot.Read.reader1

            val bin_writer_t : ('a, 'a t) Bin_prot.Type_class.S1.writer

            val bin_reader_t : ('a, 'a t) Bin_prot.Type_class.S1.reader

            val bin_t : ('a, 'a t) Bin_prot.Type_class.S1.t
          end

          val t_of_sexp :
               (Ppx_sexp_conv_lib.Sexp.t -> 'v_x__002_)
            -> Ppx_sexp_conv_lib.Sexp.t
            -> 'v_x__002_ t

          val bin_shape_t : Bin_prot.Shape.t -> Bin_prot.Shape.t

          val bin_size_t : ('a, 'a t) Bin_prot.Size.sizer1

          val bin_write_t : ('a, 'a t) Bin_prot.Write.writer1

          val bin_read_t : ('a, 'a t) Bin_prot.Read.reader1

          val __bin_read_t__ : ('a, index -> 'a t) Bin_prot.Read.reader1

          val bin_writer_t : ('a, 'a t) Bin_prot.Type_class.S1.writer

          val bin_reader_t : ('a, 'a t) Bin_prot.Type_class.S1.reader

          val bin_t : ('a, 'a t) Bin_prot.Type_class.S1.t
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
            Core_kernel__.Hash_set_intf
            .create_options_without_first_class_module

          val of_list :
            ( 'a
            , elt list -> t )
            Core_kernel__.Hash_set_intf
            .create_options_without_first_class_module

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

               val __bin_read_t__ : (index -> elt) Bin_prot.Read.reader

               val bin_shape_t : Bin_prot.Shape.t

               val bin_writer_t : elt Bin_prot.Type_class.writer

               val bin_reader_t : elt Bin_prot.Type_class.reader

               val bin_t : elt Bin_prot.Type_class.t
             end)
            -> sig
            val bin_size_t : t Bin_prot.Size.sizer

            val bin_write_t : t Bin_prot.Write.writer

            val bin_read_t : t Bin_prot.Read.reader

            val __bin_read_t__ : (index -> t) Bin_prot.Read.reader

            val bin_shape_t : Bin_prot.Shape.t

            val bin_writer_t : t Bin_prot.Type_class.writer

            val bin_reader_t : t Bin_prot.Type_class.reader

            val bin_t : t Bin_prot.Type_class.t
          end

          val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> t

          val bin_size_t : t Bin_prot.Size.sizer

          val bin_write_t : t Bin_prot.Write.writer

          val bin_read_t : t Bin_prot.Read.reader

          val __bin_read_t__ : (index -> t) Bin_prot.Read.reader

          val bin_shape_t : Bin_prot.Shape.t

          val bin_writer_t : t Bin_prot.Type_class.writer

          val bin_reader_t : t Bin_prot.Type_class.reader

          val bin_t : t Bin_prot.Type_class.t
        end

        module Hash_queue : sig
          type key = t

          val length : ('a, 'b) Core_kernel__.Hash_queue.t -> index

          val is_empty : ('a, 'b) Core_kernel__.Hash_queue.t -> bool

          val iter :
            ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> unit) -> unit

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

          val exists :
            ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> bool) -> bool

          val for_all :
            ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> bool) -> bool

          val count :
            ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> bool) -> index

          val sum :
               (module Base__.Container_intf.Summable with type t = 'sum)
            -> ('b, 'a) Core_kernel__.Hash_queue.t
            -> f:('a -> 'sum)
            -> 'sum

          val find :
            ('b, 'a) Core_kernel__.Hash_queue.t -> f:('a -> bool) -> 'a option

          val find_map :
               ('c, 'a) Core_kernel__.Hash_queue.t
            -> f:('a -> 'b option)
            -> 'b option

          val to_list : ('b, 'a) Core_kernel__.Hash_queue.t -> 'a list

          val to_array : ('b, 'a) Core_kernel__.Hash_queue.t -> 'a array

          val min_elt :
               ('b, 'a) Core_kernel__.Hash_queue.t
            -> compare:('a -> 'a -> index)
            -> 'a option

          val max_elt :
               ('b, 'a) Core_kernel__.Hash_queue.t
            -> compare:('a -> 'a -> index)
            -> 'a option

          val invariant :
               ('key, 'data) Core_kernel__.Hash_queue.t
            -> Core_kernel__.Import.unit

          val create :
               ?growth_allowed:Core_kernel__.Import.bool
            -> ?size:Core_kernel__.Import.int
            -> Core_kernel__.Import.unit
            -> (t, 'data) Core_kernel__.Hash_queue.t

          val clear :
               ('key, 'data) Core_kernel__.Hash_queue.t
            -> Core_kernel__.Import.unit

          val mem :
               ('key, 'data) Core_kernel__.Hash_queue.t
            -> 'key
            -> Core_kernel__.Import.bool

          val lookup :
               ('key, 'data) Core_kernel__.Hash_queue.t
            -> 'key
            -> 'data Core_kernel__.Import.option

          val lookup_exn :
            ('key, 'data) Core_kernel__.Hash_queue.t -> 'key -> 'data

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
               ('key, 'data) Core_kernel__.Hash_queue.t
            -> 'key Core_kernel__.Import.list

          val dequeue :
               ('key, 'data) Core_kernel__.Hash_queue.t
            -> [ `back | `front ]
            -> 'data Core_kernel__.Import.option

          val dequeue_exn :
               ('key, 'data) Core_kernel__.Hash_queue.t
            -> [ `back | `front ]
            -> 'data

          val dequeue_back :
               ('key, 'data) Core_kernel__.Hash_queue.t
            -> 'data Core_kernel__.Import.option

          val dequeue_back_exn :
            ('key, 'data) Core_kernel__.Hash_queue.t -> 'data

          val dequeue_front :
               ('key, 'data) Core_kernel__.Hash_queue.t
            -> 'data Core_kernel__.Import.option

          val dequeue_front_exn :
            ('key, 'data) Core_kernel__.Hash_queue.t -> 'data

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
               ('key, 'data) Core_kernel__.Hash_queue.t
            -> 'key
            -> [ `No_such_key | `Ok ]

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
               ('data -> Ppx_sexp_conv_lib.Sexp.t)
            -> 'data t
            -> Ppx_sexp_conv_lib.Sexp.t
        end

        val of_byte_string : string -> t

        val of_directions : Direction.t list -> t

        val root : unit -> t

        val slice : t -> index -> index -> t

        val get : t -> index -> index

        val copy : t -> t

        val parent : t -> t Core_kernel.Or_error.t

        val child :
          ledger_depth:index -> t -> Direction.t -> t Core_kernel.Or_error.t

        val child_exn : ledger_depth:index -> t -> Direction.t -> t

        val parent_exn : t -> t

        val dirs_from_root : t -> Direction.t list

        val sibling : t -> t

        val next : t -> t Core_kernel.Option.t

        val prev : t -> t Core_kernel.Option.t

        val is_leaf : ledger_depth:index -> t -> bool

        val is_parent_of : t -> maybe_child:t -> bool

        val serialize : ledger_depth:index -> t -> Core_kernel.Bigstring.t

        val to_string : t -> string

        val pp : Format.formatter -> t -> unit

        module Range : sig
          type nonrec t = t * t

          val fold :
               ?stop:[ `Exclusive | `Inclusive ]
            -> t
            -> init:'a
            -> f:(Table.key -> 'a -> 'a)
            -> 'a

          val subtree_range : ledger_depth:index -> Table.key -> t

          val subtree_range_seq :
            ledger_depth:index -> Table.key -> Table.key Core_kernel.Sequence.t
        end

        val depth : t -> index

        val height : ledger_depth:index -> t -> index

        val to_int : t -> index

        val of_int_exn : ledger_depth:index -> index -> t
      end

      module Prefix : sig
        val generic : Unsigned.UInt8.t

        val account : Unsigned.UInt8.t

        val hash : ledger_depth:index -> index -> Unsigned.UInt8.t
      end

      type t = Location.t =
        | Generic of Core.Bigstring.t
        | Account of Addr.t
        | Hash of Addr.t

      val t_of_sexp : Sexplib0.Sexp.t -> t

      val sexp_of_t : t -> Sexplib0.Sexp.t

      val hash_fold_t :
        Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state

      val hash : t -> Ppx_hash_lib.Std.Hash.hash_value

      val is_generic : t -> bool

      val is_account : t -> bool

      val is_hash : t -> bool

      val height : ledger_depth:index -> t -> index

      val root_hash : t

      val last_direction : Addr.t -> Direction.t

      val build_generic : Core.Bigstring.t -> t

      val parse :
        ledger_depth:index -> Core.Bigstring.t -> (t, unit) Core.Result.t

      val prefix_bigstring :
        Unsigned.UInt8.t -> Core.Bigstring.t -> Core.Bigstring.t

      val to_path_exn : t -> Addr.t

      val serialize : ledger_depth:index -> t -> Core.Bigstring.t

      val parent : t -> t

      val next : t -> t Core.Option.t

      val prev : t -> t Core.Option.t

      val sibling : t -> t

      val order_siblings : t -> 'a -> 'a -> 'a * 'a

      val ( >= ) : t -> t -> bool

      val ( <= ) : t -> t -> bool

      val ( = ) : t -> t -> bool

      val ( > ) : t -> t -> bool

      val ( < ) : t -> t -> bool

      val ( <> ) : t -> t -> bool

      val equal : t -> t -> bool

      val compare : t -> t -> index

      val min : t -> t -> t

      val max : t -> t -> t

      val ascending : t -> t -> index

      val descending : t -> t -> index

      val between : t -> low:t -> high:t -> bool

      val clamp_exn : t -> min:t -> max:t -> t

      val clamp : t -> min:t -> max:t -> t Base__.Or_error.t

      type comparator_witness = Location.comparator_witness

      val comparator : (t, comparator_witness) Base__.Comparator.comparator

      val validate_lbound :
        min:t Base__.Maybe_bound.t -> t Base__.Validate.check

      val validate_ubound :
        max:t Base__.Maybe_bound.t -> t Base__.Validate.check

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

        val compare : t -> t -> index

        val min : t -> t -> t

        val max : t -> t -> t
      end

      module Map : sig
        module Key : sig
          type t = Location.t

          val t_of_sexp : Sexplib0.Sexp.t -> t

          val sexp_of_t : t -> Sexplib0.Sexp.t

          type comparator_witness = Location.comparator_witness

          val comparator :
            (t, comparator_witness) Core_kernel__.Comparator.comparator
        end

        module Tree : sig
          type 'a t =
            (Location.t, 'a, comparator_witness) Core_kernel__.Map_intf.Tree.t

          val empty : 'a t

          val singleton : Location.t -> 'a -> 'a t

          val of_alist :
               (Location.t * 'a) list
            -> [ `Duplicate_key of Location.t | `Ok of 'a t ]

          val of_alist_or_error :
            (Location.t * 'a) list -> 'a t Base__.Or_error.t

          val of_alist_exn : (Location.t * 'a) list -> 'a t

          val of_alist_multi : (Location.t * 'a) list -> 'a list t

          val of_alist_fold :
            (Location.t * 'a) list -> init:'b -> f:('b -> 'a -> 'b) -> 'b t

          val of_alist_reduce :
            (Location.t * 'a) list -> f:('a -> 'a -> 'a) -> 'a t

          val of_sorted_array :
            (Location.t * 'a) array -> 'a t Base__.Or_error.t

          val of_sorted_array_unchecked : (Location.t * 'a) array -> 'a t

          val of_increasing_iterator_unchecked :
            len:index -> f:(index -> Location.t * 'a) -> 'a t

          val of_increasing_sequence :
            (Location.t * 'a) Base__.Sequence.t -> 'a t Base__.Or_error.t

          val of_sequence :
               (Location.t * 'a) Base__.Sequence.t
            -> [ `Duplicate_key of Location.t | `Ok of 'a t ]

          val of_sequence_or_error :
            (Location.t * 'a) Base__.Sequence.t -> 'a t Base__.Or_error.t

          val of_sequence_exn : (Location.t * 'a) Base__.Sequence.t -> 'a t

          val of_sequence_multi :
            (Location.t * 'a) Base__.Sequence.t -> 'a list t

          val of_sequence_fold :
               (Location.t * 'a) Base__.Sequence.t
            -> init:'b
            -> f:('b -> 'a -> 'b)
            -> 'b t

          val of_sequence_reduce :
            (Location.t * 'a) Base__.Sequence.t -> f:('a -> 'a -> 'a) -> 'a t

          val of_iteri :
               iteri:(f:(key:Location.t -> data:'v -> unit) -> unit)
            -> [ `Duplicate_key of Location.t | `Ok of 'v t ]

          val of_tree : 'a t -> 'a t

          val of_hashtbl_exn : (Location.t, 'a) Addr.Table.hashtbl -> 'a t

          val of_key_set :
               (Location.t, comparator_witness) Base.Set.t
            -> f:(Location.t -> 'v)
            -> 'v t

          val quickcheck_generator :
               Location.t Core_kernel__.Quickcheck.Generator.t
            -> 'a Core_kernel__.Quickcheck.Generator.t
            -> 'a t Core_kernel__.Quickcheck.Generator.t

          val invariants : 'a t -> bool

          val is_empty : 'a t -> bool

          val length : 'a t -> index

          val add :
               'a t
            -> key:Location.t
            -> data:'a
            -> 'a t Base__.Map_intf.Or_duplicate.t

          val add_exn : 'a t -> key:Location.t -> data:'a -> 'a t

          val set : 'a t -> key:Location.t -> data:'a -> 'a t

          val add_multi : 'a list t -> key:Location.t -> data:'a -> 'a list t

          val remove_multi : 'a list t -> Location.t -> 'a list t

          val find_multi : 'a list t -> Location.t -> 'a list

          val change : 'a t -> Location.t -> f:('a option -> 'a option) -> 'a t

          val update : 'a t -> Location.t -> f:('a option -> 'a) -> 'a t

          val find : 'a t -> Location.t -> 'a option

          val find_exn : 'a t -> Location.t -> 'a

          val remove : 'a t -> Location.t -> 'a t

          val mem : 'a t -> Location.t -> bool

          val iter_keys : 'a t -> f:(Location.t -> unit) -> unit

          val iter : 'a t -> f:('a -> unit) -> unit

          val iteri : 'a t -> f:(key:Location.t -> data:'a -> unit) -> unit

          val iteri_until :
               'a t
            -> f:
                 (   key:Location.t
                  -> data:'a
                  -> Base__.Map_intf.Continue_or_stop.t)
            -> Base__.Map_intf.Finished_or_unfinished.t

          val iter2 :
               'a t
            -> 'b t
            -> f:
                 (   key:Location.t
                  -> data:[ `Both of 'a * 'b | `Left of 'a | `Right of 'b ]
                  -> unit)
            -> unit

          val map : 'a t -> f:('a -> 'b) -> 'b t

          val mapi : 'a t -> f:(key:Location.t -> data:'a -> 'b) -> 'b t

          val fold :
            'a t -> init:'b -> f:(key:Location.t -> data:'a -> 'b -> 'b) -> 'b

          val fold_right :
            'a t -> init:'b -> f:(key:Location.t -> data:'a -> 'b -> 'b) -> 'b

          val fold2 :
               'a t
            -> 'b t
            -> init:'c
            -> f:
                 (   key:Location.t
                  -> data:[ `Both of 'a * 'b | `Left of 'a | `Right of 'b ]
                  -> 'c
                  -> 'c)
            -> 'c

          val filter_keys : 'a t -> f:(Location.t -> bool) -> 'a t

          val filter : 'a t -> f:('a -> bool) -> 'a t

          val filteri : 'a t -> f:(key:Location.t -> data:'a -> bool) -> 'a t

          val filter_map : 'a t -> f:('a -> 'b option) -> 'b t

          val filter_mapi :
            'a t -> f:(key:Location.t -> data:'a -> 'b option) -> 'b t

          val partition_mapi :
               'a t
            -> f:(key:Location.t -> data:'a -> [ `Fst of 'b | `Snd of 'c ])
            -> 'b t * 'c t

          val partition_map :
            'a t -> f:('a -> [ `Fst of 'b | `Snd of 'c ]) -> 'b t * 'c t

          val partitioni_tf :
            'a t -> f:(key:Location.t -> data:'a -> bool) -> 'a t * 'a t

          val partition_tf : 'a t -> f:('a -> bool) -> 'a t * 'a t

          val compare_direct : ('a -> 'a -> index) -> 'a t -> 'a t -> index

          val equal : ('a -> 'a -> bool) -> 'a t -> 'a t -> bool

          val keys : 'a t -> Location.t list

          val data : 'a t -> 'a list

          val to_alist :
               ?key_order:[ `Decreasing | `Increasing ]
            -> 'a t
            -> (Location.t * 'a) list

          val validate :
               name:(Location.t -> string)
            -> 'a Base__.Validate.check
            -> 'a t Base__.Validate.check

          val merge :
               'a t
            -> 'b t
            -> f:
                 (   key:Location.t
                  -> [ `Both of 'a * 'b | `Left of 'a | `Right of 'b ]
                  -> 'c option)
            -> 'c t

          val symmetric_diff :
               'a t
            -> 'a t
            -> data_equal:('a -> 'a -> bool)
            -> (Location.t, 'a) Base__.Map_intf.Symmetric_diff_element.t
               Base__.Sequence.t

          val fold_symmetric_diff :
               'a t
            -> 'a t
            -> data_equal:('a -> 'a -> bool)
            -> init:'c
            -> f:
                 (   'c
                  -> (Location.t, 'a) Base__.Map_intf.Symmetric_diff_element.t
                  -> 'c)
            -> 'c

          val min_elt : 'a t -> (Location.t * 'a) option

          val min_elt_exn : 'a t -> Location.t * 'a

          val max_elt : 'a t -> (Location.t * 'a) option

          val max_elt_exn : 'a t -> Location.t * 'a

          val for_all : 'a t -> f:('a -> bool) -> bool

          val for_alli : 'a t -> f:(key:Location.t -> data:'a -> bool) -> bool

          val exists : 'a t -> f:('a -> bool) -> bool

          val existsi : 'a t -> f:(key:Location.t -> data:'a -> bool) -> bool

          val count : 'a t -> f:('a -> bool) -> index

          val counti : 'a t -> f:(key:Location.t -> data:'a -> bool) -> index

          val split :
            'a t -> Location.t -> 'a t * (Location.t * 'a) option * 'a t

          val append :
               lower_part:'a t
            -> upper_part:'a t
            -> [ `Ok of 'a t | `Overlapping_key_ranges ]

          val subrange :
               'a t
            -> lower_bound:Location.t Base__.Maybe_bound.t
            -> upper_bound:Location.t Base__.Maybe_bound.t
            -> 'a t

          val fold_range_inclusive :
               'a t
            -> min:Location.t
            -> max:Location.t
            -> init:'b
            -> f:(key:Location.t -> data:'a -> 'b -> 'b)
            -> 'b

          val range_to_alist :
            'a t -> min:Location.t -> max:Location.t -> (Location.t * 'a) list

          val closest_key :
               'a t
            -> [ `Greater_or_equal_to
               | `Greater_than
               | `Less_or_equal_to
               | `Less_than ]
            -> Location.t
            -> (Location.t * 'a) option

          val nth : 'a t -> index -> (Location.t * 'a) option

          val nth_exn : 'a t -> index -> Location.t * 'a

          val rank : 'a t -> Location.t -> index option

          val to_tree : 'a t -> 'a t

          val to_sequence :
               ?order:[ `Decreasing_key | `Increasing_key ]
            -> ?keys_greater_or_equal_to:Location.t
            -> ?keys_less_or_equal_to:Location.t
            -> 'a t
            -> (Location.t * 'a) Base__.Sequence.t

          val binary_search :
               'a t
            -> compare:(key:Location.t -> data:'a -> 'key -> index)
            -> [ `First_equal_to
               | `First_greater_than_or_equal_to
               | `First_strictly_greater_than
               | `Last_equal_to
               | `Last_less_than_or_equal_to
               | `Last_strictly_less_than ]
            -> 'key
            -> (Location.t * 'a) option

          val binary_search_segmented :
               'a t
            -> segment_of:(key:Location.t -> data:'a -> [ `Left | `Right ])
            -> [ `First_on_right | `Last_on_left ]
            -> (Location.t * 'a) option

          val key_set : 'a t -> (Location.t, comparator_witness) Base.Set.t

          val quickcheck_observer :
               Location.t Core_kernel__.Quickcheck.Observer.t
            -> 'v Core_kernel__.Quickcheck.Observer.t
            -> 'v t Core_kernel__.Quickcheck.Observer.t

          val quickcheck_shrinker :
               Location.t Core_kernel__.Quickcheck.Shrinker.t
            -> 'v Core_kernel__.Quickcheck.Shrinker.t
            -> 'v t Core_kernel__.Quickcheck.Shrinker.t

          module Provide_of_sexp : functor
            (K : sig
               val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> Location.t
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

        type 'a t =
          (Location.t, 'a, comparator_witness) Core_kernel__.Map_intf.Map.t

        val compare :
             ('a -> 'a -> Core_kernel__.Import.int)
          -> 'a t
          -> 'a t
          -> Core_kernel__.Import.int

        val empty : 'a t

        val singleton : Location.t -> 'a -> 'a t

        val of_alist :
             (Location.t * 'a) list
          -> [ `Duplicate_key of Location.t | `Ok of 'a t ]

        val of_alist_or_error : (Location.t * 'a) list -> 'a t Base__.Or_error.t

        val of_alist_exn : (Location.t * 'a) list -> 'a t

        val of_alist_multi : (Location.t * 'a) list -> 'a list t

        val of_alist_fold :
          (Location.t * 'a) list -> init:'b -> f:('b -> 'a -> 'b) -> 'b t

        val of_alist_reduce :
          (Location.t * 'a) list -> f:('a -> 'a -> 'a) -> 'a t

        val of_sorted_array : (Location.t * 'a) array -> 'a t Base__.Or_error.t

        val of_sorted_array_unchecked : (Location.t * 'a) array -> 'a t

        val of_increasing_iterator_unchecked :
          len:index -> f:(index -> Location.t * 'a) -> 'a t

        val of_increasing_sequence :
          (Location.t * 'a) Base__.Sequence.t -> 'a t Base__.Or_error.t

        val of_sequence :
             (Location.t * 'a) Base__.Sequence.t
          -> [ `Duplicate_key of Location.t | `Ok of 'a t ]

        val of_sequence_or_error :
          (Location.t * 'a) Base__.Sequence.t -> 'a t Base__.Or_error.t

        val of_sequence_exn : (Location.t * 'a) Base__.Sequence.t -> 'a t

        val of_sequence_multi : (Location.t * 'a) Base__.Sequence.t -> 'a list t

        val of_sequence_fold :
             (Location.t * 'a) Base__.Sequence.t
          -> init:'b
          -> f:('b -> 'a -> 'b)
          -> 'b t

        val of_sequence_reduce :
          (Location.t * 'a) Base__.Sequence.t -> f:('a -> 'a -> 'a) -> 'a t

        val of_iteri :
             iteri:(f:(key:Location.t -> data:'v -> unit) -> unit)
          -> [ `Duplicate_key of Location.t | `Ok of 'v t ]

        val of_tree : 'a Tree.t -> 'a t

        val of_hashtbl_exn : (Location.t, 'a) Addr.Table.hashtbl -> 'a t

        val of_key_set :
             (Location.t, comparator_witness) Base.Set.t
          -> f:(Location.t -> 'v)
          -> 'v t

        val quickcheck_generator :
             Location.t Core_kernel__.Quickcheck.Generator.t
          -> 'a Core_kernel__.Quickcheck.Generator.t
          -> 'a t Core_kernel__.Quickcheck.Generator.t

        val invariants : 'a t -> bool

        val is_empty : 'a t -> bool

        val length : 'a t -> index

        val add :
             'a t
          -> key:Location.t
          -> data:'a
          -> 'a t Base__.Map_intf.Or_duplicate.t

        val add_exn : 'a t -> key:Location.t -> data:'a -> 'a t

        val set : 'a t -> key:Location.t -> data:'a -> 'a t

        val add_multi : 'a list t -> key:Location.t -> data:'a -> 'a list t

        val remove_multi : 'a list t -> Location.t -> 'a list t

        val find_multi : 'a list t -> Location.t -> 'a list

        val change : 'a t -> Location.t -> f:('a option -> 'a option) -> 'a t

        val update : 'a t -> Location.t -> f:('a option -> 'a) -> 'a t

        val find : 'a t -> Location.t -> 'a option

        val find_exn : 'a t -> Location.t -> 'a

        val remove : 'a t -> Location.t -> 'a t

        val mem : 'a t -> Location.t -> bool

        val iter_keys : 'a t -> f:(Location.t -> unit) -> unit

        val iter : 'a t -> f:('a -> unit) -> unit

        val iteri : 'a t -> f:(key:Location.t -> data:'a -> unit) -> unit

        val iteri_until :
             'a t
          -> f:(key:Location.t -> data:'a -> Base__.Map_intf.Continue_or_stop.t)
          -> Base__.Map_intf.Finished_or_unfinished.t

        val iter2 :
             'a t
          -> 'b t
          -> f:
               (   key:Location.t
                -> data:[ `Both of 'a * 'b | `Left of 'a | `Right of 'b ]
                -> unit)
          -> unit

        val map : 'a t -> f:('a -> 'b) -> 'b t

        val mapi : 'a t -> f:(key:Location.t -> data:'a -> 'b) -> 'b t

        val fold :
          'a t -> init:'b -> f:(key:Location.t -> data:'a -> 'b -> 'b) -> 'b

        val fold_right :
          'a t -> init:'b -> f:(key:Location.t -> data:'a -> 'b -> 'b) -> 'b

        val fold2 :
             'a t
          -> 'b t
          -> init:'c
          -> f:
               (   key:Location.t
                -> data:[ `Both of 'a * 'b | `Left of 'a | `Right of 'b ]
                -> 'c
                -> 'c)
          -> 'c

        val filter_keys : 'a t -> f:(Location.t -> bool) -> 'a t

        val filter : 'a t -> f:('a -> bool) -> 'a t

        val filteri : 'a t -> f:(key:Location.t -> data:'a -> bool) -> 'a t

        val filter_map : 'a t -> f:('a -> 'b option) -> 'b t

        val filter_mapi :
          'a t -> f:(key:Location.t -> data:'a -> 'b option) -> 'b t

        val partition_mapi :
             'a t
          -> f:(key:Location.t -> data:'a -> [ `Fst of 'b | `Snd of 'c ])
          -> 'b t * 'c t

        val partition_map :
          'a t -> f:('a -> [ `Fst of 'b | `Snd of 'c ]) -> 'b t * 'c t

        val partitioni_tf :
          'a t -> f:(key:Location.t -> data:'a -> bool) -> 'a t * 'a t

        val partition_tf : 'a t -> f:('a -> bool) -> 'a t * 'a t

        val compare_direct : ('a -> 'a -> index) -> 'a t -> 'a t -> index

        val equal : ('a -> 'a -> bool) -> 'a t -> 'a t -> bool

        val keys : 'a t -> Location.t list

        val data : 'a t -> 'a list

        val to_alist :
             ?key_order:[ `Decreasing | `Increasing ]
          -> 'a t
          -> (Location.t * 'a) list

        val validate :
             name:(Location.t -> string)
          -> 'a Base__.Validate.check
          -> 'a t Base__.Validate.check

        val merge :
             'a t
          -> 'b t
          -> f:
               (   key:Location.t
                -> [ `Both of 'a * 'b | `Left of 'a | `Right of 'b ]
                -> 'c option)
          -> 'c t

        val symmetric_diff :
             'a t
          -> 'a t
          -> data_equal:('a -> 'a -> bool)
          -> (Location.t, 'a) Base__.Map_intf.Symmetric_diff_element.t
             Base__.Sequence.t

        val fold_symmetric_diff :
             'a t
          -> 'a t
          -> data_equal:('a -> 'a -> bool)
          -> init:'c
          -> f:
               (   'c
                -> (Location.t, 'a) Base__.Map_intf.Symmetric_diff_element.t
                -> 'c)
          -> 'c

        val min_elt : 'a t -> (Location.t * 'a) option

        val min_elt_exn : 'a t -> Location.t * 'a

        val max_elt : 'a t -> (Location.t * 'a) option

        val max_elt_exn : 'a t -> Location.t * 'a

        val for_all : 'a t -> f:('a -> bool) -> bool

        val for_alli : 'a t -> f:(key:Location.t -> data:'a -> bool) -> bool

        val exists : 'a t -> f:('a -> bool) -> bool

        val existsi : 'a t -> f:(key:Location.t -> data:'a -> bool) -> bool

        val count : 'a t -> f:('a -> bool) -> index

        val counti : 'a t -> f:(key:Location.t -> data:'a -> bool) -> index

        val split : 'a t -> Location.t -> 'a t * (Location.t * 'a) option * 'a t

        val append :
             lower_part:'a t
          -> upper_part:'a t
          -> [ `Ok of 'a t | `Overlapping_key_ranges ]

        val subrange :
             'a t
          -> lower_bound:Location.t Base__.Maybe_bound.t
          -> upper_bound:Location.t Base__.Maybe_bound.t
          -> 'a t

        val fold_range_inclusive :
             'a t
          -> min:Location.t
          -> max:Location.t
          -> init:'b
          -> f:(key:Location.t -> data:'a -> 'b -> 'b)
          -> 'b

        val range_to_alist :
          'a t -> min:Location.t -> max:Location.t -> (Location.t * 'a) list

        val closest_key :
             'a t
          -> [ `Greater_or_equal_to
             | `Greater_than
             | `Less_or_equal_to
             | `Less_than ]
          -> Location.t
          -> (Location.t * 'a) option

        val nth : 'a t -> index -> (Location.t * 'a) option

        val nth_exn : 'a t -> index -> Location.t * 'a

        val rank : 'a t -> Location.t -> index option

        val to_tree : 'a t -> 'a Tree.t

        val to_sequence :
             ?order:[ `Decreasing_key | `Increasing_key ]
          -> ?keys_greater_or_equal_to:Location.t
          -> ?keys_less_or_equal_to:Location.t
          -> 'a t
          -> (Location.t * 'a) Base__.Sequence.t

        val binary_search :
             'a t
          -> compare:(key:Location.t -> data:'a -> 'key -> index)
          -> [ `First_equal_to
             | `First_greater_than_or_equal_to
             | `First_strictly_greater_than
             | `Last_equal_to
             | `Last_less_than_or_equal_to
             | `Last_strictly_less_than ]
          -> 'key
          -> (Location.t * 'a) option

        val binary_search_segmented :
             'a t
          -> segment_of:(key:Location.t -> data:'a -> [ `Left | `Right ])
          -> [ `First_on_right | `Last_on_left ]
          -> (Location.t * 'a) option

        val key_set : 'a t -> (Location.t, comparator_witness) Base.Set.t

        val quickcheck_observer :
             Location.t Core_kernel__.Quickcheck.Observer.t
          -> 'v Core_kernel__.Quickcheck.Observer.t
          -> 'v t Core_kernel__.Quickcheck.Observer.t

        val quickcheck_shrinker :
             Location.t Core_kernel__.Quickcheck.Shrinker.t
          -> 'v Core_kernel__.Quickcheck.Shrinker.t
          -> 'v t Core_kernel__.Quickcheck.Shrinker.t

        module Provide_of_sexp : functor
          (Key : sig
             val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> Location.t
           end)
          -> sig
          val t_of_sexp :
               (Ppx_sexp_conv_lib.Sexp.t -> 'v_x__002_)
            -> Ppx_sexp_conv_lib.Sexp.t
            -> 'v_x__002_ t
        end

        module Provide_bin_io : functor
          (Key : sig
             val bin_size_t : Location.t Bin_prot.Size.sizer

             val bin_write_t : Location.t Bin_prot.Write.writer

             val bin_read_t : Location.t Bin_prot.Read.reader

             val __bin_read_t__ : (index -> Location.t) Bin_prot.Read.reader

             val bin_shape_t : Bin_prot.Shape.t

             val bin_writer_t : Location.t Bin_prot.Type_class.writer

             val bin_reader_t : Location.t Bin_prot.Type_class.reader

             val bin_t : Location.t Bin_prot.Type_class.t
           end)
          -> sig
          val bin_shape_t : Bin_prot.Shape.t -> Bin_prot.Shape.t

          val bin_size_t : ('a, 'a t) Bin_prot.Size.sizer1

          val bin_write_t : ('a, 'a t) Bin_prot.Write.writer1

          val bin_read_t : ('a, 'a t) Bin_prot.Read.reader1

          val __bin_read_t__ : ('a, index -> 'a t) Bin_prot.Read.reader1

          val bin_writer_t : ('a, 'a t) Bin_prot.Type_class.S1.writer

          val bin_reader_t : ('a, 'a t) Bin_prot.Type_class.S1.reader

          val bin_t : ('a, 'a t) Bin_prot.Type_class.S1.t
        end

        module Provide_hash : functor
          (Key : sig
             val hash_fold_t :
               Base__.Hash.state -> Location.t -> Base__.Hash.state
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
          type t = Location.t

          val t_of_sexp : Sexplib0.Sexp.t -> t

          val sexp_of_t : t -> Sexplib0.Sexp.t

          type comparator_witness = Location.comparator_witness

          val comparator :
            (t, comparator_witness) Core_kernel__.Comparator.comparator
        end

        module Tree : sig
          type t =
            (Location.t, comparator_witness) Core_kernel__.Set_intf.Tree.t

          val compare : t -> t -> Core_kernel__.Import.int

          type named =
            (Location.t, comparator_witness) Core_kernel__.Set_intf.Tree.Named.t

          val length : t -> index

          val is_empty : t -> bool

          val iter : t -> f:(Location.t -> unit) -> unit

          val fold :
            t -> init:'accum -> f:('accum -> Location.t -> 'accum) -> 'accum

          val fold_result :
               t
            -> init:'accum
            -> f:('accum -> Location.t -> ('accum, 'e) Base__.Result.t)
            -> ('accum, 'e) Base__.Result.t

          val exists : t -> f:(Location.t -> bool) -> bool

          val for_all : t -> f:(Location.t -> bool) -> bool

          val count : t -> f:(Location.t -> bool) -> index

          val sum :
               (module Base__.Container_intf.Summable with type t = 'sum)
            -> t
            -> f:(Location.t -> 'sum)
            -> 'sum

          val find : t -> f:(Location.t -> bool) -> Location.t option

          val find_map : t -> f:(Location.t -> 'a option) -> 'a option

          val to_list : t -> Location.t list

          val to_array : t -> Location.t array

          val invariants : t -> bool

          val mem : t -> Location.t -> bool

          val add : t -> Location.t -> t

          val remove : t -> Location.t -> t

          val union : t -> t -> t

          val inter : t -> t -> t

          val diff : t -> t -> t

          val symmetric_diff :
            t -> t -> (Location.t, Location.t) Base__.Either.t Base__.Sequence.t

          val compare_direct : t -> t -> index

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
                  -> Location.t
                  -> ('b, 'final) Base__.Set_intf.Continue_or_stop.t)
            -> finish:('b -> 'final)
            -> 'final

          val fold_right : t -> init:'b -> f:(Location.t -> 'b -> 'b) -> 'b

          val iter2 :
               t
            -> t
            -> f:
                 (   [ `Both of Location.t * Location.t
                     | `Left of Location.t
                     | `Right of Location.t ]
                  -> unit)
            -> unit

          val filter : t -> f:(Location.t -> bool) -> t

          val partition_tf : t -> f:(Location.t -> bool) -> t * t

          val elements : t -> Location.t list

          val min_elt : t -> Location.t option

          val min_elt_exn : t -> Location.t

          val max_elt : t -> Location.t option

          val max_elt_exn : t -> Location.t

          val choose : t -> Location.t option

          val choose_exn : t -> Location.t

          val split : t -> Location.t -> t * Location.t option * t

          val group_by : t -> equiv:(Location.t -> Location.t -> bool) -> t list

          val find_exn : t -> f:(Location.t -> bool) -> Location.t

          val nth : t -> index -> Location.t option

          val remove_index : t -> index -> t

          val to_tree : t -> t

          val to_sequence :
               ?order:[ `Decreasing | `Increasing ]
            -> ?greater_or_equal_to:Location.t
            -> ?less_or_equal_to:Location.t
            -> t
            -> Location.t Base__.Sequence.t

          val binary_search :
               t
            -> compare:(Location.t -> 'key -> index)
            -> [ `First_equal_to
               | `First_greater_than_or_equal_to
               | `First_strictly_greater_than
               | `Last_equal_to
               | `Last_less_than_or_equal_to
               | `Last_strictly_less_than ]
            -> 'key
            -> Location.t option

          val binary_search_segmented :
               t
            -> segment_of:(Location.t -> [ `Left | `Right ])
            -> [ `First_on_right | `Last_on_left ]
            -> Location.t option

          val merge_to_sequence :
               ?order:[ `Decreasing | `Increasing ]
            -> ?greater_or_equal_to:Location.t
            -> ?less_or_equal_to:Location.t
            -> t
            -> t
            -> ( Location.t
               , Location.t )
               Base__.Set_intf.Merge_to_sequence_element.t
               Base__.Sequence.t

          val to_map :
               t
            -> f:(Location.t -> 'data)
            -> (Location.t, 'data, comparator_witness) Base.Map.t

          val quickcheck_observer :
               Location.t Core_kernel__.Quickcheck.Observer.t
            -> t Core_kernel__.Quickcheck.Observer.t

          val quickcheck_shrinker :
               Location.t Core_kernel__.Quickcheck.Shrinker.t
            -> t Core_kernel__.Quickcheck.Shrinker.t

          val empty : t

          val singleton : Location.t -> t

          val union_list : t list -> t

          val of_list : Location.t list -> t

          val of_array : Location.t array -> t

          val of_sorted_array : Location.t array -> t Base__.Or_error.t

          val of_sorted_array_unchecked : Location.t array -> t

          val of_increasing_iterator_unchecked :
            len:index -> f:(index -> Location.t) -> t

          val stable_dedup_list : Location.t list -> Location.t list

          val map :
            ('a, 'b) Core_kernel__.Set_intf.Tree.t -> f:('a -> Location.t) -> t

          val filter_map :
               ('a, 'b) Core_kernel__.Set_intf.Tree.t
            -> f:('a -> Location.t option)
            -> t

          val of_tree : t -> t

          val of_hash_set : Location.t Core_kernel__.Hash_set.t -> t

          val of_hashtbl_keys : (Location.t, 'a) Addr.Table.hashtbl -> t

          val of_map_keys : (Location.t, 'a, comparator_witness) Base.Map.t -> t

          val quickcheck_generator :
               Location.t Core_kernel__.Quickcheck.Generator.t
            -> t Core_kernel__.Quickcheck.Generator.t

          module Provide_of_sexp : functor
            (Elt : sig
               val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> Location.t
             end)
            -> sig
            val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> t
          end

          val t_of_sexp : Base__.Sexp.t -> t

          val sexp_of_t : t -> Base__.Sexp.t
        end

        type t = (Location.t, comparator_witness) Base.Set.t

        val compare : t -> t -> Core_kernel__.Import.int

        type named =
          (Location.t, comparator_witness) Core_kernel__.Set_intf.Named.t

        val length : t -> index

        val is_empty : t -> bool

        val iter : t -> f:(Location.t -> unit) -> unit

        val fold :
          t -> init:'accum -> f:('accum -> Location.t -> 'accum) -> 'accum

        val fold_result :
             t
          -> init:'accum
          -> f:('accum -> Location.t -> ('accum, 'e) Base__.Result.t)
          -> ('accum, 'e) Base__.Result.t

        val exists : t -> f:(Location.t -> bool) -> bool

        val for_all : t -> f:(Location.t -> bool) -> bool

        val count : t -> f:(Location.t -> bool) -> index

        val sum :
             (module Base__.Container_intf.Summable with type t = 'sum)
          -> t
          -> f:(Location.t -> 'sum)
          -> 'sum

        val find : t -> f:(Location.t -> bool) -> Location.t option

        val find_map : t -> f:(Location.t -> 'a option) -> 'a option

        val to_list : t -> Location.t list

        val to_array : t -> Location.t array

        val invariants : t -> bool

        val mem : t -> Location.t -> bool

        val add : t -> Location.t -> t

        val remove : t -> Location.t -> t

        val union : t -> t -> t

        val inter : t -> t -> t

        val diff : t -> t -> t

        val symmetric_diff :
          t -> t -> (Location.t, Location.t) Base__.Either.t Base__.Sequence.t

        val compare_direct : t -> t -> index

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
                -> Location.t
                -> ('b, 'final) Base__.Set_intf.Continue_or_stop.t)
          -> finish:('b -> 'final)
          -> 'final

        val fold_right : t -> init:'b -> f:(Location.t -> 'b -> 'b) -> 'b

        val iter2 :
             t
          -> t
          -> f:
               (   [ `Both of Location.t * Location.t
                   | `Left of Location.t
                   | `Right of Location.t ]
                -> unit)
          -> unit

        val filter : t -> f:(Location.t -> bool) -> t

        val partition_tf : t -> f:(Location.t -> bool) -> t * t

        val elements : t -> Location.t list

        val min_elt : t -> Location.t option

        val min_elt_exn : t -> Location.t

        val max_elt : t -> Location.t option

        val max_elt_exn : t -> Location.t

        val choose : t -> Location.t option

        val choose_exn : t -> Location.t

        val split : t -> Location.t -> t * Location.t option * t

        val group_by : t -> equiv:(Location.t -> Location.t -> bool) -> t list

        val find_exn : t -> f:(Location.t -> bool) -> Location.t

        val nth : t -> index -> Location.t option

        val remove_index : t -> index -> t

        val to_tree : t -> Tree.t

        val to_sequence :
             ?order:[ `Decreasing | `Increasing ]
          -> ?greater_or_equal_to:Location.t
          -> ?less_or_equal_to:Location.t
          -> t
          -> Location.t Base__.Sequence.t

        val binary_search :
             t
          -> compare:(Location.t -> 'key -> index)
          -> [ `First_equal_to
             | `First_greater_than_or_equal_to
             | `First_strictly_greater_than
             | `Last_equal_to
             | `Last_less_than_or_equal_to
             | `Last_strictly_less_than ]
          -> 'key
          -> Location.t option

        val binary_search_segmented :
             t
          -> segment_of:(Location.t -> [ `Left | `Right ])
          -> [ `First_on_right | `Last_on_left ]
          -> Location.t option

        val merge_to_sequence :
             ?order:[ `Decreasing | `Increasing ]
          -> ?greater_or_equal_to:Location.t
          -> ?less_or_equal_to:Location.t
          -> t
          -> t
          -> ( Location.t
             , Location.t )
             Base__.Set_intf.Merge_to_sequence_element.t
             Base__.Sequence.t

        val to_map :
             t
          -> f:(Location.t -> 'data)
          -> (Location.t, 'data, comparator_witness) Base.Map.t

        val quickcheck_observer :
             Location.t Core_kernel__.Quickcheck.Observer.t
          -> t Core_kernel__.Quickcheck.Observer.t

        val quickcheck_shrinker :
             Location.t Core_kernel__.Quickcheck.Shrinker.t
          -> t Core_kernel__.Quickcheck.Shrinker.t

        val empty : t

        val singleton : Location.t -> t

        val union_list : t list -> t

        val of_list : Location.t list -> t

        val of_array : Location.t array -> t

        val of_sorted_array : Location.t array -> t Base__.Or_error.t

        val of_sorted_array_unchecked : Location.t array -> t

        val of_increasing_iterator_unchecked :
          len:index -> f:(index -> Location.t) -> t

        val stable_dedup_list : Location.t list -> Location.t list

        val map : ('a, 'b) Base.Set.t -> f:('a -> Location.t) -> t

        val filter_map : ('a, 'b) Base.Set.t -> f:('a -> Location.t option) -> t

        val of_tree : Tree.t -> t

        val of_hash_set : Location.t Core_kernel__.Hash_set.t -> t

        val of_hashtbl_keys : (Location.t, 'a) Addr.Table.hashtbl -> t

        val of_map_keys : (Location.t, 'a, comparator_witness) Base.Map.t -> t

        val quickcheck_generator :
             Location.t Core_kernel__.Quickcheck.Generator.t
          -> t Core_kernel__.Quickcheck.Generator.t

        module Provide_of_sexp : functor
          (Elt : sig
             val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> Location.t
           end)
          -> sig
          val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> t
        end

        module Provide_bin_io : functor
          (Elt : sig
             val bin_size_t : Location.t Bin_prot.Size.sizer

             val bin_write_t : Location.t Bin_prot.Write.writer

             val bin_read_t : Location.t Bin_prot.Read.reader

             val __bin_read_t__ : (index -> Location.t) Bin_prot.Read.reader

             val bin_shape_t : Bin_prot.Shape.t

             val bin_writer_t : Location.t Bin_prot.Type_class.writer

             val bin_reader_t : Location.t Bin_prot.Type_class.reader

             val bin_t : Location.t Bin_prot.Type_class.t
           end)
          -> sig
          val bin_size_t : t Bin_prot.Size.sizer

          val bin_write_t : t Bin_prot.Write.writer

          val bin_read_t : t Bin_prot.Read.reader

          val __bin_read_t__ : (index -> t) Bin_prot.Read.reader

          val bin_shape_t : Bin_prot.Shape.t

          val bin_writer_t : t Bin_prot.Type_class.writer

          val bin_reader_t : t Bin_prot.Type_class.reader

          val bin_t : t Bin_prot.Type_class.t
        end

        module Provide_hash : functor
          (Elt : sig
             val hash_fold_t :
               Base__.Hash.state -> Location.t -> Base__.Hash.state
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

    val t_of_sexp : Sexplib0.Sexp.t -> witness

    val sexp_of_t : witness -> Sexplib0.Sexp.t

    type path = Path.t

    val depth : witness -> index

    val num_accounts : witness -> index

    val merkle_path_at_addr_exn : witness -> Addr.t -> path

    val get_inner_hash_at_addr_exn : witness -> Addr.t -> Inputs.Hash.t

    val set_inner_hash_at_addr_exn : witness -> Addr.t -> Inputs.Hash.t -> unit

    val set_all_accounts_rooted_at_exn :
      witness -> Addr.t -> Inputs.Account.t list -> unit

    val set_batch_accounts : witness -> (Addr.t * Inputs.Account.t) list -> unit

    val get_all_accounts_rooted_at_exn :
      witness -> Addr.t -> (Addr.t * Inputs.Account.t) list

    val make_space_for : witness -> index -> unit

    val to_list : witness -> Inputs.Account.t list

    val iteri : witness -> f:(index -> Inputs.Account.t -> unit) -> unit

    val foldi :
         witness
      -> init:'accum
      -> f:(Addr.t -> 'accum -> Inputs.Account.t -> 'accum)
      -> 'accum

    val foldi_with_ignored_accounts :
         witness
      -> Inputs.Account_id.Set.t
      -> init:'accum
      -> f:(Addr.t -> 'accum -> Inputs.Account.t -> 'accum)
      -> 'accum

    val fold_until :
         witness
      -> init:'accum
      -> f:
           (   'accum
            -> Inputs.Account.t
            -> ('accum, 'stop) Base.Continue_or_stop.t)
      -> finish:('accum -> 'stop)
      -> 'stop

    val accounts : witness -> Inputs.Account_id.Set.t

    val token_owner : witness -> Inputs.Token_id.t -> Inputs.Key.t option

    val token_owners : witness -> Inputs.Account_id.Set.t

    val tokens : witness -> Inputs.Key.t -> Inputs.Token_id.Set.t

    val next_available_token : witness -> Inputs.Token_id.t

    val set_next_available_token : witness -> Inputs.Token_id.t -> unit

    val location_of_account :
      witness -> Inputs.Account_id.t -> Location.t option

    val location_of_account_batch :
         witness
      -> Inputs.Account_id.t list
      -> (Inputs.Account_id.t * Location.t option) list

    val get_or_create_account :
         witness
      -> Inputs.Account_id.t
      -> Inputs.Account.t
      -> ([ `Added | `Existed ] * Location.t) Core.Or_error.t

    val close : witness -> unit

    val last_filled : witness -> Location.t option

    val get_uuid : witness -> Uuid.t

    val get_directory : witness -> string option

    val get : witness -> Location.t -> Inputs.Account.t option

    val get_batch :
      witness -> Location.t list -> (Location.t * Inputs.Account.t option) list

    val set : witness -> Location.t -> Inputs.Account.t -> unit

    val set_batch : witness -> (Location.t * Inputs.Account.t) list -> unit

    val get_at_index_exn : witness -> index -> Inputs.Account.t

    val set_at_index_exn : witness -> index -> Inputs.Account.t -> unit

    val index_of_account_exn : witness -> Inputs.Account_id.t -> index

    val merkle_root : witness -> Inputs.Hash.t

    val merkle_path : witness -> Location.t -> path

    val merkle_path_at_index_exn : witness -> index -> path

    val remove_accounts_exn : witness -> Inputs.Account_id.t list -> unit

    val detached_signal : witness -> unit Async.Deferred.t
  end
end
