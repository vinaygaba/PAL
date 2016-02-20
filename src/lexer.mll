{

open Parser

}



let digit = ['0'-'9']
let id = ['a'-'z'] ['a'-'z' 'A'-'Z' '0'-'9' '_']* ['?']?
let ws = [' ' '\r' '\t' '\n']


rule token = parse
    | ws                              {token lexbuf}
    | '#'                             {comment lexbuf}
    | '='                             { ASSIGN }
    | '#'                             { COMMENT }
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
    | ','                             { COMMA }
    | ';'                             { SEMICOLON }
    | ':'                             { TYPEASSIGNMENT }
    | '{'                             { LEFTPAREN }
    | '}'                             { RIGHTPAREN }
    | "+="                            { APPEND }
    | "while"                         { WHILE }
    | "if"                            { IF }
    | digit+ as num                   { LITERAL(int_of_string num) }
    | digit+ as int                   { INT(int_of_string int) }
    | digit+'.'digit+ as float        { FLOAT(float_of_string float) }
    | "boolean"                       { BOOL }
    | "true"                          { TRUE }
    | "false"                         { FALSE }
    | "int"                           { INT }
    | "byte"                          { BYTE }
    | "char"                          { CHAR }
    | "string"                        { STRING }
    | "float"                         { FLOAT }
    | "pdf"                           { PDF }
    | "blob"                          { BLOB }
    | "dataset"                       { DATASET }
    | "page"                          { PAGE }
    | "list"                          { LIST }
    | "return"                        { RETURN }
    | id                              { ID(id) }
    | eof                             { EOF }
    | _ as char { raise (Failure("illegal character " ^ Char.escaped char)) }

and comment = parse
    | '\n'                            {token lexbuf}
    | _                               {comment lexbuf}
