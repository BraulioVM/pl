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
    ccat(t, nuevaInfo);
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
  if (var.nombreSint != 0x0) {
    tmpSalida.variables[tmpSalida.nVariables++] = strdup(var.nombreSint);
  }

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

  ccat(t, codigo);
}

bool declarandoVariables = false;

void cargaBloquePrincipal(t_token *t, CodigoBloque *cb) {
  ccat(t, "#include <stdio.h>\n");
  ccat(t, "typedef int bool;\n");
  ccat(t, "#define true 1\n");
  ccat(t, "#define false 0\n");
  ccat(t, codigoDeclaraciones(cb));
  ccat(t, "int main() { \n");
  ccat(t, cb->codigo);
  ccat(t, "}\n");
}

void finDePrograma() {
  printf("\n");
}

void iniciarCodigo(t_token *c, char* d) {
  c->codigoSint = malloc(sizeof(char) * 100000);
  if (d != 0x0)
    strcpy(c->codigoSint, d);
}

void ccat(t_token *t, char *c) {
  if (c != 0x0 && t->codigoSint != 0x0) {
    strcat(t->codigoSint, c);
  }
}

typedef struct {
  char *cuantificadores;
  char **variables;
  uint nVariables;
} SEntrada;

SEntrada tmpEntrada;

void iniciarEntrada() {
  tmpEntrada.cuantificadores = malloc(sizeof(char) * 100);
  tmpEntrada.variables = malloc(sizeof(char*) * 100);
  tmpEntrada.nVariables = 0;
}

void recibirAVariable(t_token t) {
  char *variable = strdup(t.nombreSint), cuantificador;
  switch(t.tipo) {
  case caracter:
    cuantificador = 'c';
    break;
  case entero:
  case booleano:
    cuantificador = 'd';
    break;
  case real:
    cuantificador = 'f';
    break;
  }

  tmpEntrada.cuantificadores[tmpEntrada.nVariables] = cuantificador;
  tmpEntrada.variables[tmpEntrada.nVariables++] = variable;
}

void imprimeScanf(t_token *t) {
  char c[100];
  sprintf(c, "%%%c", tmpEntrada.cuantificadores[0]);
  ccat(t, "scanf(\"");
  ccat(t, c);
  int i;
  for (i = 1; i < tmpEntrada.nVariables; i++) {
    char codigo[100];
    sprintf(codigo, " %%%c ", tmpEntrada.cuantificadores[i]);
    ccat(t, codigo);
  }
  
  ccat(t, "\"");

  for (i = 0; i < tmpEntrada.nVariables; i++) {
    ccat(t, ", &");
    ccat(t, tmpEntrada.variables[i]);
  }

  ccat(t, ");\n");
}
CodigoBloque *bloqueActual;

void reservarBloque(t_token *t) {
  t->codigoBloque = malloc(sizeof(CodigoBloque));
  CodigoBloque *cb = t->codigoBloque;
  bloqueActual = cb;
  cb->variablesLocales = malloc(sizeof (DeclaracionVariable) * 30);
  cb->procedimientos = malloc(sizeof(DeclaracionProcedimiento) * 10);
  cb->codigo = malloc(sizeof(char) * 100000);
  cb->nVariables = 0;
  cb->nProcedimientos = 0;
}

void addVariableAlBloque(t_dato tipo, char *nombre) {
  bloqueActual->variablesLocales[bloqueActual->nVariables].nombre = nombre;
  bloqueActual->variablesLocales[bloqueActual->nVariables++].tipo = tipo;
}

char *codigoDeclaraciones(CodigoBloque *cb) {
  char declaraciones[10000];
  strcpy(declaraciones, "");

  int i;
  for (i = 0; i < cb->nVariables; i++) {
    char linea[1000];
    char *nombre = cb->variablesLocales[i].nombre;
    t_dato tipo = cb->variablesLocales[i].tipo;
    char tipoS[10];
    tipoC(tipoS, tipo);
    sprintf(linea, "%s %s;\n", tipoS, nombre);
    strcat(declaraciones, linea);
  }

  return strdup(declaraciones);
}
