EXEC=bff

LEXER=lexer
PARSER=parser
COMPILER=compiler

SRC=src/
TMP=tmp/
BIN=bin/

OCAMLC=ocamlc
OCAMLCFLAGS=-c -dtypes
LIBS=unix.cma camlp4o.cma
 
.PHONY: all clean
 
all:
	mkdir $(TMP)
	cp $(SRC)* $(TMP)
	cd $(TMP)
	$(OCAMLC) $(OCAMLCFLAGS) $(LEXER).ml
	$(OCAMLC) $(OCAMLCFLAGS) $(PARSER).ml
	$(OCAMLC) $(OCAMLCFLAGS) $(COMPILER).ml
	$(OCAMLC) -o $(EXEC) $(LIBS) $(COMPILER).cmo $(PARSER).cmo $(LEXER).cmo
	cd ..
	cp $(TMP)$(EXEC) $(BIN)
 
clean:
	rm -rf $(TMP)*
	rm -rf $(BIN)*
	  
