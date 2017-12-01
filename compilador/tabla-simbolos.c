#include <stdio.h>
#include <string.h>
#include "tabla-simbolos.h"

#define true 1
#define false 0
void TS_ififitsisits(){
  if(tabla.tope == MAX_TS_SIZE - 1){

  }
}


void TS_identificador_libre(char* identificador){
  uint curr = tabla.tope;
  while(tabla.pila[curr].tipoEntrada != marca){
    if((tabla.pila[curr].tipoEntrada == variable ||
        tabla.pila[curr].tipoEntrada == parametro_formal) &&
       strcmp(tabla.pila[curr].nombre, identificador) == 0){
    }

    --curr;
  }

};


void TS_insertar_entrada(Entrada item){
  tabla.pila[++tabla.tope] = item;
}


void TS_insertar_marca(){
  TS_ififitsisits();

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
}


void TS_insertar_identificador(t_token identificador){
  TS_ififitsisits();

  /* if(!TS_identificador_libre(identificador.lexema)){ */
  /* } */

  Entrada ident = {
    variable,              // tipoEntrada
    identificador.tipo,    // tipoDato
    identificador.lexema,  // nombre
    0,                     // n_parametros
    0,                     // dimensiones
    0,                     // dimension_1
    0,                     // dimension_2
  };

  TS_insertar_entrada(ident);
}


void TS_insertar_procedimiento(t_token procedimiento_){
  TS_ififitsisits();

  Entrada proc = {
    .tipoEntrada = procedimiento,           // tipoEntrada
    NA,                      // tipoDato
    procedimiento_.lexema,    // nombre
    procedimiento_.atributo,  // n_parametros
    0,                       // dimensiones
    0,                       // dimension_1
    0,                       // dimension_2
  };

  TS_insertar_entrada(proc);
}


void TS_insertar_parametro(t_token parametro){
  TS_ififitsisits();

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
}


void TS_fin_bloque(){
  while(tabla.pila[tabla.tope--].tipoEntrada != marca);
  --tabla.tope;  // elimina también la marca
}
