(* Counter module:

1/ Basic implementation: with side effect for internal state
2/ State Monad implementation
    State monad intuition: transition from one state to another *)

(* 1. **** *)

module MakeBasicCounter () = struct
  let id = ref 0

  let count () =
    incr id;
    !id
end

(* 2 distinct BasicCounter *)
module Cnt_1 = MakeBasicCounter ()
module Cnt_2 = MakeBasicCounter ()

let () =
  print_int (Cnt_1.count ()); print_newline (); (* 1 *)
  print_int (Cnt_1.count ()); print_newline (); (* 2 *)
  print_int (Cnt_2.count ()); print_newline (); (* 1 *)
  print_int (Cnt_1.count ()); print_newline (); (* 3 *)
  print_int (Cnt_2.count ()); print_newline (); (* 2 *)
  print_int (Cnt_2.count ()); print_newline (); (* 3 *)
  print_int (Cnt_1.count ()); print_newline (); (* 4 *)
  print_int (Cnt_2.count ()); print_newline (); (* 4 *)

(* 2. **** *)

module type S = sig
  type ('a, 'st) t

  val return : 'a -> ('a, 'st) t

  val bind : ('a, 'st) t -> ('a -> ('b, 'st) t) -> ('b, 'st) t

  val run : ('a, 'st) t -> 'st -> 'a * 'st

  val get_state : ('st, 'st) t

  val set_state : 'st -> (unit, 'st) t
end

(* Generic state monad impl *)
module State : S = struct
  type ('a, 'st) t = 'st -> ('a * 'st)

  let return a = fun st -> (a, st)

  let run fs st = fs st

  let bind fs ft =
    fun st -> let a, new_st = run fs st in
    run (ft a) new_st

  let ( let* ) = bind

  let get_state = fun st -> (st, st)

  let set_state st = fun _ -> ((), st)
end

module Counter = struct
  type state = { i : int }

  type ('a, 'st) t = (int, state) State.t

  let return = State.return

  let bind = State.bind

  let ( let* ) = bind

  let run fs =
    let i, _ = State.run fs { i = 0 } in
    i

  let count () =
    let* st = State.get_state in
    let i = st.i + 1 in
    let* () = State.set_state ({ i }) in
    return i
end

open Counter

let () =
  let cnt = Counter.bind
    (Counter.count ())
    (fun i ->
      Counter.bind 
        (Counter.count ())
        (fun i -> Counter.return i)
      )
  in
  let i = Counter.run cnt in
  print_int i; (* 2 *)
  print_newline ()

(* bind chaining is very verbose!
let* custom operator allows "imperative" style *)

let () =
  let cnt =
    let* i = Counter.count () in
    let* i = Counter.count () in
    let* i = Counter.count () in
    let* i = Counter.count () in
    let* i = Counter.count () in
    Counter.return i
  in
  let i = Counter.run cnt in
  print_int i; (* 5 *)
  print_newline ()
