type binop = Add | Sub | Mul | Div | Mod | Equal | Neq | Less | Leq | Greater | Geq |
          And | Or | Swap | Append

type uop = Neg | Not

type data_type = Int | Boolean | Float | Bool | String | Pdf | Page

type sp_data_type = Line

type var_decl = id * data_type

type id = String

type expression =
  Int of int
  | String of string
  | Iden of id
  | Float of float
  | Bool of boolean
  | Uop of uop * expression
  | Binop of expression * binop * expression
  | Call of string * expression list
  | Noexpr

  type statement =
    | While of expression * statement list
    | If of expression * statement list * statement list
    | Vdecl of var_decl
    | Assign of id * expression
    | InitAssign of var_decl * expression
    | ObjectCreate of id * sp_data_type * expression list
    | For of statement * expression * statement * statement list



    type func_decl = {
      rtype : data_type;
      name : string;
      formals : var_decl list;
      body : statement list;
    }

 type program = statement list
