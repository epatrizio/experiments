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

clean:
	rm -rf */*.cmo */*.cmi */*.cmx */*.o
	rm -rf pan.* vqueue.pml.trail
	rm -rf chan_hello vqueue client server verif life

# --- proof_assistant/lean ---

lean_build:
	lake --dir proof_assistant/lean/ build

lean_clean:
	lake --dir proof_assistant/lean/ clean

lean_build_force: lean_clean lean_build

lean_run:
	./proof_assistant/lean/build/bin/phonebook

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
	ocamlopt -o life unix.cmxa life_game/life.ml

life_run:
	./life
