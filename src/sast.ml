open Ast

type texpression =
  TLitInt of int * t
  | TLitString of string * t
  | TIden of Ast.id * t
  | TLitFloat of float * t
  | TLitBool of bool * t
  | TUop of Ast.uop * texpression * t
  | TBinop of texpression * Ast.binop * texpression * t
  | TCallExpr of string * texpression list * t
  | TNoexpr


type tstatement =
  | TRet of texpression * t
  | TWhile of texpression * tstatement list
  | TIf of tconditional list * tstatement list option
  | TAssign of Ast.id * texpression
  | TVdecl of Ast.var_decl
  | TListDecl of Ast.id * string
  | TInitAssign of Ast.id * Ast.t * texpression
  | TObjectCreate of Ast.id * Ast.t * texpression list
  | TFor of tstatement * texpression * tstatement * tstatement list
  | TCallStmt of string * texpression list

  and tconditional = {
    tcondition : texpression;
    tbody : tstatement list;
  }

type timport_stmt =
  | TImport of string

type tfunc_decl = {
  rtype : Ast.t;
  name : string;
  tformals : tstatement list;
  tbody : tstatement list;
}

type tmain_func_decl = {
  tbody : tstatement list;
}

type tprogram = {
  tilist : timport_stmt list;
  tmainf : tmain_func_decl;
  tdeclf : tfunc_decl list;
}
