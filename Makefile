CC = gcc
CCFLAGS =  -Wall -g
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

all: tokenizer

tokenizer: $(BIN)/tokenizador

$(BIN)/tokenizador: $(OBJ)/tokenizador.c
	$(CC) $(CC_FLAGS) -I$(SRC) $^ -o $@ $(TOKENIZER_FLAGS)

$(OBJ)/tokenizador.c: $(SRC)/tokenizador.l
	$(LEXER) -o $@ $^

grammar: $(OBJ)/gramatica.c

$(OBJ)/gramatica.c: $(SRC)/gramatica.y
	$(BISON) -v $^ -o $@

debug: $(DEBUG)/tokenizador

$(DEBUG)/tokenizador: $(DEBUG)/tokenizador.c
	$(CC) $(CC_FLAGS) -I$(SRC) $^ -o $@ $(TOKENIZER_FLAGS)

$(DEBUG)/tokenizador.c: $(DEBUG)/tokenizador.l
	$(LEXER) $^ -o $@

clean:
	rm -f $(OBJ)/*

mrproper: clean
	rm -f $(BIN)/*

.PHONY: all clean mrproper
