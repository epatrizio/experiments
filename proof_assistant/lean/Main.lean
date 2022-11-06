import Phonebook

open Phonebook
open Action

partial def ask (prompt : String) : IO String := do
  IO.print prompt
  let stdin ← IO.getStdin
  let mut str ← stdin.getLine
  str := str.trim
  if str.length == 0 then
    ask "Empty input, try again: "
  else
    return str

partial def addContact (book : Phonebook) : IO Phonebook := do
  let name ← ask "Name: "
  let number ← ask "Phone number: "
  let email ← ask "Email: "
  let book' := Phonebook.addContact book name number email
  IO.println (if book'.length = book.length then "=> Contact " ++ name ++ " already exists!" else "=> Contact added!")
  return book'

partial def delContact (book : Phonebook) : IO Phonebook := do
  let name ← ask "Name: "
  let book' := Phonebook.delContact book name
  IO.println (if book'.length = book.length then "Contact " ++ name ++ " not present in phonebook!" else "=> Contact deleted!")
  return book'

partial def showContact (book : Phonebook) : IO String := do
  let name ← ask "Name: "
  return Phonebook.findShowContact book name

partial def menu (prompt : String) : IO Action := do
  IO.println "Menu:"
  IO.println "(1) List contacts"
  IO.println "(2) Add contact"
  IO.println "(3) Delete contact"
  IO.println "(4) Find contact"
  IO.println "(5) Quit"
  IO.print prompt
  let stdin ← IO.getStdin
  let mut str ← stdin.getLine
  str := str.trim
  match str.toNat? with
  | .none => menu "Not a valid choice :( try again: "
  | .some i => 
    match getAction i with
    | none => menu "Not an existing choice :( try again: "
    | some a => return a

partial def loop (prompt : String) (book : Phonebook) : IO Unit := do
  let action ← menu prompt
  match action with
  | list =>
      IO.println ">> show book"
      IO.println "---"
      IO.println (showBook book)
      IO.println "---"
      loop "Choice: " book
  | add =>
      IO.println ">> add contact"
      IO.println "---"
      let book' ← addContact book
      IO.println "---"
      loop "Choice: " book'
  | del =>
      IO.println ">> delete contact"
      IO.println "---"
      let book' ← delContact book
      IO.println "---"
      loop "Choice: " book'
  | find =>
      IO.println ">> find contact"
      IO.println "---"
      let contact ← showContact book
      IO.println contact
      IO.println "---"
      loop "Choice: " book
  | quit => IO.println "goodbye, see you later!"

def main : IO Unit := do
  IO.println "=============="
  IO.println s!"Welcome, {welcome}!"
  IO.println "=============="
  loop "Choice: " List.nil
