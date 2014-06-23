#Script que permita exportar la informacion de las camaras Blender
import bpy #modulo de Blender para el interprete python
import os #nos permite acceder a funcionalidades dependientes del Sistema Operativo
lista_info_cam = bpy.data.cameras.items()  #de esta manera obtengo un objeto LISTA donde cada componente es otro objeto LISTA de dos componentes, 1-nombre y 2-punto de acceso a la camara
lista_nombres = [] #genero esta LISTA para guardar los nombres de las camaras
lista_acceso = [] #genero esta LISTA para guardar los puntos de acceso de las camaras
for camara in lista_info_cam:
	 #para guardar al final de la lista utilizo el metodo APPEND del objeto LISTA
	lista_nombres.append(camara[0]) #guardo el nombre  en una LISTA
	lista_acceso.append(camara[1]) #me quedo solo con la segunda componente del objeto LISTA "camara", el cual contiene el punto de acceso a la misma.	

##Ahora que tengo los puntos de acceso voy a sacar los parametros que me interesan de cada camara
#########################################
#Obtener Parametros intrinsecos
f=[]#LISTA con las distancias focales
f_unit=[]#unidades de cada componente en la LISTA anterior
shift_x=[]
shift_y=[]
sensor_width=[]
sensor_height=[]
sensor_fit = []
tipo_vista=[]
for acceso in lista_acceso:
    f.append(acceso.lens)
    f_unit.append(acceso.lens_unit)
    shift_x.append(acceso.shift_x)
    shift_y.append(acceso.shift_y)
    sensor_width.append(acceso.sensor_width)
    sensor_height.append(acceso.sensor_height)
    sensor_fit.append(acceso.sensor_fit)
    tipo_vista.append(acceso.type)
#################################
#Obtener Parametros extrinsecos	
T = []
lista_angles = []
for nombre in lista_nombres:	
	C=bpy.data.objects[nombre].location
	T.append([C.x, C.y, C.z])
	angle=bpy.data.objects[nombre].rotation_euler#tiene tres componentes angulo y un string con el orden de los angulos. EJ: "XYZ".
	lista_angles.append(angle)#me quedo con las tres primeras componentes de la lista angle
###########################################################
#Datos del renderizado
resolution_x=bpy.data.scenes["Scene"].render.resolution_x
resolution_y=bpy.data.scenes["Scene"].render.resolution_y
pixel_aspect_x=bpy.data.scenes["Scene"].render.pixel_aspect_x
pixel_aspect_y=bpy.data.scenes["Scene"].render.pixel_aspect_y
frame_start = bpy.data.scenes["Scene"].frame_start
frame_end =bpy.data.scenes["Scene"].frame_end
###################################################################
#Preparacion para imprimir en archivo
dir_actual = os.getcwd()
#A continuacion en la carpeta donde se encuentre el script creo o sobreescribo el archivo InfoCamBlender.m
with open(dir_actual + "/InfoCamBlender.m", "w") as file: #lo anterior es equivalente a efectuar 
#file = open(dir_actual + "/InfoCamBlender.txt", "w") #pero supuestamente es una buena practica hacerlo de esta manera
    file.write("%%PARAMETROS DE CAMARAS BLENDER\n\n")
    file.write("%Parametros Extrinsecos\n")
    file.write("%Matriz con los centros de las camaras. T(:,i) indica las coordenadas correspondientes a camara i\n")
    file.write("T =...\n" )
    for centro in T[0:-1]: #para todos los valores desde indice 0 hasta final, menos el ultimo.
        file.write( repr(centro) +"'+...\n" )
    
    file.write( repr(T[-1]) + "';\n\n")
    file.write("%Matriz con los angulos de las camaras. angles(:,i) indica los angulos correspondientes a camara i en el orden " + lista_angles[0].order + "\n")
    file.write("angles = ...\n")
    for angle in lista_angles[0:-1]:#para todos los XYZ desde el primero hasta final, menos el ultimo
        file.write("["+repr(angle[0]) +", " +repr(angle[1]) +", " +repr(angle[2]) +"]'+...\n" )
    
    file.write("["+repr(lista_angles[-1][0])  +", " +repr(lista_angles[-1][1])  +", "+ repr(lista_angles[-1][0]) +"]';\n\n")    
    file.write("%Matrices de rotación \n")  
    num_cam=1
    for angle in lista_angles:
        file.write("%matriz de rotacion y cuaternion asociado a la camara "+repr(num_cam)+"\n")
        matrix_rotation = angle.to_matrix()
        file.write("R" +repr(num_cam) +"= [...\n")
        for fila in matrix_rotation[0:-1]: #cada fila es un vector por lo que puedo imprimir igual que antes
            file.write(repr(fila[0]) +", " +repr(fila[1]) +", " +repr(fila[2]) +";...\n" )
        file.write(repr(fila[0]) +", " +repr(fila[1]) +", "  +repr(fila[2]) +"];\n") 
        quaternion  = angle.to_quaternion()
        file.write("q" +repr(num_cam) +" = [" +repr(quaternion[0]) +", " +repr(quaternion[1]) +", " +repr(quaternion[2]) +"]';\n\n")
        num_cam=num_cam+1 #incremento nro de camara
    
        
    file.write("\n")
    file.write("\n%Parametros Intrinsecos\n")
    file.write("t_vista ="+repr(tipo_vista) +";")
    file.write("% tipo de vista utilizado en cada camara\n")
    file.write("f="+repr(f)+";")
    file.write("% Vector con las distancias focales unidades en ("+f_unit[1]+")\n")
    file.write("shift_x = "+repr(shift_x)+";\n")
    file.write("shift_y = "+repr(shift_y)+";")
    file.write("% Corrimientos horizontales y verticales del centro de la camara \n")
    file.write("sensor_height = "+repr(sensor_height)+";")
    file.write("%Largo, ancho y tipo de ajuste utilizado para el sensor\n")
    file.write("sensor_width = "+repr(sensor_width)+";\n")
    file.write("sensor_fit = "+repr(sensor_fit)+";")
    file.write("% En modo Auto ajusta la anchura o largura del sensor en función de la resolución \n%Este parametro nos dice que dimension del sensor se va a usar por completo dada la resolucion del renderizado")
    
    file.write("\n%Datos del renderizado Blender\n")
    file.write("resolution_x = "+repr(resolution_x) +";\n")
    file.write("resolution_y = "+repr(resolution_y) +";\n")
    file.write("pixel_aspect_x = "+repr(pixel_aspect_x) +";%si estos dos valores son iguales el pixel es cuadrado\n")
    file.write("pixel_aspect_y = "+repr(pixel_aspect_y) +";\n")
    file.write("frame_start = "+repr(frame_start) +";\n")    
    file.write("frame_end = "+repr(frame_end) +";\n")    
        
file.close()
    


	

	
	


