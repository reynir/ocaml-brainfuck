%{
  open Syntax
%}

%parameter < Syntax : Bf.SYNTAX >

%token EOF
%token PLUS
%token MINUS
%token LT
%token GT
%token COMMA
%token DOT
%token L_BRACKET
%token R_BRACKET
       
%start <Syntax.t> program

%type <Syntax.t -> Syntax.t> single

%%

program :
| p=body EOF { p bf_end }

body :
| s=single b=body { fun k -> s (b k) }
| { fun k -> k }

single :
| PLUS { bf_inc }
| MINUS { bf_dec }
| LT { bf_left }
| GT { bf_right }
| COMMA { bf_input }
| DOT { bf_output }
| L_BRACKET b=body R_BRACKET { bf_loop (b bf_end) }
