OCAMLBUILD=ocamlbuild -use-ocamlfind

all: ocaml_brainfuck.native test

ocaml_brainfuck.native: src/*
	$(OCAMLBUILD) src/ocaml_brainfuck.native

bf.native: src/bf.ml
	$(OCAMLBUILD) src/bf.native

test: test.native
	./test.native

test.native: src/* tests/*
	$(OCAMLBUILD) tests/test.native

clean:
	$(OCAMLBUILD) -use-ocamlfind -clean
