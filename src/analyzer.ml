open Sast
module StringMap = Map.Make(String);;

type symbol_table = {
  parent : symbol_table option;
    mutable variables : (string * Ast.t) list;
    mutable functions : (string * Ast.t) list;
}

type environment = {
  scope : symbol_table;        (* symbol table for vars *)
}

type type_map = {
  mutable map : string StringMap.t;
}

let str_eq a b = ((Pervasives.compare a b) = 0)

let rec find_variable (scope : symbol_table) (name : string) : Ast.t option =
  try
    let (_, typ) = List.find (fun (s, _) -> s = name) scope.variables in
    Some(typ)
  with Not_found ->
    match scope.parent with
    | Some(p) -> find_variable p name
    | _ -> None

let rec find_function (scope : symbol_table) (name : string) : Ast.t option =
  try
    let (_, typ) = List.find (fun (s, _) -> s = name) scope.functions in
    Some(typ)
  with Not_found ->
    match scope.parent with
    | Some(p) -> find_variable p name
    | _ -> None

let is_keyword (name : string) : bool =
  let rec helper (name : string) (words : string list) : bool =
    match words with
    | [] -> false
    | h::t -> name = h || helper name t
  in
  helper name ["import";"main";"pdf";"page";"line";"renderpdf";"tuple";"list"]

let alphaCode = ref (Char.code 'A')
let betaCode = ref (Char.code 'A')

let next_type_var() : string =
  let c1 = !alphaCode in
  let c2 = !betaCode in
    if c2 = Char.code 'Z'
    then betaCode := Char.code 'a'
    else incr betaCode;
    if c2 = Char.code 'z'
    then (incr alphaCode; betaCode := Char.code 'A')
    else ();
    if c1 = Char.code 'Z'
    then alphaCode := Char.code 'a'
    else ();
    let name = (Char.escaped (Char.chr c1)) ^ (Char.escaped (Char.chr c2)) in
    name

let initialize_types(tmap : type_map) =
  let typeMap = StringMap.empty in
  let inttype = next_type_var() in
  let typeMap = StringMap.add "int" inttype typeMap in
  let booltype = next_type_var() in
  let typeMap = StringMap.add "bool" booltype typeMap in
  let floattype = next_type_var() in
  let typeMap = StringMap.add "float" floattype typeMap in
  let stringtype = next_type_var() in
  let typeMap = StringMap.add "string" stringtype typeMap in
  let pdftype = next_type_var() in
  let typeMap = StringMap.add "pdf" pdftype typeMap in
  let pagetype = next_type_var() in
  let typeMap = StringMap.add "page" pagetype typeMap in
  let linetype = next_type_var() in
  let typeMap = StringMap.add "line" linetype typeMap in
  let tupletype = next_type_var() in
  let typeMap = StringMap.add "tuple" tupletype typeMap in
  tmap.map <- typeMap

let nest_scope (env : environment) : environment =
  let s = {variables = []; functions = []; parent = Some(env.scope)} in
  {scope = s}

let new_env() : environment =
  let s = { variables = []; functions = []; parent = None } in
  {scope = s}

let new_map() : type_map =
  let m = StringMap.empty in
  {map = m}

let type_of (ae : Sast.texpression) : Ast.t =
  match ae with
  | TLitInt(_, t) -> t
  | TLitString(_, t) -> t
  | TLitFloat(_, t) -> t
  | TLitBool(_, t) -> t
  | TIden(_, t) -> t
  | TBinop(_, _, _, t) -> t
  | TListAccess(_, _, t) -> t
  | TMapAccess(_, _, t) -> t
  | TCallExpr(_, _, t) -> t
  | TUop(_, _, t) -> t

let find_type (t : string) (tmap : type_map) : string =
   let found = StringMap.mem t tmap.map in
   if found
   then
       StringMap.find t tmap.map
   else
       ""

let find_primitive_type (t : Ast.t) (tmap : type_map) : string =
  match t with
  | Ast.Int -> find_type "int" tmap
  | Ast.Bool -> find_type "bool" tmap
  | Ast.Float -> find_type "float" tmap
  | Ast.String -> find_type "string" tmap
  | Ast.Pdf -> find_type "pdf" tmap
  | Ast.Page -> find_type "page" tmap
  | Ast.Line -> find_type "line" tmap
  | Ast.Tuple -> find_type "tuple" tmap
  | Ast.Image -> find_type "image" tmap
  | _ -> failwith "You're doing something wrong! This shouldn't have been called."

