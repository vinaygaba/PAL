%{ open Ast %}
%token SEMICOLON
%token LEFTBRACE LEFTPAREN LEFTBRAC RIGHTBRACE RIGHTPAREN RIGHTBRAC COMMA
%token ADDOP SUBOP MULOP DIVOP MODOP
%token SWAP CONCAT TYPEASSIGNMENT LINEBUFFER
%token EQ NEQ LT GT LEQ GEQ
%token NOT AND OR
%token ASSIGN
%token IF ELIF ELSE WHILELOOP FORLOOP BREAK CONTINUE VOID NULL
%token EOF
%token IMPORT FUNCTION RETURN
%token <string> ID
%token <string> STRING
%token <int> INT
%token <float> FLOAT
%token <bool> BOOL
%token INTD BOOLD STRINGD FLOATD PDFD PAGED LINED
%left ASSIGN
%left OR
%left AND
%left EQ NEQ
%nonassoc LT LEQ GT GEQ
%left ADDOP SUBOP
%left CONCAT
%left MULOP DIVOP MODOP
%nonassoc TYPEASSIGNMENT
%right NOT
%left LEFTBRAC RIGHTBRACK
%left LEFTPAREN RIGHTPAREN
%start program
%type <Ast.program> program
%%

<<<<<<< HEAD
func_decl_list:
                          {[]}
  | func_decl_list func_decl {$2 :: $1}
=======
program:
  import_decl_list func_decl_list EOF  { Program(List.rev $1, List.rev $2) }

import_decl_list:
                                   { [] }
  | import_decl_list import_decl { $2::$1 }

func_decl_list:
                                    { [] }
  | func_decl_list func_decl        { $2::$1 }

func_decl : 
  ID LEFTPAREN expr_list RIGHTPAREN TYPEASSIGNMENT data_type body { rtype : $6; name : $1; formals : $3 ; body : $7; } 
  

import_decl:
	IMPORT LEFTPAREN STRING RIGHTPAREN SEMICOLON { Import($3) }

>>>>>>> 806fbcecf3c9ba682ff9503796ee8b86bc362525


  import_decl_list:
                            {[]}
    | import_decl_list import_decl {$2 :: $1}

func_decl:
  ID LEFTPAREN expr_list RIGHTPAREN TYPEASSIGNMENT data_type body {FuncDeclaration($6, $1, $3, $7)}

import_decl:
  IMPORT LEFTPAREN STRING RIGHTPAREN SEMICOLON    {Import($3)}

program:
  import_decl_list func_decl_list EOF {Program(List.rev $1, List.rev $2)}


  stmt:
    | WHILELOOP LEFTPAREN expr RIGHTPAREN body                        { While($3, $5) }
  /*| IF LPAREN expr RPAREN body elifs else_opt                       { If({condition=$3;body=$5} :: $6, $7) } */
    | ID TYPEASSIGNMENT data_type SEMICOLON                           { Vdecl($1, $3) }
    | assign_stmt SEMICOLON                                           { $1 }
    | ID TYPEASSIGNMENT sp_data_type LEFTPAREN expr RIGHTPAREN   { ObjectCreate($1, $3, $5) }
    | FORLOOP LEFTPAREN assign_stmt SEMICOLON expr_stmt SEMICOLON assign_stmt RIGHTPAREN body { For($3, $5, $7, $9) }
    | RETURN expr SEMICOLON                                           { Ret($2) }
    | function_call                                                    {CallStmt(fst $1,snd $1)}

stmt_list:
   /* nothing */  { [] }
 | stmt_list stmt { $2 :: $1 }


body:
   LEFTBRACE stmt_list RIGHTBRACE { List.rev $2 }


assign_stmt:
  ID ASSIGN expr                                                    { Assign($1, $3) }
| ID TYPEASSIGNMENT data_type ASSIGN expr                           { InitAssign($1,$3,$5) }


data_type:
STRINGD                                                             { String }
| INTD                                                              { Int }
| FLOATD                                                            { Float }
| BOOLD                                                             { Bool }

sp_data_type:
LINED { Line }


expr:
STRING               { LitString($1) }
| INT                { LitInt($1) }
| FLOAT              { LitFloat($1)}
| BOOL               { LitBool($1) }
| ID		             { Iden($1) }
| expr ADDOP expr    { Binop($1, Add, $3) }
| expr SUBOP expr    { Binop($1, Sub, $3) }
| expr MULOP expr    { Binop($1, Mul, $3) }
| expr DIVOP expr    { Binop($1, Div, $3) }
| expr CONCAT expr   { Binop($1, Concat,  $3) }
| expr MODOP expr    { Binop($1, Mod,     $3) }
| expr_stmt          { $1 }
| expr AND    expr   { Binop($1, And,     $3) }
| expr OR     expr   { Binop($1, Or,      $3) }
| NOT  expr         { Uop(Not,$2) }
| function_call     {CallExpr(fst $1,snd $1)}


expr_list:
   /* nothing */  { [] }
  | expr_list expr COMMA {$2 :: $1 }
  | expr_list expr {$2 :: $1}


  expr_stmt:
    expr EQ     expr                                                { Binop($1, Equal,   $3) }
  | expr NEQ    expr                                                { Binop($1, Neq,     $3) }
  | expr LT     expr                                                { Binop($1, Less,    $3) }
  | expr LEQ    expr                                                { Binop($1, Leq,     $3) }
  | expr GT     expr                                                { Binop($1, Greater, $3) }
  | expr GEQ    expr                                                { Binop($1, Geq,     $3) }


<<<<<<< HEAD
  function_call:
       ID LEFTPAREN expr_list RIGHTPAREN SEMICOLON                    {($1,$3)}
/*Remove the swap operator.
+Allows you to add only objects of similar type
. lets you add objects of different types
. had higher precedence than +
Eg. pdf1 . page1 + pad2.page2*/
=======
>>>>>>> 806fbcecf3c9ba682ff9503796ee8b86bc362525
