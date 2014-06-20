#intento generar un script que permita exportar la informacion de las camaras Blender

lista_info_cam = bpy.data.cameras.items()  #de esta manera obtengo un objeto LISTA donde cada componente es otro objeto LISTA de dos componentes, nombre y punto de acceso a la camara
lista_nombres = [] #genero esta LISTA para guardar los nombres de las camaras
lista_acceso = [] #genero esta LISTA para guardar los puntos de acceso de las camaras
for camara in lista_info_cam:
	 #para guardar al final de la lista utilizo el metodo APPEND del objeto LISTA
	lista_nombres.append(camara[0]) #guardo el nombre  en una LISTA
	lista_acceso.append(camara[1]) #me quedo solo con la segunda componente del objeto LISTA "camara", el cual contiene el punto de acceso a la misma.	
##Ahora que tengo los puntos de acceso voy a sacar los parametros que me interesan de cada camara
f=[]#LISTA con las distancias focales
f_unit=[]#unidades de cada componente en la LISTA anterior
shift_x=[]
shift_y=[]
sensor_width=[]
sensor_height=[]
tipo_vista=[]
for acceso in lista_acceso:
	f.append(acceso.lens)
	f_unit.append(acceso.lens_unit)
	shift_x.append(acceso.shift_x)
	shift_y.append(acceso.shift_y)
	sensor_width.append(acceso.sensor_width)
	sensor_height.append(acceso.sensor_height)
	tipo_vista.append(acceso.type)
	shift_y.append(acceso.shift_y)
	shift_y.append(acceso.shift_y)
	shift_y.append(acceso.shift_y)
	shift_y.append(acceso.shift_y)
	shift_y.append(acceso.shift_y)
T = []
lista_angles = []
for nombre in lista_nombres	
	C=bpy.data.objects[nombre].location
	T.append([C.x, C.y, C.z])
	angle=bpy.data.objects[nombre].rotation_euler
	if angle-pi<0.0001
		angle = pi
	lista_angles.append(angle)

	

	
	


