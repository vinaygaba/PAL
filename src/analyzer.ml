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
  let typeMap = StringMap.add "bool" inttype typeMap in
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
  | TLitFloat(_, t) -> t
  | TLitBool(_, t) -> t
  | TIden(_, t) -> t
  | TBinop(_, _, _, t) -> t
  | TListAccess(_, _, t) -> t

let find_type (t : string) (tmap : type_map) : string =
   let found = StringMap.mem t tmap.map in
   if found
   then
       StringMap.find t tmap.map
   else
       ""

let find_primitive_type (t : Ast.t) (tmap : type_map) : string =
  match t with
  | Int -> find_type "int" tmap
  | Bool -> find_type "bool" tmap
  | Float -> find_type "float" tmap
  | String -> find_type "string" tmap
  | Pdf -> find_type "pdf" tmap
  | Page -> find_type "page" tmap
  | Line -> find_type "line" tmap
  | Tuple -> find_type "tuple" tmap

let rec annotate_expr (e : Ast.expression) (env : environment) (tmap : type_map) : Sast.texpression =
  match e with
  | LitInt(n) -> TLitInt(n, Int)
  | LitBool(n) -> TLitBool(n, Bool)
  | LitFloat(n) -> TLitFloat(n, Float)
  | LitString(n) -> TLitString(n, String)
  | Iden(s) ->
	  (match s with
	  | IdTest(w) ->
		  let typ = find_variable env.scope w in
		  (match typ with
		  | Some(x) -> TIden(s,x)
		  | None -> failwith ("Unrecognized identifier " ^ w ^ ".")))

  | Binop(e1,o,e2) ->
	  let ae1 = annotate_expr e1 env tmap in
	  let ae2 = annotate_expr e2 env tmap in
	  let t1 = type_of ae1 in
	  let t2 = type_of ae2 in
	    (match o with
	      | Concat ->
	        (match t1, t2 with
	          | (Pdf, Page) -> TBinop(ae1,o,ae2,t1)
	          | (Tuple, Line) -> TBinop(ae1,o,ae2,t1))
				| Add
				| Sub
				| Div
				| Mul -> TBinop(ae1,o,ae2,t1)
				| Equal
				| Neq
				| Less
				| Leq
				| Greater
				| Geq -> TBinop(ae1,o,ae2,Bool)
			)
  | ListAccess(i,e) ->
      let ae = annotate_expr e env tmap in
      let t = type_of ae in
      (match t with
      | Int ->
          (match i with
          | IdTest(w) ->
              let typ = find_variable env.scope w in
              (match typ with
              | Some(x) ->
                  (match x with
                  | ListType(s) ->
                      TListAccess(i,ae,ListType(s))
                  | _ -> failwith "Variable not List")
              | None -> failwith ("Unrecognized identifier " ^ w ^ ".")))
      | _ -> failwith "Invalid List Access Expression")

and annotate_recr_type (rd : Ast.recr_t) (tmap : type_map) : string =
  (match rd with
    | TType(t) ->
      find_primitive_type t tmap
    | RType(r) ->
        let d = annotate_recr_type r tmap in
        let rt = find_type d tmap in
        (match rt with
          | "" ->
              let ard = next_type_var() in
              tmap.map <- StringMap.add d ard tmap.map;
              let p = Printf.printf "Assigned Type :%s\n" ard in
              ard
          | _ ->
              let p = Printf.printf "Found Assigned Type: %s\n" rt in
              rt))

and annotate_assign (i : Ast.id) (e : Ast.expression) (env : environment) (tmap : type_map) : Ast.id * Sast.texpression =
  let ae = annotate_expr e env tmap in
  let te = type_of ae in
  let id = match i with | IdTest (s) -> s in
  let tid = find_variable env.scope id in
  (match tid with
  | Some(idt) ->
      (match te with
      | ListType(lte) ->
          (match idt with
          | ListType(it) ->
              let t = find_type it tmap in
              if t = lte then i,ae
              else failwith "Invalid assignment."
          | _ ->
              let ti = find_primitive_type idt tmap in
              if ti = lte then i,ae
              else failwith "Invalid assignment.")
      | _ ->
          if idt = te then i,ae
          else failwith "Invalid assignment.")
  | None -> failwith "Invalid assignment | Variable Not Found.")

