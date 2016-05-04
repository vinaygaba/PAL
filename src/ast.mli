type binop = Add | Sub | Mul | Div | Mod | Equal | Neq | Less | Leq | Greater | Geq |
          And | Or | Swap | Append | Concat

type uop = Neg | Not | LineBuffer

type list_data_type = List

type id = IdTest of string

type recr_t =
  | TType of t
  | RType of recr_t

and t = Int | Bool | Float | String | Pdf | Page | Line | Tuple | Image | ListType of string | MapType of t * t

type var_decl =  id * t

(*type recur_list_decl = list_data_type * recur_list_decl
| data_type*)

(*type list_var_decl = id * recur_list_decl * data_type*)
type map_decl = id * t * recr_t

type list_var_decl = id * recr_t

type expression =
  LitInt of int
  | LitString of string
  | Iden of id
  | LitFloat of float
  | LitBool of bool
  | Uop of uop * expression
  | Binop of expression * binop * expression
  | CallExpr of string * expression list
  | ListAccess of id * expression
  | MapAccess of id * expression

type statement =
  | ControlStmt of string
  | Ret of expression
  | While of expression * statement list
  | If of conditional list * statement list option
  | Assign of id * expression
  | ListAssign of expression * expression
  | Vdecl of var_decl
  | ListDecl of list_var_decl
  | MapDecl of map_decl
  | InitAssign of id * t * expression
  | ObjectCreate of id * t * expression list
  | For of statement * expression * statement * statement list
  | CallStmt of string * expression list
  | MapAdd of id * expression * expression
  | MapRemove of id * expression
  | ListAdd of id * expression
  | ListRemove of id * expression

  and conditional = {
    condition : expression;
    body : statement list;
  }


type import_stmt =
  | Import of string

type func_decl = {
  rtype : recr_t;
  name : string;
  formals : statement list;
  body : statement list;
}

type main_func_decl = {
  body : statement list;
}

type program =  {
  ilist : import_stmt list ;
  mainf : main_func_decl ;
  declf : func_decl list ;
}
