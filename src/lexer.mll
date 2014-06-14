{
  open Tokens
}

rule read = parse
| eof { EOF }
| '+' { PLUS }
| '-' { MINUS }
| '<' { LT }
| '>' { GT }
| ',' { COMMA }
| '.' { DOT }
| '[' { L_BRACKET }
| ']' { R_BRACKET }
| _ { read lexbuf }

{
  
}
