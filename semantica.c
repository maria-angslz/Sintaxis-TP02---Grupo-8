#include <stdio.h>
#include <string.h>
#include "parser.h"
char identificadores [50][32];
int t1 = 48, t2 = 49;
int Declarado(YYSTYPE id){
    int i=0;
    while(i<50){
        if (strcmp(id.str, identificadores[i]) == 0){
            return 1;
        }
        else i++;
    }
    return 0;
}
void Guardar(YYSTYPE id){
    int i=0;
    while(i<50) {
        if(identificadores[i][0] == '\0'){
            strcpy(identificadores[i],id.str);
            break;
        }
        i++;
    }
}
void Generar(char *operacion, char *op1, char *op2, char *op3){
    printf("%s %s,%s,%s\n",operacion, op1, op2, op3);
}
void Asignar(YYSTYPE id, YYSTYPE exp){
    Generar("Store",exp.str,id.str,"");
}
void Leer(YYSTYPE id){
    Generar("Read",id.str,"Integer","");
}
void Escribir(YYSTYPE exp){
    Generar("Write", exp.str,"Integer","");
}
void Declarar(YYSTYPE id){
    Generar("Declare",id.str,"Integer","");
}
void Sumar(YYSTYPE op1, YYSTYPE op2, YYSTYPE resul){
    Generar("SUM",op1.str,op2.str,resul.str);
}
void Restar(YYSTYPE op1, YYSTYPE op2, YYSTYPE resul){
    Generar("SUBS", op1.str, op2.str, resul.str);
}
void Multiplicar(YYSTYPE op1, YYSTYPE op2, YYSTYPE resul){
    Generar("MULT", op1.str, op2.str, resul.str);
}
void Dividir(YYSTYPE op1, YYSTYPE op2, YYSTYPE resul){
    Generar("DIV", op1.str, op2.str, resul.str);
}
void Invertir(YYSTYPE exp,YYSTYPE resul){
    Generar("INV", exp.str,"",resul.str);
}
void Terminar(){
    Generar("Stop","","","");
}
void Comenzar(){
    Generar("Load","rtlib","","");
}
void Chequear (YYSTYPE id) {
    if (!Declarado(id)) {
        Declarar(id);
        Guardar(id);
    }
}
void Guardar_temp(YYSTYPE id){
    int i=0;
    while(i<50) {
        if(identificadores[i][0] == '\0'){
            strcpy(identificadores[i],id.str);
            break;
        }
        i++;
    }
}
YYSTYPE Generar_temp(){
    if(t2 == 58){
        t2 = 48;
        t1++;
    }
    YYSTYPE temp = {{'T','e','m','p','&',t1,t2},0};
    t2++;
    Declarar(temp);
    return temp;
}
YYSTYPE Inv(YYSTYPE op,YYSTYPE exp){
    YYSTYPE temp = Generar_temp();
    Invertir(exp, temp);
    return temp;
}
YYSTYPE Gen_infijo(YYSTYPE exp1,YYSTYPE op,YYSTYPE exp2){
    YYSTYPE temp = Generar_temp();
    switch(op.str[0]){
        case 42: Multiplicar(exp1,exp2,temp);
        break;
        case 43: Sumar(exp1,exp2,temp);
        break;
        case 45: Restar(exp1,exp2,temp);
        break;
        case 47: Dividir(exp1,exp2,temp);
    }
    return temp;
}
