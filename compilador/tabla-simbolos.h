#ifndef _TABLA_SIMBOLOS_H
#define _TABLA_SIMBOLOS_H


#define MAX_TS_SIZE 500

typedef unsigned int uint;

typedef enum {
  marca,
  procedimiento,
  variable,
  parametro_formal
} t_entrada;


typedef enum {
  NA = 0,
  array,
  booleano,
  caracter,
  entero,
  real
} t_dato;


typedef struct {
  t_entrada tipoEntrada;
  t_dato tipoDato;
  char* nombre;
  uint n_parametros;
  uint dimensiones;
  uint dimension_1;
  uint dimension_2;
} Entrada;

typedef struct {
  t_dato tipoDato;
  uint dimension;
} TipoArray;

typedef struct {
  Entrada pila[MAX_TS_SIZE];
  uint tope;
} Tabla;


typedef struct {
  int atributo;
  char* lexema;
  t_dato tipo;
  uint dimensiones;
  uint dimension_1;
  uint dimension_2;
  char *nombreSint;
} t_token;

#define YYSTYPE t_token
#define t_posicion uint
#define bool unsigned short

Tabla tabla;


void TS_insertar_marca();
void TS_insertar_identificador(t_token identificador);
void TS_insertar_procedimiento(t_token procedimiento);
void TS_insertar_parametro(t_token parametro);
void TS_fin_bloque();

void TS_insertar_entrada(Entrada item);
bool TS_ififitsisits();
void TS_nofits();
void TS_dump_table();
bool TS_identificador_libre(char* identificador);
bool TS_parametro_libre(char* parametro);

void TS_dimension_vector( t_token dimension );
void TS_dimension_matriz( t_token dimension_1, t_token dimension_2 );

void assert_tipo(t_token,t_dato);
void asignar_identificador(t_token*, char*);
void asignar_identificador_array(t_token*, char*);
void asignar_identificador_matriz(t_token*, char*);
t_posicion TS_ultima_marca();
t_posicion TS_ultimo_procedimiento();
t_dato tipoTmp;

bool tipo_numerico(t_token);
bool igualdad_de_tipos(t_token, t_token);
bool igualdad_de_tipos_y_dimensiones(t_token, t_token);

void inicia_vector();
TipoArray finaliza_vector();
void comprueba_elemento(t_token);
bool definiendo_vector();

t_posicion TS_encontrar_entrada(char* nombre);

void TS_error(const char* mensaje);
void TS_error_tipos(const char* mensaje);
void TS_error_referencia(const char* mensaje);
void TS_error_dimensiones(const char* mensaje);
void TS_error_redeclaracion_parametro(char* parametro);

#endif
