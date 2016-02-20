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
    | '+'                             { ADDOP }
    | '-'                             { SUBOP }
    | '*'                             { MULOP }
    | '/'                             { DIVOP }
    | '%'                             { MOD }
    | '<'                             { LT }
    | '>'                             { GT }
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
    | "int"                           { INT }
    | "char"                          { CHAR }
    | "string"                        { STRING }
    | "float"                         { FLOAT }
    | "pdf"                           { PDF }
    | "blob"                          { BLOB }
    | "dataset"                       { DATASET }
    | "page"                          { PAGE }
    | "list"                          { LIST }
    | eof                             { EOF }

and comment = parse
    | '/n'                            {token lexbuf}
    | _                               {comment lexbuf}
