#include <stdio.h>
#include <stdlib.h>
#define FILENAME "Lena.pgm" //si se quiere abrir otro archivo ponerlo acá
#define FILENAME2 "salida.pgm"

int main(int argc, char** argv) {
    typedef struct{
	FILE *file;   
        char magic_number[2];
	int width;
        int height;
        int depth;
        int** matrix; //contiene la matrix de puntos de la imagen
    } Pgm_file;

    Pgm_file image;

	//Abro el archivo en modo solo de lectura
    //Y compruebo que el archivo se abrió correctamente
    if ( (image.file = fopen(FILENAME,"r")) == NULL ){
		printf("No se pudo abrir %s\n",FILENAME);
	}
    else{
		printf("El archivo %s se abrió con éxito.\n", FILENAME);
	}

	//Primero voy a leer el "número mágico"
	fscanf(image.file, "%s", image.magic_number);
	//printf("%s", image.magic_number);
	//Leo el nro de filas, el nro de columnas y máximo nivel de gris
	fscanf(image.file, "%d", &image.width); //acordarse que lo que se pasa a scanf es la dirección de memoria que ocupa la variable
	//printf("%d\n", image.width);
	fscanf(image.file, "%d", &image.height);
	//printf("%d\n", image.height);
	fscanf(image.file, "%d", &image.depth);
	//printf("%d\n", image.depth);

	//Genero una matriz dinámica de 2 dimensiones, porque esto, pues recién aquí se el tamaño de la image
	//Primero asignar memoria para cada una de las filas.
	image.matrix = (int **) malloc (image.height*sizeof(int *));
	//printf("%d", image.height*sizeof(int *));
	
	//Luego para cada fila decir que cantidad de columnas tengo
	int i;
	for (i=0;i<image.height;i++)
		image.matrix[i] = (int *) malloc (image.width*sizeof(int));
	
	//Empiezo a leer los datos y rellenar la matrix
	//con el indice "i" voy a seguir las filas
	int j; //con este indice voy a seguir las columnas
	for(i=0; i<image.height; i++){
		for(j=0; j<image.width; j++){
			fscanf(image.file, "%d", &image.matrix[i][j]); //Observar que aquí image.matrix[i][j] ya apunta al lugar de memoria no preciso &
                }
	}

	fclose(image.file); //cierro el archivo
	/////////////////////////////////////////////////////////////////////
	
	//Voy a imprimir la matriz en otro archivo para ver que valor guardó
	FILE *file_out;
	if ( (file_out= fopen(FILENAME2,"w")) == NULL ){
		printf("No se pudo abrir %s\n",FILENAME2);
	}
       else{
		printf("El archivo %s se abrió con éxito.\n", FILENAME2);
	}

	//Primero le pongo los encabezados
	fprintf(file_out, "%s\n", image.magic_number);
	fprintf(file_out, "%d %d\n", image.width, image.height);
	fprintf(file_out, "%d\n", image.depth);
	
	for(i=0; i<image.height; i++){
		for(j=0; j<image.width; j++){
			fprintf(file_out, "%d ", image.matrix[i][j]); //Observar que aquí image.matrix[i][j] ya apunta al lugar de memoria no preciso &			
		}
		fprintf(file_out, "\n");
	}
	fclose(file_out);

    return (EXIT_SUCCESS);
}
