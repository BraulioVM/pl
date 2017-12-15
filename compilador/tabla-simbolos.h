#ifndef _TABLA_SIMBOLOS_H
#define _TABLA_SIMBOLOS_H


#define MAX_TS_SIZE 500

typedef unsigned int uint;

const char * nombre_no_valido = "\0";

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
  int dimension;
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
int TS_ififitsisits();
void TS_nofits();
bool TS_identificador_libre(char* identificador);

void TS_dimension_vector( t_token dimension );
void TS_dimension_matriz( t_token dimension_1, t_token dimension_2 );

void assert_tipo(t_token,t_dato);
void asignar_identificador(t_token*, char*);
t_posicion TS_ultima_marca();
t_posicion TS_ultimo_procedimiento();
t_dato tipoTmp;

bool tipo_numerico(t_token);
bool igualdad_de_tipos(t_token, t_token);

void inicia_vector();
TipoArray finaliza_vector();
void comprueba_elemento(t_token);
bool definiendo_vector();

Entrada buscar_en_tabla( char * nombre );

#endif
