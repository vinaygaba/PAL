open Sast
open Ast
open Printf
open Random
module StringMap = Map.Make(String);;


(************
  HELPERS
************)




let type_of (ae : Sast.texpression) : Ast.t =
  match ae with
  | TLitInt(_, t) -> t
  | TLitFloat(_, t) -> t
  | TLitString(_, t) -> t
	| TLitBool(_, t) -> t
  | TUop(_, _, t) -> t
  | TCallExpr(_, _, t) -> t
  | TBinop(_, _, _, t) -> t
	| TIden(_,t) -> t

let java_from_type (ty: Ast.t) : string =
    match ty with
      | _ ->  "PrimitiveObject"



let writeId iden =
   sprintf "%s" iden

let writeIntLit intLit =
  sprintf "new Integer(%d)" intLit

let writeStringLit stringLit =
  sprintf "%s" stringLit

let rec writeJavaProgramToFile fileName programString =
	let file = open_out ("javagen/" ^ fileName ^ ".java") in
		fprintf file "%s" programString


  (*and generateFunctionList prog =
  let concatenatedFunctions = List.fold_left (fun a b -> a ^ (generateFunctionDefinitions b)) "" prog in
  	sprintf "%s" concatenatedFunctions

  and generateFunctionDefinitions  = function
       tmainf(stmtList) -> writeMainFunction stmtList
      | failwith "Not handled"*)



let rec writeBinop expr1 op expr2 =
  let e1 = generateExpression expr1 and e2 = generateExpression expr2 in
    let type1 = type_of expr1 in
     let type2 = type_of expr2 in
     let writeBinopHelper e1 op e2 = match op with
      Concat ->
      match type1 with
      | Pdf -> (match type2 with
      | Page -> sprintf "%s.addPage( %s );\n" e1 e2
      | _ -> failwith "Not handled"
      )
      | Tuple -> (match type2 with
      | Line ->
      let var = e2^"contentStream" in
      sprintf "PDPageContentStream %s = new PDPageContentStream(%s.getDocument(), %s.getPage());\n  %s.beginText();\n %s.setFont(PDType1Font.TIMES_ROMAN, %s.getFontSize());\n %s.moveTextPositionByAmount( %s.getXcod(), %s.getYcod() );\n %s.drawString(%s.getText()); \n %s.endText();\n %s.close();" var e1 e1 var var e2 var e2 e2 var e2 var var
      | _ -> failwith "Not handled"
      )
      | _ -> failwith "Something went wrong!"
    in writeBinopHelper e1 op e2




and writeObjectStmt tid tspDataType tExprList =
let idstring =
  (match tid with
   | IdTest(s) ->  s ) in
 match tspDataType with
 | Line ->
 let exprMapForLine = getExpressionMap tExprList in
 let drawString =  StringMap.find "5" exprMapForLine in
 let font = StringMap.find "4" exprMapForLine in
 let fontSize = StringMap.find "3" exprMapForLine in
 let xcod = StringMap.find "2" exprMapForLine in
 let ycod = StringMap.find "1" exprMapForLine in
 sprintf "Line %s = new Line();\n %s.setFont(%s);\n %s.setText(%s);\n %s.setXcod(%s);\n %s.setYcod(%s);\n %s.setFontSize(%s);\n" idstring idstring font idstring drawString idstring xcod idstring ycod idstring fontSize
 | Tuple ->
 let exprMapForTuple = getExpressionMap tExprList in
 let pdfIden = StringMap.find "2" exprMapForTuple in
 let pageIden = StringMap.find "1" exprMapForTuple in
  sprintf "Tuple %s = new Tuple(%s,%s);\n" idstring pdfIden pageIden
 | _ -> failwith "Something went wrong"


 (*and writeObjectStmt tid tspDataType tExprList =
 let idstring =
   (match tid with
    | IdTest(s) ->  s ) in
  match tspDataType with
  | Line ->
  let drawString =  "Hello World" in
  let font = "TIMES_ROMAN" in
  let fontSize = 12 in
  let xcod = 100 in
  let ycod = 600 in
  sprintf "Line %s = new Line();\n %s.setFont(\"%s\");\n %s.setText(\"%s\");\n %s.setXcod(%d);\n %s.setYcod(%d);\n %s.setFontSize(%d);\n" idstring idstring font idstring drawString idstring xcod idstring ycod idstring fontSize
  | Tuple ->
  sprintf "Tuple %s = new Tuple(%s,%s);\n" idstring "pdfVar" "pageVar"
  | _ -> failwith "Something went wrong"
*)


