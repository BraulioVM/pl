
%{
  // código C
%}

%token CABECERA_PROGRAMA
%token LLAVE_IZQ 
%token LLAVE_DER
%token CORCHETE_IZQ 
%token CORCHETE_DER
%token PARENTESIS_IZQ 
%token PARENTESIS_DER 
%token TOKEN_SUBPROGRAMA 
%token MARCA_INI_DECLAR_VARIABLES 
%token MARCA_FIN_DECLAR_VARIABLES 
%token TIPO 
%token NOMBRE 
%token COMA 
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
%token PLUS_MINUS 
%token NOT 
%token OP_UNARIO
%token OP_BINARIO 
%token EQUALS 
%token ENTERO 
%token FL_BOOL_CH 
%token CADENA 

%start PROGRAMA


%%


PROGRAMA : CABECERA_PROGRAMA BLOQUE
  ;
BLOQUE : INICIO_DE_BLOQUE DECLAR_DE_VARIABLES_LOCALES DECLAR_DE_SUBPROGS SENTENCIAS FIN_DE_BLOQUE
  ;

DECLAR_DE_SUBPROGS : DECLAR_DE_SUBPROGS DECLAR_SUBPROGS
  |  
  ;


DECLAR_SUBPROGS : CABECERA_SUBPROGRAMA BLOQUE
  ;
DECLAR_DE_VARIABLES_LOCALES : MARCA_INI_DECLAR_VARIABLES VARIABLES_LOCALES MARCA_FIN_DECLAR_VARIABLES
  ;


VARIABLES_LOCALES : VARIABLE_LOCAL ',' VARIABLES_LOCALES
  | VARIABLE_LOCAL
  ;
VARIABLE_LOCAL : TIPO LISTA_IDENTIFICADOR
  ;
LISTA_IDENTIFICADOR : IDENTIFICADOR
  | IDENTIFICADOR ',' LISTA_IDENTIFICADOR
  ;
IDENTIFICADOR : NOMBRE
  | NOMBRE CORCHETE_IZQ DIMENSIONES CORCHETE_DER
  ;
DIMENSIONES : ENTERO
  | ENTERO ',' ENTERO
  ;


CABECERA_SUBPROGRAMA : TOKEN_SUBPROGRAMA NOMBRE PARENTESIS_IZQ LISTA_PARAMETROS PARENTESIS_DER
  ;
INICIO_DE_BLOQUE : LLAVE_IZQ
  ;
FIN_DE_BLOQUE : LLAVE_DER
  ;

PARAMETRO : TIPO IDENTIFICADOR
  ;
LISTA_PARAMETROS : PARAMETRO
  | PARAMETRO ',' LISTA_PARAMETROS
  |
  ;

SENTENCIAS : SENTENCIAS SENTENCIA
  |  SENTENCIA
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
SENTENCIA_IF : "si" PARENTESIS_IZQ EXPR PARENTESIS_DER SENTENCIA SENTENCIA_ELSE
  ;
SENTENCIA_ELSE : "si_no" SENTENCIA
  |
  ;
SENTENCIA_WHILE : "mientras" PARENTESIS_IZQ EXPR PARENTESIS_DER SENTENCIA
  ;
SENTENCIA_FOR : "para" NOMBRE ":=" EXPR DIRECCION_FOR EXPR "hacer" SENTENCIA
  ;
SENTENCIA_ENTRADA : NOMB_ENTRADA LISTA_IDENTIFICADOR_EXPR PYC
  ;
NOMB_ENTRADA : "captar"
  ;
SENTENCIA_SALIDA : NOMB_SALIDA LISTA_EXPRESIONES_O_CADENA PYC
  ;
LISTA_EXPRESIONES_O_CADENA : EXPR_O_CADENA
  | EXPR_O_CADENA ',' LISTA_EXPRESIONES_O_CADENA
  ;


EXPR_O_CADENA : EXPR
  | CADENA
  ;
NOMB_SALIDA : "imprimir"
  ;
SENTENCIA_RETURN : "volver" PYC
  ;
LLAMADA_PROCED : NOMBRE PARENTESIS_IZQ LISTA_EXPR PARENTESIS_DER PYC
  ;

EXPR : PARENTESIS_IZQ EXPR PARENTESIS_DER
         | OP_UNARIO EXPR
         | EXPR OP_BINARIO EXPR
         | IDENTIFICADOR_EXPR
         | FL_BOOL_CH
         | VECTOR      
         | MATRIZ       
  ;

IDENTIFICADOR_EXPR : NOMBRE
  | NOMBRE CORCHETE_IZQ EXPR CORCHETE_DER
  | NOMBRE CORCHETE_IZQ EXPR ',' EXPR CORCHETE_DER
  ;
LISTA_IDENTIFICADOR_EXPR : IDENTIFICADOR_EXPR
  | IDENTIFICADOR_EXPR ','
  | LISTA_IDENTIFICADOR_EXPR
  ;

LISTA_EXPR : EXPR ',' LISTA_EXPR
  | EXPR
  |
  ;
VECTOR : LLAVE_IZQ LISTA_EXPR LLAVE_DER
  ;
LISTA_VECTORES : VECTOR 
    | VECTOR ',' LISTA_VECTORES
  ;
MATRIZ : LLAVE_IZQ LISTA_VECTORES LLAVE_DER
  ;


%%


#include "lexyy.c"
#include "error.y"


main(){
  
  yyparse();


/* 

Qué hay que arreglar por ahora:

  54: CABECERA_SUBPROG es lo mismo que TOKEN_SUBPROGRAMA?
  76: de dónde sale PROCEDIMIENTO?
  138: dígito, letra, caracter, alfanum
  161: booleano
  145: OP_UNARIO used but not token nor rules
  166: real, natural

*/

}

