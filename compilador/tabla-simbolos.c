#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "tabla-simbolos.h"

int yylineno;  // viene del tokenizador con un extern

#define true 1
#define false 0

Tabla tabla = { .tope = 0 };

bool TS_ififitsisits(){
  return tabla.tope < MAX_TS_SIZE - 1;
}

bool TS_identificador_libre(char* identificador){
  t_posicion curr = tabla.tope;

  while(tabla.pila[curr].tipoEntrada != marca){
    if(tabla.pila[curr].tipoEntrada == variable &&
       strcmp(tabla.pila[curr].nombre, identificador) == 0){
      return false;
    }

    --curr;
  }

  --curr;  // es una marca

  while(tabla.pila[curr].tipoEntrada == parametro_formal){
    /* Estamos en el bloque de un subprograma/procedimiento,
     * por lo que debemos comprobar también en sus parámetros formales
     */
    if(strcmp(tabla.pila[curr].nombre, identificador) == 0){
      return false;
    }

    --curr;
  }

  return true;
};


bool TS_parametro_libre(char* parametro){
  t_posicion curr = tabla.tope + 1;
  while(tabla.pila[--curr].tipoEntrada == parametro_formal){
    if(strcmp(tabla.pila[curr].nombre, parametro) == 0){
      return false;
    }
  }

  return true;
}


void TS_insertar_entrada(Entrada item){
  tabla.pila[++tabla.tope] = item;
}


void TS_insertar_marca(){
  if(TS_ififitsisits()){
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
  } else {
    TS_nofits();
  }
}


void TS_insertar_identificador(t_token identificador){
  if(TS_ififitsisits()){
    if(TS_identificador_libre(identificador.lexema)) {
      Entrada ident = {
        variable,              // tipoEntrada
        tipoTmp,               // tipoDato
        identificador.lexema,  // nombre
        0,                     // n_parametros
        .dimensiones = identificador.dimensiones,
        .dimension_1 = identificador.dimension_1,
        .dimension_2 = identificador.dimension_2
      };

      TS_insertar_entrada(ident);
    } else {
      printf(
             "Error semántico: redeclaración de la variable %s\n",
             identificador.lexema
             );
    }
  } else {
    TS_nofits();
  }
}


void TS_insertar_procedimiento(t_token procedimiento_){
  if(TS_ififitsisits()){
    Entrada proc = {
      procedimiento,          // tipoEntrada
      NA,                     // tipoDato
      procedimiento_.lexema,  // nombre
      0,                      // n_parametros
      0,                      // dimensiones
      0,                      // dimension_1
      0,                      // dimension_2
    };

    TS_insertar_entrada(proc);
  } else {
    TS_nofits();
  }
}


void TS_insertar_parametro(t_token parametro){
  if (TS_ififitsisits()){
    if(TS_parametro_libre(parametro.lexema)){
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

      t_posicion proc = TS_ultimo_procedimiento();
      tabla.pila[proc].n_parametros += 1;  // incrementa el número de params
    } else {
      TS_error_redeclaracion_parametro(parametro.lexema);
    }
  } else {
    TS_nofits();
  }
}


void TS_nofits(){

  // Informe de error somehow
}


void TS_fin_bloque(){
  tabla.tope = TS_ultima_marca() - 1;
}


void TS_dimension_vector(t_token dimension){
  tabla.pila[tabla.tope].dimensiones = 1;
  tabla.pila[tabla.tope].dimension_1 = dimension.atributo;
}


void TS_dimension_matriz( t_token dimension_1, t_token dimension_2 ){
  tabla.pila[ tabla.tope ].dimensiones = 2;
  tabla.pila[ tabla.tope ].dimension_1 = dimension_1.atributo;
  tabla.pila[ tabla.tope ].dimension_2 = dimension_2.atributo;
}


bool assert_tipo(t_token token, t_dato tipo) {
  return token.tipo == tipo;
}


void asignar_identificador(t_token *token, char *identificador) {
  t_posicion pos = TS_encontrar_entrada(identificador);

  if(pos == -1) {
    TS_error_referencia(identificador);
  } else {
    token->tipo = tabla.pila[pos].tipoDato;
    token->lexema = tabla.pila[pos].nombre;
    token->dimensiones = tabla.pila[pos].dimensiones;
    token->dimension_1 = tabla.pila[pos].dimension_1;
    token->dimension_2 = tabla.pila[pos].dimension_2;
  }
}

