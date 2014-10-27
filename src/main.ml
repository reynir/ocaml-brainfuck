let hello_string = "++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>+.+"

let () =
  let minified =
    let lexbuf = Lexing.from_channel stdin in
    Utils.parse_with_error (module Bf.Syntax) lexbuf
    |> Bf.string_of_syntax in
  let module Run = Bf.RunnableSyntax(Bf.ExampleState) in
  let runnable =
    let lexbuf = Lexing.from_string minified in
    Utils.parse_with_error (module Run) lexbuf in
  print_endline "Minified:";
  print_endline minified;
  print_endline "Running program...";
  Run.run runnable Bf.ExampleState.empty
  |> ignore
