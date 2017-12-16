%{
  #include "tabla-simbolos.h"
  #include <string.h>
  // código C
  #define YYERROR_VERBOSE 1
  int yylex(void);
  void yyerror(const char *s);
  int yydebug = 0;
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

%left OP_OR
%left OP_AND
%left OP_EQ
%left OP_CMP
%left PLUS_MINUS
%left OP_MULT_MAT
%left OP_MULT
%right NOT
%right COMA

%start PROGRAMA


%%


PROGRAMA : CABECERA_PROGRAMA BLOQUE
  ;

BLOQUE :
    INICIO_DE_BLOQUE               { TS_insertar_marca(); }
    DECLARACION_VARIABLES_LOCALES
    DECLARACION_SUBPROGRAMAS
    SENTENCIAS
    FIN_DE_BLOQUE                  { TS_fin_bloque(); }
  ;

DECLARACION_VARIABLES_LOCALES :
    INICIO_DECLARACION_VARIABLES
    VARIABLES_LOCALES
    FIN_DECLARACION_VARIABLES
  |
  ;

VARIABLE_PYC : VARIABLE_LOCAL PYC
  | error
  ;

VARIABLES_LOCALES : VARIABLE_PYC VARIABLES_LOCALES
  | VARIABLE_LOCAL
  ;

VARIABLE_LOCAL : TIPO { tipoTmp = $1.tipo; } LISTA_IDENTIFICADOR
  | error
  ;

LISTA_IDENTIFICADOR : IDENTIFICADOR { TS_insertar_identificador($1); }
  | IDENTIFICADOR COMA LISTA_IDENTIFICADOR { TS_insertar_identificador($1); }
  | error
  ;

IDENTIFICADOR : NOMBRE {
              $$.dimensiones = 0;
              $$.dimension_1 = 0;
              $$.dimension_2 = 0;
  }
  | NOMBRE CORCHETE_IZQ DIMENSIONES CORCHETE_DER {
      $$.lexema = strdup($1.lexema);

      $$.dimensiones = $3.dimensiones;
      $$.dimension_1 = $3.dimension_1;
      $$.dimension_2 = $3.dimension_2;
    }
  ;

DIMENSIONES : NATURAL    {
            $$.dimensiones = 1;
            $$.dimension_1 = $1.atributo;
  }
  | NATURAL COMA NATURAL { $$.dimensiones = 2; $$.dimension_1 = $1.atributo; $$.dimension_2 = $3.atributo; }
  ;

DECLARACION_SUBPROGRAMAS : DECLARACION_SUBPROGRAMAS DECLARACION_SUBPROGRAMA
  |
  ;

DECLARACION_SUBPROGRAMA : CABECERA_SUBPROGRAMA BLOQUE
  ;

CABECERA_SUBPROGRAMA : TOKEN_SUBPROGRAMA
                       NOMBRE { TS_insertar_procedimiento($2); }
                       PARENTESIS_IZQ PARAMETROS_PROCEDIMIENTO PARENTESIS_DER
  ;

INICIO_DE_BLOQUE : LLAVE_IZQ
  ;

FIN_DE_BLOQUE : LLAVE_DER
  ;

PARAMETRO : TIPO IDENTIFICADOR { TS_insertar_parametro($2); }
  | error
  ;

LISTA_PARAMETROS : PARAMETRO
  | PARAMETRO COMA LISTA_PARAMETROS
  ;

PARAMETROS_PROCEDIMIENTO : LISTA_PARAMETROS
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

SENTENCIA_ASIGNACION : IDENTIFICADOR_EXPR EQUALS EXPR PYC {
  if(!igualdad_de_tipos_y_dimensiones($1, $3)){

      char mensaje[80];
      sprintf( mensaje, "error al intentar asignar tipo %d a un identificador de tipo %d.", $3.tipo, $1.tipo );
      yyerror( mensaje );
    }
}
  ;

SENTENCIA_IF : IF PARENTESIS_IZQ EXPR {
             if ($3.tipo != booleano) {
                TS_error_tipos("el tipo de la expresion dentro del si debe ser booleano");
                }
  } PARENTESIS_DER SENTENCIA SENTENCIA_ELSE

  ;

SENTENCIA_ELSE : ELSE SENTENCIA
  |
  ;

SENTENCIA_WHILE : WHILE PARENTESIS_IZQ EXPR {
             if ($3.tipo != booleano) {
                TS_error_tipos("el tipo de la expresion dentro del mientras debe ser booleano");
                }
  } PARENTESIS_DER SENTENCIA
  ;

SENTENCIA_FOR : FOR NOMBRE INIT_FOR EXPR {
              $2.tipo = entero;
              TS_insertar_identificador($2);
              assert_tipo($4, entero);
  } DIRECCION_FOR EXPR DO SENTENCIA
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

LLAMADA_PROCED : NOMBRE PARENTESIS_IZQ ARGUMENTOS_PROCEDIMIENTO PARENTESIS_DER PYC  {
      t_posicion pos = TS_encontrar_entrada($1.lexema);

      if(pos != -1){
        // éxitos
      } else {
        TS_error_referencia($1.lexema);
      }
}
  ;

EXPR : PARENTESIS_IZQ EXPR PARENTESIS_DER { $$ = $2; }
  | NOT EXPR {
        assert_tipo($2, booleano);
        $$.tipo = booleano;
  }
  | PLUS_MINUS EXPR {
    char mensaje[100];
    if (tipo_numerico($2)) {
      $$.tipo = $2.tipo;
    } else {
      sprintf(
              mensaje,
              "el operador %s no soporta el tipo '%d'",
              $1.lexema, $2.tipo
              );
      TS_error_tipos(mensaje);
    }
  }
  | EXPR PLUS_MINUS EXPR {
    if (tipo_numerico($1) && igualdad_de_tipos($1, $3)) {
       $$.tipo = $1.tipo;

       if ($1.dimensiones == 0) {
          $$.dimensiones = $3.dimensiones;
          $$.dimension_1 = $3.dimension_1;
          $$.dimension_2 = $3.dimension_2;
       } else {
          $$.dimensiones = $1.dimensiones;
          $$.dimension_1 = $1.dimension_1;
          $$.dimension_2 = $1.dimension_2;

          if ($3.dimensiones != 0) {
             if ($3.dimensiones != $1.dimensiones || $3.dimension_1 != $1.dimension_1 || $3.dimension_2 != $1.dimension_2) {
                yyerror("error de dimensiones en suma/resta");
             }
          }
       }
    } else {
     char mensaje[100];
      sprintf(
              mensaje,
              "el operador %d no soporta los tipos '%s' y '%d'",
              $1.tipo, $2.lexema, $3.tipo
              );
      TS_error_tipos(mensaje);
    }
  }
  | EXPR OP_OR EXPR {
         assert_tipo($1, booleano);
         assert_tipo($3, booleano);
         $$.tipo = booleano;
  }
  | EXPR OP_AND EXPR {
         assert_tipo($1, booleano);
         assert_tipo($3, booleano);
         $$.tipo = booleano;
  }
  | EXPR OP_EQ EXPR {
         if (igualdad_de_tipos($1, $3)) {
            $$.tipo = booleano;
         } else {
            TS_error_tipos("en una comparacion ambos elementos deben ser del mismo tipo");
         }
  }
  | EXPR OP_CMP EXPR {
         if (igualdad_de_tipos($1, $3) && tipo_numerico($1)) {
            $$.tipo = booleano;
         } else {
           TS_error_tipos("un operador de orden compara numeros del mismo tipo");
         }
  }
  | EXPR OP_MULT EXPR {
       if (igualdad_de_tipos($1, $3) && tipo_numerico($1)) {
            $$.tipo = $1.tipo;
         } else {
           TS_error_tipos("en una multiplicación/división intervienen números del mismo tipo");
         }
  }
  | EXPR OP_MULT_MAT EXPR   {
    if(tipo_numerico($1) && igualdad_de_tipos($1, $3)){
       if($1.dimensiones != 2 || $3.dimensiones != 2){
          TS_error_tipos("alguno de los operandos no es una matriz");
       } else {
          uint dimensionA1 = $1.dimension_1,
               dimensionA2 = $1.dimension_2,
               dimensionB1 = $3.dimension_1,
               dimensionB2 = $3.dimension_2;

          if (dimensionA2 != dimensionB1) {
             TS_error_dimensiones("las dimensiones de las matrices no son compatibles para su multiplicación");
          }

          $$.tipo = $1.tipo;
          $$.dimensiones = 2;
          $$.dimension_1 = dimensionA1;
          $$.dimension_2 = dimensionB2;
      }
   } else {
     TS_error_tipos("los tipos de los elementos de las matrices deben coincidir y ser numéricos.");
    }
  }
  | IDENTIFICADOR_EXPR
  | FL_BOOL_CH {
    char *lexema = $1.lexema;

    switch(lexema[0]) {
        case 'v': $$.tipo = booleano; break;
        case 'f': $$.tipo = booleano; break;
        case '\'': $$.tipo = caracter; break;
        default: $$.tipo = real;
    }
  }
  | NATURAL {
        $$.tipo = entero;
  }
  | VECTOR
  | error
  ;

IDENTIFICADOR_EXPR : NOMBRE {
                   asignar_identificador(&$$, $1.lexema);
  }
  | NOMBRE CORCHETE_IZQ EXPR CORCHETE_DER {
    asignar_identificador_array(&$$, $1.lexema);
  }
  | NOMBRE CORCHETE_IZQ EXPR COMA EXPR CORCHETE_DER
  ;

LISTA_IDENTIFICADOR_EXPR : IDENTIFICADOR_EXPR
  | IDENTIFICADOR_EXPR COMA LISTA_IDENTIFICADOR_EXPR
  ;

LISTA_EXPR : EXPR {
           if (definiendo_vector()) {
              comprueba_elemento($1);
           }
  } COMA LISTA_EXPR
  | EXPR { if (definiendo_vector()) { comprueba_elemento($1); } }
  ;

VECTOR : LLAVE_IZQ { inicia_vector(); }  LISTA_EXPR LLAVE_DER {
       TipoArray v = finaliza_vector();
       $$.tipo = v.tipoDato;
       $$.dimensiones = 1;
       $$.dimension_1 = v.dimension;
  }
  ;

%%

#include "tokenizador.c"

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
