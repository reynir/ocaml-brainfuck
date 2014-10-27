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

%type <S.t> body
%type <S.t -> S.t> single

%%

program :
| p=body EOF { p }

body :
| s=single b=body { s b }
| { S.stop }

single :
| PLUS { S.inc }
| MINUS { S.dec }
| LT { S.left }
| GT { S.right }
| COMMA { S.input }
| DOT { S.output }
| L_BRACKET b=body R_BRACKET { S.loop b }