void asignar_identificador_array(t_token *token, char *identificador) {
  t_posicion var_pos = TS_encontrar_entrada(identificador);

  if (var_pos != -1) {
    Entrada var = tabla.pila[var_pos];

    if (var.dimensiones == 0) {
      yyerror("no se puede utilizar el operador de corchete sobre una variable primitiva");
    } else {
      token->lexema = var.nombre;
      token->tipo = var.tipoDato;
      token->dimensiones = var.dimensiones - 1;
      token->dimension_1 = var.dimensiones == 1? 0 : var.dimension_2;
      token->dimension_2 = 0;
    }

  } else {
    yyerror("no existe tal identificador");
  }

}

void asignar_identificador_matriz(t_token *token, char *nombre) {
  t_posicion var_pos = TS_encontrar_entrada(nombre);

  if (var_pos != -1) {
    Entrada var = tabla.pila[var_pos];

    if (var.dimensiones == 2) {
      token->lexema = var.nombre;
      token->tipo = var.tipoDato;
      token->dimensiones = 0;
      token->dimension_1 = 0;
      token->dimension_2 = 0;
    } else {
      yyerror("la variable debe ser una matriz");
    }

  } else {
    yyerror("no existe tal identificador");
  }
}


t_posicion TS_ultima_marca(){
  t_posicion curr = tabla.tope + 1;
  while(tabla.pila[--curr].tipoEntrada != marca);
  return curr;
}


t_posicion TS_ultimo_procedimiento(){
  t_posicion curr = tabla.tope + 1;
  while(tabla.pila[--curr].tipoEntrada != procedimiento);
  return curr;
}

char* TS_dimensiones(t_token token){
  char format[10], tmp[100];
  format[0] = '\0';  // evita reutilización de memoria basura

  if(token.dimensiones == 0){
    strcat(format, "[]");
  } else if(token.dimensiones == 1){
    strcat(format, "[%d]");
  } else if(token.dimensiones == 2){
    strcat(format, "[%d, %d]");
  }

  sprintf(tmp, format, token.dimension_1, token.dimension_2);
  char *ptr = strdup(tmp);
  return ptr;
}

bool tipo_numerico(t_token t){
  return t.tipo == real || t.tipo == entero;
}

bool igualdad_de_tipos(t_token t1, t_token t2){
  return t1.tipo == t2.tipo;
}


bool igualdad_de_tipos_y_dimensiones(t_token t1, t_token t2) {
  bool eq = igualdad_de_tipos(t1, t2) && t1.dimensiones == t2.dimensiones;

  if(eq && t1.dimensiones >= 1){
    eq = eq && t1.dimension_1 == t2.dimension_1;
  }

  if(eq && t1.dimensiones == 2){
    eq = eq && t1.dimension_2 == t2.dimension_2;
  }

  return eq;
}


void TS_dump_table(){
  for(uint i = 1; i <= tabla.tope; ++i){
    printf("%d %s \n", tabla.pila[i].tipoEntrada, tabla.pila[i].nombre);
  }
}

uint elementos_leidos;
bool leyendo_vector = false;
t_dato tipo_elementos;

void inicia_vector() {
  leyendo_vector = true;
  elementos_leidos = 0;
}


void comprueba_elemento (t_token token) {
  if (elementos_leidos == 0) {
    tipo_elementos = token.tipo;
  } else {
    if (token.tipo != tipo_elementos) {
      yyerror("error de tipos en vector");
    }
  }

  elementos_leidos++;
}


TipoArray finaliza_vector() {
  TipoArray resultado = {
    .tipoDato = tipo_elementos,
    .dimension = elementos_leidos
  };

  leyendo_vector = false;

  return resultado;
}


bool definiendo_vector() {
  return leyendo_vector;
}


bool stringeq(const char *str1, const char *str2){
  if(str1 == NULL || str2 == NULL){
    return str1 == str2;
  } else {
    return strcmp(str1, str2) == 0;
  }
}


t_posicion TS_encontrar_entrada(char* nombre){
  for(int i = tabla.tope; i > 0; --i){
    if(stringeq(tabla.pila[i].nombre, nombre)){
      return i;
    }
  }

  return -1;
}


bool TS_existe_procedimiento(char *proc){
  return TS_encontrar_entrada(proc) != -1;
}


