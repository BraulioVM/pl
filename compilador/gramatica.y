%{
  #include "tabla-simbolos.h"
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

IDENTIFICADOR : NOMBRE
  | NOMBRE CORCHETE_IZQ DIMENSIONES CORCHETE_DER {
      $$.lexema = strdup($1.lexema);
    }
  ;

DIMENSIONES : NATURAL    { TS_dimension_vector($1); }
  | NATURAL COMA NATURAL { TS_dimension_matriz($1, $3); }
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
  if(!igualdad_de_tipos($1, $3)){

      char * mensaje;
      sprintf( mensaje, "Error al intentar asignar tipo %s a un identificador de tipo %s.", $3.tipo, $1.tipo );
      yyerror( mensaje );
    }
}
  ;

SENTENCIA_IF : IF PARENTESIS_IZQ EXPR {
             if ($3.tipo != booleano) {
                yyerror("el tipo de la expresion dentro del si debe ser booleano");
                }
  } PARENTESIS_DER SENTENCIA SENTENCIA_ELSE

  ;

SENTENCIA_ELSE : ELSE SENTENCIA
  |
  ;

SENTENCIA_WHILE : WHILE PARENTESIS_IZQ EXPR {
             if ($3.tipo != booleano) {
                yyerror("el tipo de la expresion dentro del mientras debe ser booleano");
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
  
      Entrada entrada= buscar_en_tabla( $1.lexema );

      if ( strcmp( entrada.nombre, nombre_no_valido ) != 0 ){

      }
      else{
        char * mensaje;
        sprintf( mensaje, "Procedimiento %s no definido.", entrada.nombre );
        yyerror( mensaje );
      }
}
  ;

EXPR : PARENTESIS_IZQ EXPR PARENTESIS_DER { $$ = $2; }
  | NOT EXPR {
        assert_tipo($2, booleano);
        $$.tipo = booleano;
  }
  | PLUS_MINUS EXPR {
    if (tipo_numerico($2)) {
       $$.tipo = $2.tipo;
    } else {
      yyerror("error de tipos +/- debe ser usado con un numero");
    }
  }
  | EXPR PLUS_MINUS EXPR {
    if (tipo_numerico($1) && igualdad_de_tipos($1, $3)) {
       $$.tipo = $1.tipo;
    } else {
      yyerror("error de tipos +/- debe ser usado con numeros del mismo tipo");
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
            yyerror("en una comparacion ambos elementos deben ser del mismo tipo");
         }
  }
  | EXPR OP_CMP EXPR {
         if (igualdad_de_tipos($1, $3) && tipo_numerico($1)) {
            $$.tipo = booleano;
         } else {
           yyerror("un operador de orden compara numeros del mismo tipo");
         }
  }
  | EXPR OP_MULT EXPR {
       if (igualdad_de_tipos($1, $3) && tipo_numerico($1)) {
            $$.tipo = $1.tipo;
         } else {
           yyerror("en una multiplicación/división intervienen números del mismo tipo");
         }
  }
  | EXPR OP_MULT_MAT EXPR   {

        if ( igualdad_de_tipos( $1, $3 ) ){

          Entrada matriz_1 = buscar_en_tabla( $1.lexema );
          Entrada matriz_2 = buscar_en_tabla( $3.lexema );

          if ( matriz_1.dimension_2 == matriz_2.dimension_1 ){

            $$.tipo = $1.tipo;

          }
          else{
            yyerror( "Las dimensiones de las matrices no son compatibles para su multiplicación. Debe especificarse una matriz de orden m*n y otra de orden n*p." );
          }

        }
        else{
          yyerror( "Los tipos de los elementos de las matrices deben coincidir." );
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
  | NOMBRE CORCHETE_IZQ EXPR CORCHETE_DER
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
       $$.dimension = v.dimension;
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