let rec annotate_expr (e : Ast.expression) (env : environment) (tmap : type_map) : Sast.texpression =
  match e with
  | Ast.LitInt(n) -> TLitInt(n, Ast.Int)
  | Ast.LitBool(n) -> TLitBool(n, Ast.Bool)
  | Ast.LitFloat(n) -> TLitFloat(n, Ast.Float)
  | Ast.LitString(n) -> TLitString(n, Ast.String)
  | Ast.Iden(s) ->
    (match s with
    | Ast.IdTest(w) ->
      let typ = find_variable env.scope w in
      (match typ with
      | Some(x) -> TIden(s,x)
      | None -> failwith ("Unrecognized identifier " ^ w ^ ".")))

  | Ast.Binop(e1,o,e2) ->
    let ae1 = annotate_expr e1 env tmap in
    let ae2 = annotate_expr e2 env tmap in
    let t1 = type_of ae1 in
    let t2 = type_of ae2 in
      (match o with
        | Ast.Concat ->
          (match t1, t2 with
            | (Ast.Pdf, Ast.Page) -> TBinop(ae1,o,ae2,t1)
            | (Ast.Tuple, Ast.Line) -> TBinop(ae1,o,ae2,t1)
            | (Ast.Tuple,Ast.Image) -> TBinop(ae1,o,ae2,t1)
            | _ -> failwith "Oops")
        | Ast.Add
        | Ast.Sub
        | Ast.Div
        | Ast.Swap
        | Ast.Append
        | Ast.Mod
        | Ast.Mul -> TBinop(ae1,o,ae2,t1)
        | Ast.Equal
        | Ast.Neq
        | Ast.Less
        | Ast.Leq
        | Ast.Greater
        | Ast.And
        | Ast.Or
        | Ast.Geq -> TBinop(ae1,o,ae2,Ast.Bool))

  | Ast.ListAccess(i,e) ->
      let ae = annotate_expr e env tmap in
      let t = type_of ae in
      (match t with
      | Ast.Int ->
          (match i with
          | Ast.IdTest(w) ->
              let typ = find_variable env.scope w in
              (match typ with
              | Some(x) ->
                  (match x with
                  | Ast.ListType(s) ->
                      TListAccess(i,ae,x)
                  | _ -> failwith "Variable not List")
              | None -> failwith ("Unrecognized identifier " ^ w ^ ".")))
      | _ -> failwith "Invalid List Access Expression")
    | Ast.MapAccess(i, e) ->
        let ae = annotate_expr e env tmap in
        let t = type_of ae in
        (match i with
          | Ast.IdTest(w) ->
                    let typ = find_variable env.scope w in
                    (match typ with
                      | Some(x) ->
                            (match x with
                            | Ast.MapType(kd,vd) ->
                                  if kd = t
                                  then TMapAccess(i, ae, x)
                                  else failwith "Incorrect type for access"
                            | _ -> failwith "Variable not Map" )
                      | None -> failwith ("Unrecognized identifier " ^ w ^ ".") ) )
    | Ast.CallExpr(e, elist) ->
      let et = find_function env.scope e in
      let aelist = List.map (fun x -> annotate_expr x env tmap) elist in
      (match et with
        | Some(x) ->  TCallExpr(e, aelist, x)
        | None -> failwith "Did not find the type for this function" )
    | Ast.Uop(u,e) ->
          let ae = annotate_expr e env tmap in
          let t = type_of ae in
          match u with
          | LineBuffer -> TUop(u, ae, Ast.String)
          | _ -> TUop(u, ae, t)

and annotate_recr_type (rd : Ast.recr_t) (tmap : type_map) : string =
  (match rd with
    | Ast.TType(t) ->
      find_primitive_type t tmap
    | Ast.RType(r) ->
        let d = annotate_recr_type r tmap in
        let rt = find_type d tmap in
        (match rt with
          | "" ->
              let ard = next_type_var() in
              tmap.map <- StringMap.add d ard tmap.map;
              ard
          | _ ->
              rt))

