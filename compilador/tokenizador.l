%{

%}


cabecera_programa    BIENVENIDO
llave_izq            \{
llave_der            \}
corchete_izq         \[
corchete_der         \]
parentesis_izq       \(
parentesis_der       \)
token_subprograma    procedimiento
tipo                 (booleano)|(entero)|(real)|(caracter)
coma                 ,
PYC                  ;
if                   si
else                 si_no
while                mientras
for                  para
direccion_for        (hasta)|(bajando_hasta)
init_for             :=
do                   hacer
scanf                captar
printf               imprimir
return               volver
plus_minus           \+|-
not                  !
op_or                \|\|
op_and               \&\&
op_eq                (==)|(!=)
op_cmp               <|>|(<=)|(>=)
op_mult_mat          (\*\*)
op_mult              \*|(\/)
equals               =
natural              [0-9]+
fl_bool_ch           ([0-9]*\.[0-9]+)|(\'[^\']\')|(verdadero)|(falso)
cadena               \"[^\"]*\"
nombre               [_a-zA-Z][_a-zA-Z0-9]*
inicio_declaracion_variables    sean?
fin_declaracion_variables       \.


%%

{inicio_declaracion_variables}    { return INICIO_DECLARACION_VARIABLES; }
{fin_declaracion_variables}       { return FIN_DECLARACION_VARIABLES; }
{cabecera_programa}    { return CABECERA_PROGRAMA; }
{llave_izq}            { return LLAVE_IZQ; }
{llave_der}            { return LLAVE_DER; }
{corchete_izq}         { return CORCHETE_IZQ; }
{corchete_der}         { return CORCHETE_DER; }
{parentesis_izq}       { return PARENTESIS_IZQ; }
{parentesis_der}       { return PARENTESIS_DER; }
{token_subprograma}    { return TOKEN_SUBPROGRAMA; }
{tipo}                 {
                         switch(yytext[0]) {
                           case 'b': yylval.tipo = booleano; break;
                           case 'c': yylval.tipo = caracter; break;
                           case 'e': yylval.tipo = entero; break;
                           case 'r': yylval.tipo = real; break;
                         }
                         return TIPO;
                       }
{coma}                 { return COMA; }
{PYC}                  { return PYC; }
{if}                   { return IF; }
{else}                 { return ELSE; }
{while}                { return WHILE; }
{for}                  { return FOR; }
{direccion_for}        {
                         switch(yytext[0]){
                           case 'b': yylval.atributo = 0; break;  // bajando_hasta
                           case 'h': yylval.atributo = 1; break;  // hasta
                         }
                         return DIRECCION_FOR;
                       }
{init_for}             { return INIT_FOR; }
{do}                   { return DO; }
{scanf}                { return SCANF; }
{printf}               { return PRINTF; }
{return}               { return RETURN; }
{plus_minus}           {
                         if(yytext[0] == '-'){
                           yylval.atributo = 1;
                         } else {
                            yylval.atributo = 0;
                         }
                         yylval.lexema = strdup(yytext);
                         return PLUS_MINUS;
                       }
{not}                  { return NOT; }
{op_or}                {
                         yylval.lexema = strdup(yytext);
                         return OP_OR;
                       }
{op_and}               {
                         yylval.lexema = strdup(yytext);
                         return OP_AND;
                       }
{op_eq}                {
                         if(yytext[0] == '!'){
                           yylval.atributo = 1;
                         } else{
                            yylval.atributo = 0;
                         }
                         yylval.lexema = strdup(yytext);
                         return OP_EQ;
                       }
{op_cmp}               {
                         if(strcmp(yytext, "<=") == 0){ yylval.atributo = 0; }
                         if(strcmp(yytext, "<") == 0){  yylval.atributo = 1; }
                         if(strcmp(yytext, ">=") == 0){ yylval.atributo = 2; }
                         if(strcmp(yytext, ">") == 0){  yylval.atributo = 3; }
                         yylval.lexema = strdup(yytext);
                         return OP_CMP;
                       }
{op_mult}              {
                         if(yytext[0] == '*'){
                           yylval.atributo = 0;
                         } else {
                            yylval.atributo = 1;
                         }
                         yylval.lexema = strdup(yytext);
                         return OP_MULT;
                       }
{op_mult_mat}          { return OP_MULT_MAT; }
{equals}               { return EQUALS; }
{natural}              { yylval.atributo = atoi(yytext);
                         yylval.lexema = yytext;
                         return NATURAL; }
{fl_bool_ch}           {
                       yylval.lexema = strdup(yytext);
                       return FL_BOOL_CH;
                       }
{cadena}               {
                         yylval.lexema = strdup(yytext);
                         return CADENA;
                       }
{nombre}               {
                       yylval.lexema = strdup(yytext);
                       return NOMBRE;
                       }
[\ \t]                 { }
[\n]                   { yylineno++; }
.                      {
    ERROR = 1;
    printf("Error léxico: %s no esperado en línea %d\n", yytext, yylineno );
}

%%
