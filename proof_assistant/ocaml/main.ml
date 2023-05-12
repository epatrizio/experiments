open Phonebook_concrete

let list_contacts (st : state) : state =
  print_endline "Phonebook content:";
  Phonebook_concrete.List.action st

let ask (label : string) : string =
  print_string (label ^ ": ");
  read_line ()

let add_contact (st : state) : state =
  print_endline "Add a new contact:";
  let name = ask "name" in
  let phone = ask "phone" in
  let email = ask "email" in
    Phonebook_concrete.Add.action st {name; phone; email}

let find_contact (st : state) : unit =
  print_endline "Find a contact:";
  let name = ask "name" in
    match Phonebook_concrete.Find.action st name with
    | Some (_, c) -> print_contact c; print_newline ()
    | None -> print_endline "contact not found!"

let delete_contact (st : state) : state =
  print_endline "Delete a contact:";
  let name = ask "name" in
    Phonebook_concrete.Delete.action st name

let rec loop (st : state) =
  print_endline "Menu:";
  print_endline "(1) List contacts";
  print_endline "(2) Add contact";
  print_endline "(3) Find contact";
  print_endline "(4) Delete contact";
  print_endline "(5) Quit";
  print_string "Choice: ";
  let i = read_int () in begin
    match i with
    | 1 -> let st = list_contacts st in loop st
    | 2 -> let st = add_contact st in begin
        print_endline "contact added!";
        loop st
      end
    | 3 -> find_contact st; loop st
    | 4 -> let st = delete_contact st in loop st
    | 5 -> print_endline "good bye!"
    | _ -> print_endline "input error!"; loop st
    end

let () =
  print_endline "---------------";
  print_endline "My Phonebook ;)";
  print_endline "---------------";
  let st = Phonebook_concrete.Init.action () in
    loop st
