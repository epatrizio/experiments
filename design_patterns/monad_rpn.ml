(* Reverse Polish Notation (RPN) monad
   A micro stack-based language managed by a state monad in a functor *)

module type S = sig
  type ('a, 'st) t

  val debug : bool ref

  val return : 'a -> ('a, 'st) t

  val run : ('a, 'st) t -> 'st -> 'a * 'st

  val bind : ('a, 'st) t -> ('a -> ('b, 'st) t) -> ('b, 'st) t

  val ( let* ) : ('a, 'st) t -> ('a -> ('b, 'st) t) -> ('b, 'st) t

  val map : ('a -> 'b) -> ('a, 'st) t -> ('b, 'st) t

  val ( let+ ) : ('a, 'st) t -> ('a -> 'b) ->  ('b, 'st) t

  val get_state : ('st, 'st) t

  val set_state : 'st -> (unit, 'st) t
end

module type NumericType = sig
  type t

  val zero : t

  val add : t -> t -> t
  val sub : t -> t -> t
  val mul : t -> t -> t
  val div : t -> t -> t

  val eq : t -> t -> bool

  val print : t -> unit
end

module State : S = struct
  type ('a, 'st) t = St of ('st -> ('a * 'st))

  let debug = ref false

  let return a = St ( fun st -> (a, st) )

  let run (St at) st = at st

  let bind at f = St (
    fun st -> let a, new_st = run at st in
    run (f a) new_st
  )

  let ( let* ) = bind

  let map f at =
    let* a = at in
    let r = f a in
    return r

  let ( let+ ) at f = map f at

  let get_state = St (fun st -> st, st)

  let set_state st = St (fun _st -> (), st)
end

module Make (Elt: NumericType) = struct
  type ('a, 'e) t = ('a, Elt.t list) State.t

  let debug = ref false

  let return = State.return

  let bind = State.bind

  let ( let* ) = State.( let* )

  let map = State.map

  let ( let+ ) = State.( let+ )

  let print () : (unit, 'e) t =
    let* st = State.get_state in
    List.iter (fun e -> Elt.print e; print_string " :: ")  st;
    print_newline ();
    return ()

  let debug_print () : (unit, 'e) t =
    if !debug then print () else return ()

  let push (e : 'e) : (unit, 'e) t =
    let* st = State.get_state in
    let* () = State.set_state (e :: st) in
    debug_print ()

  let pop : ('e option, 'e) t =
    let* st = State.get_state in
    match st with
    | [] -> return None
    | e :: tl -> 
      let* () = State.set_state tl in
      let* () = debug_print () in
      return (Some e) 

  let run (at : ('a, 'e) t) : 'a = 
    let a, _b = State.run at [] in a

  let binop op : ('e option, 'e) t =
    let* e1 = pop in
    let* e2 = pop in
    match (e1, e2) with
    | Some e1, Some e2 ->
      let e = op e1 e2 in
      let+ () = push e in
      Some e
    | _ -> return None

  let add = binop Elt.add

  let sub = binop Elt.sub

  let mul = binop Elt.mul

  let div : ('e option, 'e) t =
    let* e1 = pop in
    let* e2 = pop in
    match (e1, e2) with
    | Some e1, Some e2 when not (Elt.eq e1 Elt.zero) ->
      let e = Elt.div e2 e1 in  (* Warning: operand stack position! *)
      let+ () = push e in
      Some e
    | _ -> return None

end

(* other possible types :
type t = float / Int32 / Int64 / ...
type t =
  | Vint of int
  | Vfloat of float
  | ...
...
*)
module NumericType = struct
  type t = int

  let zero = Int.zero

  let add = Int.add
  let sub = Int.sub
  let mul = Int.mul
  let div = Int.div

  let eq = Int.equal

  let print i : unit = print_int i
end

module StackState = Make (NumericType)

open StackState

(* Static example : [0] = stack at the end, 42 is pop *)
let test1 () =
  debug := true;
  let vt =
    let* () = push 0 in
    let* () = push 1 in
    let* () = push 1 in 
    let* _v = add in
    let* () = push 40 in
    let* _v = add in
    pop
  in
  let v = run vt in
  assert (v = (Some 42))

(* Example including a mini parser : [42] = stack at the end *)
let test2 () =
  debug := false;
  let parse_str str =
    match str with
    | "+" -> let* _ : int option = add in return ()
    | "-" -> let* _ : int option = sub in return ()
    | "*" -> let* _ : int option = mul in return ()
    | "/" -> let* _ : int option = div in return ()
    | "p" -> print ()
    | s -> match int_of_string_opt s with
      | Some i -> push i
      | None -> return ()
  in
  let str_list = String.split_on_char ' ' "21 4 * 2 / p" in
  let vt = List.fold_left
    ( fun (acc : (unit, int list) StackState.t) (s : string) ->
        let* () = acc in
        parse_str s )
    ( return () )
    str_list
  in
  let () = run vt in
    print ()

let () =
  print_endline "First test:";
  test1 ()

let () =
  print_endline "Second test:";
  let _ = test2 () in ()
