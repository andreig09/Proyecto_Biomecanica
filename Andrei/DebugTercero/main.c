/* 
 * File:   main.c
 * Author: andrei
 *
 * Created on 15 de noviembre de 2013, 09:07 PM
 */

#include <stdio.h>
#include <stdlib.h>

typedef struct{
    char* name;
    char sexo;
    int edad;
} persona;

persona* crear_persona(char* name, char sexo, int edad); 

int main() {
    persona *p1 = crear_persona("Juan",'M',300);
    
    int edad = p1->edad;
    
    printf("edad: %d\n", edad);
    
    return 0;
    
}

persona* crear_persona(char* name, char sexo, int edad){
    persona *p1 = NULL;
    if ((edad >= 0) && (edad<100)){
        p1=malloc(sizeof (persona));
        p1->name = name;
        p1->sexo = sexo;
        p1->edad = edad;
    }
    return p1;
    
}