and annotate_assign (i : Ast.id) (e : Ast.expression) (env : environment) (tmap : type_map) : Ast.id * Sast.texpression =
  let ae = annotate_expr e env tmap in
  let te = type_of ae in
  let id = match i with | Ast.IdTest (s) -> s in
  let tid = find_variable env.scope id in
  (match tid with
  | Some(idt) ->
      (match te with
      | Ast.ListType(lte) ->
          (match idt with
          | Ast.ListType(it) ->
              let t = find_type it tmap in
              if t = lte then i,ae
              else failwith "Invalid assignment."
          | _ ->
              let ti = find_primitive_type idt tmap in
              if ti = lte then i,ae
              else failwith "Invalid assignment.")
      | Ast.MapType(kdt, vdt) ->
           if vdt = idt
           then i,ae
           else failwith "Invalid assignment."
      | _ ->
          if idt = te then i,ae
          else failwith "Invalid assignment.")
  | None -> failwith "Invalid assignment | Variable Not Found.")

and annotate_map_add (i : Ast.id) (e1 : Ast.expression) (e2 : Ast.expression) (env : environment) (tmap : type_map) : Ast.id * Sast.texpression * Sast.texpression =
  let ae1 = annotate_expr e1 env tmap in
  let ae2 = annotate_expr e2 env tmap in
  let te1 = type_of ae1 in
  let te2 = type_of ae2 in
  let id = match i with | Ast.IdTest (s) -> s in
  let tid = find_variable env.scope id in
  (match tid with
  | Some(idt) ->
      (match idt with
      | Ast.MapType(kidt,vidt) ->
          if kidt = te1
          then if vidt = te2
               then i,ae1,ae2
               else failwith "Invalid assignment | Value not Valid"
          else failwith "Invalid assignment | Key not Valid"
      | _ -> failwith "Invalid assignment | Variable not Map")
  | None -> failwith "Invalid assignment | Variable Not Found.")

and annotate_map_remove (i : Ast.id) (e : Ast.expression) (env : environment) (tmap : type_map) : Ast.id * Sast.texpression =
  let ae = annotate_expr e env tmap in
  let te = type_of ae in
  let id = match i with | Ast.IdTest (s) -> s in
  let tid = find_variable env.scope id in
  (match tid with
  | Some(idt) ->
      (match idt with
      | Ast.MapType(kidt,vidt) ->
          if kidt = te then i,ae
          else failwith "Invalid assignment | Key not Valid"
      | _ -> failwith "Invalid assignment | Variable not Map")
  | None -> failwith "Invalid assignment | Variable Not Found.")

and annotate_list_assign (e1 : Ast.expression) (e2 : Ast.expression) (env : environment) (tmap : type_map) : Sast.texpression * Sast.texpression =
  let ae1 = annotate_expr e1 env tmap in
  let ae2 = annotate_expr e2 env tmap in
  let et1 = type_of ae1 in
  let et2 = type_of ae2 in
  (match et1 with
  | Ast.ListType(s1) ->
      (match et2 with
      | Ast.ListType(s2) ->
          let t1 = find_type s2 tmap in
          if t1 = s1 then ae1,ae2
          else failwith "Invalid assignment."
      | _ ->
          let t2 = find_primitive_type et2 tmap in
          if t2 = s1 then ae1,ae2
          else failwith "Invalid assignment.")
  | _ -> failwith "Invalid Assignment | Variable not List")

and add_scope_variable (i : Ast.id) (d : Ast.t) (env : environment) : unit =
  match i with
    | Ast.IdTest(s) ->
    if is_keyword s
      then failwith "Cannot assign keyword."
      else
      let typ = find_variable env.scope s in
      (match typ with
      | Some(t) ->
        failwith "Invalid assignment, already exists."
    | None ->
      env.scope.variables <- (s,d) :: env.scope.variables);

