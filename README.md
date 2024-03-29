# Pedagogical experiments

This repository contains experiments: they implement subjects, techniques, patterns,
only in a training context.\
So, examples are simple but always (I hope) with an interesting pedagogical point of view.\
Have fun!

*Nb. See the Makefile: each example has its own rules.*

## Threads programming

First of all, [concurrent computing](https://en.wikipedia.org/wiki/Concurrent_computing) is difficult, very difficult!\
When you start creating threads, it gets stuck, it doesn't do what you want,
it's not deterministic (the processor scheduler involves instruction interleaving),
it's hard to reproduce and therefore to test :(\
But we no longer have a choice:
[The Free Lunch Is Over: A Fundamental Turn Toward Concurrency in Software](http://www.gotw.ca/publications/concurrency-ddj.htm).

My first experiment is not here but in this other
[repository](https://github.com/epatrizio/cds/tree/main/examples/threads).
In C language, with [POSIX system threads](https://en.wikipedia.org/wiki/Pthreads),
I implemented a small classic example (which will be used here again in order to compare)
using a vegetables queue with producers and consumers.
Difficulties appeared quickly: to master instructions interleaving, it is necessary to lock and unlock
threads with complex manipulations of mutexes and conditions. That's why I decided to learn more ...

### Concepts

Here is a simple and quick presentation of some basic concepts.
The humble objective is to obtain a first global vision.

Concurrent programming divides like this:

* **by shared memory**

  * **Preemptive model:** it's about running sequential processes at the same time.\
    The scheduler interleaves threads atomic instructions in a "random" way, the state space grows
    (exponentially), so it becomes difficult to manage and the result is not deterministic.
    So much complexity! For example, sometimes deadlocks may occur
    ([Dining philosophers problem](https://en.wikipedia.org/wiki/Dining_philosophers_problem)).
    In this context, as explained before, the programmer must manage the atomic instructions blocks
    (= without interleaving) with low-level language primitives (lock, unlock, mutex, condition, wait, ...).
    This is not an easy stuff!

  * **Cooperative model:** it's about having a constant state space in order to have a deterministic behavior.\
  OS scheduler manage system threads. Here the program will manage its own threads, application threads,
  which represents new, other, complicated things.
  Switching from one thread to another is done in a specific way and at specific times.\
  Here is a [Fair Threads library](https://www-sop.inria.fr/mimosa/rp/FairThreads/FTC/documentation/ft.html)
  in C language, fully compatible with the
  [Pthreads library](https://www.cs.cmu.edu/afs/cs/academic/class/15492-f07/www/pthreads.html).

* **by messages passing**
Memory is no longer a shared area, it moves during communications.
This requires the use of communication medias (synchronous channels) between identified processes with
primitives like create, send, receive, etc.
As a corollary, there is the elegant concept of "future" (promise) allowing asynchronous programming.
This makes sense, for example, during independent intermediate multi-thread, multi-core, computes.

### Langages selection

For my experiments, I used the Go language and the OCaml language.

* **Go**\
[Golang](https://go.dev) is probably the most suitable language for concurrent programming.
Indeed, it is relatively low level but offers "high level" primitives, generally easy to access,
to manage concurrency via channels and the famous goroutine.
Go is efficient because it is designed for multicore computers.\
In conclusion, don't forget the motto of Go:
*"Do not communicate by sharing memory; instead, share memory by communicating."*.
[Learn more ...](https://go.dev/blog/codelab-share)

* **OCaml**\
[OCaml language](https://ocaml.org), an excellent academic language, also used in industry in critical contexts,
has very elegant concurrent programming mechanisms that are strongly typed and encapsulated in modules.
(See the [Event module](https://v2.ocaml.org/api/Event.html)).
[LWT](https://ocsigen.org/lwt/) (Light Weight cooperative Threads) by [Ocsigen](https://ocsigen.org),
is the asynchronous programming component written in monadic style which I used a bit in this
[repository](https://github.com/epatrizio/ographics).
Finally, [multicore OCaml](https://github.com/ocaml-multicore) is under development.

### Hello world

This first example is the traditional hello world with a client/server pattern.
Notice: Each client must create his own return channel,
a classic pattern to prevent the server from answering the wrong client.

### Vegetables queue

This second example is the Go and OCaml translation of the example already written in C that we talked about above.
It's interesting to see the differences between the 3 implementations. The OCaml version is the simplest and most
compact, but you have to be used to the functional approach and type inference.

#### Verification

As explained previously, the significant complexity of concurrent programming is the state space
important increase, the sometimes non-deterministic execution result, and therefore the difficulty of testing.\
In thread/spin/ directory, here is a small example (simple and not exhaustive) of the use of
[SPIN model checker](https://spinroot.com), a formal verification tool of multi-threaded applications.\
Via the [Promela language](https://en.wikipedia.org/wiki/Promela), which is not a programming language
but a language for describing asynchronous systems, SPIN check flows between processes, scan the entire state space
(in our example, spin scan 181 states), check system global properties, etc.

## Proof assistant initiation

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

## Client Server

Writing a client server is always a good programming exercise. Here is a small example, written in OCaml,
which implements an authentication based on cryptographic signature verification. The signature algorithm
used is [EdDSA](https://en.wikipedia.org/wiki/EdDSA) with the Ed25519 implementation.

Communications between client and server are secured by the
[public/private keys system](https://en.wikipedia.org/wiki/Public-key_cryptography).
Key pairs are generated on the server side and after the client receives its private key:

* The client signs (secures) his messages with his private key
* The server checks the received messages with the public key

In OCaml ecosystem,
[Mirage Crypto EC library](https://ocaml.org/p/mirage-crypto-ec/0.10.0/doc/Mirage_crypto_ec/Ed25519/index.html)
implement the Ed25519 algorithm.
Installation with [opam package mirage-crypto-ec](https://opam.ocaml.org/packages/mirage-crypto-ec/).

The implementation is based on this [documentation](https://caml.inria.fr/pub/docs/oreilly-book/html/book-ora187.html).

For another client-server component example, here is a small [http server](https://github.com/epatrizio/chttpserver)
written in C language.

## Conway's Game of Life

Here is a [Game of life](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life) implementation.\
Written in OCaml language, this is a classic example of functional programming.

The most important thing is to discover this little game, which, from 2 simple rules, generates fascinating cell divisions.\
It's up to you to try, to find, some extra starting points.\
Have fun!

## Mandelbrot & Julia sets

Here are 2 famous fractals :
[Mandelbrot](https://en.wikipedia.org/wiki/Mandelbrot_set) and
[Julia](https://en.wikipedia.org/wiki/Julia_set) sets.\
Always written in OCaml language, this is another classic example of programming.

By changing the window size, the window zoom, and the colors generation, the results evolve and are beautiful.
Have fun!

## Design patterns

### OCaml functor

[`functor`](https://ocaml.org/docs/functors) (Module parameterized with other modules)
is a major OCaml language feature not easy to understand.
The concept is similar to interfaces in object-oriented programming.

### OCaml monad (don't be afraid :)

The [monad](https://en.wikipedia.org/wiki/Monad_(functional_programming)) concept scares people
because it's based on the [mathematical theory of categories](https://en.wikipedia.org/wiki/Monad_(category_theory)).
This example illustrates that it's possible to use them in simple contexts,
allowing to begin to understand them, and see how powerful it is to obtain readable and safe code.

Have a look at a quick implementation of the
[Reverse Polish Notation](https://en.wikipedia.org/wiki/Reverse_Polish_notation):
A classic (and more complete) example of a micro stack-based language managed by a state monad in a functor!

*Note that, in [Haskell](https://wiki.haskell.org/All_About_Monads), functors are part of monads,
but nothing to do with OCaml functors.*
