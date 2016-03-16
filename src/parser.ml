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

open Parsing;;
let _ = parse_error;;
# 1 "parser.mly"
 open Ast 
# 60 "parser.ml"
let yytransl_const = [|
  257 (* SEMICOLON *);
  258 (* LEFTBRACE *);
  259 (* LEFTPAREN *);
  260 (* LEFTBRAC *);
  261 (* RIGHTBRACE *);
  262 (* RIGHTPAREN *);
  263 (* RIGHTBRAC *);
  264 (* COMMA *);
  265 (* ADDOP *);
  266 (* SUBOP *);
  267 (* MULOP *);
  268 (* DIVOP *);
  269 (* MODOP *);
  270 (* SWAP *);
  271 (* CONCAT *);
  272 (* TYPEASSIGNMENT *);
  273 (* LINEBUFFER *);
  274 (* EQ *);
  275 (* NEQ *);
  276 (* LT *);
  277 (* GT *);
  278 (* LEQ *);
  279 (* GEQ *);
  280 (* NOT *);
  281 (* AND *);
  282 (* OR *);
  283 (* ASSIGN *);
  284 (* IF *);
  285 (* ELIF *);
  286 (* ELSE *);
  287 (* WHILELOOP *);
  288 (* FORLOOP *);
  289 (* BREAK *);
  290 (* CONTINUE *);
  291 (* VOID *);
  292 (* NULL *);
    0 (* EOF *);
  293 (* IMPORT *);
  294 (* FUNCTION *);
  295 (* RETURN *);
  301 (* INTD *);
  302 (* BOOLD *);
  303 (* STRINGD *);
  304 (* FLOATD *);
  305 (* PDFD *);
  306 (* PAGED *);
  307 (* LINED *);
    0|]

let yytransl_block = [|
  296 (* ID *);
  297 (* STRING *);
  298 (* INT *);
  299 (* FLOAT *);
  300 (* BOOL *);
    0|]

let yylhs = "\255\255\
\002\000\003\000\003\000\005\000\004\000\004\000\004\000\004\000\
\004\000\004\000\007\000\007\000\009\000\009\000\009\000\009\000\
\009\000\009\000\006\000\006\000\006\000\006\000\008\000\001\000\
\001\000\001\000\001\000\001\000\001\000\001\000\001\000\001\000\
\001\000\001\000\001\000\001\000\001\000\001\000\000\000"

let yylen = "\002\000\
\001\000\000\000\002\000\003\000\005\000\004\000\002\000\006\000\
\009\000\003\000\003\000\005\000\003\000\003\000\003\000\003\000\
\003\000\003\000\001\000\001\000\001\000\001\000\001\000\001\000\
\001\000\001\000\001\000\001\000\003\000\003\000\003\000\003\000\
\003\000\003\000\001\000\003\000\003\000\002\000\002\000"

let yydefred = "\000\000\
\000\000\000\000\000\000\028\000\024\000\025\000\026\000\027\000\
\000\000\035\000\038\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\031\000\032\000\034\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000"

let yydgoto = "\002\000\
\009\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\010\000"

let yysindex = "\255\255\
\011\255\000\000\011\255\000\000\000\000\000\000\000\000\000\000\
\055\255\000\000\000\000\011\255\011\255\011\255\011\255\011\255\
\011\255\011\255\011\255\011\255\011\255\011\255\011\255\011\255\
\011\255\027\255\027\255\000\000\000\000\000\000\247\254\105\255\
\105\255\003\255\003\255\003\255\003\255\090\255\073\255"

let yyrindex = "\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\007\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\019\000\037\000\000\000\000\000\000\000\001\000\046\000\
\048\000\050\000\059\000\061\000\063\000\005\000\006\000"

let yygindex = "\000\000\
\008\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000"

