{

open Parser

}



let digit = ['0'-'9']
let id = ['a'-'z'] ['a'-'z' 'A'-'Z' '0'-'9' '_']* ['?']?
let ws = [' ' '\r' '\t']


rule micro = parse
    | "="     { ASSIGN }
    | '+'      { ADDOP }
    | '-'      { SUBOP }
    | ','      { COMMA }
    | ';'      { SEMICOLON }
    | '{'      { LEFTPAREN }
    | '}'      { RIGHTPAREN }
    
