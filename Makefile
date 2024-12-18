# --- threads ---

chan_hello_go:
	go run threads/chan_hello.go

chan_hello_ocaml:
	ocamlc -thread unix.cma threads.cma -o chan_hello threads/chan_hello.ml
	./chan_hello

vqueue_go:
	go run threads/vqueue.go

vqueue_ocaml:
	ocamlc -thread unix.cma threads.cma -o vqueue threads/vqueue.ml
	./vqueue

spin_check:
	spin threads/spin/vqueue.pml

spin_verif:
	spin -a threads/spin/vqueue.pml
	gcc -o verif pan.c
	./verif

# --- proof_assistant/lean ---

lean_build:
	lake --dir proof_assistant/lean/ build

lean_clean:
	lake --dir proof_assistant/lean/ clean

lean_build_force: lean_clean lean_build

lean_run:
	./proof_assistant/lean/build/bin/phonebook

# --- proof_assistant/ocaml ---

phonebook_compile:
	ocamlopt -I=./proof_assistant/ocaml -o phonebook \
	proof_assistant/ocaml/phonebook_abstract.ml \
	proof_assistant/ocaml/phonebook_concrete.ml \
	proof_assistant/ocaml/main.ml

phonebook_run:
	./phonebook

# --- cs ---

cs_server_compile:
	ocamlfind ocamlc -I=./cs -o server -package mirage-crypto-ec -package mirage-crypto-rng.unix \
	-linkpkg cs/crypto.ml cs/utils.ml cs/server.ml

cs_client_compile:
	ocamlfind ocamlc -I=./cs -o client -package mirage-crypto-ec -package mirage-crypto-rng.unix \
	-linkpkg cs/crypto.ml cs/utils.ml cs/client.ml

cs_server_run:
	./server

cs_client_run:
	./client

# --- life ---

life_compile:
	ocamlopt -o life unix.cmxa classics/life.ml

life_run:
	./life

# --- Mandelbrot / Julia sets ---

mandelbrot_compile:
	ocamlfind ocamlopt -o mandelbrot -package graphics \
	-linkpkg classics/mandelbrot.ml

mandelbrot_run:
	./mandelbrot

# --- Design patterns ---

functor_compile:
	ocamlopt -o functor design_patterns/functor.ml

functor_run:
	./functor

monad_compile:
	ocamlopt -o monad design_patterns/monad.ml

monad_run:
	./monad

monad_rpn_compile:
	ocamlopt -o rpn design_patterns/monad_rpn.ml

monad_rpn_run:
	./rpn

ts_func_prog:
	deno run design_patterns/func_prog.ts

# --- Utils (general) ---

clean:
	rm -rf */*.cmo */*.cmi */*.cmx */*.o
	rm -rf */*/*.cmo */*/*.cmi */*/*.cmx */*/*.o
	rm -rf pan.* vqueue.pml.trail
	rm -rf chan_hello vqueue client server verif life mandelbrot phonebook \
	functor monad rpn