let yytablesize = 345
let yytable = "\001\000\
\033\000\014\000\015\000\016\000\036\000\037\000\039\000\000\000\
\000\000\000\000\011\000\012\000\013\000\014\000\015\000\016\000\
\000\000\017\000\029\000\026\000\027\000\028\000\029\000\030\000\
\031\000\032\000\033\000\034\000\035\000\036\000\037\000\038\000\
\039\000\000\000\003\000\000\000\030\000\014\000\015\000\016\000\
\000\000\017\000\000\000\000\000\000\000\013\000\000\000\014\000\
\000\000\015\000\004\000\005\000\006\000\007\000\008\000\000\000\
\000\000\000\000\017\000\000\000\016\000\000\000\018\000\012\000\
\013\000\014\000\015\000\016\000\000\000\017\000\000\000\000\000\
\018\000\019\000\020\000\021\000\022\000\023\000\000\000\024\000\
\025\000\012\000\013\000\014\000\015\000\016\000\000\000\017\000\
\000\000\000\000\018\000\019\000\020\000\021\000\022\000\023\000\
\000\000\024\000\012\000\013\000\014\000\015\000\016\000\000\000\
\017\000\000\000\000\000\018\000\019\000\020\000\021\000\022\000\
\023\000\012\000\013\000\014\000\015\000\016\000\000\000\017\000\
\000\000\000\000\000\000\000\000\020\000\021\000\022\000\023\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\033\000\033\000\000\000\000\000\000\000\000\000\033\000\
\000\000\000\000\033\000\033\000\033\000\033\000\033\000\033\000\
\000\000\033\000\033\000\029\000\029\000\036\000\036\000\037\000\
\000\000\000\000\000\000\000\000\029\000\029\000\029\000\029\000\
\029\000\029\000\000\000\029\000\029\000\030\000\030\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\030\000\030\000\
\030\000\030\000\030\000\030\000\000\000\030\000\030\000\013\000\
\013\000\014\000\014\000\015\000\015\000\000\000\013\000\013\000\
\014\000\014\000\015\000\015\000\017\000\017\000\016\000\016\000\
\018\000\018\000\000\000\017\000\017\000\016\000\016\000\018\000\
\018\000"

let yycheck = "\001\000\
\000\000\011\001\012\001\013\001\000\000\000\000\000\000\255\255\
\255\255\255\255\003\000\009\001\010\001\011\001\012\001\013\001\
\255\255\015\001\000\000\012\000\013\000\014\000\015\000\016\000\
\017\000\018\000\019\000\020\000\021\000\022\000\023\000\024\000\
\025\000\255\255\024\001\255\255\000\000\011\001\012\001\013\001\
\255\255\015\001\255\255\255\255\255\255\000\000\255\255\000\000\
\255\255\000\000\040\001\041\001\042\001\043\001\044\001\255\255\
\255\255\255\255\000\000\255\255\000\000\255\255\000\000\009\001\
\010\001\011\001\012\001\013\001\255\255\015\001\255\255\255\255\
\018\001\019\001\020\001\021\001\022\001\023\001\255\255\025\001\
\026\001\009\001\010\001\011\001\012\001\013\001\255\255\015\001\
\255\255\255\255\018\001\019\001\020\001\021\001\022\001\023\001\
\255\255\025\001\009\001\010\001\011\001\012\001\013\001\255\255\
\015\001\255\255\255\255\018\001\019\001\020\001\021\001\022\001\
\023\001\009\001\010\001\011\001\012\001\013\001\255\255\015\001\
\255\255\255\255\255\255\255\255\020\001\021\001\022\001\023\001\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\009\001\010\001\255\255\255\255\255\255\255\255\015\001\
\255\255\255\255\018\001\019\001\020\001\021\001\022\001\023\001\
\255\255\025\001\026\001\009\001\010\001\025\001\026\001\026\001\
\255\255\255\255\255\255\255\255\018\001\019\001\020\001\021\001\
\022\001\023\001\255\255\025\001\026\001\009\001\010\001\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\018\001\019\001\
\020\001\021\001\022\001\023\001\255\255\025\001\026\001\018\001\
\019\001\018\001\019\001\018\001\019\001\255\255\025\001\026\001\
\025\001\026\001\025\001\026\001\018\001\019\001\018\001\019\001\
\018\001\019\001\255\255\025\001\026\001\025\001\026\001\025\001\
\026\001"

