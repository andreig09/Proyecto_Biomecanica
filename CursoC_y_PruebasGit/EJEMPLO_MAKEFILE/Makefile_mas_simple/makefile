
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
SOURCES=detectarBlobs.cpp colorFilter.cpp Source.cpp
OBJECTS=$(SOURCES:.cpp=.o)
EXECUTABLE=blobsTest


#Primera regla que tiene el makefile por lo tanto es la única que va a correr, claro si precisa compilar más cosas va a usar las que viene a continuación.
all: $(EXECUTABLE)
#------------------
#Reglas Explícitas:
#------------------    
$(EXECUTABLE): $(OBJECTS) 
#	$(CC) $(LDFLAGS) $(OBJECTS) -o $(EXECUTABLE)
#la línea anterior es igual a poner: 
	$(CC) $(LDFLAGS) $(OBJECTS) -o $@
#------------------
#Reglas Implícitas
#------------------
%.o: %.c

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
