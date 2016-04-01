include Ast

type tbinop = Add | Sub | Mul | Div | Mod | Equal | Neq | Less | Leq | Greater | Geq |
          And | Or | Swap | Append | Concat

type tuop = Neg | Not

type tdata_type = Int | Bool | Float | String | Pdf | Page

type tlist_data_type = List

type tsp_data_type = Line

type tid = string

type tvar_decl =  tid * tdata_type

type tlist_var_decl = tid * tlist_data_type * tdata_type


type t = tdata_type 
| tlist_data_type 
| tsp_data_type



type texpression =
  TLitInt of int * t
  | TLitString of string * t
  | TIden of tid * t
  | TLitFloat of float * t
  | TLitBool of bool * t
  | TUop of tuop * texpression * t
  | TBinop of texpression * tbinop * texpression * t
  | TCallExpr of string * texpression list * t
  | TNoexpr


type tstatement =
  | TRet of texpression * t
  | TWhile of texpression * tstatement list
  | TIf of tconditional list * tstatement list option
  | TAssign of tid * texpression
  | TVdecl of tvar_decl
  | TListDecl of tlist_var_decl
  | TInitAssign of tid * tdata_type * texpression
  | TObjectCreate of tid * tsp_data_type * texpression list
  | TFor of tstatement * texpression * tstatement * tstatement list
  | TCallStmt of string * texpression list

  and tconditional = {
    tcondition : texpression;
    tbody : tstatement list;
  }
  
type timport_stmt = 
  | TImport of string

type tfunc_decl = {
  trtype : tdata_type;
  tname : string;
  tformals : tstatement list;
  tbody : tstatement list;
}

type tprogram = TProgram of timport_stmt list * tfunc_decl list
