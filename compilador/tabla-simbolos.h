#define MAX_TS_SIZE 500


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
  Entrada pila[MAX_TS_SIZE];
  uint tope;
} Tabla;


typedef struct {
  int atributo;
  char* lexema;
  t_dato tipo;
} t_token;

#define YYSTYPE t_token;

Tabla tabla;
tabla.tope = 0;  // 0th possition is gargabe

void TS_insertar_marca();
void TS_insertar_identificador(t_token identificador);
void TS_insertar_procedimiento(t_token procedimiento);
void TS_insertar_parametro(t_token parametro);
void TS_fin_bloque();

void TS_insertar_entrada(Entrada item);
void TS_ififitsisits();
void TS_identificador_libre(char* identificador);
