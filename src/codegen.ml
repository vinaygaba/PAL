open Sast
open Printf
open Random


let rec writeJavaProgramToFile fileName programString =
	let file = open_out ("javagen/" ^ fileName ^ ".java") in
		fprintf file "%s" programString

and generateJavaProgram fileName prog =
	let statementString = generateStatementList prog in
	let progString = sprintf "
	public class %s
	{
		public static void main(String[] args)
		{
		%s
		}
	}
" fileName statementString in
  writeJavaProgramToFile fileName progString;
  progString

 and generateStatementList prog =
 	let concatenatedStatements = List.fold_left (fun a b -> a ^ (gen_stmt b)) "" prog in
 	sprintf "%s" concatenatedStatements

 and generateStatement = function
     TVdecl(tid, tdataType, _) -> writeDeclarationStmt tid tdataType
     | TAssign(tid, tExpression, _) -> writeAssignmentStmt tid tExpression
     | TObjectCreate(tid, tspDataType, tExprList, _) -> writeObjectStmt tid tspDataType tExprList
     | TCallStmt(name, exprList, _) -> writeFunctionCallStmt name exprList

 and generateExpression = function
 	   ABinop(ope1, op, ope2, _) -> writeBinop ope1 op ope2
 	 | ALitString(stringLit, _) -> writeStringLit stringLit
 	 | AIntLit(intLit, _) -> writeIntLite intLit

 and generateFuncDecl = function
 		AFuncDecl(tdataType, name, declList, stmtList, _) -> writeAFuncDecl tdataType name declList stmtList

 and generatteImportStmt = function
 		TImpStmt(module, _) -> writeImportStmt module



and writeAssignmentStmt expr1 expr2 =
		    let lhs_type = java_from_type (type_of expr2) in
		    let e2string = gen_expr expr2 in
		      match expr1 with
		        | TIden(name, typ) ->
		          sprintf "%s = (%s)(%s);\n" name lhs_type e2string
		        | _ -> failwith "How'd we get all the way to java with this!!!! Not a valid LHS"

and writeDeclarationStmt tid tdataType =
	let lhs_type = java_from_type (type_of tdataType) in
		match tid with
			| TIden(name, typ) ->
				sprintf "%s %s = (%s) (%s);\n" lhs_type name lhs_type typ
			| _ -> failwith "How'd we get all the way to java with this!!!! Not a valid LHS"


(*******************************************************************************
  Binop and Not Handling - helper functions
********************************************************************************)

and writeBinop expr1 op expr2 =
	let e1 = generateExpression expr1 and e2 = generateExpression expr2 in
		let writeBinopHelper e1 op e2 = match op with
			Concat -> sprintf "new PrimitiveObject(%s,%s)" e1 e2
		in writeBinopHelper e1 op e2

(*******************************************************************************
	Literal expression handling - helper functions
********************************************************************************)

and writeIntLit intLit =
  sprintf "new PrimitiveObject(%d)" intLit

	and writeStringLit stringLit =
	  sprintf "new PrimitiveObject(%s)" stringLit
