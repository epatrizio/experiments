(* Ordered list implementation with an OCaml functor *)

(* Element Module type *)
module type OrderedType = sig
  type t
  val compare : t -> t -> int
  val print : t -> unit
end

(* Functor Module type
   Nb. It's not an OCaml.List extension, it's a new specific type.
   So, all functions need to be redefined. *)
module type S = sig
  type elt

  type t 

  val empty : t

  val cons : elt -> t -> t

  val from_list : elt list -> t

  val to_list : t -> elt list

  val print_list : t -> unit

  (* ... *)
end

(* Functor generic implementation *)
module Make (Elt: OrderedType) : S with type elt = Elt.t = struct
  type elt = Elt.t  (* Specific type based on functor parameter *)

  type t = elt list

  let empty = []

  let rec cons v l =    (* Specific cons *)
    match l with
    | [] -> [v]
    | e :: tl ->
      if Elt.compare v e <= 0 then v :: e :: tl
      else e :: cons v tl

  let to_list ol = ol

  let from_list el = List.sort Elt.compare el

  let print_list el = List.iter Elt.print (to_list el)
end

(* Minimal example
   Nb. Functor is generic, only elements have to be specified *)

module StringOrderedType = struct
  type t = String.t
  
  let compare = String.compare

  let print str = Printf.printf "%s " str
end

module IntOrderedType = struct
  type t = Int.t
  
  let compare = Int.compare

  let print i = Printf.printf "%d " i
end

module OSlist = Make (StringOrderedType)
module OIlist = Make (IntOrderedType)

let () =
  let list = OSlist.empty in
  let list = OSlist.cons "titi" list in
  let list = OSlist.cons "toto" list in
  let list = OSlist.cons "tata" list in
    OSlist.print_list list

let () =
  let list = OIlist.empty in
  let list = OIlist.cons 42 list in
  let list = OIlist.cons (-42) list in
  let list = OIlist.cons 0 list in
    OIlist.print_list list
