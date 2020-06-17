#ifndef SEMANTICA_H_INCLUDED
#define SEMANTICA_H_INCLUDED
#include "parser.h"
void Generar(char *operacion, char *op1, char *op2, char *op3);
void Asignar(YYSTYPE id, YYSTYPE exp);
void Leer(YYSTYPE id);
void Escribir(YYSTYPE exp);
void Chequear (YYSTYPE id);
void Terminar();
void Comenzar();
YYSTYPE Gen_infijo(YYSTYPE exp1,YYSTYPE op,YYSTYPE exp2);
YYSTYPE Inv(YYSTYPE op,YYSTYPE exp);

#endif // SEMANTICA_H_INCLUDED
