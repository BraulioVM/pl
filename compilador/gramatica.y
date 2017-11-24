%{
  #include "tokenizador.c"
  // código C
  #define YYERROR_VERBOSE 1
  void yyerror(const char *s);
  // int yydebug = 1;
%}

%token CABECERA_PROGRAMA
%token LLAVE_IZQ
%token LLAVE_DER
%token CORCHETE_IZQ
%token CORCHETE_DER
%token PARENTESIS_IZQ
%token PARENTESIS_DER
%token TOKEN_SUBPROGRAMA
%token INICIO_DECLARACION_VARIABLES
%token FIN_DECLARACION_VARIABLES
%token TIPO
%token NOMBRE
%token PYC
%token IF
%token ELSE
%token WHILE
%token FOR
%token DIRECCION_FOR
%token INIT_FOR
%token DO
%token SCANF
%token PRINTF
%token RETURN
%token EQUALS
%token NATURAL
%token FL_BOOL_CH
%token CADENA

%left PLUS_MINUS
%left OP_BINARIO
%left NOT
%right COMA

%start PROGRAMA


%%


PROGRAMA : CABECERA_PROGRAMA BLOQUE
  ;

BLOQUE :
    INICIO_DE_BLOQUE
    DECLARACION_VARIABLES_LOCALES
    DECLARACION_SUBPROGRAMAS
    SENTENCIAS
    FIN_DE_BLOQUE
  ;

DECLARACION_VARIABLES_LOCALES :
    INICIO_DECLARACION_VARIABLES
    VARIABLES_LOCALES
    FIN_DECLARACION_VARIABLES
  |
  ;

VARIABLES_LOCALES : VARIABLE_LOCAL PYC VARIABLES_LOCALES
  | VARIABLE_LOCAL
  |
  | VARIABLE_LOCAL error PYC VARIABLES_LOCALES { yyerrok; }
  ;

VARIABLE_LOCAL : TIPO LISTA_IDENTIFICADOR
  ;

LISTA_IDENTIFICADOR : IDENTIFICADOR
  | IDENTIFICADOR COMA LISTA_IDENTIFICADOR
  ;

IDENTIFICADOR : NOMBRE
  | NOMBRE CORCHETE_IZQ DIMENSIONES CORCHETE_DER
  ;

DIMENSIONES : NATURAL
  | NATURAL COMA NATURAL
  ;

DECLARACION_SUBPROGRAMAS : DECLARACION_SUBPROGRAMAS DECLARACION_SUBPROGRAMA
  |
;

DECLARACION_SUBPROGRAMA : CABECERA_SUBPROGRAMA BLOQUE
;

CABECERA_SUBPROGRAMA :
    TOKEN_SUBPROGRAMA NOMBRE PARENTESIS_IZQ LISTA_PARAMETROS PARENTESIS_DER
;

INICIO_DE_BLOQUE : LLAVE_IZQ
  ;

FIN_DE_BLOQUE : LLAVE_DER
  ;

PARAMETRO : TIPO IDENTIFICADOR
  ;

LISTA_PARAMETROS : PARAMETRO
  | PARAMETRO COMA LISTA_PARAMETROS
  |
  ;

SENTENCIAS : SENTENCIAS SENTENCIA
  |
  ;

SENTENCIA : BLOQUE
  | SENTENCIA_ASIGNACION
  | SENTENCIA_IF
  | SENTENCIA_WHILE
  | SENTENCIA_ENTRADA
  | SENTENCIA_SALIDA
  | LLAMADA_PROCED
  | SENTENCIA_FOR
  | SENTENCIA_RETURN
  ;

SENTENCIA_ASIGNACION : IDENTIFICADOR_EXPR EQUALS EXPR PYC
  ;

SENTENCIA_IF : IF PARENTESIS_IZQ EXPR PARENTESIS_DER SENTENCIA SENTENCIA_ELSE
  ;

SENTENCIA_ELSE : ELSE SENTENCIA
  |
  ;

SENTENCIA_WHILE : WHILE PARENTESIS_IZQ EXPR PARENTESIS_DER SENTENCIA
  ;

SENTENCIA_FOR : FOR NOMBRE INIT_FOR EXPR DIRECCION_FOR EXPR DO SENTENCIA
  ;

SENTENCIA_ENTRADA : SCANF LISTA_IDENTIFICADOR_EXPR PYC
  ;

SENTENCIA_SALIDA : PRINTF LISTA_EXPRESIONES_O_CADENA PYC
  ;

LISTA_EXPRESIONES_O_CADENA : EXPR_O_CADENA
  | EXPR_O_CADENA COMA LISTA_EXPRESIONES_O_CADENA
  ;

EXPR_O_CADENA : EXPR
  | CADENA
  ;

SENTENCIA_RETURN : RETURN PYC
  ;

ARGUMENTOS_PROCEDIMIENTO : LISTA_EXPR
  |
  ;

LLAMADA_PROCED : NOMBRE PARENTESIS_IZQ ARGUMENTOS_PROCEDIMIENTO PARENTESIS_DER PYC
  ;

EXPR : PARENTESIS_IZQ EXPR PARENTESIS_DER
         | NOT EXPR
         | PLUS_MINUS EXPR
         | EXPR PLUS_MINUS EXPR
         | EXPR OP_BINARIO EXPR
         | IDENTIFICADOR_EXPR
         | FL_BOOL_CH
         | NATURAL
         | VECTOR
  ;

IDENTIFICADOR_EXPR : NOMBRE
  | NOMBRE CORCHETE_IZQ EXPR CORCHETE_DER
  | NOMBRE CORCHETE_IZQ EXPR COMA EXPR CORCHETE_DER
  ;

LISTA_IDENTIFICADOR_EXPR : IDENTIFICADOR_EXPR
  | IDENTIFICADOR_EXPR COMA LISTA_IDENTIFICADOR_EXPR
  ;

LISTA_EXPR : EXPR COMA LISTA_EXPR
  | EXPR
  ;

VECTOR : LLAVE_IZQ LISTA_EXPR LLAVE_DER
  ;

%%

void yyerror(const char *s) {
    printf(
           "Yacc error at line %d: %s. Unexpected \"%s\"\n",
           yylineno,
           s,
           yytext);
}

int main(){
  yyparse();
}
