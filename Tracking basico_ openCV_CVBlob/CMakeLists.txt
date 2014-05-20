#PROJECT: asigna un nombre que identifica al proyecto. 
#Ahora los ficheros del proyecto podrán referirse 
#al directorio fuente raíz del proyecto como ${NOMBREPROYECTO_SOURCE_DIR} 
#y al directorio binario raíz del proyecto como ${NOMBREPROYECTO_BINARY_DIR}

PROJECT(PRUEBA)

#CMAKE_MINIMUM_REQUIRED: Establece una versión mínima de cmake para poder
#generar el proyecto. Si no se especifica puede que cmake nos muestre algún warning al intentar configurar el proyecto.

CMAKE_MINIMUM_REQUIRED(VERSION 2.6)

FIND_PACKAGE( OpenCV REQUIRED )
FIND_PACKAGE(cvBlob REQUIRED ) 

 
#ADD_SUBDIRECTORY: Permite añadir los subdirectorios donde se localizan los archivos fuente para compilar así como el subdirectorio donde se pondrán los archivos objeto. Antes de procesar el directorio actual, se procesara cada uno de los subdirectorios indicado. Toda variable definida en el directorio padre mantendra su valor para cada uno de los CMakeLists.txt de sus subdirectorios indicados. Sin embargo, es conveniente evitar depender demasiado de dichas variables, ya que generan dependencias innecesarias.

ADD_SUBDIRECTORY(lib)
ADD_SUBDIRECTORY(client)


#INCLUDE_DIRECTORIES: Permite insertar directorios para los include.
#Mediante esta variable se pueden añadir nuevas rutas para buscar los
#ficheros .h. Si se hace uso de una sentencia #include <name.h> #debería de encontrarse el fichero name.h o bien en una ruta del #sistema (usualmente: /usr/include/, /usr/local/include, . . . ) o bien #en una ruta asignada a esta variable. 
#Lo importante de recordar es que aparentemente en cualquier directorio donde se compile un archivo fuente que precise un fichero.h
#se debe incluir las directivas que indiquen donde están esos archivos fichero.h, o sea que parece que la directiva #INCLUDE_DIRECTORIES no se hereda de directorio padre a directorio hijo.

INCLUDE_DIRECTORIES(
  /usr/local/include
  ${OpenCV_INCLUDE_DIRS} 
  ${cvBlob_INCLUDE_DIRS} 
  include
#La directiva anterior es igual a    ${PRUEBA_SOURCE_DIR} /include 
   lib
)


#LINK_DIRECTORIES: Permite insertar directorios en donde buscar las librerias. Mediante esta variable se pueden añadir nuevas rutas para #buscar las librerias. ¿Se hereda esta directiva?

LINK_DIRECTORIES(
${OpenCV_LIB_DIR}

)

#Esta es la manera de escribir mensajes cuando se ejecuta el Cmake
MESSAGE(directorios_incluidos  ${cvBlob_LIBS}  )	






