let syntax =
  let module S = Bf.Syntax in
  QCheck.Arbitrary.(fix
    ~max:50
    ~base:(return S.stop)
    (fun p -> 
     choose [
         map p S.inc;
         map p S.dec;
         map p S.left;
         map p S.right;
         map p S.input;
         map p S.output;
         lift2 S.loop p p;
       ]))

let syntax_string =
  QCheck.Arbitrary.(fix
    ~max:50
    ~base:(return "")
    (fun s ->
     choose [
         map s ((^) "+");
         map s ((^) "-");
         map s ((^) "<");
         map s ((^) ">");
         map s ((^) ",");
         map s ((^) ".");
         lift2 (fun b k -> "[" ^ b ^ "]" ^ k) s s
       ]))

let test_string_of_syntax_and_parser =
  QCheck.mk_test
    ~n:1000
    ~name:"string_of_syntax and parser identity"
    ~pp:Bf.string_of_syntax
    syntax
    (fun s ->
     Bf.string_of_syntax s
     |> Lexing.from_string
     |> Utils.parse_with_error (module Bf.Syntax)
     = s)

let test_parser_and_string_of_syntax =
  QCheck.mk_test
    ~n:1000
    ~name:"parser and string_of_syntax identity"
    ~pp:QCheck.PP.string
    syntax_string
    (fun s ->
     Lexing.from_string s
     |> Utils.parse_with_error (module Bf.Syntax)
     |> Bf.string_of_syntax
     = s)

let test_transform_syntax =
  QCheck.mk_test
    ~n:1000
    ~name:"transform_syntax"
    ~pp:Bf.string_of_syntax
    syntax
    (fun s ->
     Bf.transform_syntax (module Bf.Syntax) s
     = s)

(* This will run random programs! *)
let bad_test =
  QCheck.mk_test
    ~n:1000
    ~name:"bad test"
    ~pp:Bf.string_of_syntax
    syntax
    (fun s ->
     let module Run = Bf.RunnableSyntax(Bf.ExampleState) in
     Bf.transform_syntax (module Run) s
     |> (fun p -> Run.run p Bf.ExampleState.empty)
     |> Bf.ExampleState.(fun { left; curr; right } ->
                         print_int curr;
                         true))

let _ : bool = QCheck.run_tests [
                   test_string_of_syntax_and_parser;
                   test_parser_and_string_of_syntax;
                   test_transform_syntax;
                 ]
