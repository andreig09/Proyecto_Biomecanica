#include "fir.h"

//-------------------------------------------------------------------------------------------------
//	Declaracion de variables.								 									 
//-------------------------------------------------------------------------------------------------
//static t_muestra h[TAP_LENGTH]={ 4 , 1 , 1 , -4 , -1 , -1}; // Array que contiene los coeficientes del filtro.
//static t_muestra h[TAP_LENGTH]={ -0.929412,-0.952941,-0.952941,-0.992157,-0.968627,-0.968627,}; // Array que contiene los coeficientes del filtro.
static t_muestra h[TAP_LENGTH]={ 1,0.25,0.25,-1,-0.25,-0.25}; // Array que contiene los coeficientes del filtro.
static t_muestra estado[TAP_LENGTH];		
static t_muestra *ptr_estado = estado;
//-------------------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------------------
//	Inicialización del FIR.									 		   							 
//-------------------------------------------------------------------------------------------------
void fir_ini(void){
	int i;			

	// Definimos cada uno de los coeficientes.
	for(i=0; i<	TAP_LENGTH; i++){
		
		estado[i] = 0.0;					// Limpiamos el buffer de estado.
  	}
}
//-------------------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------------------
//	Filtrado.																				 	 
//-------------------------------------------------------------------------------------------------
t_muestra fir_filtrar(t_muestra x){
	static int k;							// Indice de la sumatoria de la convolución.
	static t_muestra y;						// Variable para devolver el resultado de cada muestra.							

	if((ptr_estado - estado) > (TAP_LENGTH-1)) ptr_estado = estado; 	// Si llegamos al principio del 
																		// buffer lo apuntamos al último elemento.
	*ptr_estado = x;						// Colocamos en el buffer circular el elemento mas nuevo.

	y = 0;									// Inicializamos en cero la salida.
   	for(k=0; k<TAP_LENGTH; k++){			// Hacemos la convolución de la señal de entrada con los
		y += h[k] * (*ptr_estado);  		// coeficientes del filtro.
		ptr_estado--;						// Apuntamos al próximo elemento.
		if(ptr_estado < estado) ptr_estado = estado + TAP_LENGTH-1; 	// Si llegamos al principio del  
																		// buffer apuntamos al último elemento.
    }
	ptr_estado++;														// Quedamos apuntando al primero vacío.
	return y;
}
//-------------------------------------------------------------------------------------------------
