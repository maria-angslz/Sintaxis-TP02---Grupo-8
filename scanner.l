%{
#include <stdio.h>
#include <strings.h>
#include "parser.h"
int linea = 1;
%}
%option header-file="scanner.h"
%option outfile="scanner.c"
%option yylineno

identificador 				({letra}{letraodigito}*)
constante 					({digito}+)
letraodigito 				({letra}|{digito})
letra 						([a-zA-Z])
digito 						([0-9])
prinicio					("inicio")
prleer						("leer")
prescribir					("escribir")
prfin						("fin")
suma						("+")
resta						("-")
multiplicacion				("*")
division					("/")
asignacion					(:=)
parentesisizquierdo			("(")
parentesisderecho			(")")
coma						(",")
puntoycoma					(";")
errorcomun					("#"|"$"|"!"|"¡"|"%"|"&"|"?"|"¿"|"@")
erroridentificador			({errorcomun}({identificador}|{errorcomun})*)
errorconstante				({digito}+{letra}{letraodigito}*)
comentario					"//".+
saltolinea					({comentario}|\n|{comentario}\n)
cosarara					({errorcomun}+.+({prescribir}|{prleer}|{prinicio}|{prfin}))
%%
{parentesisderecho}			{strcpy(yylval.str,strdup(yytext));
							return PARENDER;}
{parentesisizquierdo}		{strcpy(yylval.str,strdup(yytext));
							return PARENIZQ;}
{coma}						{strcpy(yylval.str,strdup(yytext));
							return COMA;}
{puntoycoma}				{strcpy(yylval.str,strdup(yytext));
							return PUNTOYCOMA;}
{asignacion} 				{strcpy(yylval.str,strdup(yytext));
							return ASIGNACION;}
{suma}						{strcpy(yylval.str,strdup(yytext));
							return SUMA;}
{resta}						{strcpy(yylval.str,strdup(yytext));
							return RESTA;}
{multiplicacion}			{strcpy(yylval.str,strdup(yytext));
							return MULT;}
{division}					{strcpy(yylval.str,strdup(yytext));
							return DIV;}
{prinicio}					{strcpy(yylval.str,strdup(yytext));
							return INICIO;}
{prfin}						{strcpy(yylval.str,strdup(yytext));
							return FIN;}
{prescribir}				{strcpy(yylval.str,strdup(yytext));
							return ESCRIBIR;}
{prleer}					{strcpy(yylval.str,strdup(yytext));
							return LEER;}
{constante}					{strcpy(yylval.str,strdup(yytext));
							sscanf(yytext, "%d", &yylval.num);
							return CONSTANTE;}
{identificador}				{strcpy(yylval.str,strdup(yytext));
							return IDENTIFICADOR;}
{errorcomun}				{nerrlex++;
							yyerror("Caracter incorrecto");}
{erroridentificador}		{nerrlex++;
							yyerror("Identificador mal formado");}
{errorconstante}			{nerrlex++;
							yyerror("Constante mal formada");}
{saltolinea}				++linea;
<<EOF>>						return EOF;
.							;
%%
