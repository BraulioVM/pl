#ifndef _GENERACION_CODIGO_H
#define _GENERACION_CODIGO_H

#include "tabla-simbolos.h"

typedef unsigned int uint;

#define bool unsigned short
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

void generarAsignacion(t_token *t);
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
void imprimePrintf(t_token *t);


bool declarandoVariables;

void inicioDePrograma(t_token*);
void finDePrograma();

void iniciarCodigo(t_token *c, char*);
void ccat(t_token*, char*);

#endif
