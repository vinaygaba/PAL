type binop = Add | Sub | Mul | Div | Mod | Equal | Neq | Less | Leq | Greater | Geq |
          And | Or | Swap | Append | Concat

type uop = Neg | Not

type data_type = Int | Bool | Float | String | Pdf | Page

type sp_data_type = Line

type id = string

type var_decl = id * data_type



type expression =
  LitInt of int
  | LitString of string
  | Iden of id
  | LitFloat of float
  | LitBool of bool
  | Uop of uop * expression
  | Binop of expression * binop * expression
  | Call of string * expression list
  | Noexpr

  type statement =
    | While of expression * statement list
    | If of conditional list * stmt list option
    | Vdecl of var_decl
    | Assign of id * expression
    | InitAssign of id * data_type * expression
    | ObjectCreate of id * sp_data_type * expression
    | For of statement * expression * statement * statement list
    | Ret of expression


    type func_decl = {
      rtype : data_type;
      name : string;
      formals : var_decl list;
      body : statement list;
    }

 type program = statement list
