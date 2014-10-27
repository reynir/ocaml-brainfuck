open Printf
open Lexing

let print_position outx lexbuf =
  let pos = lexbuf.lex_curr_p in
  fprintf outx "%s:%d:%d" pos.pos_fname
    pos.pos_lnum (pos.pos_cnum - pos.pos_bol + 1)

let parse_with_error (type s) (module S : Bf.SYNTAX with type t = s) lexbuf =
  let module P = Parser.Make(S) in
  try P.program Lexer.read lexbuf with
  | P.Error ->
    fprintf stderr "%a: syntax error\n" print_position lexbuf;
    exit (-1)

