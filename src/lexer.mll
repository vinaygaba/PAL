{

open Parser

}



let digit = ['0'-'9']
let id = ['a'-'z'] ['a'-'z' 'A'-'Z' '0'-'9' '_']* ['?']?
let ws = [' ' '\r' '\t']


rule token = parse
    | "="     { ASSIGN }
    | '#'      { COMMENT }
    | '+'      { ADDOP }
    | '-'      { SUBOP }
    | '*'      { MULOP }
    | '/'      { DIVOP }
    | ','      { COMMA }
    | ';'      { SEMICOLON }
    | ':'      { TYPEASSIGNMENT }
    | '{'      { LEFTPAREN }
    | '}'      { RIGHTPAREN }
    | "+="     { APPEND }
    | eof      { EOF }
