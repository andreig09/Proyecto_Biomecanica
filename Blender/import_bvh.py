#Se debe ingresar la ubicación del archivo .bvh a importar. 
#EJEMPLO: blender --background ARCHIVO.blend --python import_bvh.py -- FILEPATH_BVH 
import bpy
import sys#se agrega para poder manejar parametros de entrada, los mismos se deben colocar a continuación del nombre del script python y después de "-- ", observar que el último caracter es un espacio en blanco. Los parametros van separados de espacios

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
#############################################

#habilito la importación de archivos .bvh
#bpy.ops.wm.addon_enable(module="io_anim_bvh")

#se debe ingresar el archivo bvh con los parametros global_scale=0.06 si provienen de la base de datos MotionBuilder-friendly version de cgspeed.
#además para que el frame rate sea correcto se debe tener use_fps_sclae=True

if params[0] !=0: #si el primer parametro de entrada es dinstinto de cero
    #bpy.ops.import_anim.bvh(filepath="", filter_glob="*.bvh", target='ARMATURE', global_scale=0.06, frame_start=1, use_fps_scale=True, use_cyclic=False, rotate_mode='NATIVE', axis_forward='-Z', axis_up='Y')
    bpy.ops.import_anim.bvh(filepath=params[0], filter_glob="*.bvh", target='ARMATURE', global_scale=0.06, frame_start=1, use_fps_scale=True, use_cyclic=False, rotate_mode='NATIVE', axis_forward='-Z', axis_up='Y')
    #llevo la secuencia al frame 1
    bpy.data.scenes["Scene"].frame_current=1
    #guardo la salida
    bpy.ops.wm.save_mainfile(filepath=params[1], check_existing=True, filter_blender=True, filter_backup=False, filter_image=False, filter_movie=False, filter_python=False, filter_font=False, filter_sound=False, filter_text=False, filter_btx=False, filter_collada=False, filter_folder=True, filemode=8, display_type='FILE_DEFAULTDISPLAY', compress=False, relative_remap=False)