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
  | TListAccess(_, _, t) -> t
  | TMapAccess (_, _, t) -> t

let java_from_type (ty: Ast.t) : string =
    match ty with
      | _ ->  "PrimitiveObject"


let writeId iden =
   sprintf "%s" iden

let writeIntLit intLit =
  sprintf "new Integer(%d)" intLit

let writeFloatLit floatLit  =
  sprintf "new Float(%f)" floatLit

let writeBoolLit boolLit =
  sprintf "new Boolean(%b)" boolLit

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
     let writeBinopHelper e1 op e2 =
     (match op with
        Add -> sprintf "%s + %s" e1 e2
      | Sub -> sprintf "%s - %s" e1 e2
      | Mul -> sprintf "%s * %s" e1 e2
      | Div -> sprintf "%s / %s" e1 e2
      | Equal -> sprintf "%s == %s" e1 e2
      | Neq -> sprintf "%s != %s" e1 e2
      | Less -> sprintf "%s < %s" e1 e2
      | Leq -> sprintf "%s <= %s" e1 e2
      | Greater -> sprintf "%s > %s" e1 e2
      | Geq -> sprintf "%s >= %s" e1 e2
      | Mod -> sprintf "%s || %s" e1 e2
      | And -> sprintf "%s && %s" e1 e2
      | Or -> sprintf "%s || %s" e1 e2
      | Swap -> sprintf "%s || %s" e1 e2
      | Append -> sprintf "%s || %s" e1 e2
      | Concat ->
                match type1 with
                | Pdf ->
                        (match type2 with
                          | Page -> sprintf "Util.addPageToPDF(%s,%s);\n" e1 e2
                          | _ -> failwith "Not handled")
      | Tuple ->
      (match type2 with
          | Line ->
                sprintf "Util.addLineToTuple(%s,%s)" e1 e2
          | Image ->
                sprintf "Util.addImageToTuple(%s, %s)" e1 e2
          | _ -> failwith "Not handled" )
      | _ -> failwith "Something went wrong!")
    in writeBinopHelper e1 op e2

and writeUop expr1 op =
  let e1 = generateExpression expr1 in
  let writeUopHelper e1 op = match op with
    | LineBuffer -> sprintf "%s.getRemainingText();" e1
    | Neg -> sprintf "-%s" e1
    | Not -> sprintf "!%s" e1
  in writeUopHelper e1 op

and writeObjectStmt tid tspDataType tExprList =
let idstring =
  (match tid with
   | IdTest(s) ->  s ) in
 (match tspDataType with
 | Line -> (match tExprList with
          [] -> sprintf "Line %s = new Line();\n %s.setFont(\"TIMES_ROMAN\");\n %s.setText(\"Hello World\");\n %s.setXcod(100);\n %s.setYcod(700);\n %s.setFontSize(12);\n %s.setWidth(500);\n" idstring idstring idstring idstring idstring idstring idstring
          | _ ->
          let exprMapForLine = getExpressionMap tExprList in
          let drawString =  StringMap.find "6" exprMapForLine in
          let font = StringMap.find "5" exprMapForLine in
          let fontSize = StringMap.find "4" exprMapForLine in
          let xcod = StringMap.find "3" exprMapForLine in
          let ycod = StringMap.find "2" exprMapForLine in
          let width = StringMap.find "1" exprMapForLine in
          sprintf "Line %s = new Line();\n %s.setFont(%s);\n %s.setText(%s);\n %s.setXcod(%s);\n %s.setYcod(%s);\n %s.setFontSize(%s);\n %s.setWidth(%s);\n" idstring idstring font idstring drawString idstring xcod idstring ycod idstring fontSize idstring width)
 | Tuple ->
 let exprMapForTuple = getExpressionMap tExprList in
 let pdfIden = StringMap.find "2" exprMapForTuple in
 let pageIden = StringMap.find "1" exprMapForTuple in
  sprintf "Tuple %s = new Tuple(%s,%s);\n" idstring pdfIden pageIden
 | Image ->  (match tExprList with
          [] -> sprintf "\nFile file = new File(\"\"); \nImage %s = new Image(file,%s,%s,%s,%s);\n" idstring "800" "600" "100" "600"
          | _ ->
           let exprMapForImage = getExpressionMap tExprList in
           let fileLoc =  StringMap.find "5" exprMapForImage in
           let xcood = StringMap.find "4" exprMapForImage in
           let ycood = StringMap.find "3" exprMapForImage in
           let height = StringMap.find "2" exprMapForImage in
           let width = StringMap.find "1" exprMapForImage in
           let fileVar = idstring^"file" in
           sprintf "\nFile %s = new File(\"%s\"); \nImage %s = new Image(%s,%s,%s,%s,%s);\n" fileVar fileLoc idstring fileVar height width xcood ycood)
 | _ -> failwith "Something went wrong")


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


