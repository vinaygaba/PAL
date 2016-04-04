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
	ocamlc -c sast.ml
	ocamlc -c analyzer.ml
	#ocamlc -c semantics.ml
	#ocamlc -c compile.ml
	ocamlc -c codegen.ml
	ocamlc -c pal.ml
	ocamlc -o pal sast.cmo parser.cmo lexer.cmo analyzer.cmo codegen.cmo pal.cmo

.PHONY : clean
clean :
	rm -f pal parser.ml parser.mli lexer.ml bin/*.class \
	*.cmo *.cmi *.output *.class *.java *.log *.csv

#javac -cp ".:pdfbox.jar" Output.java
#java -cp ".:pdfbox.jar" Output
