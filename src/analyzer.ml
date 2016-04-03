
type symbol_table = {
	parent : symbol_table option;
  mutable variables : (string * Sast.t) list;
  mutable functions : (string * Sast.t) list;
}

type environment = {
	scope : symbol_table;        (* symbol table for vars *)
}

let str_eq a b = ((Pervasives.compare a b) = 0)

let rec find_variable (scope : symbol_table) (name : string) : Sast.t option =
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

let new_env() : environment =
  let s = { variables = []; functions = []; parent = None } in
  {scope = s}

let type_of (ae : Sast.texpression) : Sast.t =
  match ae with
  | TLitInt(_, t) -> t
  | TLitFloat(_, t) -> t
  | TLitBool(_, t) -> t
  | TIden(_, t) -> t


let rec annotate_expr (e : Ast.expression) (env : environment) : Sast.texpression =
  match e with
  | LitInt(n) -> TLitInt(n, Int)
  | LitFloat(n) -> TLitFloat(n, Float)
  | LitBool(b) -> TLitBool(b,Bool)
  | Iden(s) ->
      let typ = find_variable env.scope s in
      (match typ with
      | Some(x) -> TIden(s,x)
      | None -> failwith ("Unrecognized identifier " ^ s ^ "."))
  | Binop(e1,o,e2) ->
	  let ae1 = annotate_expr e1 env in
	  let ae2 = annotate_expr e2 env in
	  let ao = o in
	  let at = type_of ae1 in
	  TBinop(ae1,ao,ae2,at)

and annotate_assign (e1 : Ast.expression) (e2 : Ast.expression) (env : environment) : Sast.texpression * Sast.texpression =
  let ae2 = annotate_expr e2 env in
  match e1 with
  | Iden(x) ->
      if is_keyword x
      then failwith "Cannot assign keyword."
      else
      let typ = find_variable env.scope x in
      (match typ with
      | Some(t) ->
          TIden(x,t), ae2)
      | None -> failwith "Invalid assignment."
  | _ -> failwith "Invalid assignment."

and add_scope_variable (e : Ast.expression) (d : Ast.data_type) (env : environment) : Sast.expression =
  match e with
  | Iden(x) ->
      if is_keyword x
      then failwith "Cannot assign keyword."
      else
      let typ = find_variable env.scope x in
			(match typ with
				None -> env.scope.variables <- (x, d) :: env.scope.variables;
      	| Some(t) -> failwith "Invalid assignment, already exists.";)
	| _ -> failwith "Not an identifier";



and annotate_stmt (s : Ast.statement) (env : environment) : Sast.statement =
  match s with
  | Assign(e1, e2) ->
      let (ae1, ae2) = annotate_assign e1 e2 env in
      TAssign(ae1, ae2)
  | CallStmt(e, elist) ->
      let ae = annotate_expr e env in
      let aelist = List.map (fun x -> annotate_expr x env) elist in
      TCallStmt(ae, aelist)
  | VDecl(e,d) ->
	  add_scope_variable e d env;
      let ae = annotate_expr e env in
      let ad = d in
      TVDecl(ae, ad)
  | ObjectCreate(e,sd,el) ->
	  let ae = annotate_expr e env in
	  let ad = sd in
	  let ael = annotate_exprs el in
	  TObjectCreate(ae,ad,ael)

and annotate_func_decl (fdecl : Ast.func_decl) (env : environment) : Sast.tfunc_decl =
  env.scope.functions <- (fdecl.name, fdecl.rtype) :: env.scope.functions;
  let s = {variables = []; functions = []; parent = Some(env.scope)} in
  let fenv = {scope = s} in
  let aes = annotate_exprs fdecl.formals fenv in
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
  let af = annotate_func_decl p.declf env in
  {tilist = ai; tmainf = am; tdeclf = af}
