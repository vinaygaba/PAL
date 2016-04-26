let parseFile (fname : string) : Sast.tprogram =
  let file = open_in fname in
  let lexbuf = Lexing.from_channel file in
  let program = Parser.program Lexer.token lexbuf in
  let annotatedProgram = Analyzer.annotate_prog program in
  annotatedProgram

let _ =
  if Array.length Sys.argv > 1
  then
    let fname = Sys.argv.(1) in
    let annotatedProgram = parseFile fname in
    let _ = Codegen.generateJavaProgram "Output" annotatedProgram in
    print_string "Compilation Successful\n"
  else failwith "Input File Missing"
