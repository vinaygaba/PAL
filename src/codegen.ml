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

