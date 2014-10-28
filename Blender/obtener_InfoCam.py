#Script que permita exportar la informacion de las camaras Blender
#Se debe ingresar el directorio donde se desea InfoCamBlender.m
#Ejemplo: blender --background ARCHIVO.blend --P obtener_InfoCam.py -- /home/sun/datos
import bpy #modulo de Blender para el interprete python
import os #nos permite acceder a funcionalidades dependientes del Sistema Operativo
import sys#se agrega para poder manejar parametros de entrada, los mismos se deben colocar a continuación del nombre del script
# Get script parameters:
# all list items after the last occurence of "--"
print()
print(sys.argv)
print()

try:
    args = list(reversed(sys.argv))
    idx = args.index("--")

except ValueError:
    params = []

else:
    params = args[:idx][::-1]

print("Script params:", params)





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
scene = bpy.data.scenes["Scene"]
resolution_x=scene.render.resolution_x
resolution_y=scene.render.resolution_y
pixel_aspect_x=scene.render.pixel_aspect_x
pixel_aspect_y=scene.render.pixel_aspect_y
frame_start = scene.frame_start
frame_end = scene.frame_end
frame_map_old = scene.render.frame_map_old#con este parámetro y el que sigue se puede ingresar o sacar frames en los videos respecto a las tomas originales del bvh
frame_map_new = scene.render.frame_map_new
###################################################################
#Preparacion para imprimir en archivo
#dir_actual = os.getcwd()
dir_destino = params[-1]#tomo el último parámetro el cual debe ser la carpeta donde se desea el archivo InfoCamBlender. 
#A continuacion en la carpeta donde se encuentre el script creo o sobreescribo el archivo InfoCamBlender.m
with open(dir_destino + "/InfoCamBlender.m", "w") as file: 
#with open(dir_actual + "/InfoCamBlender.m", "w") as file: #lo anterior es equivalente a efectuar 
#file = open(dir_actual + "/InfoCamBlender.txt", "w") #pero supuestamente es una buena practica hacerlo de esta manera
    file.write("%%PARAMETROS DE CAMARAS BLENDER\n\n")
    file.write("n_cams = "+ repr(len(T)) +"; %Numero de camaras\n\n")
    file.write("%Parametros Extrinsecos\n")
    file.write("%Matriz con los centros de las camaras. T(:,i) indica las coordenadas correspondientes a camara i\n")
    file.write("T =[...\n" )
    for centro in T[0:-1]: #para todos los valores desde indice 0 hasta final, menos el ultimo.
        file.write("\t" +repr(centro) +"'...\n" )
    
    file.write("\t" +repr(T[-1]) + "'...\n];\n\n")
    file.write("%Matriz con los angulos de las camaras. angles(:,i) indica los angulos correspondientes a camara i en el orden " + lista_angles[0].order + "\n")
    file.write("angles =[...\n")
    for angle in lista_angles[0:-1]:#para todos los XYZ desde el primero hasta final, menos el ultimo
        file.write("\t[" +repr(angle.x) +", " +repr(angle.y) +", " +repr(angle.z) +"]'...\n" )
    
    file.write("\t[ " +repr(lista_angles[-1].x)  +", " +repr(lista_angles[-1].y)  +", "+ repr(lista_angles[-1].z) +"]'...\n];\n\n")    
    file.write("%Matrices de rotación \n")  
    num_cam=1
    file.write("R=zeros(3, 3, n_cams);% Array de matrices para guardar en tercera dimension las rotaciones de cada camara\n\n")
    for angle in lista_angles:
        file.write("%matriz de rotacion y cuaternion asociado a la camara "+repr(num_cam)+"\n")
        matrix_rotation = angle.to_matrix()
        file.write("R(:,:," +repr(num_cam) +")= [...\n")
        for fila in matrix_rotation[0:-1]: #cada fila es un vector por lo que puedo imprimir igual que antes
            file.write("\t" +repr(fila.x) +", " +repr(fila.y) +", " +repr(fila.z) +";...\n" )
        fila=matrix_rotation[-1]
        file.write("\t" +repr(fila.x) +", " +repr(fila.y) +", "  +repr(fila.z) +"...\n];\n") 
        quaternion  = angle.to_quaternion()
        file.write("q" +repr(num_cam) +" = [" +repr(quaternion[0]) +", " +repr(quaternion[1]) +", " +repr(quaternion[2]) +", " +repr(quaternion[3]) +"];\n\n")
        
        num_cam=num_cam+1 #incremento nro de camara
    
      
    file.write("\n")
    file.write("\n%Parametros Intrinsecos\n")
    file.write("t_vista ={")
    for elemento in tipo_vista:
        file.write(repr(elemento) + "  ")
        
    file.write("};")
    file.write("% tipo de vista utilizado en cada camara\n")
    file.write("f="+repr(f)+";")
    file.write("% Vector con las distancias focales unidades en ("+f_unit[1]+")\n")
    file.write("shift_x = "+repr(shift_x)+";\n")
    file.write("shift_y = "+repr(shift_y)+";")
    file.write("% Corrimientos horizontales y verticales del centro de la camara \n")
    file.write("sensor_height = "+repr(sensor_height)+";")
    file.write("%Largo, ancho y tipo de ajuste utilizado para el sensor\n")
    file.write("sensor_width = "+repr(sensor_width)+";\n")
    file.write("sensor_fit = {")
    for elemento in sensor_fit:
        file.write(repr(elemento) + "  ")
        
    file.write("};")
    file.write("% En modo Auto ajusta la anchura o largura del sensor en función de la resolución \n%Este parametro nos dice que dimension del sensor se va a usar por completo dada la resolucion del renderizado")
    
    
    file.write("\n\n%Datos del renderizado Blender\n")
    file.write("resolution_x = "+repr(resolution_x) +"*ones(1, length(f));\n")
    file.write("resolution_y = "+repr(resolution_y) +"*ones(1, length(f));\n")
    file.write("pixel_aspect_x = "+repr(pixel_aspect_x) +";%si estos dos valores son iguales el pixel es cuadrado\n")
    file.write("pixel_aspect_y = "+repr(pixel_aspect_y) +";\n")
    file.write("frame_start = "+repr(frame_start) +";\n")    
    file.write("frame_end = "+repr(frame_end) +";\n")    
    file.write("frame_map_old = "+repr(frame_map_old) +";\n")    
    file.write("frame_map_new = "+repr(frame_map_new) +";\n\n")    
    
    file.write("%Ajustes finales\n")
    file.write("sensor = [sensor_width; sensor_height]; %Agrupo el ancho y largo del sensor en un solo vector\n")
    file.write("resolution = [resolution_x; resolution_y]; %agrupo resoluciones en un solo vector\n")
    file.write("str='q=[q1';\n")
    file.write("for i=2:n_cams %genero un comando que agrupe todos los cuaterniones\n")
    file.write("    str = sprintf('%s;q%d', str, i);\n")
    file.write("end\n")
    file.write("str = [str, '];'];\n")
    file.write("eval(str);\n")
    file.write("q=quaternion(q); %transformo en tipo de dato cuaternion\n")
    file.write("Rq=RotationMatrix(q);%Obtengo las matrices de rotación a partir de los cuaterniones. R(:,:,i) es la matriz de rotación de la camara i")        
file.close()
    


	

	
	


