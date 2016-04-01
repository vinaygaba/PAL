.PHONY : make
make :
	#javac -cp ../YahooFinanceAPI-2.0.0.jar bin/*
	ocamlc -c ast.mli
	#ocamlc -c sast.ml
	ocamlyacc -v parser.mly
	ocamlc -c parser.mli
	ocamlc -c parser.ml
	ocamllex lexer.mll
	ocamlc -c lexer.ml
	#ocamlc -c semantics.ml
	#ocamlc -c compile.ml
	#ocamlc -c pal.ml
	#ocamlc -o pal ast.cmo sast.cmo parser.cmo lexer.cmo compile.cmo semantics.cmo pal.cmo

.PHONY : clean
clean :
	rm -f pal parser.ml parser.mli lexer.ml bin/*.class \
	*.cmo *.cmi *.output *.class *.java *.log *.csv
