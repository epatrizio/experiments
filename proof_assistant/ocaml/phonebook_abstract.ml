let max_contacts = 10

type state = {
  nb_contacts : int;
  is_full : bool
}

let invariant_1 st =
  st.nb_contacts >=0 && st.nb_contacts <= max_contacts

let invariant_2 st =
  not st.is_full && st.nb_contacts < max_contacts ||
  st.is_full && st.nb_contacts = max_contacts

(* init phonebook event *)
module Init = (struct
  let guard () : bool = true

  let action () : state = {nb_contacts = 0; is_full = false}

  let safty_1 : bool = invariant_1 (action ())

  let safty_2 : bool = invariant_2 (action ())
end)

(* list contacts event *)
module List = (struct
  let guard (st : state) : bool = true

  let action (st : state) : state = st

  let safty_1 (st : state) : bool = invariant_1 (action st)

  let safty_2 (st : state) : bool = invariant_2 (action st)
end)

(* add contact event *)
module Add = (struct
  let guard (st : state) : bool = not st.is_full

  let action (st : state) : state =
    {nb_contacts = st.nb_contacts+1; is_full = (st.nb_contacts+1) = max_contacts}

  let variant (st : state) : int =
    max_contacts - st.nb_contacts

  let safty_1 (st : state) : bool =
    invariant_1 st && invariant_2 st && invariant_1 (action st)

  let safty_2 (st : state) : bool =
    invariant_1 st && invariant_2 st && invariant_2 (action st)
end)

(* find contact event *)
module Find = (struct
  let guard (st : state) : bool = true

  let action (st : state) : state = st

  let safty_1 (st : state) : bool = invariant_1 (action st)

  let safty_2 (st : state) : bool = invariant_2 (action st)
end)

(* delete contact event *)
module Delete = (struct
  let guard (st : state) : bool = st.nb_contacts > 0

  let action (st : state) : state =
    {nb_contacts = st.nb_contacts-1; is_full = false}

  let safty_1 (st : state) : bool =
    invariant_1 st && invariant_2 st && invariant_1 (action st)

  let safty_2 (st : state) : bool =
    invariant_1 st && invariant_2 st && invariant_2 (action st)
end)