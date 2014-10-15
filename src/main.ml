open Printf
open Lexing

let hello_string = "++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>+.+"

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

let () =
  let minified =
    let lexbuf = Lexing.from_channel stdin in
    parse_with_error (module Bf.Syntax) lexbuf
    |> Bf.string_of_syntax in
  let module Run = Bf.RunnableSyntax(Bf.ExampleState) in
  let runnable =
    let lexbuf = Lexing.from_string minified in
    parse_with_error (module Run) lexbuf in
  print_endline "Minified:";
  print_endline minified;
  print_endline "Running program...";
  Run.run runnable Bf.ExampleState.empty
  |> ignore
