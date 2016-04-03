type action = Ast | Sast | Java | Debug

let _ =
  let action = if Array.length Sys.argv > 1 then
    List.assoc Sys.argv.(1) [ ("-j", Java);]
  else Java in
  let lexbuf = Lexing.from_channel stdin in
  let program = Parser.program Scanner.token lexbuf in
  match action with
  Java ->
      let ap = Analyzer.infer_prog program in
      let _ = Javagen.generateJavaProgram "output" ap in
      print_string "Success! Compiled to java/output.java\n"