and writeFunctionCallExpr name exprList =
match name with
| "length" -> let identifier = List.hd exprList in
 ( match identifier with
  |  TIden(n, t) -> (
      let name =
      ( match n with
      |IdTest(n) -> n) in
    match t with
    | String ->  sprintf "%s.length()" name
    | ListType(x) -> sprintf "%s.size()" name
    | MapType(t,x) -> sprintf "%s.size()" name
    | _ -> failwith "How dare you ask for length of this type?"
  )
  | _ -> failwith "expecting an identifier"
 )
| "readfile" -> let funcExprMap = getFuncExpressionMap exprList in
let location = StringMap.find "1" funcExprMap in
sprintf "\n Util.readFile(%s)" location
| "drawpiechart" -> let funcExprMapForPieChart = getFuncExpressionMap exprList in
let dataList = StringMap.find "1" funcExprMapForPieChart in
let attributeMap = StringMap.find "2" funcExprMapForPieChart in
sprintf "\n Util.drawPieChart(%s, %s)" dataList attributeMap
| "readtable" -> let funcExprMapForTable = getFuncExpressionMap exprList in
let location = StringMap.find "1" funcExprMapForTable in
let pagenumberList = StringMap.find "2" funcExprMapForTable in
sprintf "\n Util.readTable(%s, %s)" location pagenumberList
| _ ->
let expressionListString = List.fold_left (fun a b -> a ^ (generateExpression b)^ ",") "" exprList in
let argList = String.sub expressionListString 0 ((String.length expressionListString) - 1) in
sprintf "\n%s(%s);" name argList


and writeFunctionCallStmt name exprList =
match name with
| "renderpdf" -> let funcExprMap = getFuncExpressionMap exprList in
let pdfIden =  StringMap.find "1" funcExprMap in
let location = StringMap.find "2" funcExprMap in
sprintf "\n%s.save(%s);\n %s.close();" pdfIden location pdfIden
| _ ->
let expressionListString = List.fold_left (fun a b -> a ^ (generateExpression b)^ ",") "" exprList in
let argList = String.sub expressionListString 0 ((String.length expressionListString) - 1) in
sprintf "\n%s(%s);" name argList


and writeInitAssignStmt iden t expression =
let expressionString = generateExpression expression in
let name =
( match iden with
| IdTest(n ) -> n ) in
match t with
| Int -> sprintf "\nInteger %s = %s;" name expressionString
| String -> sprintf "\nString %s = %s;" name expressionString
| Bool -> sprintf "\nBoolean %s = %s;" name expressionString
| Float -> sprintf "\nFloat %s = %s;" name expressionString
| _ -> failwith "initialization not possible for this type"



and writeControlStmt name =
match name with
| "Continue" -> sprintf "\ncontinue;"
| "Break" -> sprintf "\nbreak;"
| _ -> failwith "undefined control statement"


