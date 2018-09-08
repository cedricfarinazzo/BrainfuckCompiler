EXEC=bff

TOOLS=tools
LEXER=lexer
PARSER=parser
COMPILER=compiler

SRC=src/
TMP=tmp/
BIN=bin/

OCAMLC=ocamlc
OCAMLCFLAGS=-c -dtypes
LIBS=unix.cma
 
.PHONY: all clean clean-tmp runtest
 
all: clean
	mkdir -p $(TMP)
	mkdir -p $(BIN)
	cp $(SRC)* $(TMP)
	cd $(TMP) && $(OCAMLC) $(OCAMLCFLAGS) $(TOOLS).ml
	cd $(TMP) && $(OCAMLC) $(OCAMLCFLAGS) $(LEXER).ml
	cd $(TMP) && $(OCAMLC) $(OCAMLCFLAGS) $(PARSER).ml
	cd $(TMP) && $(OCAMLC) $(OCAMLCFLAGS) $(COMPILER).ml
	cd $(TMP) && $(OCAMLC) -o $(EXEC) $(LIBS) $(TOOLS).cmo $(LEXER).cmo $(PARSER).cmo $(COMPILER).cmo  
	cp $(TMP)$(EXEC) $(BIN)$(EXEC)
 
clean-tmp:
	rm -rf $(TMP)*
 
clean: clean-tmp
	rm -rf $(BIN)*
	echo "bff" > $(BIN).gitignore
	
runtest: 
	chmod +x test/test.sh
	./test/test.sh
