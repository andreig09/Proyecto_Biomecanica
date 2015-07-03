#!/bin/bash 
echo "Ingresar el numero de sujeto de la base CMU: " 
read sujeto 
echo "Ingresar el nombre de la secuencia" 
read secuencia 

directorio="Sujeto_CMU_"$sujeto"/"$sujeto"_"$secuencia

#genero si es necesario las carpetas para trabajar
mkdir -p $directorio
Datos_Imagen=$directorio/Datos_Imagen
mkdir -p $Datos_Imagen
Datos_Procesados=$directorio/Datos_Procesados
mkdir -p $Datos_Procesados
Ground_Truth=$directorio/Ground_Truth
mkdir -p $Ground_Truth
#dejo pronto los archivos para ajustar el modelo y generar los renderizados
archivo_blend="CMU_"$sujeto"_"$secuencia".blend"
path_blend=$directorio"/Datos_Imagen/"$archivo_blend
cp CMU_modelo.blend $path_blend

echo "¿Desea ingresar una armadura bvh?(S/N) "
read ingresarbvh
if [[ $ingresarbvh=="S" ]]; 
then
	echo "Ingresar la ubicación del archivo: "
	read filepath_bvh	
	#importación del esqueleto a blender
	blender --background  $path_blend --python import_bvh.py -- $filepath_bvh $path_blend
	blender --background  $path_blend --python acoplar_modelo.py
	cp $archivo_blend $path_blend
	cp Info_Blender.xml $Datos_Imagen"/Info_Blender.xml"
	cp Informacion_del_Modelo.txt $Datos_Imagen"/Informacion_del_Modelo.txt"
	rm $Datos_Imagen"/"$archivo_blend"1"
	rm $archivo_blend
	rm Info_Blender.xml
	rm Informacion_del_Modelo.txt
else
	#habilito la opción de importación de archivo bvh
	blender --background  $archivo_blend --python import_bvh.py -- 0
fi