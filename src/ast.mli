type op = Add | Sub | Mult | Div | Mod | Equal | Neq | Less | Leq | Greater | Geq |
          And | Or | Swap | Append

type uop = Neg | Not

type data_type = Int | Boolean | Float | Byte | Char | String |

type var_decl = {
  dtype: data_type;
  vname: string;
}

type func_decl = {
  rtype : data_type;
  name : string;
  formals : var_decl list;
  body : statement list;
}

type expression =
  Int of int
  | String of string
  | Float of float
  | Stock of string
  | Var of string
  | Unop of unop * expression
  | Binop of expression * binop * expression
  | Assign of string * expression
  | Call of string * expression list
  | Noexpr

  type statement =
    Expr of expression
    | While of expression * statement list
    | When of (expression * binop * expression) * statement list
    | If of expression * statement list * statement list
    | Vdecl of var_decl
    | Ret of expression
    | Print of expression
    | Fdecl of func_decl

  type program = {
        statements : statement list;
    }