(*and writeFunctionCallStmt name exprList =
match name with
| "renderpdf" ->
let pdfIden =  "pdfVar" in
let location = "helloworld.pdf" in
sprintf "\n%s.save(\"%s\");\n %s.close();" pdfIden location pdfIden
| _ -> failwith "undefined function"*)

 and writeListAccess tid texpression =
   let gexpr = generateExpression texpression in
   match tid with
   | IdTest(x) -> sprintf "%s[%s]" x gexpr

 and writeMapAccess tid texpression =
   let gexpr = generateExpression texpression in
   match tid with
   | IdTest(x) -> sprintf "%s.get(%s)" x gexpr

 and generateExpression = function
     TBinop(ope1, op, ope2, _) -> writeBinop ope1 op ope2
   | TUop(op,ope1, _) -> writeUop ope1 op
   | TLitString(stringLit, _) -> writeStringLit stringLit
   | TLitInt(intLit, _) -> writeIntLit intLit
   | TLitFloat (floatLit, _) -> writeFloatLit floatLit
   | TLitBool(boolLit, _) -> writeBoolLit boolLit
   | TCallExpr(name, exprList, _) -> writeFunctionCallExpr name exprList
   | TIden(name, _) ->
   (match name with
   |IdTest(n) -> writeId n
    )
   | TListAccess(tid, tex, _) -> writeListAccess tid tex
   | TMapAccess (tid, tex, _) -> writeMapAccess tid tex


let rec writeAssignmentStmt id expr2 =
        let e2string = generateExpression expr2 in
        match id with
             IdTest(n) ->  sprintf "%s = %s;\n" n e2string

let rec makeLists (typeid : string) (typemap)  : string =
      let found = StringMap.mem typeid typemap in
      if found
      then let foundType = StringMap.find typeid typemap in
      let recurseType = makeLists foundType typemap in
      let liststring = "List<" ^ recurseType ^ ">" in
      liststring
      else
          (match typeid with
          | "int" ->  "Integer"
          | "bool" -> "Boolean"
          | "float" -> "Float"
          | "string" -> "String"
          | "pdf" -> "PDDocument"
          | "page" -> "PDPage"
          | "line" -> "Line"
          | "tuple" -> "Tuple"
          | "image" -> "Image"
          | _ -> failwith "Type not found" )



let rec writeDeclarationStmt tid tdataType typemap =
  match tid with
      | IdTest(name) ->
                        (match tdataType with
                                  | Pdf -> sprintf "PDDocument %s = new PDDocument();\n" name
                                  | Page -> sprintf "PDPage %s = new PDPage();\n" name
                                  | Int -> sprintf "Integer %s = new Integer(0);\n" name
                                  | Float -> sprintf "Float %s = new Float(0.0); \n" name
                                  | Bool -> sprintf "Boolean %s = new Boolean(true);\n" name
                                  | String -> sprintf "String %s = new String();\n" name
                                  | ListType(x) ->
                                    let acc = makeLists x typemap in
                                    sprintf "%s %s = new Array%s(); \n" acc name acc
                                  | MapType(k,v) ->
                                      let keytype =
                                      (   match k with
                                            | Int ->  "Integer"
                                            | Bool -> "Boolean"
                                            | Float -> "Float"
                                            | String -> "String"
                                            | Pdf -> "PDDocument"
                                            | Page -> "PDPage"
                                            | Line -> "Line"
                                            | Tuple -> "Tuple"
                                            | Image -> "Image"
                                            | _ -> failwith "Can't use Lists or Maps as keys")  in
                                      let valuetype =
                                          ( match v with
                                            | ListType(x) ->
                                                      let acc = makeLists x typemap in
                                                      acc
                                            | Int ->  "Integer"
                                            | Bool -> "Boolean"
                                            | Float -> "Float"
                                            | String -> "String"
                                            | Pdf -> "PDDocument"
                                            | Page -> "PDPage"
                                            | Line -> "Line"
                                            | Tuple -> "Tuple"
                                            | Image -> "Image"
                                            | _ -> failwith "Can't put map type as value type") in
                                          sprintf "Map<%s,%s> %s = new HashMap<%s,%s>(); \n" keytype valuetype name keytype valuetype


                                     | _ -> failwith "Can't declare list, tuple or image"   )


and writeListAssign lexpr texpression =
      let genexpr = generateExpression texpression in
      match lexpr with
      | TListAccess(tid, texpr, t) -> let las = writeListAccess tid texpr in
                                      sprintf "%s = %s;\n" las genexpr
      | _ -> "Y u no use Id?"

and writeListAdd tid texpression typemap =
      let genexpr = generateExpression texpression in
      match tid with
      | IdTest(name) -> sprintf "%s.append(%s); \n" name genexpr

and writeListRemove tid texpression typemap =
      let genexpr = generateExpression texpression in
      match tid with
      | IdTest(name) -> sprintf "%s.remove(%s); \n" name genexpr

