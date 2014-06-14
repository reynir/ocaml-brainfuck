OCAMLBUILD=ocamlbuild -use-ocamlfind -menhir "menhir --external-tokens Tokens"

main.native: src/main.ml
	$(OCAMLBUILD) src/main.native

bf.native: src/bf.ml
	$(OCAMLBUILD) src/bf.native

clean:
	$(OCAMLBUILD) -use-ocamlfind -clean
