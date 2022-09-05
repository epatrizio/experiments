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
	rm -rf chan_hello vqueue verif
