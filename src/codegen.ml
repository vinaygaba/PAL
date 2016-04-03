open Sast
open Printf
open Random


(************
  HELPERS
************)




let type_of (ae : Sast.aExpr) : Sast.t =
  match ae with
  | TLitInt(_, t) -> t
  | TLitFloat(_, t) -> t
  | TLitString(_, t) -> t
	| TLitBool(_, t) -> t
  | TUop(_, _, t) -> t
  | TCallExpr(_, _,_, t) -> t
  | TRet(_,t) -> t
  | TBinop(_, _, _, t) -> t
	| TIden(_,t) -> t

let java_from_type (ty: Sast.t) : string =
    match ty with
      | _ ->  "PrimitiveObject"

let rec writeJavaProgramToFile fileName programString =
	let file = open_out ("javagen/" ^ fileName ^ ".java") in
		fprintf file "%s" programString

and generateJavaProgram fileName prog =
	let statementString = generateFunctionList prog.declf in
	let progString = sprintf "
	public class %s
	{
    %s
	}
" fileName statementString in
  writeJavaProgramToFile fileName progString;
  progString


  and generateFunctionList prog =
  let concatenatedFunctions = List.fold_left (fun a b -> a ^ (generateFunctionDefinitions b)) "" prog in
  	sprintf "%s" concatenatedFunctions

  and generateFunctionDefinitions  = function
       tmainf(stmtList) -> writeMainFunction stmtList
      | failwith "Not handled"


 and generateStatement = function
     TVdecl(tid, tdataType, _) -> writeDeclarationStmt tid tdataType
     | TAssign(tid, tExpression, _) -> writeAssignmentStmt tid tExpression
     | TObjectCreate(tid, tspDataType, tExprList, _) -> writeObjectStmt tid tspDataType tExprList
     | TCallStmt(name, exprList, _) -> writeFunctionCallStmt name exprList
     | failwith "Not handled"

and writeStmtList stmtList =
let outStr = List.fold_left (fun a b -> a ^ (generateStatement b)) "" stmtList in
sprintf "%s" outStr

 and generateExpression = function
 	   TBinop(ope1, op, ope2, _) -> writeBinop ope1 op ope2
 	 | TLitString(stringLit, _) -> writeStringLit stringLit
 	 | TLitInt(intLit, _) -> writeIntLit intLit
	 | TIden(name, _) -> writeId name
   | failwith "Not handled"

and writeAssignmentStmt expr1 expr2 =
		    let lhs_type = java_from_type (type_of expr2) in
		    let e2string = generateExpression expr2 in
		      match expr1 with
		        | TIden(name, typ) ->
		          sprintf "%s = (%s)(%s);\n" name lhs_type e2string
		        | _ -> failwith "How'd we get all the way to java with this!!!! Not a valid LHS"


            and getExpressionMap exprList =
            let exprMap =  StringMap.empty in
            let rec access_list exprList index = match exprList with
            | [] -> exprMap
            | head::body ->
            (
            mymap = StringMap.add index head;
            access_list body index+1
            )
            in access_list exprList 1


and writeDeclarationStmt tid tdataType =
	let lhs_type = java_from_type tdataType in
		match tid with
			| TIden(name, typ) ->
			  (match typ with
				| Pdf -> sprintf "%s %s = new %s(new PDDocument());\n" lhs_type name lhs_type
				| Page -> sprintf "%s %s = new %s(new PDPage());\n" lhs_type name lhs_type
				| _ -> sprintf "%s %s = new %s();\n" lhs_type name lhs_type)
			| _ -> failwith "How'd we get all the way to java with this!!!! Not a valid LHS"


 and writeObjectStmt tid tspDataType tExprList =
 match tspDataType with
 | Line ->
 let exprMapForLine = getExpressionMap tExprList in
 let drawString =  StringMap.find 1 exprMapForLine in
 let font = StringMap.find 2 exprMapForLine in
 let fontSize = StringMap.find 3 exprMapForLine in
 let xcod = StringMap.find 4 exprMapForLine in
 let ycod = StringMap.find 5 exprMapForLine in
 sprintf "Line %s = new Line();\n %s.setFont(%s);\n %s.setText(%s);\n %s.setXcod(%s);\n %s.setYcod(%s);\n %s.setFontSize(%s);\n" tid tid font tid drawString tid xcod tid ycod tid fontSize
 | Tuple ->
 let exprMapForTuple = getExpressionMap tExprList in
 let pdfIden = StringMap.find 1 exprMapForTuple in
 let pageIden = StringMap.find 2 exprMapForTuple in
 sprintf "Tuple %s = new Tuple(%s,%s);\n" tid, pdfIden, pageIden
 | _ -> failwith "Something went wrong"


(*******************************************************************************
  Binop and Not Handling - helper functions
********************************************************************************)

and writeBinop expr1 op expr2 =
	let e1 = generateExpression expr1 and e2 = generateExpression expr2 in
		let type1 = type_of expr1 and let type2 = type_of expr2 in
		let writeBinopHelper e1 op e2 = match op with
			Concat ->
			match type1 with
			| Pdf -> (match type2 with
			| Page -> sprintf "%s.addPage( %s );\n" e1 e2
			)
      | Tuple -> (match type2 with
      | Line -> sprintf "  PDPageContentStream %s = new PDPageContentStream(%s.getDocument(), %s.getPage());\n  %s.beginText();\n %s.setFont(PDType1Font.TIMES_NEW_ROMAN, %s.getFontSize());\n %s.moveTextPositionByAmount( %s.getXcod(), %s.getYcod() );\n %s.drawString(%s.getText()); \n %s.endText();\n %s.close();" e2^"contentStream" e1 e1 e2^"contentStream" e2^"contentStream" e2 e2^"contentStream" e2 e2 e2^"contentStream" e2 e2^"contentStream"
      )
			| _ -> failwith "Something went wrong!"
		in writeBinopHelper e1 op e2


and writeFunctionCallStmt name exprList =
match name with
| "renderPdf" -> let exprMap = getExpressionMap exprList in
let pdfIden =  StringMap.find 1 exprMap in
let location = StringMap.find 2 exprMap in
sprintf "%s.save(%s);\n %s.close()" pdfIden location pdfIden
| failwith "undefined function"



writeMainFunction stmtList =
let mainBody = writeStmtList stmtList in
sprintf "  public static void main(String[] args)
      {
        %s
      }  " mainBody

(*******************************************************************************
	Literal expression handling - helper functions
********************************************************************************)


and writeId iden =
   sprintf "PrimtiveObject %s" iden

and writeIntLit intLit =
  sprintf "new PrimitiveObject(%d)" intLit

and writeStringLit stringLit =
	sprintf "new PrimitiveObject(%s)" stringLit

and writeFloatLit floatLit =
	sprintf "new PrimitiveObject(%f)" floatLit

and writeBoolLit boolLit =
	sprintf "new PrimitiveObject(%b)" boolLit
