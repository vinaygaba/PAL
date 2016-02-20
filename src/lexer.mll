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
    | '%'                             { MOD }
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
    | '/n'                            {token lexbuf}
    | _                               {comment lexbuf}
