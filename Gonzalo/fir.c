#include <stdio.h>
#include "fir.h"

sample_t coeficientes[TAP_length]; 
sample_t buffer_ent[TAP_length];

//prueba de comentario gonzalo

int p; //puntero a una muestra. Apunta a la ultima muestra ingresada

void ini_fir(sample_t coefs[]){ //inicializo los coeficientes del filtro, y el buffer de entrada en 0.
	int i;
	for (i=0; i<TAP_length; i++){
		coeficientes[i]=coefs[i];
		buffer_ent[i]=0;
	}
	p=0;
}

void update_p(int paso){
	if (p+paso < 0){ // por si estas yendo para atras y te pasas de 0
		p= TAP_length + p + paso; 
	} else if (p+paso > TAP_length - 1) {
		p = p + paso - TAP_length; //por si estas yendo para adelante y te pasas de tap_length-1
	} else {
		p = p+paso;
	}	
}

sample_t fir(sample_t muestra){
	buffer_ent[p] = muestra;
	int i;
	sample_t muestra_out = 0;
	for (i=0;i<TAP_length;i++){
		muestra_out = muestra_out + coeficientes[TAP_length - i - 1]*buffer_ent[p];
		update_p(1);
	}
	update_p(1);
	return muestra_out;
}
