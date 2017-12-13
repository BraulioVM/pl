#include <stdio.h>
#include <string.h>
#include "tabla-simbolos.h"

#define true 1
#define false 0

int TS_ififitsisits(){
  return tabla.tope < MAX_TS_SIZE - 1;
}


bool TS_identificador_libre(char* identificador){

  t_posicion curr = tabla.tope;

  while(tabla.pila[curr].tipoEntrada != marca){
    if(tabla.pila[curr].tipoEntrada == variable &&
       strcmp(tabla.pila[curr].nombre, identificador) == 0){
      return false;
    }

    --curr;
  }

  --curr;  // es una marca

  while(tabla.pila[curr].tipoEntrada == parametro_formal){
    /* Estamos en el bloque de un subprograma/procedimiento,
     * por lo que debemos comprobar también en sus parámetros formales
     */
    if(strcmp(tabla.pila[curr].nombre, identificador) == 0){
      return false;
    }

    --curr;
  }

  return true;
};


void TS_insertar_entrada(Entrada item){
  tabla.pila[++tabla.tope] = item;
}


void TS_insertar_marca(){
  if(TS_ififitsisits()){
    Entrada item = {
      marca,  // tipoEntrada
      NA,     // tipoDato
      NULL,   // nombre
      0,      // n_parametros
      0,      // dimensiones
      0,      // dimension_1
      0,      // dimension_2
    };

    TS_insertar_entrada(item);
  } else {
    TS_nofits();
  }
}


void TS_insertar_identificador(t_token identificador){
  if(TS_ififitsisits()){
    if(TS_identificador_libre(identificador.lexema)) {
      Entrada ident = {
        variable,              // tipoEntrada
        tipoTmp,               // tipoDato
        identificador.lexema,  // nombre
        0,                     // n_parametros
        0,                     // dimensiones
        0,                     // dimension_1
        0,                     // dimension_2
      };

      TS_insertar_entrada(ident);
    } else {
      yyerror(
             "Error semántico: redeclaración de la variable %s"
             );
    }
  } else {
    TS_nofits();
  }
}


void TS_insertar_procedimiento(t_token procedimiento_){
  if(TS_ififitsisits()){
    Entrada proc = {
      procedimiento,          // tipoEntrada
      NA,                     // tipoDato
      procedimiento_.lexema,  // nombre
      0,                      // n_parametros
      0,                      // dimensiones
      0,                      // dimension_1
      0,                      // dimension_2
    };

    TS_insertar_entrada(proc);
  } else {
    TS_nofits();
  }
}


void TS_insertar_parametro(t_token parametro){
  if (TS_ififitsisits()){
    Entrada param = {
      parametro_formal,  // tipoEntrada
      parametro.tipo,    // tipoDato
      parametro.lexema,  // nombre
      0,                 // n_parametros
      0,                 // dimensiones
      0,                 // dimension_1
      0,                 // dimension_2
    };

    TS_insertar_entrada(param);

    t_posicion proc = TS_ultimo_procedimiento();
    tabla.pila[proc].n_parametros += 1;  // incrementa el número de params
  } else {
    TS_nofits();
  }
}


void TS_nofits(){

  // Informe de error somehow
}


void TS_fin_bloque(){
  tabla.tope = TS_ultima_marca();
  while(tabla.pila[--tabla.tope].tipoEntrada == parametro_formal);
}


void TS_dimension_vector(t_token dimension){
  tabla.pila[tabla.tope].dimensiones = 1;
  tabla.pila[tabla.tope].dimension_1 = dimension.atributo;
}


void TS_dimension_matriz( t_token dimension_1, t_token dimension_2 ){
  tabla.pila[ tabla.tope ].dimensiones = 2;
  tabla.pila[ tabla.tope ].dimension_1 = dimension_1.atributo;
  tabla.pila[ tabla.tope ].dimension_2 = dimension_2.atributo;
}


void assert_tipo(t_token token, t_dato tipo) {
  if (token.tipo != tipo) {
    yyerror("Error semántico: tipos incorrectos");
  }
}


void asignar_identificador(t_token *token, char *identificador) {
  uint identificadorEncontrado = false;
  int indicePila;
  for (indicePila = tabla.tope; indicePila >= 0; indicePila--) {

    if (tabla.pila[indicePila].tipoEntrada == variable &&
        strcmp(tabla.pila[indicePila].nombre, identificador) == 0) {

      identificadorEncontrado = true;
      break;
    }
  }

  if (!identificadorEncontrado) {
    yyerror("Identificador no encontrado");
  } else {
    token->tipo = tabla.pila[indicePila].tipoDato;
    token->lexema = tabla.pila[indicePila].nombre;
  }
}


t_posicion TS_ultima_marca(){
  t_posicion curr = tabla.tope + 1;
  while(tabla.pila[--curr].tipoEntrada != marca);
  return curr;
}


t_posicion TS_ultimo_procedimiento(){
  t_posicion curr = tabla.tope + 1;
  while(tabla.pila[--curr].tipoEntrada != procedimiento);
  return curr;
}


bool tipo_numerico(t_token t){
  return t.tipo == real || t.tipo == entero;
}


bool igualdad_de_tipos(t_token t1, t_token t2){
  return t1.tipo == t2.tipo;
}
