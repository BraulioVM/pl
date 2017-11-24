#include "tabla-simbolos.h"

void TS_insertar_marca(){
  if(tabla.tope == MAX_TS_SIZE){
    return 0; //  BOOM
  }

  Entrada ident = {
    pass
  };

  tabla.pila[tope++] = 0;
}
