#include "generacion-codigo.h"
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

int tempVarIndex = 0;
int tempEtiquetaIndex = 0;

char *temporal() {
  char *buffer = malloc(sizeof(char) * 80);
  snprintf(buffer, 80, "var%d", tempVarIndex++);

  return buffer;
}

char *etiqueta() {
  char *buffer = malloc(sizeof(char) * 80);
  snprintf(buffer, 80, "etiqueta%d", tempEtiquetaIndex++);

  return buffer;
}

void iniciarAsignacion() {
  // liberar la memoria anterior (lo no liberado
  // no es de nuestra propiedad)
  if (tmpAsignacion.instrucciones != 0x0) {
    int i;
    for (i = 0; i < tmpAsignacion.subexpresiones; i++) {
      
    }

    free(tmpAsignacion.instrucciones);
  }

  tmpAsignacion.subexpresiones = 0;
  tmpAsignacion.variableAsignada = 0x0;
  tmpAsignacion.instrucciones = malloc(sizeof(char*) * 80);
}

void asignarNombre(char *variableAsignada) {
  tmpAsignacion.variableAsignada = strdup(variableAsignada);
}

void addInstruccion(char *tipo, char *result, char *instr) {
  char finalResult[1000];
  sprintf(finalResult, "%s %s = %s;", tipo, result, instr);
  tmpAsignacion.instrucciones[tmpAsignacion.subexpresiones++] = strdup(finalResult);
}

void generarAsignacion(char *resultadoFinal) {
  printf("{\n");
  int i;
  for(i = 0; i < tmpAsignacion.subexpresiones; i++) {
    printf("%s\n", tmpAsignacion.instrucciones[i]);
  }

  printf("%s = %s;\n}\n", tmpAsignacion.variableAsignada, resultadoFinal);
}

void generarOperacionBasica(t_token *sint, char *op, t_token t1, t_token t2) {
  
  char tipo[7];
  tipoC(tipo, sint->tipo);
          
  generarOperacionBasicaConTipo(sint, tipo, op, t1, t2);
}

void generarOperacionBasicaConTipo(t_token *sint, char *tipo,  char *op, t_token t1, t_token t2) {
  char *varResultado = temporal();
  char instruccion[300];

  sprintf(instruccion, "%s %s %s", t1.nombreSint, op, t2.nombreSint);
  addInstruccion(
                 tipo,
                 varResultado,
                 instruccion
                 );

  sint->nombreSint = varResultado;
}


void tipoC(char *tipo, t_dato tip) {
  switch(tip) {
  case booleano:
    strcpy(tipo, "bool");
    break;
  case caracter:
    strcpy(tipo, "char");
    break;
  case entero:
    strcpy(tipo, "int");
    break;
  case real:
    strcpy(tipo, "double");
    break;
  }
}
