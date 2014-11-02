val parse_with_error :
  (module Bf.SYNTAX with type t = 'a) -> Lexing.lexbuf -> 'a
