type token =
  | SEMICOLON
  | LEFTBRACE
  | LEFTPAREN
  | LEFTBRAC
  | RIGHTBRACE
  | RIGHTPAREN
  | RIGHTBRAC
  | COMMA
  | ADDOP
  | SUBOP
  | MULOP
  | DIVOP
  | MODOP
  | SWAP
  | CONCAT
  | TYPEASSIGNMENT
  | LINEBUFFER
  | EQ
  | NEQ
  | LT
  | GT
  | LEQ
  | GEQ
  | NOT
  | AND
  | OR
  | ASSIGN
  | IF
  | ELIF
  | ELSE
  | WHILELOOP
  | FORLOOP
  | BREAK
  | CONTINUE
  | VOID
  | NULL
  | EOF
  | IMPORT
  | FUNCTION
  | RETURN
  | ID of (string)
  | STRING of (string)
  | INT of (int)
  | FLOAT of (float)
  | BOOL of (bool)
  | INTD
  | BOOLD
  | STRINGD
  | FLOATD
  | PDFD
  | PAGED
  | LINED

val expr :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Ast.expr
