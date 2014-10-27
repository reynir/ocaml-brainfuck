OCAMLBUILD=ocamlbuild -use-ocamlfind -menhir "menhir --external-tokens Tokens"

all: main.native test

main.native: src/*
	$(OCAMLBUILD) src/main.native

bf.native: src/bf.ml
	$(OCAMLBUILD) src/bf.native

test: test.native
	./test.native

test.native: src/* tests/*
	$(OCAMLBUILD) tests/test.native

clean:
	$(OCAMLBUILD) -use-ocamlfind -clean
