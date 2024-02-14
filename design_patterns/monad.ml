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

(* Result Monad - Same as Opt Monad with an error message *)
module Res : sig
  val return : 'a -> ('a, 'e) result

  val bind : ('a, 'e) result -> ('a -> ('b, 'e) result) -> ('b, 'e) result

  val ( let* ) : ('a, 'e) result -> ('a -> ('b, 'e) result) -> ('b, 'e) result

  val lift : ('a -> 'b) -> ('a, 'e) result -> ('b, 'e) result
end = struct
  let return a =  Ok a

  let bind ae f = match ae with
    | Ok a -> f a
    | Error e as err -> err

  let ( let* ) = bind

  let lift f ae = 
    let* a = ae in
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
  fun () -> [ Some "42"; Some "142"; Some "str"; None ]

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

(* Minimal example with Res monad - error messages are better managed *)

open Res

let get_user_input : unit -> (string, string) Result.t list =
  fun () -> [ Ok "42"; Ok "142"; Ok "str"; Error "User input error!" ]

let test_user_input_integer (sr : (string, string) Result.t) : (int, string) Result.t =
  let* s = sr in
  let i = int_of_string_opt s in
  match i with
  | None -> Error "User input isn't an integer!"
  | Some i -> Ok i

let test_user_input_between_zero_hundred (sr : (string, string) Result.t) : (unit, string) Result.t =
  let* i = test_user_input_integer sr in
  if i > 0 && i < 100 then Ok () else Error "User input integer not between zero and hundred!"

let () =
  List.iter
    (fun sr ->
      match test_user_input_between_zero_hundred sr with
      | Ok () -> print_endline "OK"
      | Error e -> print_endline e )
    (get_user_input ())
