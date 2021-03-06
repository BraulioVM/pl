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
  char *nombre;
  t_dato tipo;
} DeclaracionVariable;

typedef struct {
  char *nombre;
  DeclaracionVariable *parametros;
  uint nParametros;
  char *codigo;
} DeclaracionProcedimiento;

typedef struct {
  DeclaracionVariable *variablesLocales;
  DeclaracionProcedimiento *procedimientos;
  char *codigo;

  int nVariables;
  int nProcedimientos;

} CodigoBloque;


typedef struct {
  int atributo;
  char* lexema;
  t_dato tipo;
  uint dimensiones;
  uint dimension_1;
  uint dimension_2;
  char *nombreSint;
  char *codigoSint;
  CodigoBloque *codigoBloque;
} t_token;

#define YYSTYPE t_token
#define t_posicion uint
#define bool unsigned short

Tabla tabla;
extern bool TS_ERROR;


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

bool assert_tipo(t_token, t_dato);
void asignar_identificador(t_token*, char*);
void asignar_identificador_array(t_token*, char*);
void asignar_identificador_matriz(t_token*, char*);
t_posicion TS_ultima_marca();
t_posicion TS_ultimo_procedimiento();
t_dato tipoTmp;


static inline const char* TS_nombre_tipo(t_dato tipo){
  static const char* nombres[] = {
    "NA",
    "booleano",
    "caracter",
    "entero",
    "real"
  };

  return nombres[tipo];
}

char* TS_dimensiones(t_token token);

bool tipo_numerico(t_token);
bool igualdad_de_tipos(t_token, t_token);
bool igualdad_de_tipos_y_dimensiones(t_token, t_token);

void inicia_vector();
TipoArray finaliza_vector();
void comprueba_elemento(t_token);
bool definiendo_vector();

bool llamando_procedimiento;
char *nombre_procedimiento;
uint parametro_actual;
t_posicion procedimiento_actual;

bool TS_existe_procedimiento(char *proc);
void TS_iniciar_llamada(char *proc);
void TS_comprobar_parametro(t_token param);
void TS_finalizar_llamada();

t_posicion TS_encontrar_entrada(char* nombre);

bool stringeq(const char *str1, const char *str2);

void TS_error(const char* mensaje);
void TS_error_tipos(const char* mensaje);
void TS_error_tipos_vector(const t_dato esperado, const t_dato recibido);
void TS_error_tipos_asignacion(const t_token lhs, const t_token rhs);
void TS_error_tipos_argumento(const char* param, const char* proc, t_dato esperado, t_dato recibido);
void TS_error_tipos_operacion(const char* op, const t_dato tipoA, const t_dato tipoB);
void TS_error_tipos_for_init(const t_dato recibido);
void TS_error_tipos_condicion(const t_dato recibido);
void TS_error_dimensiones(const char* mensaje);
void TS_error_dimensiones_asignacion(const t_token lhs, const t_token rhs);
void TS_error_dimensiones_argumento(const char* param, const char* proc, uint esperadas, uint recibidas);
void TS_error_dimensiones_dimension1_argumento(const char* param, const char* proc, uint esperado, uint recibido);
void TS_error_dimensiones_dimension2_argumento(const char* param, const char* proc, uint esperado, uint recibido);
void TS_error_dimensiones_operacion(const char* op, const t_token left, const t_token right);
void TS_error_dimensiones_producto_matrices(const t_token left, const t_token right);
void TS_error_dimensiones_acceso(uint esperadas, uint recibidas);
void TS_error_referencia(const char* mensaje);
void TS_error_redeclaracion_parametro(const char* parametro);
void TS_error_numero_parametros(const char* proc, uint esperados, uint recibidos);
void TS_error_redeclaracion(const char*);
#endif
