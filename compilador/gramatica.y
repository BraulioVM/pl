%{
  #include "tabla-simbolos.h"
  #include "generacion-codigo.h"
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


PROGRAMA : CABECERA_PROGRAMA BLOQUE {
         iniciarCodigo(&$$);
         $$.codigoSint[0] = 0;
         inicioDePrograma(&$$);
         strcat($$.codigoSint, $2.codigoSint);
         printf("%s", $$.codigoSint);
         finDePrograma();
  }
  ;

BLOQUE :
    INICIO_DE_BLOQUE {
                      TS_insertar_marca();
    }
    DECLARACION_VARIABLES_LOCALES 
    DECLARACION_SUBPROGRAMAS
    SENTENCIAS
    FIN_DE_BLOQUE                  { TS_fin_bloque(); 
                                   iniciarCodigo(&$$);
                                   strcpy($$.codigoSint, "{\n");
                                   strcat($$.codigoSint, $3.codigoSint);
                                   strcat($$.codigoSint, $5.codigoSint);
                                   strcat($$.codigoSint, "}\n");
    }
  ;

DECLARACION_VARIABLES_LOCALES :
    INICIO_DECLARACION_VARIABLES { declarandoVariables = true; }
    VARIABLES_LOCALES
    FIN_DECLARACION_VARIABLES {
                              declarandoVariables = false;
                              $$.codigoSint = $3.codigoSint;
  } 
  | { $$.codigoSint = ""; }
  ;

VARIABLE_PYC : VARIABLE_LOCAL PYC { $$.codigoSint = $1.codigoSint; }
  | error
  ;

VARIABLES_LOCALES : VARIABLE_PYC VARIABLES_LOCALES {
                  iniciarCodigo(&$$);
                  strcpy($$.codigoSint, $1.codigoSint);
                  strcat($$.codigoSint, $2.codigoSint);
  } | VARIABLE_LOCAL
  ;

VARIABLE_LOCAL : TIPO { tipoTmp = $1.tipo; } LISTA_IDENTIFICADOR {
               $$.codigoSint = $3.codigoSint;
  }
  | error
  ;

LISTA_IDENTIFICADOR : IDENTIFICADOR {
                    TS_insertar_identificador($1);
                    
                    if (declarandoVariables) {
                       iniciarCodigo(&$$);
                       char tipo[10], codigo[500];
                       tipoC(tipo, tipoTmp);
                       sprintf(codigo, "%s %s;\n", tipo, $1.lexema);
                       $$.codigoSint = strdup(codigo);
                    }
  }
  | IDENTIFICADOR COMA LISTA_IDENTIFICADOR {
    TS_insertar_identificador($1);
    iniciarCodigo(&$$);
    if (declarandoVariables) {
       char tipo[10], codigo[500];
       tipoC(tipo, tipoTmp);
       sprintf(codigo, "%s %s;\n", tipo, $1.lexema);
       strcpy($$.codigoSint, codigo);
       strcat($$.codigoSint, $3.codigoSint);
    }
  }
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

DECLARACION_SUBPROGRAMA : CABECERA_SUBPROGRAMA BLOQUE {

  }
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

SENTENCIAS : SENTENCIAS SENTENCIA {
           iniciarCodigo(&$$);
           strcpy($$.codigoSint, $1.codigoSint);
           strcat($$.codigoSint, "\n");
           strcat($$.codigoSint, $2.codigoSint);
  }
  | { $$.codigoSint = strdup(""); }
  ;

SENTENCIA : BLOQUE
  | SENTENCIA_ASIGNACION 
  | SENTENCIA_IF { $$.codigoSint = strdup(""); }
  | SENTENCIA_WHILE { $$.codigoSint = strdup(""); }
  | SENTENCIA_ENTRADA { $$.codigoSint = strdup(""); }
  | SENTENCIA_SALIDA
  | LLAMADA_PROCED { $$.codigoSint = strdup(""); }
  | SENTENCIA_FOR { $$.codigoSint = strdup(""); }
  | SENTENCIA_RETURN { $$.codigoSint = strdup(""); }
  ;

SENTENCIA_ASIGNACION : IDENTIFICADOR_EXPR  { iniciarAsignacion(); } EQUALS EXPR PYC {
  // parece ser que $4 tiene el valor que esperaria en $3 aqui
  // y $3 tiene un valor que no se
  // de donde viene no se por que (por ahora funciona)
  if(!igualdad_de_tipos_y_dimensiones($1, $4)){
      char mensaje[80];
      sprintf( mensaje, "error al intentar asignar tipo %d a un identificador de tipo %d.", $4.tipo, $1.tipo );
      yyerror( mensaje );
    } else {
      asignarNombre($1.lexema);
      iniciarCodigo(&$$);
      strcpy($$.codigoSint, "{\n");
      generarAsignacion(&$$); // no se por que funciona
                                        // con $4 y no con $3
                                        // debe ser alguna movida de
                                        // manejo de la memoria

      char codigoO[10000];
      sprintf(codigoO, "%s = %s;\n", $1.nombreSint, $4.nombreSint);
      strcat($$.codigoSint, codigoO);
      strcat($$.codigoSint, "}\n");
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

SENTENCIA_SALIDA : PRINTF { iniciarSalida(); iniciarAsignacion(); } LISTA_EXPRESIONES_O_CADENA PYC {
                 iniciarCodigo(&$$);
                 strcpy($$.codigoSint, "{\n");

                 generarAsignacion(&$$);
                 imprimePrintf(&$$);

                 strcat($$.codigoSint, "}\n");
  }
  ;

LISTA_EXPRESIONES_O_CADENA : EXPR_O_CADENA
  | EXPR_O_CADENA COMA LISTA_EXPRESIONES_O_CADENA
  ;

EXPR_O_CADENA : EXPR { addVariable($1); }
  | CADENA { addCadena($1.lexema); }
  ;

SENTENCIA_RETURN : RETURN PYC
  ;

ARGUMENTOS_PROCEDIMIENTO : LISTA_EXPR
  |
  ;

LLAMADA_PROCED : NOMBRE PARENTESIS_IZQ {
    TS_iniciar_llamada($1.lexema);
  } ARGUMENTOS_PROCEDIMIENTO PARENTESIS_DER {
    TS_finalizar_llamada();
  } PYC
  ;

EXPR : PARENTESIS_IZQ EXPR PARENTESIS_DER { $$ = $2; }
  | NOT EXPR {
        assert_tipo($2, booleano);
        $$.tipo = booleano;

        char *tempVar = temporal();
        char instruccion[80];
        sprintf(instruccion, "!%s", $2.nombreSint);
        addInstruccion("bool", tempVar, instruccion);
        $$.nombreSint = tempVar;
  }
  | PLUS_MINUS EXPR {
    char mensaje[100];
    if (tipo_numerico($2)) {
      $$.tipo = $2.tipo;

      char *tempVar = temporal();
      char instruccion[80];
      char tipo[80];

      tipoC(tipo, $$.tipo);

      if ($1.atributo == 1) { // si es un menos
         sprintf(instruccion, "-%s", $2.nombreSint);
      } else {
        sprintf(instruccion, "+%s", $2.nombreSint);
      }

      addInstruccion(tipo, tempVar, instruccion);
      $$.nombreSint = tempVar;

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

          if ($2.atributo == 1) {
            generarOperacionBasica(&$$, "-", $1, $3);
          } else {
            generarOperacionBasica(&$$, "+", $1, $3);
          }
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

         generarOperacionBasica(&$$, "||", $1, $3);

  }
  | EXPR OP_AND EXPR {
         assert_tipo($1, booleano);
         assert_tipo($3, booleano);
         $$.tipo = booleano;

         generarOperacionBasica(&$$, "&&", $1, $3);
  }
  | EXPR OP_EQ EXPR {
         if (igualdad_de_tipos($1, $3)) {
            $$.tipo = booleano;

            if ($2.atributo == 1) {
               generarOperacionBasicaConTipo(&$$, "bool", "!=", $1, $3);
            } else {
               generarOperacionBasicaConTipo(&$$, "bool", "==", $1, $3);
            }

         } else {
            TS_error_tipos("en una comparacion ambos elementos deben ser del mismo tipo");
         }
  }
  | EXPR OP_CMP EXPR {
         if (igualdad_de_tipos($1, $3) && tipo_numerico($1)) {
            $$.tipo = booleano;

            switch ($2.atributo) {
            case 0:
                 generarOperacionBasicaConTipo(&$$, "bool", "<=", $1, $3);
                 break;
            case 1:
                 generarOperacionBasicaConTipo(&$$, "bool", "<", $1, $3);
                 break;
            case 2:
                 generarOperacionBasicaConTipo(&$$, "bool", ">=", $1, $3);
                 break;
            case 3:
                 generarOperacionBasicaConTipo(&$$, "bool", ">", $1, $3);
                 break;
            }


         } else {
           TS_error_tipos("un operador de orden compara numeros del mismo tipo");
         }
  }
  | EXPR OP_MULT EXPR {
       if (igualdad_de_tipos($1, $3) && tipo_numerico($1)) {
            $$.tipo = $1.tipo;
            char op[1];
            if ($2.atributo == 0) {
               op[0] = '*'; op[1] = 0;
            } else { op[0] = '/'; op[1] = 0; }
            generarOperacionBasica(&$$, op, $1, $3);
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

    $$.nombreSint = $1.lexema;
    switch(lexema[0]) {
        case 'v': $$.tipo = booleano; break;
        case 'f': $$.tipo = booleano; break;
        case '\'': $$.tipo = caracter; break;
        default: $$.tipo = real;
    }
  }
  | NATURAL {
        $$.tipo = entero;
        $$.nombreSint = strdup($1.lexema);
  }
  | VECTOR
  | error
  ;

IDENTIFICADOR_EXPR : NOMBRE {
    $$.nombreSint = $1.lexema;
    asignar_identificador(&$$, $1.lexema);
  }
  | NOMBRE CORCHETE_IZQ EXPR CORCHETE_DER {
    asignar_identificador_array(&$$, $1.lexema);
  }
  | NOMBRE CORCHETE_IZQ EXPR COMA EXPR CORCHETE_DER {
    asignar_identificador_matriz(&$$, $1.lexema);
  }
  ;

LISTA_IDENTIFICADOR_EXPR : IDENTIFICADOR_EXPR
  | IDENTIFICADOR_EXPR COMA LISTA_IDENTIFICADOR_EXPR
  ;

LISTA_EXPR : EXPR COMA LISTA_EXPR {
    if(definiendo_vector()){
      comprueba_elemento($1);
    } else if(llamando_procedimiento){
      TS_comprobar_parametro($1);
    }
  }
  | EXPR {
    if(definiendo_vector()){
      comprueba_elemento($1);
    } else if(llamando_procedimiento){
      TS_comprobar_parametro($1);
    }
  }
  ;

VECTOR : LLAVE_IZQ { inicia_vector(); } LISTA_EXPR LLAVE_DER {
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
