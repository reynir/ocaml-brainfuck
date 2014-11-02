open Ocamlbuild_plugin;;

let menhir_opts = S[A"--external-tokens"; A"Tokens"] ;;

flag ["ocaml"; "menhir_ocamldep"] menhir_opts;;

flag ["ocaml"; "parser"; "menhir"] menhir_opts;;
