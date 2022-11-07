namespace Phonebook

def welcome := "Phonebook project"

abbrev Name := String
abbrev Number := String
abbrev Email := String

structure Contact where
  name : Name
  number : Number
  email : Email
deriving Repr

def Phonebook := List Contact

-- get a test Phonebook (2 contacts)
def get_test_book : Phonebook :=
  {name := "eric", number := "01.01.01.01.01", email := "eric@dom.ext"}::
  {name := "pat", number := "02.02.02.02.02", email := "pat@dom.ext"}::[]

-- Action abstraction

inductive Action where
  | list : Action
  | add : Action
  | del : Action
  | find : Action
  | quit : Action
deriving Repr

-- Todo : better implementation with recursor ?
def getAction (id : Nat) : Option Action :=
  match id with
  | 1 => some Action.list
  | 2 => some Action.add
  | 3 => some Action.del
  | 4 => some Action.find
  | 5 => some Action.quit
  | _ => none

-- util function
def is_some {α  : Type} (opt : Option α): Bool :=
  match opt with
  | none => false
  | some _ => true

-- | "show" functions

def showBookLen (book : Phonebook) : String :=
  toString book.length

def showContact (contact : Contact) : String :=
  contact.name ++ ": " ++ contact.number ++ " - " ++ contact.email

def showBookItems (book : Phonebook) : String :=
  match book with
  | [] => ""
  | c::r => "\n" ++ showContact c ++ showBookItems r

def showBook (book : Phonebook) : String :=
  match book with
  | [] => "Phonebook is empty!"
  | _ => "Showing " ++ showBookLen book ++ " entries:" ++ showBookItems book

-- | find contact

def findContact (book : Phonebook) (name : Name) : Option Contact :=
  match book with
  | [] => none
  | c::r =>
      match name == c.name with
      | true => some c
      | false => findContact r name

def findShowContact (book : Phonebook) (name : Name) : String :=
  match findContact book name with
  | none => "Contact " ++ name ++ " not present in phonebook!"
  | some c => showContact c

def existsContact (book : Phonebook) (name : Name) : Bool :=
  match findContact book name with
  | none => false
  | some _ => true

example:
  is_some (findContact get_test_book "eric") = true :=
by
  simp[findContact]

example:
  is_some (findContact get_test_book "not") = false :=
by
  simp[findContact]

-- | add contact

def addContact (book : Phonebook) (name : Name) (num : Number) (email : Email) : Phonebook :=
  match findContact book name with
  | none => {name := name, number := num, email := email}::book
  | some _ => book

example:
  (addContact get_test_book "new" "000" "new@dom.ext").length = get_test_book.length + 1 :=
by
  simp

example:
  (addContact get_test_book "eric" "000" "eric@dom.ext").length = get_test_book.length :=
by
  simp

-- | delete contact

def delContact (book : Phonebook) (name : Name) : Phonebook :=
  match book with
  | [] => book
  | c::r =>
      match name == c.name with
      | true => r
      | false => c::delContact r name

example:
  (delContact get_test_book "new").length = 2 :=
by
  simp

example:
  (delContact get_test_book "eric").length = 1 :=
by
  simp

end Phonebook
