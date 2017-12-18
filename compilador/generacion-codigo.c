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

void generarAsignacion(t_token *t) {
  int i;
  for(i = 0; i < tmpAsignacion.subexpresiones; i++) {
    char nuevaInfo[1000];
    sprintf(nuevaInfo, "%s\n", tmpAsignacion.instrucciones[i]);
    strcat(t->codigoSint, nuevaInfo);
  }
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

Salida tmpSalida;

void iniciarSalida() {
   tmpSalida.cadenas = malloc(sizeof(char *) * 80);
   tmpSalida.variables = malloc(sizeof(char *) * 80);

   tmpSalida.nCadenas = 0;
   tmpSalida.nVariables = 0;
}

void addCadena(char *cadena) {
  tmpSalida.cadenas[tmpSalida.nCadenas++] = strdup(cadena);
}

void addVariable(t_token var) {
  char cadena[80];
  switch (var.tipo) {
  case entero:
    strcpy(cadena, " %d ");
    break;
  case caracter:
    strcpy(cadena, " %c ");
    break;
  case booleano:
    strcpy(cadena, " %d ");
    break;
  case real:
    strcpy(cadena, " %f ");
    break;
  }

  addCadena(cadena);
  tmpSalida.variables[tmpSalida.nVariables++] = strdup(var.nombreSint);

}

void imprimePrintf(t_token *t) {
  char codigo[1000];
  strcpy(codigo, "printf(\"");
  int i;

  for (i = 0; i < tmpSalida.nCadenas; i++) {
    tmpSalida.cadenas[i][strlen(tmpSalida.cadenas[i]) - 1] = 0x0;
    strcat(codigo, tmpSalida.cadenas[i] + 1);
  }
  
  strcat(codigo, "\\n\"");

  for( i = 0; i < tmpSalida.nVariables; i++) {
    strcat(codigo, ", ");
    strcat(codigo, tmpSalida.variables[i]);
  }

  strcat(codigo, ");\n");

  strcat(t->codigoSint, codigo);
}

bool declarandoVariables = false;

void inicioDePrograma(t_token *t) {
  strcat(t->codigoSint, "#include <stdio.h>\n");
  strcat(t->codigoSint, "typedef int bool;\n");
  strcat(t->codigoSint, "#define true 1\n");
  strcat(t->codigoSint, "#define false 0\n");
  strcat(t->codigoSint, "int main()\n");
}

void finDePrograma() {
  printf("\n");
}

void iniciarCodigo(t_token *c) {
  c->codigoSint = malloc(sizeof(char) * 100000);
}
