{

open Parser

}

(*test*)

let digit = ['0'-'9']
let id = ['a'-'z'] ['a'-'z' 'A'-'Z' '0'-'9' '_']* ['?']?
let ws = [' ' '\r' '\t' '\n']


rule token = parse
    | ws                              {token lexbuf}
    | ','                             { COMMA }
    | ';'                             { SEMICOLON }
    | ':'                             { TYPEASSIGNMENT }
    | "::"                            { LINEBUFFER }
    | eof                             { EOF }
    (* Scoping *)
    | '{'                             { LEFTBRACE }
    | '}'                             { RIGHTBRACE }
    | '('                             { LEFTPAREN }
    | ')'                             { RIGHTPAREN }
    | '['                             { LEFTBRAC }
    | ']'                             { RIGHTBRAC }
    (* Operators *)
    | '*'                             { MULOP }
    | '/'                             { DIVOP }
    | '+'                             { ADDOP }
    | '-'                             { SUBOP }
    | '%'                             { MODOP }
    | "<>"                            { SWAP }
    | "<="                            { LEQ }
    | ">="                            { GEQ }
    | '<'                             { LT }
    | '>'                             { GT }
    | "=="                            { EQ }
    | "!="                            { NEQ }
    | "&&"                            { AND }
    | "||"                            { OR }
    | "!"                             { NOT }
    | '='                             { ASSIGN }
    | '.'                             { CONCAT }
    (* Keywords *)
    | "bool"                          { BOOLD }
    | "true"                          { BOOL(true) }
    | "false"                         { BOOL(false) }
    | "int"                           { INTD }
    | "float"                         { FLOATD }
    | "string"                        { STRINGD }
    | "pdf"                           { PDFD }
    | "page"                          { PAGED }
    | "line"                          { LINED }
    | "list"                          { LISTD }
    | "if"                            { IF }
    | "elif"                          { ELIF }
    | "else"                          { ELSE }
    | "while"                         { WHILELOOP }
    | "for"                           { FORLOOP }
    | "break"                         { BREAK }
    | "continue"                      { CONTINUE }
    | "import"                        { IMPORT }
    | "void"                          { VOID }
    | "null"                          { NULL }
    | "function"                      { FUNCTION }
    (* Literals *)
    | digit+ as int                   { INT(int_of_string int) }
    | digit+'.'digit+ as float        { FLOAT(float_of_string float) }
    | '"'('\\'_|[^'"'])*'"' as str    { STRING(str) }
    (* Identifier *)
    | id as i                              { ID(i) }
    (* Comment *)
    | '#'                             {comment lexbuf}
    | _ as char { raise (Failure("Illegal character " ^ Char.escaped char)) }

and comment = parse
    | '\n'                            {token lexbuf}
    | _                               {comment lexbuf}
