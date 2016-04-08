open Sast

type symbol_table = {
	parent : symbol_table option;
  mutable variables : (string * Ast.t) list;
  mutable functions : (string * Ast.t) list;
}

type environment = {
	scope : symbol_table;        (* symbol table for vars *)
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
  helper name ["import";"main";"pdf";"page";"line";"renderpdf"]

let nest_scope (env : environment) : environment =
  let s = {variables = []; functions = []; parent = Some(env.scope)} in
  {scope = s}

let new_env() : environment =
  let s = { variables = []; functions = []; parent = None } in
  {scope = s}

let type_of (ae : Sast.texpression) : Ast.t =
  match ae with
  | TLitInt(_, t) -> t
  | TLitFloat(_, t) -> t
  | TLitBool(_, t) -> t
  | TIden(_, t) -> t
  | TBinop(_, _, _, t) -> t


let rec annotate_expr (e : Ast.expression) (env : environment) : Sast.texpression =
  Printf.printf "Entered annotate_expression\n";
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
	  let ae1 = annotate_expr e1 env in
	  let ae2 = annotate_expr e2 env in
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


and annotate_assign (i : Ast.id) (e : Ast.expression) (env : environment) : Ast.id * Sast.texpression =
  Printf.printf "Entered annotate_assign\n";
  let ae2 = annotate_expr e env in
  Printf.printf "Got annotated rhs of assign\n";
  let t2 = type_of ae2 in
  let p1 = Printf.printf "Got type of annotated rhs\n" in
  let ii = match i with | IdTest(s) -> s in
  let t1 = find_variable env.scope ii in
		(match t1 with
		| Some(t) -> 
			if t = t2 then i,ae2
            else failwith "Invalid assignment."
		| None -> failwith "Invalid assignment | Variable Not Found.")

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

and annotate_stmt (s : Ast.statement) (env : environment) : Sast.tstatement =
  match s with
  | Assign(i, e) ->
      let (ae1, ae2) = annotate_assign i e env in
      TAssign(ae1, ae2)
  | CallStmt(e, elist) ->
      let ae = e in
      let aelist = List.map (fun x -> annotate_expr x env) elist in
      TCallStmt(ae, aelist)
  | Vdecl(e,d) ->
	  add_scope_variable e d env;
      TVdecl(e, d)
  | ObjectCreate(e,sd,el) ->
      Printf.printf "Entered ObjectCreate in annotate_statement\n";
      add_scope_variable e sd env;
	  let ad = sd in
	  let ael = annotate_exprs el env in
	  let p2 = Printf.printf "Got annotated rhs exp list\n" in
	  let ttt = TObjectCreate(e,ad,ael) in
	  let p3 = Printf.printf "Here\n" in
	  ttt
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
		      let ae1 = annotate_expr e1 nenv in
		      let ae2 = annotate_expr e2 nenv in
		      let t1 = type_of ae1 in
		      let t2 = type_of ae2 in
		      let te = TBinop(ae1,o,ae2,Bool) in
		      let tsl = annotate_stmts sl nenv in
		      TWhile(te,tsl)
		  | _ -> failwith "Invalid While Expression Type.")
      | _ -> failwith "Invalid While Expression Type.")
  | For(s1,e,s2,sl) ->
      let nenv = nest_scope env in
      (match s1 with
      | Assign(i1,ie1) ->
          let aes1 = annotate_expr ie1 nenv in
          let ets1 = type_of aes1 in
          (match ets1 with
          | Int ->
              let ts1 = annotate_stmt s1 nenv in
              (*let (ae11,ae12) = annotate_assign i1 ie1 nenv in
              let ts1 = TAssign(ae11,ae12) in*)
              (match e with
              | Binop(e1,o,e2) ->
                  (match o with
                  | Equal
				  | Neq
				  | Less
				  | Leq
				  | Greater
				  | Geq ->
				      let ae1 = annotate_expr e1 nenv in
	                  let ae2 = annotate_expr e2 nenv in
	                  let t1 = type_of ae1 in
	                  let t2 = type_of ae2 in
	                  let te = TBinop(ae1,o,ae2,Bool) in
	                  (match s2 with
	                  | Assign(i2,ie2) ->
	                      let aes2 = annotate_expr ie2 nenv in
	                      let ets2 = type_of aes2 in
	                      (match ets2 with
	                      | Int ->
	                          let ts2 = annotate_stmt s2 nenv in
	                          (*let (ae21,ae22) = annotate_assign i2 ie2 nenv in
	                          let ts2 = TAssign(ae11,ae12) in*)
	                          let tsl = annotate_stmts sl nenv in
	                          TFor(ts1,te,ts2,tsl)
	                      | _ -> failwith "Invalid Assignment Expression Type.")
	                  | _ -> failwith "Invalid For Statement.")
				  | _ -> failwith "Invalid For Expression Type.")
              | _ -> failwith "Invalid For Expression Type.")
          | _ -> failwith "Invalid Assignment Expression Type.")
      | _ -> failwith "Invalid For Statement.")

and annotate_func_decl (fdecl : Ast.func_decl) (env : environment) : Sast.tfunc_decl =
  env.scope.functions <- (fdecl.name, fdecl.rtype) :: env.scope.functions;
  let s = {variables = []; functions = []; parent = Some(env.scope)} in
  let fenv = {scope = s} in
  let aes = annotate_stmts fdecl.formals fenv in
  let asts = annotate_stmts fdecl.body fenv in
  {rtype = fdecl.rtype; name = fdecl.name; tformals = aes; tbody = asts}

and annotate_main_func_decl (mdecl : Ast.main_func_decl) (env : environment) : Sast.tmain_func_decl =
  let asts = annotate_stmts mdecl.body env in
  {tbody = asts}

and annotate_import_statement (istmt : Ast.import_stmt) (env : environment) : Sast.timport_stmt =
  let ai = "" in
  TImport(ai)

and annotate_import_statements (istmts : Ast.import_stmt list) (env : environment) : Sast.timport_stmt list =
  List.map (fun i -> annotate_import_statement i env) istmts

and annotate_exprs (exprs : Ast.expression list) (env : environment) : Sast.texpression list =
  List.map (fun s -> annotate_expr s env) exprs

and annotate_stmts (stmts : Ast.statement list) (env : environment) : Sast.tstatement list =
  List.map (fun x -> annotate_stmt x env) stmts

and annotate_func_decls (fdecls : Ast.func_decl list) (env : environment) : Sast.tfunc_decl list =
  List.map (fun f -> annotate_func_decl f env) fdecls

let annotate_prog (p : Ast.program) : Sast.tprogram =
  let env = new_env() in
  let ai = annotate_import_statements p.ilist env in
  let am = annotate_main_func_decl p.mainf env in
  let af = annotate_func_decls p.declf env in
  Printf.printf "There\n";
  {tilist = ai; tmainf = am; tdeclf = af}
