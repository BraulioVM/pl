
%{
  // código C
}

%token whatever

%%


PROGRAMA : CABECERA_PROGRAMA BLOQUE
  ;


%%

#include "lexyy.c"
#include "error.y"


main(){
  
  yyparse();


/* 

<bloque> ::= <Inicio_de_bloque>
                               <Declar_de_variables_locales>
                               <Declar_de_subprogs>
                               <Sentencias>
                      <Fin_de_bloque>
      
<Declar_de_subprogs> ::= <Declar_de_subprogs> <Declar_subprog>
                                         |  
<Declar_subprog> ::= <Cabecera_subprograma> <bloque>

<Declar_de_variables_locales> ::= <Marca_ini_declar_variables>
                                                              <Variables_locales>
                                                              <Marca_fin_declar_variables>
                                  |
<Marca_ini_declarar_variables> ::=  sean
<Marca_fin_declarar_variables> ::=  .
<Variables_locales> ::= <variable_local>, <Variables_locales> | <variable_local>
<variable_local> ::= <tipo> <lista_identificador>
<tipo> ::= booleano | entero | real | caracter

<lista_identificador> ::= <identificador> | <identificador>, <lista_identificador>
<identificador> ::= <nombre> | <nombre>[<dimensiones>]
<dimensiones> ::= <natural> | <natural>,<natural>

<Cabecera_programa> ::= BIENVENIDO
<Inicio_de_bloque> ::= {
<Fin_de_bloque> ::= }

<Cabecera_subprograma> ::= procedimiento <nombre> (<lista_parametros>)
<parametro> ::= <tipo> <identificador>
<lista_parametros> ::= <parametro>, <lista_parametros> | <parametro> |


<Sentencias> ::= <Sentencias> <Sentencia>
                               |  <Sentencia>


<Sentencia> ::= <bloque>
                               |  <sentencia_asignacion>    
                               |  <sentencia_if>
                               |  <sentencia_while>
                               |  <sentencia_entrada>
            |  <sentencia_salida>         
            |  <llamada_proced>
            |  <sentencia_for>
        | <sentencia_return>


<sentencia_asignacion> ::= <identificador_expr> = <expr>;
<sentencia_if> ::= si (<expr>) <sentencia> <sentencia_else>
<sentencia_else> ::= si_no <sentencia> |
<sentencia_while> ::= mientras (<expr>) <sentencia>
<sentencia_for> ::= para <nombre> := <expr> <direccion_for> <expr> hacer <sentencia>
<direccion_for> ::= hasta | bajando_hasta
<sentencia_entrada> ::= <nomb_entrada> <lista_identificador_expr>;
<nomb_entrada> ::= captar
<sentencia_salida> ::= <nomb_salida> <lista_expresiones_o_cadena>;
<lista_expresiones_o_cadena> ::= <expr_o_cadena> 
                                                     | <expr_o_cadena>,<lista_expresiones_o_cadena>

<expr_o_cadena> ::= <expr> | <cadena>
<nomb_salida> ::= imprimir
<sentencia_return> ::= volver;
<llamada_proced> ::= <nombre>(<lista_expr>);

<letra> ::= "A" | "B" | "C" | "D" | "E" | "F" | "G" | "H" | "I" | "J" | "K" | "L" | "M" | "N" | "O" | "P" | "Q" | "R" | "S" | "T" | "U" | "V" | "W" | "X" | "Y" | "Z" | "a" | "b" | "c" | "d" | "e" | "f" | "g" | "h" | "i" | "j" | "k" | "l" | "m" | "n" | "o" | "p" | "q" | "r" | "s" | "t" | "u" | "v" | "w" | "x" | "y" | "z"
<digito> ::= "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9"
<alfanum> ::= <letra> | <digito>
<palabra> ::= <alfanum> <palabra> | "_" <palabra> |
<nombre> ::= <letra> <palabra> | “_” <nombre>

<expr> ::= ( <expr> )
         | <op_unario> <expr>
         | <expr> <op_binario> <expr>
         | <identificador_expr>
         | <literal>
<op_unario> ::= "-" | "!" | “+”

<op_aritmetico> ::= "+" | "-" | "*" | “**” | "/"
<op_logico> ::= "&&" | "||" | "^"
<op_comparacion> ::= ">" | ">=" | "<" | "<=" | "==" | "!="
<op_binario> ::=  <op_aritmetico> | <op_logico> | <op_comparacion>

<identificador_expr> ::= <nombre> | <nombre>[<expr>] | <nombre>[<expr>, <expr>]
<lista_identificador_expr> ::= <identificador_expr> | <identificador_expr>, 
                                          | <lista_identificador_expr>
<literal> ::= <numero>
            | <booleano>
            | <caracter>
  | <vector>
  | <matriz>

<booleano> ::= “verdadero” | “falso”
<numero> ::= <natural>
| <real>
<natural> ::= <digito> | <digito> <natural>
<real> ::= <natural>.<natural>

<imprimible> ::= <alfanum> | "!" | "#" | "$" | "%" | "&" | "(" | ")" | "*" | "+" | "," | "-" | "." | "/" | ":" | ";" | "<" | "=" | ">" | "?" | "@" | "["  | "]" | "^" | "_" | "`" | "{" | "|" | "}" | "~" | " " | "\"" | "\'" | "\n"
<comilla_simple> ::= "'"
<comilla_doble> ::= '"'
<cadena_aux> ::=  <imprimible> <cadena_aux> | 
<cadena> ::= <comilla_doble> <cadena_aux> <comilla_doble>

<caracter> ::= <comilla_simple> <imprimible> <comilla_simple>

<lista_expr> ::= <expr>, <lista_expr>
    | <expr>
    |
<vector> ::= { <lista_expr> }

<lista_vectores> ::= <vector> 
    | <vector>, <lista_vectores>
<matriz> ::= { <lista_vectores> }

*/
}

