open Ast
let rec eval = function
String(x) -> x
| Int(x) -> x
| Binop(e1, op, e2) ->
let v1 = eval e1 and v2 = eval e2 in
(match op with
| Add -> ( match v1 with
| int ->  string_of_int ((int_of_string v1) + (int_of_string v2))
| string -> v1 ^ v2
)
| _ -> v1 ^ v2
)

let _ =
let lexbuf = Lexing.from_channel stdin in
let expr = Parser.expr Lexer.token lexbuf in
let result = eval expr in
print_endline (result);;
