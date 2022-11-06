import Lake
open Lake DSL

package phonebook {
  -- add package configuration options here
}

lean_lib Phonebook {
  -- add library configuration options here
}

@[defaultTarget]
lean_exe phonebook {
  root := `Main
}
