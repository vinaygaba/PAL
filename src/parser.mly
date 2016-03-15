%{ open Ast %}
%token SEMICOLON
%token LEFTBRACE LEFTPAREN LEFTBRAC RIGHTBRACE RIGHTPAREN RIGHTBRAC COMMA
%token ADDOP SUBOP MULOP DIVOP MODOP EOF
%token APPEND SWAP CONCAT TYPEASSIGNMENT LINEBUFFER
%token EQ NEQ LT GT LEQ GEQ
%token NOT AND OR
%token ASSIGN
%token IF ELIF ELSE WHILELOOP FORLOOP BREAK CONTINUE VOID NULL
%token EOF
%token IMPORT FUNCTION
%token <string> ID
%token <string> STRING
%token <int> INT
%token <float> FLOAT
%token <bool> BOOL
%token INTD BOOLD STRINGD FLOATD PDF PAGE LINE
%left OR
%left AND
%left EQ NEQ
%nonassoc LT LEQ GT GEQ
%left ADDOP SUBOP
%left MULOP DIVOP
%left CONCAT
%left TYPEASSIGNMENT
%start program
%type <Ast.expression> program
%%
expr:
STRING               { String($1) }
| INT                { Int($1) }
| FLOAT              { Float($1) }
| BOOL               { Bool($1) }
| expr ADDOP expr    { Binop($1, Add, $3) }
| expr SUBOP expr    { Binop($1, Sub, $3) }
| expr MULOP expr    { Binop($1, Mul, $3) }
| expr DIVOP expr    { Binop($1, Div, $3) }
| expr CONCAT expr   { Binop($1, Concat,  $3) }
| expr MOD    expr   { Binop($1, Mod,     $3) }
| expr EQ     expr   { Binop($1, Equal,   $3) }
| expr NEQ    expr   { Binop($1, Neq,     $3) }
| expr LT     expr   { Binop($1, Less,    $3) }
| expr LEQ    expr   { Binop($1, Leq,     $3) }
| expr GT     expr   { Binop($1, Greater, $3) }
| expr GEQ    expr   { Binop($1, Geq,     $3) }
| expr AND    expr   { Binop($1, And,     $3) }
| expr OR     expr   { Binop($1, Or,      $3) }
| NOT expr           { Not($2) }