and annotate_stmt (s : Ast.statement) (env : environment) (tmap : type_map) : Sast.tstatement =
  match s with
  | Ast.Ret(e) ->
      let ae = annotate_expr e env tmap in
      let typ = type_of ae in
      TRet(ae, typ)
  | Ast.ControlStmt(s) -> TControlStmt(s)
  | Ast.Assign(i, e) ->
      let (ae1, ae2) = annotate_assign i e env tmap in
      TAssign(ae1, ae2)
  | Ast.InitAssign(i,t,e) ->
      (match t with
      | Ast.Int
      | Ast.Bool
      | Ast.Float
      | Ast.String
      | Ast.Pdf
      | Ast.Page ->
          add_scope_variable i t env;
          let ae = annotate_expr e env tmap in
          TInitAssign(i,t,ae)
      | _ -> failwith "Invalid Assignment Type.")
  | Ast.ListAssign(e1,e2) ->
      let (ae1, ae2) = annotate_list_assign e1 e2 env tmap in
      TListAssign(ae1,ae2)
  | Ast.CallStmt(e, elist) ->
      let ae = e in
      let aelist = List.map (fun x -> annotate_expr x env tmap) elist in
      TCallStmt(ae, aelist)
  | Ast.ListDecl(e,rd) ->
      let ard = annotate_recr_type rd tmap in
      let ld = Ast.ListType(ard) in
      add_scope_variable e ld env;
      TListDecl(e, ld)
  | Ast.ListAdd(i,e) ->
      let ie = Ast.Iden(i) in
      let (t,ae) = annotate_list_assign ie e env tmap in
      (match t with
      | TIden(ti,tt) -> TListAdd(ti,ae)
      | _ -> failwith "Invalid Identifier Expression")
  | Ast.ListRemove(i,e) ->
      let ae = annotate_expr e env tmap in
      let te = type_of ae in
      let id = match i with | Ast.IdTest(s) -> s in
      let tid = find_variable env.scope id in
      (match tid with
      | Some(idt) ->
          (match idt with
          | Ast.ListType(lt) ->
              (match te with
              | Ast.Int -> TMapRemove(i,ae)
              | _ -> failwith "Invalid List Access")
          | _ -> failwith "Invalid assignment | Variable not List")
      | None -> failwith "Invalid assignment | Variable Not Found.")
  | Ast.MapDecl(e, kd, vd) ->
      (match vd with
      | Ast.TType(x) ->
              let md = Ast.MapType(kd,x) in
              add_scope_variable e md env;
              TMapDecl(e, md)
      | Ast.RType(x) ->
              let rd = annotate_recr_type x tmap in
              let mrd = Ast.ListType(rd) in
              let md = Ast.MapType(kd,mrd) in
              add_scope_variable e md env;
              TMapDecl(e, md))
  | Ast.MapAdd(i,e1,e2) ->
      let (t,ae1,ae2) = annotate_map_add i e1 e2 env tmap in
      TMapAdd(t,ae1,ae2)
  | Ast.MapRemove(i,e) ->
      let (t,ae) = annotate_map_remove i e env tmap in
      TMapRemove(t,ae)
  | Ast.Vdecl(e,d) ->
    add_scope_variable e d env;
      TVdecl(e, d)
  | Ast.ObjectCreate(e,sd,el) ->
      (match sd with
      | Ast.Line
      | Ast.Image
      | Ast.Tuple ->
          add_scope_variable e sd env;
        let ad = sd in
        let ael = annotate_exprs el env tmap in
        let ttt = TObjectCreate(e,ad,ael) in
        ttt
      | _ -> failwith "Invalid Object Type.")
  | Ast.While(e,sl) ->
      let nenv = nest_scope env in
      (match e with
      | Ast.Binop(e1,o,e2) ->
          (match o with
          | Ast.Equal
      | Ast.Neq
      | Ast.Less
      | Ast.Leq
      | Ast.Greater
      | Ast.Geq ->
          let ae1 = annotate_expr e1 nenv tmap in
          let ae2 = annotate_expr e2 nenv tmap in
          let te = TBinop(ae1,o,ae2,Ast.Bool) in
          let tsl = annotate_stmts sl nenv tmap in
          TWhile(te,tsl)
      | _ -> failwith "Invalid While Expression Type.")
      | _ -> failwith "Invalid While Expression Type.")
  | Ast.If(cl,sl) ->
      let tcl = annotate_conds cl env tmap in
      (match sl with
      | Some(xsl) ->
          let nenv = nest_scope env in
          let tsl = annotate_stmts xsl nenv tmap in
          TIf(tcl,Some(tsl))
      | None -> TIf(tcl,None))
  | Ast.For(s1,e,s2,sl) ->
      let nenv = nest_scope env in
      (match s1 with
      | Ast.Assign(i1,ie1) ->
          let aes1 = annotate_expr ie1 nenv tmap in
          let ets1 = type_of aes1 in
          (match ets1 with
          | Ast.Int ->
              let ts1 = annotate_stmt s1 nenv tmap in
              (match e with
              | Ast.Binop(e1,o,e2) ->
                  (match o with
                  | Ast.Equal
                  | Ast.Neq
                  | Ast.Less
                  | Ast.Leq
                  | Ast.Greater
                  | Ast.Geq ->
                      let ae1 = annotate_expr e1 nenv tmap in
                            let ae2 = annotate_expr e2 nenv tmap in
                            let te = TBinop(ae1,o,ae2,Ast.Bool) in
                            (match s2 with
                            | Ast.Assign(i2,ie2) ->
                                let aes2 = annotate_expr ie2 nenv tmap in
                                let ets2 = type_of aes2 in
                                (match ets2 with
                                | Ast.Int ->
                                    let ts2 = annotate_stmt s2 nenv tmap in
                                    (*let (ae21,ae22) = annotate_assign i2 ie2 nenv in
                                    let ts2 = TAssign(ae11,ae12) in*)
                                    let tsl = annotate_stmts sl nenv tmap in
                                    TFor(ts1,te,ts2,tsl)
                                | _ -> failwith "Invalid Assignment Expression Type.")
                            | _ -> failwith "Invalid For Statement.")
                  | _ -> failwith "Invalid For Expression Type.")
              | _ -> failwith "Invalid For Expression Type.")
          | _ -> failwith "Invalid Assignment Expression Type.")
      | _ -> failwith "Invalid For Statement.")

