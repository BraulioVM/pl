cabecera_programa	BIENVENIDO
llave_izq	{
llave_der	}
corchete_izq	[
corchete_der	]
parentesis_izq	(
parentesis_der 	)
token_subprograma	procedimiento
marca_ini_declar_variables	sean
marca_fin_declar_variables	.
tipo	(booleano)|(entero)|(real)|(caracter)
nombre	[_a-zA-Z][_a-zA-Z0-9]*
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
plus_minus	+|-
not	!
op_binario	\*|(\*\*)|\/|(&&)|(\|\|)|\^|>|<|(>=)|(<=)|(==)|(!=)
equals	=
entero	[0-9]+
fl_bool_ch	([0-9]+(.[0-9]+)?)|(\’[^\’]\’)|(true)|(false)
cadena	\”[^\”]*\”


%%



{cabecera_programa}				
{llave_izq}
{llave_der}
{corchete_izq}
{corchete_der}
{parentesis_izq}
{parentesis_der}
{token_subprograma}
{marca_ini_declar_variables}
{marca_fin_declar_variables}
{tipo}
{nombre}
{coma}
{PYC}
{if}
{else}
{while}
{for}
{direccion_for}
{init_for}
{do}
{scanf}
{printf}
{return}
{plus_minus}
{not}
{op_binario}
{equals}
{entero}
{fl_bool_ch}
{cadena}


