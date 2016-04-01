
let annotate_stmt (s : Ast.stmt) (env : environment) : Sast.aStmt =
  match s with
  |Assign(e1, e2) ->
  	let (te1, te2) = annotate_assign e1 e2 env 


  and annotate_assign (e1 : Ast.expr) (e2 : Ast.expr) (env : environment) : Sast.aExpr * Sast.aExpr =
  	let te = annotate_expr



  	

let apply_stmt (s : sStmt) (subs : subst)


and annotate_stmts (stmts : Ast.stmt list) (env : environment) : Sast.aStmt list =
  List.map (fun x -> annotate_stmt x env) stmts
  
let annotate_prog (p : Ast.program) : Sast.aProgram =
  let env = new_env() in
  annotate_stmts p env