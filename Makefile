debug/tokenizador-mac: debug/tokenizador.c
	gcc debug/tokenizador.c -o debug/tokenizador -ll

debug/tokenizador: debug/tokenizador.c
	gcc debug/tokenizador.c -o debug/tokenizador -lfl

debug/tokenizador.c: debug/tokenizador.l
	lex debug/tokenizador.l
	mv lex.yy.c debug/tokenizador.c

compilador/tokenizador-mac: compilador/tokenizador.c
	gcc compilador/tokenizador.c -o compilador/tokenizador -ll

compilador/tokenizador: compilador/tokenizador.c
	gcc compilador/tokenizador.c -o compilador/tokenizador -lfl

compilador/tokenizador.c: compilador/tokenizador.l
	lex compilador/tokenizador.l
	mv lex.yy.c compilador/tokenizador.c

compilador/gramatica.c: compilador/gramatica.y
	yacc compilador/gramatica.y -o compilador/gramatica.c


