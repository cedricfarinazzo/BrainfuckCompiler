EXEC=bff

LEXER=lexer
PARSER=parser
COMPILER=compiler

SRC=src/
TMP=tmp/
BIN=bin/

OCAMLC=ocamlc
OCAMLCFLAGS=-c -dtypes
LIBS=unix.cma
 
.PHONY: all clean
 
all:
	mkdir $(TMP)
	cp $(SRC)* $(TMP)
	cd $(TMP) && $(OCAMLC) $(OCAMLCFLAGS) $(LEXER).ml
	cd $(TMP) && $(OCAMLC) $(OCAMLCFLAGS) $(PARSER).ml
	cd $(TMP) && $(OCAMLC) $(OCAMLCFLAGS) $(COMPILER).ml
	cd $(TMP) && $(OCAMLC) -o $(EXEC) $(LIBS) $(COMPILER).cmo $(PARSER).cmo $(LEXER).cmo
	cp $(TMP)$(EXEC) $(BIN)
 
clean:
	rm -rf $(TMP)*
	rm -rf $(BIN)*
	  