let yynames_const = "\
  SEMICOLON\000\
  LEFTBRACE\000\
  LEFTPAREN\000\
  LEFTBRAC\000\
  RIGHTBRACE\000\
  RIGHTPAREN\000\
  RIGHTBRAC\000\
  COMMA\000\
  ADDOP\000\
  SUBOP\000\
  MULOP\000\
  DIVOP\000\
  MODOP\000\
  SWAP\000\
  CONCAT\000\
  TYPEASSIGNMENT\000\
  LINEBUFFER\000\
  EQ\000\
  NEQ\000\
  LT\000\
  GT\000\
  LEQ\000\
  GEQ\000\
  NOT\000\
  AND\000\
  OR\000\
  ASSIGN\000\
  IF\000\
  ELIF\000\
  ELSE\000\
  WHILELOOP\000\
  FORLOOP\000\
  BREAK\000\
  CONTINUE\000\
  VOID\000\
  NULL\000\
  EOF\000\
  IMPORT\000\
  FUNCTION\000\
  RETURN\000\
  INTD\000\
  BOOLD\000\
  STRINGD\000\
  FLOATD\000\
  PDFD\000\
  PAGED\000\
  LINED\000\
  "

let yynames_block = "\
  ID\000\
  STRING\000\
  INT\000\
  FLOAT\000\
  BOOL\000\
  "

