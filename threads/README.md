# Threads programming

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

## Concepts

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

## Langages selection

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

## Hello world

This first example is the traditional hello world with a client/server pattern.
Notice: Each client must create his own return channel,
a classic pattern to prevent the server from answering the wrong client.

## Vegetables queue

This second example is the Go and OCaml translation of the example already written in C that we talked about above.
It's interesting to see the differences between the 3 implementations. The OCaml version is the simplest and most
compact, but you have to be used to the functional approach and type inference.

### Verification

As explained previously, the significant complexity of concurrent programming is the state space
important increase, the sometimes non-deterministic execution result, and therefore the difficulty of testing.\
In thread/spin/ directory, here is a small example (simple and not exhaustive) of the use of
[SPIN model checker](https://spinroot.com), a formal verification tool of multi-threaded applications.\
Via the [Promela language](https://en.wikipedia.org/wiki/Promela), which is not a programming language
but a language for describing asynchronous systems, SPIN check flows between processes, scan the entire state space
(in our example, spin scan 181 states), check system global properties, etc.
