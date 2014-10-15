import bpy


n_camaras = 17


nombre_archivo = bpy.path.display_name_from_filepath(bpy.context.blend_data.filepath)

res_x = bpy.data.scenes["Scene"].render.resolution_x
res_y = bpy.data.scenes["Scene"].render.resolution_y
path = '//' + nombre_archivo + '/' + str(res_x) + '_' + str(res_y)  + '/cam'

i = 1

while i <= n_camaras:
    if i < 10:
        str_cam = 'Camera.0' + str(i)
    else:
        str_cam = 'Camera.' + str(i)
        
    bpy.context.scene.camera = bpy.data.objects[str_cam]
    bpy.data.scenes["Scene"].render.filepath = path + str(i)
    
    texto = 'Renderizando cámara: ' + str(i)
    print(texto)
    bpy.ops.render.render(animation=True)
    i=i+1