let yyact = [|
  (fun _ -> failwith "parser")
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'stmt_list) in
    Obj.repr(
# 35 "parser.mly"
            ( List.rev _1 )
# 320 "parser.ml"
               : 'program))
; (fun __caml_parser_env ->
    Obj.repr(
# 38 "parser.mly"
                  ( [] )
# 326 "parser.ml"
               : 'stmt_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'stmt_list) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'stmt) in
    Obj.repr(
# 39 "parser.mly"
                  ( _2 :: _1 )
# 334 "parser.ml"
               : 'stmt_list))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'stmt_list) in
    Obj.repr(
# 44 "parser.mly"
                                  ( List.rev _2 )
# 341 "parser.ml"
               : 'body))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 2 : Ast.expr) in
    let _5 = (Parsing.peek_val __caml_parser_env 0 : 'body) in
    Obj.repr(
# 50 "parser.mly"
                                                                        ( While(_3, _5) )
# 349 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : 'data_type) in
    Obj.repr(
# 52 "parser.mly"
                                                                    ( Vdecl(_1,_3) )
# 357 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'assign_stmt) in
    Obj.repr(
# 53 "parser.mly"
                                                                    ( _1 )
# 364 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 5 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 3 : 'sp_data_type) in
    let _5 = (Parsing.peek_val __caml_parser_env 1 : Ast.expr) in
    Obj.repr(
# 54 "parser.mly"
                                                               ( ObjectCreate(_1, _3, _5) )
# 373 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 6 : 'assign_stmt) in
    let _5 = (Parsing.peek_val __caml_parser_env 4 : 'expr_stmt) in
    let _7 = (Parsing.peek_val __caml_parser_env 2 : 'assign_stmt) in
    let _9 = (Parsing.peek_val __caml_parser_env 0 : 'body) in
    Obj.repr(
# 55 "parser.mly"
                                                                                            ( For(_3, _5, _7, _9) )
# 383 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Ast.expr) in
    Obj.repr(
# 56 "parser.mly"
                                                                    ( Ret(_2) )
# 390 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Ast.expr) in
    Obj.repr(
# 61 "parser.mly"
                                                                    ( Assign(_1, _3) )
# 398 "parser.ml"
               : 'assign_stmt))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 4 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 2 : 'data_type) in
    let _5 = (Parsing.peek_val __caml_parser_env 0 : Ast.expr) in
    Obj.repr(
# 62 "parser.mly"
                                                                    ( InitAssign(_1,_3,_5) )
# 407 "parser.ml"
               : 'assign_stmt))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Ast.expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Ast.expr) in
    Obj.repr(
# 65 "parser.mly"
                                                                  ( Binop(_1, Equal,   _3) )
# 415 "parser.ml"
               : 'expr_stmt))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Ast.expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Ast.expr) in
    Obj.repr(
# 66 "parser.mly"
                                                                  ( Binop(_1, Neq,     _3) )
# 423 "parser.ml"
               : 'expr_stmt))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Ast.expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Ast.expr) in
    Obj.repr(
# 67 "parser.mly"
                                                                  ( Binop(_1, Less,    _3) )
# 431 "parser.ml"
               : 'expr_stmt))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Ast.expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Ast.expr) in
    Obj.repr(
# 68 "parser.mly"
                                                                  ( Binop(_1, Leq,     _3) )
# 439 "parser.ml"
               : 'expr_stmt))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Ast.expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Ast.expr) in
    Obj.repr(
# 69 "parser.mly"
                                                                  ( Binop(_1, Greater, _3) )
# 447 "parser.ml"
               : 'expr_stmt))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Ast.expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Ast.expr) in
    Obj.repr(
# 70 "parser.mly"
                                                                  ( Binop(_1, Geq,     _3) )
# 455 "parser.ml"
               : 'expr_stmt))
; (fun __caml_parser_env ->
    Obj.repr(
# 74 "parser.mly"
                                                                    ( String )
# 461 "parser.ml"
               : 'data_type))
; (fun __caml_parser_env ->
    Obj.repr(
# 75 "parser.mly"
                                                                    ( Int )
# 467 "parser.ml"
               : 'data_type))
; (fun __caml_parser_env ->
    Obj.repr(
# 76 "parser.mly"
                                                                    ( Float )
# 473 "parser.ml"
               : 'data_type))
; (fun __caml_parser_env ->
    Obj.repr(
# 77 "parser.mly"
                                                                    ( Bool )
# 479 "parser.ml"
               : 'data_type))
; (fun __caml_parser_env ->
    Obj.repr(
# 80 "parser.mly"
      ( Line )
# 485 "parser.ml"
               : 'sp_data_type))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 84 "parser.mly"
                     ( LitString(_1) )
# 492 "parser.ml"
               : Ast.expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 85 "parser.mly"
                     ( LitInt(_1) )
# 499 "parser.ml"
               : Ast.expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : float) in
    Obj.repr(
# 86 "parser.mly"
                     ( LitFloat(_1))
# 506 "parser.ml"
               : Ast.expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : bool) in
    Obj.repr(
# 87 "parser.mly"
                     ( LitBool(_1) )
# 513 "parser.ml"
               : Ast.expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 88 "parser.mly"
                   ( Iden(_1) )
# 520 "parser.ml"
               : Ast.expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Ast.expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Ast.expr) in
    Obj.repr(
# 89 "parser.mly"
                     ( Binop(_1, Add, _3) )
# 528 "parser.ml"
               : Ast.expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Ast.expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Ast.expr) in
    Obj.repr(
# 90 "parser.mly"
                     ( Binop(_1, Sub, _3) )
# 536 "parser.ml"
               : Ast.expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Ast.expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Ast.expr) in
    Obj.repr(
# 91 "parser.mly"
                     ( Binop(_1, Mul, _3) )
# 544 "parser.ml"
               : Ast.expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Ast.expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Ast.expr) in
    Obj.repr(
# 92 "parser.mly"
                     ( Binop(_1, Div, _3) )
# 552 "parser.ml"
               : Ast.expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Ast.expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Ast.expr) in
    Obj.repr(
# 93 "parser.mly"
                     ( Binop(_1, Concat,  _3) )
# 560 "parser.ml"
               : Ast.expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Ast.expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Ast.expr) in
    Obj.repr(
# 94 "parser.mly"
                     ( Binop(_1, Mod,     _3) )
# 568 "parser.ml"
               : Ast.expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'expr_stmt) in
    Obj.repr(
# 95 "parser.mly"
                     ( _1 )
# 575 "parser.ml"
               : Ast.expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Ast.expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Ast.expr) in
    Obj.repr(
# 96 "parser.mly"
                     ( Binop(_1, And,     _3) )
# 583 "parser.ml"
               : Ast.expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Ast.expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Ast.expr) in
    Obj.repr(
# 97 "parser.mly"
                     ( Binop(_1, Or,      _3) )
# 591 "parser.ml"
               : Ast.expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : Ast.expr) in
    Obj.repr(
# 98 "parser.mly"
                      ( Uop(Not,_2) )
# 598 "parser.ml"
               : Ast.expr))
(* Entry expr *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
|]
let yytables =
  { Parsing.actions=yyact;
    Parsing.transl_const=yytransl_const;
    Parsing.transl_block=yytransl_block;
    Parsing.lhs=yylhs;
    Parsing.len=yylen;
    Parsing.defred=yydefred;
    Parsing.dgoto=yydgoto;
    Parsing.sindex=yysindex;
    Parsing.rindex=yyrindex;
    Parsing.gindex=yygindex;
    Parsing.tablesize=yytablesize;
    Parsing.table=yytable;
    Parsing.check=yycheck;
    Parsing.error_function=parse_error;
    Parsing.names_const=yynames_const;
    Parsing.names_block=yynames_block }
let expr (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 1 lexfun lexbuf : Ast.expr)
