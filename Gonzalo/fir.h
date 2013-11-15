#define TAP_length 4 // # de coefs del filtro
#define SIGNAL_length 10 // # de muestras.

typedef float sample_t;

void ini_fir(sample_t coefs[]);

sample_t fir(sample_t muestra);

void update_p(int paso);
