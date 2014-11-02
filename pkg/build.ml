#!/usr/bin/env ocaml
#directory "pkg"
#use "topkg.ml"

let () =
  Pkg.describe "brainfuck"
               ~builder:`OCamlbuild
               [ Pkg.lib "pkg/META";
                 Pkg.lib ~exts:Exts.module_library "src/bf";
                 Pkg.lib ~exts:Exts.module_library "src/utils";
                 Pkg.lib ~exts:Exts.library "src/lexer";
                 Pkg.lib ~exts:Exts.library "src/parser";
                 Pkg.bin ~auto:true "src/ocaml_brainfuck";
               ]