(*and getExpressionMap exprList =
let exprMap = StringMap.empty in
StringMap.add "1" "Test" exprMap;
StringMap.add "2" "Test" exprMap;
StringMap.add "3" "Test" exprMap;
StringMap.add "4" "Test" exprMap;
StringMap.add "5" "Test" exprMap;
exprMap*)

and getExpressionMap exprList =
let rec access_list exprMap exprList index =
match exprList with
| [] -> exprMap
| head::body ->
(
let indexString = string_of_int index in
let value = generateExpression head in
let exprMap = StringMap.add indexString value exprMap in
let nextIndex = (index + 1) in
access_list exprMap body nextIndex
)
in access_list StringMap.empty exprList 1;


and getFuncExpressionMap exprList =
let rec access_list funcExprMap exprList index =
match exprList with
| [] -> funcExprMap
| head::body ->
(
let indexString = string_of_int index in
let value = generateExpression head in
let funcExprMap = StringMap.add indexString value funcExprMap in
let nextIndex = (index + 1) in
access_list funcExprMap body nextIndex
)
in access_list StringMap.empty exprList 1;


and writeFunctionCallStmt name exprList =
match name with
| "renderpdf" -> let funcExprMap = getFuncExpressionMap exprList in
let pdfIden =  StringMap.find "1" funcExprMap in
let location = StringMap.find "2" funcExprMap in
sprintf "\n%s.save(%s);\n %s.close();" pdfIden location pdfIden
| _ -> failwith "undefined function"

(*and writeFunctionCallStmt name exprList =
match name with
| "renderpdf" ->
let pdfIden =  "pdfVar" in
let location = "helloworld.pdf" in
sprintf "\n%s.save(\"%s\");\n %s.close();" pdfIden location pdfIden
| _ -> failwith "undefined function"*)



 and generateExpression = function
     TBinop(ope1, op, ope2, _) -> writeBinop ope1 op ope2
   | TLitString(stringLit, _) -> writeStringLit stringLit
   | TLitInt(intLit, _) -> writeIntLit intLit
   | TIden(name, _) ->
   (match name with
   |IdTest(n) -> writeId n
  )


let rec writeAssignmentStmt id expr2 =
        let lhs_type = java_from_type (type_of expr2) in
        let expr2_type = type_of expr2 in
        let e2string = generateExpression expr2 in
        match expr2_type with
        | Tuple -> sprintf "%s" e2string
        | Pdf -> sprintf "%s" e2string
        | _ ->  ( match id with
             IdTest(n) ->  sprintf "%s = %s;\n" n e2string
            | _ -> failwith "How'd we get all the way to java with this!!!! Not a valid LHS" )


let rec writeDeclarationStmt tid tdataType =
  let lhs_type = java_from_type tdataType in
  match tid with
      | IdTest(name) ->
                        (match tdataType with
                                  | Pdf -> sprintf "PDDocument %s = new PDDocument();\n" name
                                  | Page -> sprintf "PDPage %s = new PDPage();\n" name
                                  | Int -> sprintf "Integer %s = new Integer();\n" name
                                  | String -> sprintf "String %s = new String();\n" name)
      | _ -> failwith "Not handled"



 and generateStatement = function
     TVdecl(tid, tdataType) -> writeDeclarationStmt tid tdataType
     | TAssign(tid, tExpression ) ->  writeAssignmentStmt tid tExpression
     | TObjectCreate(tid, tspDataType, tExprList ) -> writeObjectStmt tid tspDataType tExprList
     | TCallStmt(name, exprList ) -> writeFunctionCallStmt name exprList

and writeStmtList stmtList =
let outStr = List.fold_left (fun a b -> a ^ (generateStatement b)) "" stmtList in
sprintf "%s" outStr


and generateJavaProgram fileName prog =
  let statementString = generateMainFunction prog.tmainf in
  let progString = sprintf "
  import java.io.File;
  import org.apache.pdfbox.pdmodel.PDDocument;
  import org.apache.pdfbox.pdmodel.PDPage;
  import org.apache.pdfbox.pdmodel.PageLayout;
  import org.apache.pdfbox.pdmodel.font.PDFont;
  import org.apache.pdfbox.pdmodel.PDPageContentStream;
  import org.apache.pdfbox.pdmodel.font.PDType1Font;

  public class %s
  {
    %s
  }
" fileName statementString in
  writeJavaProgramToFile fileName progString;
  progString




and writeMainFunction stmtList =
let mainBody = writeStmtList stmtList in
sprintf "  public static void main(String[] args) throws Exception
      {
        %s
      }  " mainBody



  and generateMainFunction prog =
  let mainFunctionBody =  writeMainFunction prog.tbody in
  sprintf "%s" mainFunctionBody



(*******************************************************************************
	Literal expression handling - helper functions
********************************************************************************)