and writeMapAdd tid texpression1 texpression2 =
      let genexpr1 = generateExpression texpression1 in
      let genexpr2  = generateExpression texpression2 in
      match tid with
      | IdTest(name) -> sprintf "%s.put(%s,%s); \n" name genexpr1 genexpr2

and writeMapRemove tid texpression  =
      let genexpr = generateExpression texpression in
      match tid with
      | IdTest(name) -> sprintf "%s.remove(%s); \n" name genexpr


 and generateStatement tstatement typemap =
 match tstatement with
     | TVdecl(tid, tdataType) -> writeDeclarationStmt tid tdataType typemap
     | TAssign(tid, tExpression ) ->  writeAssignmentStmt tid tExpression
     | TObjectCreate(tid, tspDataType, tExprList ) -> writeObjectStmt tid tspDataType tExprList
     | TCallStmt(name, exprList ) -> writeFunctionCallStmt name exprList
     | TInitAssign(iden, t, expression) -> writeInitAssignStmt iden t expression
     | TFor(initStmt, condition, incrStmt, body) -> writeForLoopStatement initStmt condition incrStmt body typemap
     | TWhile(condition, body) -> writeWhileStatement condition body typemap
     | TListAssign (lac, lvexpr) -> writeListAssign lac lvexpr
     | TIf(conditionStmtList, elsestmtList) -> writeIfBlock conditionStmtList elsestmtList typemap
     | TControlStmt(name) -> writeControlStmt name
     | TListDecl(tid, tdataype) -> writeDeclarationStmt tid tdataype typemap
     | TListAdd(tid, texpr) -> writeListAdd tid texpr typemap
     | TListRemove(tid, texpr) -> writeListRemove tid texpr typemap
     | TMapDecl(tid, tdataype) -> writeDeclarationStmt tid tdataype typemap
     | TMapAdd(tid, texpr1, texpr2) -> writeMapAdd tid texpr1 texpr2
     | TMapRemove(tid, texpr) -> writeMapRemove tid texpr
     | TRet(texpr,t) -> writeReturnStatement texpr


and writeReturnStatement tExpression =
let exprString = generateExpression tExpression in
sprintf "\nreturn %s;" exprString


and writeStmtList stmtList typemap =
let outStr = List.fold_left (fun a b -> a ^ (generateStatement b typemap)) "" stmtList in
sprintf "%s" outStr


and generateConditionStmt conditionalList index typemap =
  match conditionalList with
   [] -> []
   | a::l -> let ifExpression = generateExpression a.tcondition in
   let body = writeStmtList a.tbody typemap in
    match index with
   | 1  -> sprintf "\n if (%s)  \n{ \n %s \n}" ifExpression body :: generateConditionStmt l (index+1) typemap
   | _ ->  sprintf "\n else if (%s)  \n{ \n %s \n}" ifExpression body :: generateConditionStmt l (index+1) typemap

and generateConditionalList conditionList typemap=
  let concatenatedConditionalsList =  generateConditionStmt conditionList 1 typemap in
   let concatenatedConditionals = List.fold_left (fun a b -> a ^ b ) "" concatenatedConditionalsList in
    sprintf "%s" concatenatedConditionals

and writeElseStmt body typemap =
let bodyString = writeStmtList body typemap in
sprintf " else \n{   %s \n}" bodyString


and writeIfBlock conditionList elseBody typemap =
let conditionListString = generateConditionalList conditionList typemap in
match elseBody with
Some(x) -> let elseBodyString = writeElseStmt x typemap in
sprintf " %s \n %s " conditionListString elseBodyString
| None -> sprintf " %s " conditionListString


and writeForLoopStatement initStmt condition incrStmt body typemap =
let exprString = generateExpression condition in
let initStmtString = generateStatement initStmt typemap in
let incrStmtString = generateStatement incrStmt typemap in
let incrStmtSubString = String.sub incrStmtString 0 ((String.length incrStmtString) - 2) in
let bodyString = writeStmtList body typemap in
sprintf "\nfor(%s %s ; %s) \n { %s \n }" initStmtString exprString incrStmtSubString bodyString