and annotate_func_decl (fdecl : Ast.func_decl) (env : environment) (tmap : type_map) : Sast.tfunc_decl =
  env.scope.functions <- (fdecl.Ast.name , fdecl.Ast.rtype) :: env.scope.functions;
  let s = {variables = []; functions = []; parent = Some(env.scope)} in
  let fenv = {scope = s} in
  let aes = annotate_stmts fdecl.Ast.formals fenv tmap in
  let asts = annotate_stmts fdecl.Ast.body fenv tmap in
  {rtype = fdecl.Ast.rtype; name = fdecl.Ast.name; tformals = aes; tbody = asts}

and annotate_main_func_decl (mdecl : Ast.main_func_decl) (env : environment) (tmap : type_map) : Sast.tmain_func_decl =
  let asts = annotate_stmts mdecl.Ast.body env tmap in
  {tbody = asts}

and annotate_import_statement (istmt : Ast.import_stmt) (env : environment) (tmap : type_map) : Sast.timport_stmt =
  let ai = "" in
  TImport(ai)

and annotate_cond (cond: Ast.conditional) (env : environment) (tmap : type_map) : Sast.tconditional =
  let ae = annotate_expr cond.Ast.condition env tmap in
  let t = type_of ae in
  (match t with
  | Ast.Bool ->
      let nenv = nest_scope env in
      let tsl = annotate_stmts cond.Ast.body nenv tmap in
      {tcondition = ae; tbody = tsl}
  | _ -> failwith "Invalid For Statement.")

and annotate_conds (conds : Ast.conditional list) (env : environment) (tmap : type_map) : Sast.tconditional list =
  List.map (fun i -> annotate_cond i env tmap) conds

and annotate_import_statements (istmts : Ast.import_stmt list) (env : environment) (tmap : type_map) : Sast.timport_stmt list =
  List.map (fun i -> annotate_import_statement i env tmap) istmts

and annotate_exprs (exprs : Ast.expression list) (env : environment) (tmap : type_map) : Sast.texpression list =
  List.map (fun s -> annotate_expr s env tmap) exprs

and annotate_stmts (stmts : Ast.statement list) (env : environment) (tmap : type_map) : Sast.tstatement list =
  List.map (fun x -> annotate_stmt x env tmap) stmts

and annotate_func_decls (fdecls : Ast.func_decl list) (env : environment) (tmap : type_map) : Sast.tfunc_decl list =
  List.map (fun f -> annotate_func_decl f env tmap) fdecls

let annotate_prog (p : Ast.program) : Sast.tprogram =
  let env = new_env() in
  let tmap = new_map() in
  initialize_types tmap;
  let ai = annotate_import_statements p.Ast.ilist env tmap in
  let af = annotate_func_decls p.Ast.declf env tmap in
  let am = annotate_main_func_decl p.Ast.mainf env tmap in
  Printf.printf "There there\n";
  {tilist = ai; tmainf = am; tdeclf = af}
