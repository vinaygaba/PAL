{

open Parser

}

(*test*)

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
    | "::"                            { LINEBUFFER }
    | '{'                             { LEFTPAREN }
    | '}'                             { RIGHTPAREN }
    | "+="                            { APPEND }
    | "while"                         { WHILE }
    | digit+ as num                   { LITERAL(int_of_string num) }
    | digit+ as int                   { INT(int_of_string int) }
    | digit+'.'digit+ as float        { FLOAT(float_of_string float) }
    | "bool"                          { BOOL }
    | "true"                          { TRUE }
    | "false"                         { FALSE }
    | "int"                           { INTD }
    | "float"                         { FLOATD }
    | "string"                        { STRINGD }
    | "pdf"                           { PDF }
    | "page"                          { PAGE }
    | "line"                          { LINE }
    | "list"                          { LIST }
    | "map"                           { MAP }
    | "paragraph"                     { PARAGRAPH }
    | "if"                            { IF }
    | "elif"                          { ELIF }
    | "else"                          { ELSE }
    | "while"                         { WHILELOOP }
    | "for"                           { FORLOOP }
    | "break"                         { BREAK }
    | "continue"                      { CONTINUE }
    | "import"                        { IMPORT }
    | "split"                         { SPLIT }
    | "watermark"                     { WATERMARK }
    | "protect"                       { PROTECT }
    | "loadText"                      { LOADTEXT }
    | "loadImage"                     { LOADIMAGE }
    | "loadPDF"                       { LOADPDF  }
    | "loadCSV"                       { LOADCSV }
    | "renderPDF"                     { RENDER }
    | "print"                         { PRINT }
    | "scan"                          { SCAN }
    | "sizeof"                        { SIZE }
    | "void"                          { VOID }
    | "null"                          { NULL }
    | id                              { ID(id) }
    | digit+ as int                   { INT(int_of_string int) }
    | '"'('\\'_|[^'"'])*'"' as str    { STRING(str) }
    | eof                             { EOF }
    | _ as char { raise (Failure("illegal character " ^ Char.escaped char)) }

and comment = parse
    | '\n'                            {token lexbuf}
    | _                               {comment lexbuf}
