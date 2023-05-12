open Phonebook_abstract

let max_contacts = 10

type contact = {
  name : string;
  phone : string;
  email : string
}

module Book = Map.Make(String)

type phonebook = contact Book.t

type state = {
  book : phonebook;
  is_full : bool
}

let print_contact (c : contact) : unit =
  print_string (c.name ^ ":" ^ c.phone ^ ":" ^ c.email)

(* let refine_1 () =
  Phonebook_abstract.max_contacts = max_contacts *)

let refine_2 st abs_st =
  (Book.cardinal st.book) = abs_st.nb_contacts && st.is_full = abs_st.is_full

let invariant_1 st =
  (Book.cardinal st.book) <= max_contacts

let invariant_2 st =
  not st.is_full && (Book.cardinal st.book) < max_contacts ||
  st.is_full && (Book.cardinal st.book) = max_contacts

(* init phonebook event *)
module Init = (struct
  let guard () : bool = true

  let action () : state = {book = Book.empty; is_full = false}

  let safty_1 : bool = invariant_1 (action ())

  let safty_2 : bool = invariant_2 (action ())
end)

(* list contacts event *)
module List = (struct
  let guard (st : state) : bool = true

  let action (st : state) : state =
    if Book.is_empty st.book then print_endline "phonebook is empty!"
    else Book.iter (fun _ c -> print_contact c; print_newline ()) st.book;
    if st.is_full then print_string "phonebook is full!" else ();
    st

  let safty_1 (st : state) : bool = invariant_1 (action st)

  let safty_2 (st : state) : bool = invariant_2 (action st)
end)

(* add contact event *)
module Add = (struct
  let guard (st : state) : bool = not st.is_full

  let action (st : state) (c : contact) : state =
    {book = Book.add c.name c st.book; is_full = ((Book.cardinal st.book)+1) = max_contacts}

  let safty_1 (st : state) (c : contact) : bool =
    invariant_1 st && invariant_2 st && invariant_1 (action st c)

  let safty_2 (st : state) (c : contact) : bool =
    invariant_1 st && invariant_2 st && invariant_2 (action st c)
end)

(* find contact event *)
module Find = (struct
  let guard (st : state) : bool = true

  let action (st : state) (name : string) : (state * contact) option =
    try
      let c = Book.find name st.book in Some (st,c)
    with Not_found -> None

  let safty_1 (st : state) (name : string) : bool =
    match action st name with
    | Some (st,c) -> invariant_1 st
    | None -> true

  let safty_2 (st : state) (name : string) : bool =
    match action st name with
    | Some (st,c) -> invariant_2 st
    | None -> true
end)

(* delete contact event *)
module Delete = (struct
  let guard (st : state) : bool = Book.cardinal st.book > 0

  let action (st : state) (name : string) : state =
    let b = Book.remove name st.book in
    {book = b; is_full = Book.cardinal b = max_contacts}

  let safty_1 (st : state) (name : string) : bool =
    invariant_1 st && invariant_2 st && invariant_1 (action st name)

  let safty_2 (st : state) (name : string) : bool =
    invariant_1 st && invariant_2 st && invariant_2 (action st name)
end)