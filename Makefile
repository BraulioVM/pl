CC = gcc
CCFLAGS = -g -Wall
LEXER = lex
BISON = yacc
BIN = ./bin
SRC = ./compilador
# not like real objects, but intermediate steps
OBJ = ./obj
DEBUG = ./debug
OS := $(shell uname)

ifeq ($(OS),Linux)
	TOKENIZER_FLAGS = -lfl
endif
ifeq ($(OS),Darwin)
	TOKENIZER_FLAGS = -ll
endif

all: grammarizer #tokenizer

tokenizer: $(BIN)/tokenizador

grammarizer: $(BIN)/gramatizador

$(BIN)/tokenizador: $(OBJ)/tokenizador.c
	$(CC) $(CCFLAGS) -I$(SRC) $^ -o $@ $(TOKENIZER_FLAGS)

$(OBJ)/tokenizador.c: $(SRC)/tokenizador.l
	$(LEXER) -o $@ $^

$(OBJ)/tabla-simbolos.o: $(SRC)/tabla-simbolos.c $(SRC)/tabla-simbolos.h
	gcc  $(CCFLAGS) -c $(SRC)/tabla-simbolos.c -o $(OBJ)/tabla-simbolos.o

$(OBJ)/generacion-codigo.o: $(SRC)/generacion-codigo.c $(SRC)/generacion-codigo.h
	gcc  $(CCFLAGS) -c $(SRC)/generacion-codigo.c -o $(OBJ)/generacion-codigo.o

$(BIN)/gramatizador: $(OBJ)/gramatica.c $(OBJ)/tokenizador.c $(OBJ)/tabla-simbolos.o $(OBJ)/generacion-codigo.o
	$(CC) $(CCFLAGS) -I$(SRC) -I$(OBJ) $(OBJ)/generacion-codigo.o $(OBJ)/tabla-simbolos.o $(OBJ)/gramatica.c -o $@ $(TOKENIZER_FLAGS) 

grammar: $(OBJ)/gramatica.c

$(OBJ)/gramatica.c: $(SRC)/gramatica.y
	$(BISON) --debug --verbose -dv $^ -o $@

debug: $(DEBUG)/tokenizador

$(DEBUG)/tokenizador: $(DEBUG)/tokenizador.c
	$(CC) $(CCFLAGS) -I$(SRC) $^ -o $@ $(TOKENIZER_FLAGS)

$(DEBUG)/tokenizador.c: $(DEBUG)/tokenizador.l
	$(LEXER) $^ -o $@

clean:
	rm -f $(OBJ)/*

mrproper: clean
	rm -f $(BIN)/*

.PHONY: all clean mrproper tokenizer grammarizer grammar debug
