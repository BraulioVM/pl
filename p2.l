cabecera_programa	BIENVENIDO
llave_izq	\{
llave_der	\}
corchete_izq	\[
corchete_der	\]
parentesis_izq	\(
parentesis_der	\)
token_subprograma	procedimiento
marca_ini_declar_variables	sean
marca_fin_declar_variables	\.
tipo	(booleano)|(entero)|(real)|(caracter)
coma	,
PYC	;
if	si
else	si_no
while	mientras
for	para
direccion_for	(hasta)|(bajando_hasta)
init_for	:=
do	hacer
scanf	captar
printf	imprimir
return	volver
plus_minus	\+|-
not	!
op_binario	\*|(\*\*)|\/|(&&)|(\|\|)|\^|>|<|(>=)|(<=)|(==)|(!=)
equals	=
entero	[0-9]+
fl_bool_ch	([0-9]+(.[0-9]+)?)|(\'[^\']\')|(true)|(false)
cadena	\"[^\"]*\"
nombre	[_a-zA-Z][_a-zA-Z0-9]*
%%
{cabecera_programa}	{ printf("{cabecera_programa}"); }		
{llave_izq}	{ printf("{llave_izq}"); }
{llave_der}	{ printf("{llave_der}"); }
{corchete_izq}	{ printf("{corchete_izq}"); }
{corchete_der}	{ printf("{corchete_der}"); }
{parentesis_izq}	{ printf("{parentesis_izq}"); }
{parentesis_der}	{ printf("{parentesis_der}"); }
{token_subprograma}	{ printf("{token_subprograma}"); }
{marca_ini_declar_variables}	{ printf("{marca_ini_declar_variables}"); }
{marca_fin_declar_variables}	{ printf("{marca_fin_declar_variables}"); }
{tipo}	{ printf("{tipo}"); }
{coma}	{ printf("{coma}"); }
{PYC}	{ printf("{PYC}"); }
{if}	{ printf("{if}"); }
{else}	{ printf("{else}"); }
{while}	{ printf("{while}"); }
{for}	{ printf("{for}"); }
{direccion_for}	{ printf("{direccion_for}"); }
{init_for}	{ printf("{init_for}"); }
{do}	{ printf("{do}"); }
{scanf}	{ printf("{scanf}"); }
{printf}	{ printf("{printf}"); }
{return}	{ printf("{return}"); }
{plus_minus}	{ printf("{plus_minus}"); }
{not}	{ printf("{not}"); }
{op_binario}	{ printf("{op_binario}"); }
{equals}	{ printf("{equals}"); }
{entero}	{ printf("{entero}"); }
{fl_bool_ch}	{ printf("{fl_bool_ch}"); }
{cadena}	{ printf("{cadena}"); }
{nombre}	{ printf("{nombre}"); }
[\ \t\n]		{ printf( "%s",yytext ); }
.			{ printf("No se pudo reconocer: %s\n", yytext ); }


%%

int main() {
	yylex();
}
