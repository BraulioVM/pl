#include "tabla-simbolos.h"


void TS_ififitsisits(){
  if(tabla.tope == MAX_TS_SIZE - 1){
    return 0;  //  BOOM
  }
}


bool TS_identificador_libre(char* identificador){
  uint curr = tabla.tope;
  while(tabla.pila[curr].tipoEntrada != marca){
    if((tabla.pila[curr].tipoEntrada == variable ||
        tabla.pila[curr].tipoEntrada == parametro_formal) &&
       strcmp(tabla.pila[curr].nombre, identificador) == 0){
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

  if(!TS_identificador_libre(identificador.lexema)){
    return 0;  // BOOM
  }

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


void TS_insertar_procedimiento(t_token procedimiento){
  TS_ififitsisits();

  Entrada proc = {
    procedimiento,           // tipoEntrada
    NA,                      // tipoDato
    procedimiento.lexema,    // nombre
    procedimiento.atributo,  // n_parametros
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
