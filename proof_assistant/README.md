# Proof assistant initiation

In terms of program validation (already discussed above with SPIN and Promela),
this is the step that follows the tests.
A proof assistant provides a formal language to write mathematical definitions, properties in order to
proove theorems!

*Testing finds bugs but does not prove that there are none!*\
*With a theorem prover, we are guaranteed that a function (for example) is 100% correct!*

In the [OCaml](https://ocaml.org) ecosystem, [Coq](https://coq.inria.fr) is the proof assistant reference.

In my example ([proof_assistant/lean/](./proof_assistant/lean/)),
I use the [Lean Theorem Prover](https://leanprover.github.io/), created by Microsoft Research.
Since version 4, the Lean platform has the advantage of bringing everything together
(an advanced functional programming language - like OCaml or Haskell - and a formal mathematical language).\
So my phonebook example is complete and executable.\
Finally, I suggest [Lake](https://github.com/leanprover/lake), the build system and package manager for Lean 4.
