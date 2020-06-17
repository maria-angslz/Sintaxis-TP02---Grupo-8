%code top{
#include <stdio.h>
#include "scanner.h"
#include "semantica.h"
void yyerror(const char *);
}
%code provides {
struct YYSTYPE {
	char str[32];
	int num;
	};
void yyerror(const char *s);
extern int nerrlex;
}
%defines "parser.h"
%define parse.error verbose
%output "parser.c"
%start programa
%token IDENTIFICADOR CONSTANTE INICIO FIN ESCRIBIR LEER PARENDER PARENIZQ COMA PUNTOYCOMA
%right ASIGNACION
%left SUMA RESTA
%left MULT DIV
%left NEG
%define api.value.type {struct YYSTYPE}
%%

programa : 					INICIO listaSentencias FIN {Terminar();if(nerrlex+yynerrs) YYABORT;}
							;
listaSentencias : 			sentencia PUNTOYCOMA |
							listaSentencias sentencia PUNTOYCOMA |
							listaSentencias error PUNTOYCOMA
							;
sentencia:					identificador ASIGNACION expresion {Asignar($1,$3);}|
							LEER PARENIZQ listaIdentificadores PARENDER |	
							ESCRIBIR PARENIZQ listaExpresiones PARENDER 
							;
listaIdentificadores : 		identificador {Leer($1);}|
							listaIdentificadores COMA identificador {Leer($3);}
							;
identificador:				IDENTIFICADOR {Chequear($1);}	
							;
listaExpresiones :   		expresion {Escribir($1);}|
							listaExpresiones COMA expresion {Escribir($3);}
							;
expresion :					termino |
							expresion operadoraditivo termino {$$ = Gen_infijo($1,$2,$3);}|
							expresion error
							;
termino	:					primaria |
							termino operadormultiplicativo primaria {$$ = Gen_infijo($1,$2,$3);}
							;
primaria :					identificador |
							CONSTANTE |
							PARENIZQ expresion PARENDER {$$ = $2;}|
							RESTA primaria %prec NEG {$$ = Inv($1,$2);}
							;
operadoraditivo :			SUMA	|
							RESTA	
							;
operadormultiplicativo : 	MULT	|
							DIV		
							;


%%


int nerrlex = 0;
int main() {
	Comenzar();
	switch ( yyparse() ){
	case 0:
		printf("Compilacion con exito"); return 0;
	case 1:
		printf("Errores de compilacion\nErrores sintacticos: %d - Errores lexicos: %d\n",yynerrs,nerrlex); return 1;
	case 2:
		puts("Memoria insuficiente"); return 2;
	}
	return 0;
}
/* Informa la ocurrencia de un error. */
void yyerror(const char *s){
	printf("línea #%d: %s\n", yylineno, s);
	printf("lexema: %s\n", yytext);
	return;
}
