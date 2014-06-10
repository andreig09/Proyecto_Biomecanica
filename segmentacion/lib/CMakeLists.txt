#La idea es crear una librería dinamica que contenga todas las fuentes
SET(roof_lib_src ColorFilter.cpp funcionesAuxiliares.cpp otsu.cpp detectarBlobs.cpp getThreshold.cpp) 

INCLUDE_DIRECTORIES(
  ../include 
 )

ADD_LIBRARY(libreria_prueba SHARED ${roof_lib_src})





