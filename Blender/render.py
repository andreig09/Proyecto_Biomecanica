#Este Script permite renderizar automaticamente las camaras de un archivo blender. 
#Ejemplo blender --background ARCHIVO.blend --python render.py 
import bpy
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
######################################################


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
#########################################################


nombre_archivo = bpy.path.display_name_from_filepath(bpy.context.blend_data.filepath)
#genero carpeta con nombre de archivo y resolución de renderizado
res_x = bpy.data.scenes["Scene"].render.resolution_x
res_y = bpy.data.scenes["Scene"].render.resolution_y
path = '//' + '/' + str(res_x) + '_' + str(res_y)  + '-' + str(frame_map_old) + ':' + str(frame_map_new) + '/cam'
current_path = os.getcwd()
path2 = current_path +'/' + str(res_x) + '_' + str(res_y)  + '-' + str(frame_map_old) + ':' + str(frame_map_new) #en esta dirección se debe ubicar el Leanme.txt

#obtengo las camaras
cams = bpy.data.cameras
#obtengo los nombres de las camaras
lista_nombres = cams.keys()
bpy.data.scenes['Scene'].render.use_file_extension = False#se desabilita que blender agregue información al nombre del archivo
for i in range(0,len(cams)):
    #bpy.context.scene.camera = bpy.data.objects[cams[i].name]
    bpy.context.scene.camera = bpy.data.objects[lista_nombres[i]]
    #obtengo los nombres de las camaras
    pos_punto = lista_nombres[i].find('.')
    nombre = lista_nombres[i][pos_punto+1:]
    bpy.data.scenes["Scene"].render.filepath = path + nombre
    texto = 'Renderizando cámara: ' + nombre
    print(texto)
    bpy.ops.render.render(animation=True)

    
with open(path2 + "/Leanme.txt", "w") as file: 
    file.write("Parámetros básicos utilizados en el renderizado de los videos de la carpeta actual.\n\n")
    file.write("resolution_x = "+repr(resolution_x) +";\n")
    file.write("resolution_y = "+repr(resolution_y) +";\n")
    file.write("pixel_aspect_x = "+repr(pixel_aspect_x) +";\n")
    file.write("pixel_aspect_y = "+repr(pixel_aspect_y) +";\n")
    file.write("frame_start = "+repr(frame_start) +";\n")    
    file.write("frame_end = "+repr(frame_end) +";\n")    
    file.write("frame_map_old = "+repr(frame_map_old) +";\n")    
    file.write("frame_map_new = "+repr(frame_map_new) +";\n\n") 
    file.write("El resto de los parámetros de interés se encuentran en el archivo InfoCamBlender.m \n\n") 
    file.close()
