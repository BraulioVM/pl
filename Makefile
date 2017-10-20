lex: p2.c
	gcc p2.c -o lex -lfl

p2.c: p2.l
	lex p2.l
	mv lex.yy.c p2.c
