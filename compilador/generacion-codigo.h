#ifndef _GENERACION_CODIGO_H
#define _GENERACION_CODIGO_H

#include "tabla-simbolos.h"

typedef unsigned int uint;
typedef int bool;

#define false 0
#define true 1

char *temporal(void);
char *etiqueta(void);

typedef struct {
  char *variableAsignada;
  uint subexpresiones;
  char **instrucciones;
} Asignacion;

Asignacion tmpAsignacion;
void iniciarAsignacion();

void asignarNombre(char *variableAsignada);
void addInstruccion(char*, char*, char *instr);

void generarAsignacion();
void generarOperacionBasica(t_token*, char*, t_token, t_token);
void generarOperacionBasicaConTipo(t_token *sint, char *tipo,  char *op, t_token t1, t_token t2);

void tipoC(char *tipo, t_dato tip);


typedef struct {
  char **cadenas;
  char **variables;
  uint nCadenas;
  uint nVariables;
} Salida;

void iniciarSalida();
void addCadena(char*);
void addVariable(t_token);
void imprimePrintf();


bool declarandoVariables;

void inicioDePrograma();
void finDePrograma();

#endif
