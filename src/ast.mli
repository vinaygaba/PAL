type binop = Add | Sub | Mul | Div | Mod | Equal | Neq | Less | Leq | Greater | Geq |
          And | Or | Swap | Append | Concat

type uop = Neg | Not

type data_type = Int | Bool | Float | String | Pdf | Page

type list_data_type = List

type sp_data_type = Line | Tuple

type id = IdTest of string

type t = Int | Bool | Float | String | Pdf | Page


type var_decl =  id * t


(*type recur_list_decl = list_data_type * recur_list_decl 
| data_type*)

(*type list_var_decl = id * recur_list_decl * data_type*)


type list_var_decl = id * list_data_type * data_type

type expression =
  LitInt of int
  | LitString of string
  | Iden of id
  | LitFloat of float
  | LitBool of bool
  | Uop of uop * expression
  | Binop of expression * binop * expression
  | CallExpr of string * expression list
  | Noexpr


type statement =
  | Ret of expression
  | While of expression * statement list
  | If of conditional list * statement list option
  | Assign of id * expression
  | Vdecl of var_decl
  | ListDecl of list_var_decl
  | InitAssign of id * data_type * expression
  | ObjectCreate of id * sp_data_type * expression list
  | For of statement * expression * statement * statement list
  | CallStmt of string * expression list

  and conditional = {
    condition : expression;
    body : statement list;
  }

type import_stmt =
  | Import of string


type func_decl = {
  rtype : t;
  name : string;
  formals : statement list;
  body : statement list;
}

type main_func_decl = {
  body : statement list;
}

type program = {
  ilist : import_stmt list option;
  mainf : main_func_decl option;
  declf : func_decl list option;
}
