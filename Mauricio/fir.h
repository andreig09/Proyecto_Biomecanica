//-------------------------------------------------------------------------------------------------
//	Definición MACROS.																		 
//-------------------------------------------------------------------------------------------------
#define TAP_LENGTH	6 // Definimos el orden del filtro.
#define PI 3.141592653589
//#define TAM_MUESTRA 	100	// Definimos el tama�o de la muestra.
//-------------------------------------------------------------------------------------------------

// Deja de meter tanto comentario, es demasiado prolijo y nos haces paarecer vagos. Gonzalo. Aca agrego un pedazo sobre algo que escribio GO, un negro. M



//-------------------------------------------------------------------------------------------------
//	Definición tipos.																		 
//-------------------------------------------------------------------------------------------------
//typedef double t_muestra;//ACA CAMBIAR ALGO PARA CORRERLO LUEGO EN DSP!!!!!!!!!!
typedef _fract t_muestra;//ACA CAMBIAR ALGO PARA CORRERLO LUEGO EN DSP!!!!!!!!!!
//-------------------------------------------------------------------------------------------------
						
//-------------------------------------------------------------------------------------------------
//	Declaración funciones.																	 
//-------------------------------------------------------------------------------------------------
void fir_ini(void);
t_muestra fir_filtrar(t_muestra x);
//-------------------------------------------------------------------------------------------------

