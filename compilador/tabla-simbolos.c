#include <stdio.h>
#include <string.h>
#include "tabla-simbolos.h"

#define true 1
#define false 0

Tabla tabla = { .tope = 0 };

bool TS_ififitsisits(){
  return tabla.tope < MAX_TS_SIZE - 1;
}

const char * nombre_no_valido = "\0";

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
        0,                     // dimensiones
        0,                     // dimension_1
        0,                     // dimension_2
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
  tabla.tope = TS_ultima_marca();
  while(tabla.pila[--tabla.tope].tipoEntrada == parametro_formal);
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


void assert_tipo(t_token token, t_dato tipo) {
  if (token.tipo != tipo) {
    yyerror("Error semántico: tipos incorrectos");
  }
}


void asignar_identificador(t_token *token, char *identificador) {
  uint identificadorEncontrado = false;
  int indicePila;
  for (indicePila = tabla.tope; indicePila >= 0; indicePila--) {

    if (tabla.pila[indicePila].tipoEntrada == variable &&
        strcmp(tabla.pila[indicePila].nombre, identificador) == 0) {

      identificadorEncontrado = true;
      break;
    }
  }

  if (!identificadorEncontrado) {
    yyerror("Identificador no encontrado");
  } else {
    token->tipo = tabla.pila[indicePila].tipoDato;
    token->lexema = tabla.pila[indicePila].nombre;
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


bool tipo_numerico(t_token t){
  return t.tipo == real || t.tipo == entero;
}

bool igualdad_de_tipos(t_token t1, t_token t2){
  return t1.tipo == t2.tipo;
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


t_posicion TS_encontrar_entrada(char* nombre){
  for(int i = tabla.tope; i > 0; --i){
    if(strcmp(tabla.pila[i].nombre, nombre) == 0){
      return i;
    }
  }

  return -1;
}


void TS_error(const char* mensaje){
  fprintf(stderr, "%s", mensaje);
}


void TS_error_redeclaracion_parametro(char *parametro){
  char base[100] = "Error: Argumento '%s' duplicado en declaración de procedimiento";
  sprintf(base, base, parametro);
  TS_error(base);
}


void TS_error_tipos(const char* mensaje){
  char tmp[100];
  strcat(tmp, "Error de tipos: ");
  strcat(tmp, mensaje);
  TS_error(tmp);
}


void TS_error_referencia(const char* mensaje){  // variable o procedimiento no definido
  char tmp[100];
  strcat(tmp, "Variable no definida: ");
  strcat(tmp, mensaje);
  TS_error(tmp);
}


void TS_error_dimensiones(const char* mensaje){  // variable o procedimiento no definido
  char tmp[100];
  strcat(tmp, "Dimensiones no compatibles: ");
  strcat(tmp, mensaje);
  TS_error(tmp);
}
