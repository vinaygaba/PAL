type token =
  | ADDOP
  | SUBOP
  | MULOP
  | DIVOP
  | MODOP
  | EOF
  | STRING of (string)
  | INT of (int)

val expr :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Ast.expression