and writeWhileStatement condition body typemap =
let exprString = generateExpression condition in
let bodyString = writeStmtList body typemap in
sprintf "\nwhile(%s ) \n { %s \n }" exprString bodyString


and generateJavaProgram fileName prog =
  let statementString = generateMainFunction prog.tmainf prog.tmap in
  let decllist = prog.tdeclf in
  let funcDeclString = generateOtherFunctions decllist prog.tmap in
  let classBody = statementString^funcDeclString in
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
" fileName classBody in
  writeJavaProgramToFile fileName progString;
  progString



and getJavaType typ typemap =
match typ with
  | Int ->  "Integer"
  | Bool -> "Boolean"
  | Float -> "Float"
  | String -> "String"
  | Pdf -> "PDDocument"
  | Page -> "PDPage"
  | Line -> "Line"
  | Tuple -> "Tuple"
  | Image -> "Image"
  | ListType(l) -> makeLists l typemap
  | MapType(k,v) ->    let keytype =
                                      (match k with
                                            | Int ->  "Integer"
                                            | Bool -> "Boolean"
                                            | Float -> "Float"
                                            | String -> "String"
                                            | Pdf -> "PDDocument"
                                            | Page -> "PDPage"
                                            | Line -> "Line"
                                            | Tuple -> "Tuple"
                                            | Image -> "Image"
                                            | _ -> "Key type can't be list or map")  in
                                      let valuetype =
                                          ( match v with
                                            | ListType(x) ->
                                                      let acc = makeLists x typemap in
                                                      acc
                                            | Int ->  "Integer"
                                            | Bool -> "Boolean"
                                            | Float -> "Float"
                                            | String -> "String"
                                            | Pdf -> "PDDocument"
                                            | Page -> "PDPage"
                                            | Line -> "Line"
                                            | Tuple -> "Tuple"
                                            | Image -> "Image"
                                            | _  -> "value type can't be map"      )  in "Map<" ^keytype ^","^valuetype^">"


and generateFunction (b : Sast.tfunc_decl) typemap =
let name = b.name in
let returnType = b.rtype in
let returnTypeString = getJavaType returnType typemap in
let formalStatementList = b.tformals in
let functionBody = b.tbody in
let formalsListString = generateFormalsList formalStatementList typemap in
let functionBodyString = writeStmtList functionBody typemap in
sprintf"\npublic static %s %s ( %s ) throws Exception \n{ \n%s \n}" returnTypeString name formalsListString functionBodyString


and generateFormal formal typemap =
match formal with
    | TVdecl(id,t) ->
               (let name = match id with
                            | IdTest(n) -> n in
                            let jtype = getJavaType t typemap in sprintf "%s %s" jtype name )
    | TListDecl(id,t) ->
                (let name = match id with
                            | IdTest(n) -> n in
                            let jtype = getJavaType t typemap in sprintf "%s %s" jtype name )
    | TMapDecl(id,t) ->
                (let name = match id with
                            | IdTest(n) -> n in
                            let jtype = getJavaType t typemap in sprintf "%s %s" jtype name )
    | TObjectCreate(id,t,exprList) ->
                (let name = match id with
                            | IdTest(n) -> n in
                            let jtype = getJavaType t typemap in sprintf "%s %s" jtype name )
    | _ -> failwith "What formals do you want bruh?"



and generateFormalsList formalStatementList typemap =
let outStr = List.fold_left (fun a b -> a ^ (generateFormal b typemap)^ ",") "" formalStatementList in
let arg = String.sub outStr 0 ((String.length outStr) - 1) in
sprintf "%s" arg


and generateOtherFunctions functionList typemap =
let outStr = List.fold_left (fun a b -> a ^ (generateFunction b typemap)) "" functionList in
sprintf "%s" outStr


and writeMainFunction stmtList typemap =
let mainBody = writeStmtList stmtList typemap in
sprintf "  public static void main(String[] args) throws Exception
      {
        %s
      }  " mainBody



  and generateMainFunction prog typemap =
  let mainFunctionBody =  writeMainFunction prog.tbody typemap in
  sprintf "%s" mainFunctionBody








(*******************************************************************************
	Literal expression handling - helper functions
********************************************************************************)
