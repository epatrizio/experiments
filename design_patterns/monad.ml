(* Monad simple example in OCaml *)

(* Option Monad *)
module Opt : sig (* Minimal interface *)

  (* Basic monad element generation *)
  val return : 'a -> 'a option

  (* The major feature!
     Intuition: Chaining, linking, like JS Promise
     (~ Waiting a network request response, and if success, go on!) *)
  val bind : 'a option -> ('a -> 'b option) -> 'b option

  (* Only 'bind' syntax, but very powerful!
     simulates imperative style - "~ Haskell 'do' notation" *)
  val ( let* ) : 'a option -> ('a -> 'b option) -> 'b option

  (* Intuition: List.map *)
  val lift : ('a -> 'b) -> 'a option -> 'b option
end = struct
  let return a =  Some a

  let bind ao f = match ao with
    | Some a -> f a
    | None -> None

  let ( let* ) = bind

  let lift f ao =
  (* Direct implementation:
      match ao with
      | Some a -> Some (f a)
      | None -> None *)
  (* With bind and return:
     bind ao (fun a -> return (f a)) *)
  (* At the end, with let* syntax : monad may be forgotten! *)
  let* a = ao in
  return (f a)
end

(* Choice monad - based on lists *)
module Choice : sig
  val return : 'a -> 'a list
  val bind : 'a list -> ('a -> 'b list) -> 'b list
  val ( let* ) : 'a list -> ('a -> 'b list) -> 'b list
  val lift : ('a -> 'b) -> 'a list -> 'b list
end = struct
  let return a =  [ a ]

  let bind al f =
    List.flatten (List.map f al)

  let ( let* ) = bind

  let lift = List.map
end

(* Minimal example
   With the monad pattern, an input/controls flow should be implemented
   in sequential style (more natural, readable ...) *)

open Opt

(* User inputs simulator *)
let get_user_input : unit -> string option list =
  fun () -> [ Some "42"; Some "str"; None ]

let test_user_input_between_zero_hundred (so : string option) : bool option =
  (* multi bind (with double Some/None pattern matching) is hidden *)
  let* s = so in
  let* i = int_of_string_opt s in
  return (i > 0 && i < 100)

let () =
  (* user input loop simulator *)
  List.iter
    (fun so ->
      match test_user_input_between_zero_hundred so with
      | Some true -> print_endline "OK"
      | _ -> print_endline "KO!" )
    (get_user_input ())