bool llamando_procedimiento = false;
char *nombre_procedimiento = NULL;
uint parametro_actual = 0;
t_posicion procedimiento_actual = 0;


void TS_iniciar_llamada(char *proc){
  if(!TS_existe_procedimiento(proc)){
    TS_error_referencia(proc);
  } else {
    llamando_procedimiento = true;
    nombre_procedimiento = strdup(proc);
    parametro_actual = 0;
    procedimiento_actual = TS_encontrar_entrada(proc);
  }
}


void TS_comprobar_parametro(t_token param){
  ++parametro_actual;
  Entrada entrada_parametro = tabla.pila[procedimiento_actual + parametro_actual];

  if(tabla.pila[procedimiento_actual].n_parametros < parametro_actual){
    TS_error_numero_parametros(
      nombre_procedimiento,
      tabla.pila[procedimiento_actual].n_parametros,
      parametro_actual
    );
  } else if(entrada_parametro.tipoDato != param.tipo){
    TS_error_tipos_argumento(
        entrada_parametro.nombre,
        nombre_procedimiento,
        entrada_parametro.tipoDato,
        param.tipo
    );
  } else if(entrada_parametro.dimensiones != param.dimensiones){
    TS_error_dimensiones_argumento(
        entrada_parametro.nombre,
        nombre_procedimiento,
        entrada_parametro.dimensiones,
        param.dimensiones
    );
  } else if(param.dimensiones >= 1 &&
            entrada_parametro.dimension_1 != param.dimension_1){
    TS_error_dimensiones_dimension1_argumento(
        entrada_parametro.nombre,
        nombre_procedimiento,
        entrada_parametro.dimension_1,
        param.dimension_1
    );
  } else if(param.dimensiones >= 2 &&
            entrada_parametro.dimension_2 != param.dimension_2){
    TS_error_dimensiones_dimension2_argumento(
        entrada_parametro.nombre,
        nombre_procedimiento,
        entrada_parametro.dimension_2,
        param.dimension_2
    );
  } // else: todo ok
}


void TS_finalizar_llamada(){
  if(parametro_actual < tabla.pila[procedimiento_actual].n_parametros){
    TS_error_numero_parametros(
        nombre_procedimiento,
        tabla.pila[procedimiento_actual].n_parametros,
        parametro_actual
    );
  }

  llamando_procedimiento = 0;
  free(nombre_procedimiento);
  parametro_actual = 0;
  procedimiento_actual = 0;
}

void TS_error(const char* mensaje){
  fprintf(stderr, "L%d: %s\n", yylineno, mensaje);
}


void TS_error_redeclaracion_parametro(const char *parametro){
  char base[100];
  sprintf(
          base,
          "Error: argumento '%s' duplicado en declaración de procedimiento",
          parametro
          );
  TS_error(base);
}


void TS_error_tipos(const char* mensaje){
  char tmp[400];
  strcat(tmp, "Error de tipos: ");
  strcat(tmp, mensaje);
  TS_error(tmp);
}


void TS_error_tipos_vector(const t_dato esperado, const t_dato recibido){
  char mensaje[200];
  sprintf(
          mensaje,
          "se esperaba un valor de tipo '%s' en la inicialización del vector. En su lugar se encontró un valor de tipo '%s'.",
          TS_nombre_tipo(esperado),
          TS_nombre_tipo(recibido)
          );
  TS_error_tipos(mensaje);
}


void TS_error_referencia(const char* referencia){
  // variable o procedimiento no definido
  char base[100];
  sprintf(
          base,
          "Error de referencia: el nombre '%s' no ha sido definido.",
          referencia
          );
  TS_error(base);
}


void TS_error_dimensiones(const char* mensaje){
  char tmp[400];
  strcat(tmp, "Error de dimensiones: ");
  strcat(tmp, mensaje);
  TS_error(tmp);
}


void TS_error_numero_parametros(const char* proc, uint esperados, uint recibidos){
  char base[200];
  sprintf(
          base,
           "el procedimiento '%s' esperaba %d parámetros pero recibió %d.",
          proc,
          esperados,
          recibidos
          );
  TS_error_tipos(base);
}


