chan_hello_go:
	go run threads/chan_hello.go

chan_hello_ocaml:
	ocamlc -thread unix.cma threads.cma -o chan_hello threads/chan_hello.ml
	./chan_hello

vqueue_go:
	go run threads/vqueue.go

