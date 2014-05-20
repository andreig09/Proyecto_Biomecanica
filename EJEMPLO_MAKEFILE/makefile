
#La línea .SUFFIXES declara los sufijos de los archivos cuyos cambios sigue make
.SUFFIXES: .o .cpp 
#la regla .cpp.o indica cómo obtener un archivo .o a partir de un archivo .cpp; 
.cpp.o:
	$(CC) -c $(CFLAGS) $< -o $@
#básicamente está diciendo: gcc -c -g -Wall -O2 <primer prerrequisito> -o <destino de la regla>

#------------------
#MACROS
#------------------
#Etiqueta que indica el tipo de compilador a utilizar
CC=g++
#Opciones del compilador, dejo para debbuger, para que me muestre más info al compilar....¿que es O2?.
CFLAGS= -g -Wall -O2
#LDFLAGS es una variable igual que CFLAGS, pero que le dice a las reglas implícitas qué 
#opciones usar para el linkeado. Si tenemos librerías en la subcarpeta \LIB dentro de directorio de make, debemos poner LDFLAGS=-L./LIB 
LDFLAGS=
SOURCES=./Funciones/DetectarBlobs/detectarBlobs.cpp ./Funciones/ColorFilter/colorFilter.cpp Source.cpp
OBJECTS=$(SOURCES:.cpp=.o)
EXECUTABLE=blobsTest


#Primera regla que tiene el makefile por lo tanto es la única que va a correr, claro si precisa compilar más cosas va a usar las reglas que vienen a continuación.
all: $(EXECUTABLE)

#------------------
#REGLAS EXPLICITAS:
#------------------    
$(EXECUTABLE): $(OBJECTS) 
	$(CC) $(LDFLAGS) $(OBJECTS) -o $(EXECUTABLE)
#la línea anterior es igual a poner: 
#	$(CC) $(LDFLAGS) $(OBJECTS) -o $@

#------------------
#REGLAS IMPLICITAS:
#------------------
#aquí se utiliza la regla de .cpp.o escrita arriba
#la línea siguiente solo sirve si todos los .c están el la misma carpeta que el makefile
#%.o: %.c
./Funciones/DetectarBlobs/detectarBlobs.o: ./Funciones/DetectarBlobs/detectarBlobs.cpp 
./Funciones/ColorFilter/colorFilter.o: ./Funciones/ColorFilter/colorFilter.cpp	
Source.o: Source.cpp ./Funciones/DetectarBlobs/detectarBlobs.h ./Funciones/ColorFilter/colorFilter.h

#------------------
#LIMPIEZA
#------------------
clean:
	rm $(EXECUTABLE) $(OBJECTS)
#.PHONY : clean
#	 clean :
#			-rm $(EXECUTABLE) $(OBJECTS)

##Lista de Variables automáticas
#·   $<. El nombre del primer prerrequisito.
#·   $*. En la definición de una regla implícita, tiene el valor correspondiente al texto que reemplaza el símbolo %.
#·   $?. El nombre de todos los prerrequisitos.
#·   $@. El nombre del archivo del objetivo(destino) de la regla.
