SET(roof_client_src Source.cpp)

#INCLUDE_DIRECTORIES: Permite insertar directorios para los include.
#Mediante esta variable se pueden añadir nuevas rutas para buscar los
#ficheros .h. Si se hace uso de una sentencia #include <name.h> #debería de encontrarse el fichero name.h o bien en una ruta del #sistema (usualmente: /usr/include/, /usr/local/include, . . . ) o bien #en una ruta asignada a esta variable. 
#Lo importante de recordar es que aparentemente en cualquier directorio donde se compile un archivo fuente que precise un fichero.h
#se debe incluir las directivas que indiquen donde están esos archivos fichero.h, o sea que parece que la directiva #INCLUDE_DIRECTORIES no se hereda de directorio padre a directorio hijo.

INCLUDE_DIRECTORIES(
  ${PRUEBA_SOURCE_DIR}/include 
)



ADD_EXECUTABLE(Source ${roof_client_src})

TARGET_LINK_LIBRARIES(Source libreria_prueba ${OpenCV_LIBS} ${cvBlob_LIBS})