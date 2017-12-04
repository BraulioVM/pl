#include <stdio.h>
#include <string.h>
#include "tabla-simbolos.h"

#define true 1
#define false 0

int TS_ififitsisits(){

  return ! ( tabla.tope == MAX_TS_SIZE - 1 );
}


int TS_identificador_libre(char* identificador){

  uint curr = tabla.tope;

  // Buscar la variable dentro del bloque
  while ( tabla.pila[curr].tipoEntrada != marca ){

    if ( tabla.pila[curr].tipoEntrada == variable &&
        strcmp( tabla.pila[curr].nombre, identificador ) == 0 ){
      return false;
    }

    --curr;
  }

  // Buscarla en los parámetros formales, por encima de la marca
  while ( tabla.pila[curr].tipoEntrada != procedimiento ){

    if ( tabla.pila[curr].tipoEntrada == parametro_formal &&
        strcmp( tabla.pila[curr].nombre, identificador ) == 0 ){
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

  if ( TS_ififitsisits() ){

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
  else{
    TS_nofits();
  }
}


void TS_insertar_identificador(t_token identificador){
  
  if ( TS_ififitsisits() ){

    Entrada ident = {
      variable,              // tipoEntrada
      tipoTmp,    // tipoDato
      identificador.lexema,  // nombre
      0,                     // n_parametros
      0,                     // dimensiones
      0,                     // dimension_1
      0,                     // dimension_2
    };

    TS_insertar_entrada(ident);
  }
  else{
    TS_nofits();
  }
}


void TS_insertar_procedimiento(t_token procedimiento_){

  if ( TS_ififitsisits() ){

    Entrada proc = {
      .tipoEntrada = procedimiento,           // tipoEntrada
      procedimiento_.tipo,                      // tipoDato
      procedimiento_.lexema,    // nombre
      procedimiento_.atributo,  // n_parametros
      0,                       // dimensiones
      0,                       // dimension_1
      0,                       // dimension_2
    };

    TS_insertar_entrada(proc);
  }
  else{
    TS_nofits();
  }
}


void TS_insertar_parametro(t_token parametro){
  
  if ( TS_ififitsisits() ){

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
  else{
    TS_nofits();
  }
}


void TS_nofits(){

  // Informe de error somehow
}


void TS_fin_bloque(){

  while ( tabla.pila[ tabla.tope-- ].tipoEntrada != marca );
}


void TS_dimension_vector( t_token dimension ){

  tabla.pila[ tabla.tope ].dimensiones = 1;
  tabla.pila[ tabla.tope ].dimension_1 = dimension.atributo;
}


void TS_dimension_matriz( t_token dimension_1, t_token dimension_2 ){

  tabla.pila[ tabla.tope ].dimensiones = 2;
  tabla.pila[ tabla.tope ].dimension_1 = dimension_1.atributo;
  tabla.pila[ tabla.tope ].dimension_2 = dimension_2.atributo;
}
