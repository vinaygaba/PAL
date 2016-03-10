type binop = Add | Sub | Mul | Div | Mod | Equal | Neq | Less | Leq | Greater | Geq |
          And | Or | Swap | Append

type uop = Neg | Not

type data_type = Int | Boolean | Float | Byte | Char

type var_decl = {
  dtype: data_type;
  vname: string;
}


type expression =
  Int of int
  | String of string
  | Float of float
  | Uop of uop * expression
  | Binop of expression * binop * expression
  | Assign of string * expression
  | Call of string * expression list
  | Noexpr

  type statement =
    Expr of expression
    | While of expression * statement list
    | If of expression * statement list * statement list
    | Vdecl of var_decl
    | Ret of expression
    | Print of expression


    type func_decl = {
      rtype : data_type;
      name : string;
      formals : var_decl list;
      body : statement list;
    }

  type program = {
        statements : statement list;
    }