and annotate_list_assign (e1 : Ast.expression) (e2 : Ast.expression) (env : environment) (tmap : type_map) : Sast.texpression * Sast.texpression =
  let ae1 = annotate_expr e1 env tmap in
  let ae2 = annotate_expr e2 env tmap in
  let et1 = type_of ae1 in
  let et2 = type_of ae2 in
  (match et1 with
  | ListType(s1) ->
      (match et2 with
      | ListType(s2) ->
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
    | IdTest(s) ->
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
  | Assign(i, e) ->
      let (ae1, ae2) = annotate_assign i e env tmap in
      TAssign(ae1, ae2)
  | InitAssign(i,t,e) ->
      (match t with
      | Int
      | Bool
      | Float
      | String
      | Pdf
      | Page ->
          add_scope_variable i t env;
          let ae = annotate_expr e env tmap in
          TInitAssign(i,t,ae)
      | _ -> failwith "Invalid Assignment Type.")
  | ListAssign(e1,e2) ->
      let (ae1, ae2) = annotate_list_assign e1 e2 env tmap in
      TListAssign(ae1,ae2)
  | CallStmt(e, elist) ->
      let ae = e in
      let aelist = List.map (fun x -> annotate_expr x env tmap) elist in
      TCallStmt(ae, aelist)
  | ListDecl(e,rd) ->
      let ard = annotate_recr_type rd tmap in
      let ld = Ast.ListType(ard) in
      add_scope_variable e ld env;
      TListDecl(e, Ast.ListType(ard))
  | Vdecl(e,d) ->
	  add_scope_variable e d env;
      TVdecl(e, d)
  | ObjectCreate(e,sd,el) ->
      (match sd with
      | Line
      | Tuple ->
          add_scope_variable e sd env;
	      let ad = sd in
	      let ael = annotate_exprs el env tmap in
	      let ttt = TObjectCreate(e,ad,ael) in
	      ttt
      | _ -> failwith "Invalid Object Type.")
  | While(e,sl) ->
      let nenv = nest_scope env in
      (match e with
      | Binop(e1,o,e2) ->
          (match o with
          | Equal
		  | Neq
		  | Less
		  | Leq
		  | Greater
		  | Geq ->
		      let ae1 = annotate_expr e1 nenv tmap in
		      let ae2 = annotate_expr e2 nenv tmap in
		      let t1 = type_of ae1 in
		      let t2 = type_of ae2 in
		      let te = TBinop(ae1,o,ae2,Bool) in
		      let tsl = annotate_stmts sl nenv tmap in
		      TWhile(te,tsl)
		  | _ -> failwith "Invalid While Expression Type.")
      | _ -> failwith "Invalid While Expression Type.")
  | If(cl,sl) ->
      let tcl = annotate_conds cl env tmap in
      let nenv = nest_scope env in
      (match sl with
      | Some(xsl) ->
          let nenv = nest_scope env in
          let tsl = annotate_stmts xsl nenv tmap in
          TIf(tcl,Some(tsl))
      | None -> TIf(tcl,None))
  | For(s1,e,s2,sl) ->
      let nenv = nest_scope env in
      (match s1 with
      | Assign(i1,ie1) ->
          let aes1 = annotate_expr ie1 nenv tmap in
          let ets1 = type_of aes1 in
          (match ets1 with
          | Int ->
              let ts1 = annotate_stmt s1 nenv tmap in
              (match e with
              | Binop(e1,o,e2) ->
                  (match o with
                  | Equal
				  | Neq
				  | Less
				  | Leq
				  | Greater
				  | Geq ->
				      let ae1 = annotate_expr e1 nenv tmap in
	                  let ae2 = annotate_expr e2 nenv tmap in
	                  let t1 = type_of ae1 in
	                  let t2 = type_of ae2 in
	                  let te = TBinop(ae1,o,ae2,Bool) in
	                  (match s2 with
	                  | Assign(i2,ie2) ->
	                      let aes2 = annotate_expr ie2 nenv tmap in
	                      let ets2 = type_of aes2 in
	                      (match ets2 with
	                      | Int ->
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
  env.scope.functions <- (fdecl.name, fdecl.rtype) :: env.scope.functions;
  let s = {variables = []; functions = []; parent = Some(env.scope)} in
  let fenv = {scope = s} in
  let aes = annotate_stmts fdecl.formals fenv tmap in
  let asts = annotate_stmts fdecl.body fenv tmap in
  {rtype = fdecl.rtype; name = fdecl.name; tformals = aes; tbody = asts}

and annotate_main_func_decl (mdecl : Ast.main_func_decl) (env : environment) (tmap : type_map) : Sast.tmain_func_decl =
  let asts = annotate_stmts mdecl.body env tmap in
  {tbody = asts}

and annotate_import_statement (istmt : Ast.import_stmt) (env : environment) (tmap : type_map) : Sast.timport_stmt =
  let ai = "" in
  TImport(ai)

and annotate_cond (cond: Ast.conditional) (env : environment) (tmap : type_map) : Sast.tconditional =
  let ae = annotate_expr cond.condition env tmap in
  let t = type_of ae in
  (match t with
  | Bool ->
      let nenv = nest_scope env in
      let tsl = annotate_stmts cond.body nenv tmap in
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
  let ai = annotate_import_statements p.ilist env tmap in
  let am = annotate_main_func_decl p.mainf env tmap in
  let af = annotate_func_decls p.declf env tmap in
  Printf.printf "There there\n";
  {tilist = ai; tmainf = am; tdeclf = af}
