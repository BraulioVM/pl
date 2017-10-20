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
{cabecera_programa}	{ printf("cabecera_programa\n"); }		
{llave_izq}	{ printf("llave_izq\n"); }
{llave_der}	{ printf("llave_der\n"); }
{corchete_izq}	{ printf("corchete_izq\n"); }
{corchete_der}	{ printf("corchete_der\n"); }
{parentesis_izq}	{ printf("parentesis_izq\n"); }
{parentesis_der}	{ printf("parentesis_der\n"); }
{token_subprograma}	{ printf("token_subprograma\n"); }
{marca_ini_declar_variables}	{ printf("marca_ini_declar_variables\n"); }
{marca_fin_declar_variables}	{ printf("marca_fin_declar_variables\n"); }
{tipo}	{ printf("tipo\n"); }
{coma}	{ printf("coma\n"); }
{PYC}	{ printf("PYC\n"); }
{if}	{ printf("if\n"); }
{else}	{ printf("else\n"); }
{while}	{ printf("while\n"); }
{for}	{ printf("for\n"); }
{direccion_for}	{ printf("direccion_for\n"); }
{init_for}	{ printf("init_for\n"); }
{do}	{ printf("do\n"); }
{scanf}	{ printf("scanf\n"); }
{printf}	{ printf("printf\n"); }
{return}	{ printf("return\n"); }
{plus_minus}	{ printf("plus_minus\n"); }
{not}	{ printf("not\n"); }
{op_binario}	{ printf("op_binario\n"); }
{equals}	{ printf("equals\n"); }
{entero}	{ printf("entero\n"); }
{fl_bool_ch}	{ printf("fl_bool_ch\n"); }
{cadena}	{ printf("cadena\n"); }
{nombre}	{ printf("nombre\n"); }


%%

int main() {
	yylex();
}
