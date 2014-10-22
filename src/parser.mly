%parameter < S : Bf.SYNTAX >

%token EOF
%token PLUS
%token MINUS
%token LT
%token GT
%token COMMA
%token DOT
%token L_BRACKET
%token R_BRACKET
       
%start <S.t> program

%type <S.t -> S.t> body
%type <S.t -> S.t> single

%%

program :
| p=body EOF { p S.bf_end }

body :
| s=single b=body { fun k -> s (b k) }
| { fun k -> k }

single :
| PLUS { S.bf_inc }
| MINUS { S.bf_dec }
| LT { S.bf_left }
| GT { S.bf_right }
| COMMA { S.bf_input }
| DOT { S.bf_output }
| L_BRACKET b=body R_BRACKET { S.bf_loop (b S.bf_end) }
