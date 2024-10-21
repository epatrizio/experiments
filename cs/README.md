# Client Server

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
