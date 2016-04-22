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
%token IMPORT FUNCTION RETURN MAIN
%token <string> ID
%token IDTEST
%token <string> STRING
%token <int> INT
%token <float> FLOAT
%token <bool> BOOL
%token INTD BOOLD STRINGD FLOATD PDFD PAGED LINED LISTD TUPLED IMAGED MAPD
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

program:
  import_decl_list main_func_decl_option func_decl_list EOF  { { ilist = List.rev $1 ; mainf = $2 ; declf = List.rev $3} }

main_func_decl_option:
  MAIN LEFTPAREN RIGHTPAREN body { { body = $4 }  }


import_decl_list:
                                   { [] }
  | import_decl_list import_decl { $2::$1 }

func_decl_list:
                                    { [] }
  | func_decl_list func_decl        { $2::$1 }

func_decl :
  ID LEFTPAREN stmt_list RIGHTPAREN TYPEASSIGNMENT data_type body {
    { rtype = $6 ; name = $1; formals = $3 ; body = $7; }
  }



import_decl:
	IMPORT LEFTPAREN STRING RIGHTPAREN SEMICOLON { Import($3) }


stmt_list:
   /* nothing */  { [] }
 | stmt_list stmt { $2 :: $1 }



expr_list:
   /* nothing */  { [] }
  | expr_list expr COMMA {$2 :: $1 }
  | expr_list expr {$2 :: $1}


body:
   LEFTBRACE stmt_list RIGHTBRACE { List.rev $2 }

function_call:
     ID LEFTPAREN expr_list RIGHTPAREN SEMICOLON                    { ($1,List.rev $3) }



stmt:
  | assign_stmt SEMICOLON                                           { $1 }
  | FORLOOP LEFTPAREN assign_stmt SEMICOLON expr_stmt SEMICOLON assign_stmt RIGHTPAREN body { For($3, $5, $7, $9) }
  | RETURN expr SEMICOLON                                           { Ret($2) }
  | function_call                                                   { CallStmt(fst $1,snd $1) }
  | v_decl                                                          { Vdecl(fst $1, snd $1) }
  | list_decl                                                       { ListDecl(fst $1, snd $1) }
  | ID TYPEASSIGNMENT MAPD data_type COMMA recr_data_type SEMICOLON      { MapDecl(Ast.IdTest($1),$4,$6) }
  | WHILELOOP LEFTPAREN expr_stmt RIGHTPAREN body                   { While($3, $5) }
  | ID TYPEASSIGNMENT sp_data_type LEFTPAREN expr_list RIGHTPAREN SEMICOLON  { ObjectCreate(Ast.IdTest($1), $3, $5) }
  | IF LEFTPAREN expr_stmt RIGHTPAREN body elifs else_opt {If({condition = $3; body = $5} :: $6, $7)}
  | ID ADDOP ASSIGN expr COMMA expr SEMICOLON                       { MapAdd(Ast.IdTest($1), $4, $6) }
  | ID SUBOP ASSIGN expr SEMICOLON                                  { MapRemove(Ast.IdTest($1), $4) }
  | ID ADDOP ASSIGN expr SEMICOLON                                  { ListAdd(Ast.IdTest($1), $4) }
  | ID SUBOP ASSIGN LEFTBRAC expr RIGHTBRAC SEMICOLON               { ListRemove(Ast.IdTest($1), $5) }

elifs:
  | {[]}
  | ELIF LEFTPAREN expr_stmt RIGHTPAREN body elifs { {condition = $3; body = $5} :: $6 }

else_opt:
  | {None}
  | ELSE body {Some($2)}

list_decl:
  | ID TYPEASSIGNMENT LISTD recr_data_type SEMICOLON                           { (Ast.IdTest($1), $4) }

recr_data_type:
  | sp_data_type                                                               { (Ast.TType($1)) }
  | data_type                                                                  { (Ast.TType($1)) }
  | LISTD recr_data_type                                                       { (Ast.RType($2)) }

v_decl :
| ID TYPEASSIGNMENT data_type SEMICOLON                           { (Ast.IdTest($1),$3) }

assign_stmt:
  ID ASSIGN expr                                                  { Assign(Ast.IdTest($1), $3) }
| ID TYPEASSIGNMENT data_type ASSIGN expr                         { InitAssign(Ast.IdTest($1),$3,$5) }
| list_access ASSIGN expr                                         { ListAssign(ListAccess(fst $1, snd $1), $3) }

expr_stmt:
  expr EQ     expr                                                { Binop($1, Equal,   $3) }
| expr NEQ    expr                                                { Binop($1, Neq,     $3) }
| expr LT     expr                                                { Binop($1, Less,    $3) }
| expr LEQ    expr                                                { Binop($1, Leq,     $3) }
| expr GT     expr                                                { Binop($1, Greater, $3) }
| expr GEQ    expr                                                { Binop($1, Geq,     $3) }

data_type:
STRINGD                                                             { String }
| INTD                                                              { Int }
| FLOATD                                                            { Float }
| BOOLD                                                             { Bool }
| PDFD                                                              { Pdf }
| PAGED                                                             { Page }


list_data_type:
LISTD { List }

sp_data_type:
LINED { Line }
| TUPLED { Tuple }
| IMAGED { Image }


expr:
STRING               { LitString($1) }
| INT                { LitInt($1) }
| FLOAT              { LitFloat($1)}
| BOOL               { LitBool($1) }
| ID		             { Iden(Ast.IdTest($1)) }
| list_access        { ListAccess(fst $1,snd $1) }
| ID TYPEASSIGNMENT ASSIGN expr { MapAccess(Ast.IdTest($1), $4) }
| expr ADDOP expr    { Binop($1, Add, $3) }
| expr SUBOP expr    { Binop($1, Sub, $3) }
| expr MULOP expr    { Binop($1, Mul, $3) }
| expr DIVOP expr    { Binop($1, Div, $3) }
| expr CONCAT expr   { Binop($1, Concat,  $3) }
| expr MODOP expr    { Binop($1, Mod,     $3) }
| LEFTPAREN expr RIGHTPAREN { $2 }
| expr_stmt          { $1 }
| expr AND    expr   { Binop($1, And,     $3) }
| expr OR     expr   { Binop($1, Or,      $3) }
| NOT  expr         { Uop(Not,$2) }
| function_call     {CallExpr(fst $1,snd $1)}

list_access:
ID LEFTBRAC expr RIGHTBRAC { (Ast.IdTest($1), $3) }
