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
