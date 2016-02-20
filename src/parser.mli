type token =
  | ADDOP
  | SUBOP
  | MULOP
  | DIVOP
  | MODOP
  | EOF
  | LITERAL of (int)
  | VARIABLE of (int)
  | STRING of (string)

val expr :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Ast.expression
