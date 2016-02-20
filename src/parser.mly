%{ open Ast %}
%token ADDOP SUBOP MULOP DIVOP MODOP EOF
%token <int> LITERAL
%token <int> VARIABLE
%token <string> STRING
%left ADDOP SUBOP
%left MULOP DIVOP
%start expr
%type <Ast.expression> expr
%%
expr:
expr ADDOP expr { Binop($1, Add, $3) }
| expr SUBOP expr { Binop($1, Sub, $3) }
| expr MULOP expr { Binop($1, Mul, $3) }
| expr DIVOP expr { Binop($1, Div, $3) }
| VARIABLE { Var(string_of_int $1)}
| STRING { String($1) }