void TS_error_tipos_argumento(const char* param, const char* proc, t_dato esperado, t_dato recibido){
  char mensaje[200];
  sprintf(
          mensaje,
          "el parámetro '%s' del procedimiento '%s' debe ser de tipo '%s'. En su lugar se encontró un valor de tipo '%s'.",
          param,
          proc,
          TS_nombre_tipo(esperado),
          TS_nombre_tipo(recibido)
          );
  TS_error_tipos(mensaje);
}


void TS_error_tipos_asignacion(const t_token lhs, const t_token rhs){
  char mensaje[200];
  sprintf(
          mensaje,
          "no se pudo asignar un valor de tipo '%s' al identificador '%s' de tipo '%s'.",
          TS_nombre_tipo(recibido),
          lhs.lexema,
          TS_nombre_tipo(esperado)
          );
  TS_error_tipos(mensaje);
}


void TS_error_tipos_operacion(const char* op, const t_dato tipoA, const t_dato tipoB){
  char mensaje[200];
  sprintf(
          mensaje,
          "tipos no soportados por el operador '%s': '%s' y '%s'.",
          op,
          TS_nombre_tipo(tipoA),
          TS_nombre_tipo(tipoB)
          );
  TS_error_tipos(mensaje);
}


void TS_error_tipos_for_init(const t_dato recibido){
  char mensaje[200];
  sprintf(
          mensaje,
          "la variable iteradora debe ser de tipo entero. En su lugar se encontró un valor de tipo '%s'.",
          TS_nombre_tipo(recibido)
          );
  TS_error_tipos(mensaje);
}


void TS_error_tipos_condicion(const t_dato recibido){
  char mensaje[200];
  sprintf(
          mensaje,
          "la condición debe ser de tipo booleano. En su lugar se encontró un valor de tipo '%s'.",
          TS_nombre_tipo(recibido)
          );
  TS_error_tipos(mensaje);
}


void TS_error_dimensiones_argumento(const char* param, const char* proc, uint esperadas, uint recibidas){
  char mensaje[200];
  sprintf(
          mensaje,
          "el parámetro '%s' del procedimiento '%s' debe tener %d dimensiones. En su lugar se encontró un valor con %d dimensiones.",
          param,
          proc,
          esperadas,
          recibidas
          );
  TS_error_dimensiones(mensaje);
}


void TS_error_dimensiones_dimension1_argumento(const char* param, const char* proc, uint esperado, uint recibido){
  char mensaje[200];
  sprintf(
          mensaje,
          "en el procedimiento '%s', la primera dimensión del parámetro '%s' debe ser de tamaño %d. En su lugar se encontró un valor de tamaño %d.",
          proc,
          param,
          esperado,
          recibido
          );
  TS_error_dimensiones(mensaje);
}


void TS_error_dimensiones_dimension2_argumento(const char* param, const char* proc, uint esperado, uint recibido){
  char mensaje[200];
  sprintf(
          mensaje,
          "en el procedimiento '%s', la segunda dimensión del parámetro '%s' debe ser de tamaño %d. En su lugar se encontró un valor de tamaño %d.",
          proc,
          param,
          esperado,
          recibido
          );
  TS_error_dimensiones(mensaje);
}


void TS_error_dimensiones_operacion(const char* op, const t_token left, const t_token right){
  char mensaje[200], *dim_left, *dim_right;
  dim_left = TS_dimensiones(left);
  dim_right = TS_dimensiones(right);
  sprintf(
          mensaje,
          "%s %s %s no soportado",
          dim_left,
          op,
          dim_right
          );
  TS_error_dimensiones(mensaje);
  free(dim_left);
  free(dim_right);
}


void TS_error_dimensiones_producto_matrices(const t_token left, const t_token right){
  char mensaje[200], *dim_left, *dim_right;
  dim_left = TS_dimensiones(left);
  dim_right = TS_dimensiones(right);
  sprintf(
          mensaje,
          "%s ** %s no soportado. Las dimensiones de las matrices no son compatibles para su producto.",
          dim_left,
          dim_right
          );
  TS_error_dimensiones(mensaje);
  free(dim_left);
  free(dim_right);
}


void TS_error_dimensiones_acceso(uint esperadas, uint recibidas){
  char mensaje[200];
  sprintf(
          mensaje,
          "se esperaba un valor de %d dimensiones pero en su lugar se encontró uno de %d.",
          esperadas,
          recibidas
          );
  TS_error_dimensiones(mensaje);
}
