# Design patterns

## OCaml functor

[`functor`](https://ocaml.org/docs/functors) (Module parameterized with other modules)
is a major OCaml language feature not easy to understand.
The concept is similar to interfaces in object-oriented programming.

## OCaml monad (don't be afraid :)

The [monad](https://en.wikipedia.org/wiki/Monad_(functional_programming)) concept scares people
because it's based on the [mathematical theory of categories](https://en.wikipedia.org/wiki/Monad_(category_theory)).
This example illustrates that it's possible to use them in simple contexts,
allowing to begin to understand them, and see how powerful it is to obtain readable and safe code.

Have a look at a quick implementation of the
[Reverse Polish Notation](https://en.wikipedia.org/wiki/Reverse_Polish_notation):
A classic (and more complete) example of a micro stack-based language managed by a state monad in a functor!

*Note that, in [Haskell](https://wiki.haskell.org/All_About_Monads), functors are part of monads,
but nothing to do with OCaml functors.*
