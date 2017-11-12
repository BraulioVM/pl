%{
#include "gramatica.h"
%}


cabecera_programa             BIENVENIDO
llave_izq                     \{
llave_der                     \}
corchete_izq                  \[
corchete_der                  \]
parentesis_izq                \(
parentesis_der                \)
token_subprograma             procedimiento
marca_ini_declar_variables    sean?
marca_fin_declar_variables    \.
tipo                          (booleano)|(entero)|(real)|(caracter)
coma                          ,
PYC                           ;
if                            si
else                          si_no
while                         mientras
for                           para
direccion_for                 (hasta)|(bajando_hasta)
init_for                      :=
do                            hacer
scanf                         captar
printf                        imprimir
return                        volver
plus_minus                    \+|-
not                           !
op_binario                    \*|(\*\*)|\/|(&&)|(\|\|)|\^|>|<|(>=)|(<=)|(==)|(!=)
equals                        =
natural                       [0-9]+
fl_bool_ch                    ([0-9]*\.[0-9]+)|(\'[^\']\')|(verdadero)|(falso)
cadena                        \"[^\"]*\"
nombre                        [_a-zA-Z][_a-zA-Z0-9]*


%%


{cabecera_programa}             { return CABECERA_PROGRAMA; }
{llave_izq}                     { return LLAVE_IZQ; }
{llave_der}                     { return LLAVE_DER; }
{corchete_izq}                  { return CORCHETE_IZQ; }
{corchete_der}                  { return CORCHETE_DER; }
{parentesis_izq}                { return PARENTESIS_IZQ; }
{parentesis_der}                { return PARENTESIS_DER; }
{token_subprograma}             { return TOKEN_SUBPROGRAMA; }
{marca_ini_declar_variables}    { return MARCA_INI_DECLAR_VARIABLES; }
{marca_fin_declar_variables}    { return MARCA_FIN_DECLAR_VARIABLES; }
{tipo}                          { return TIPO; }
{coma}                          { return COMA; }
{PYC}                           { return PYC; }
{if}                            { return IF; }
{else}                          { return ELSE; }
{while}                         { return WHILE; }
{for}                           { return FOR; }
{direccion_for}                 { return DIRECCION_FOR; }
{init_for}                      { return INIT_FOR; }
{do}                            { return DO; }
{scanf}                         { return SCANF; }
{printf}                        { return PRINTF; }
{return}                        { return RETURN; }
{plus_minus}                    { return PLUS_MINUS; }
{not}                           { return NOT; }
{op_binario}                    { return OP_BINARIO; }
{equals}                        { return EQUALS; }
{natural}                       { return NATURAL; }
{fl_bool_ch}                    { return FL_BOOL_CH; }
{cadena}                        { return CADENA; }
{nombre}                        { return NOMBRE; }
[\ \t]                          { }
[\n]                            { }
.                               {
    printf("Error léxico: %s no esperado en línea %d\n", yytext, yylineno );
}


%%
