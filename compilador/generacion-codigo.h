#ifndef _GENERACION_CODIGO_H
#define _GENERACION_CODIGO_H

#include "tabla-simbolos.h"

typedef unsigned int uint;

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

void generarAsignacion(char *resultadoFinal);
void generarOperacionBasica(t_token*, char*, t_token, t_token);
void generarOperacionBasicaConTipo(t_token *sint, char *tipo,  char *op, t_token t1, t_token t2);

void tipoC(char *tipo, t_dato tip);

#endif
