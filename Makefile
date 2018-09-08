EXEC=bff

TOOLS=tools
LEXER=lexer
PARSER=parser
COMPILER=compiler

SRC=src/
TMP=tmp/
BIN=bin/

OCAMLC=ocamlc
OCAMLCFLAGSI=-i
OCAMLCFLAGSB=-c -dtypes
LIBS=unix.cma
 
.PHONY: all clean clean-tmp runtest
 
all: clean
	mkdir -p $(TMP)
	mkdir -p $(BIN)
	cp $(SRC)* $(TMP)
	cd $(TMP) && $(OCAMLC) $(OCAMLCFLAGSI) $(TOOLS).ml > $(TOOLS).mli
	cd $(TMP) && $(OCAMLC) $(OCAMLCFLAGSI) $(LEXER).ml > $(LEXER).mli
	cd $(TMP) && $(OCAMLC) $(OCAMLCFLAGSI) $(PARSER).ml > $(PARSER).mli
	
	cd $(TMP) && $(OCAMLC) $(OCAMLCFLAGSB) $(TOOLS).mli $(TOOLS).ml
	cd $(TMP) && $(OCAMLC) $(OCAMLCFLAGSB) $(LEXER).mli $(LEXER).ml
	cd $(TMP) && $(OCAMLC) $(OCAMLCFLAGSB) $(PARSER).mli $(PARSER).ml
	cd $(TMP) && $(OCAMLC) $(OCAMLCFLAGSB) $(COMPILER).ml
	
	cd $(TMP) && $(OCAMLC) -o $(EXEC) $(LIBS) $(TOOLS).cmo $(LEXER).cmo $(PARSER).cmo $(COMPILER).cmo  
	
	cp $(TMP)$(EXEC) $(BIN)$(EXEC)
 
clean-tmp:
	rm -rf $(TMP)*
 
clean: clean-tmp
	mkdir -p $(BIN)
	rm -rf $(BIN)*
	echo "*" > $(BIN).gitignore
	
runtest: 
	chmod +x test/test.sh
	./test/test.sh
