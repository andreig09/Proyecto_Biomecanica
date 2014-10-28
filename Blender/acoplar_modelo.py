#La idea de este script es automatizar la colocación de los marcadores en el esqueleto modelo.

#!/usr/local/bin/python2.7
import bpy
import os

D = bpy.data
C = bpy.context


#color changing code from http://wiki.blender.org/index.php/Dev:2.5/Py/Scripts/Cookbook/Code_snippets/Materials_and_textures

def makeMaterial(name, diffuse, specular, alpha):
	mat = bpy.data.materials.new(name)
	mat.diffuse_color = diffuse
	mat.diffuse_shader = 'LAMBERT'
	mat.diffuse_intensity = 1.0
	mat.specular_color = specular
	mat.specular_shader = 'COOKTORR'
	mat.specular_intensity = 1.0 
	mat.alpha = alpha
	mat.ambient = 1
	mat.emit = 1#que emita luz	
	return mat

def setMaterial(ob, mat):
	me = ob.data
	me.materials.append(mat)

#cleaning the scene from http://wiki.blender.org/index.php/Dev:2.5/Py/Scripts/Cookbook/Code_snippets/Interface
#bpy.ops.object.select_by_type(type=’MESH’)
#bpy.ops.object.delete()

white = makeMaterial('White',(1,1,1),(1,1,1),1)
marker_radius = 0.014#unidades en metros

data_skeleton = D.objects.data.armatures#se asume que solo existe una armadura, la que recién se importo
skeleton = D.objects[data_skeleton[0].name]

bpy.context.scene.objects.active = skeleton#selecciono skeleton
bpy.ops.object.mode_set(mode='POSE', toggle=False)#lo llevo a pose mode
bpy.data.armatures[skeleton.name].pose_position = 'REST'#lo llevo a rest_position
bpy.ops.pose.select_all(action='TOGGLE')#deselecciono todos los huesos



#bpy.context.scene.objects.active = skeleton
#bpy.ops.object.mode_set(mode='POSE')#Dejo skeleton situado en el Pose mode
#bpy.ops.pose.select_all(action='TOGGLE')#deselecciono todos los huesos
#bpy.context.scene.objects.active = skeleton
#bpy.ops.object.select_all(action='DESELECT') #deselect all object   

#list_bones =skeleton.data.bones.keys()
list_bones = ['LeftUpLeg', 'LeftLeg', 'LeftFoot', 'RightUpLeg', 'RightLeg', 'RightFoot', 'Head',  'LeftArm', 'LeftForeArm', 'LeftHand',  'RightArm', 'RightForeArm', 'RightHand', 'Spine']#huesos donde se quiere poner un marcador en su head
  
list_sphere = []  
print('A continuación se generan las esferas asociadas a los huesos indicados en la variable  list_bones.\n Correspondencias entre huesos y esferas:')    
for name in list_bones:        
    bone = skeleton.data.bones[name]#hueso que se está utilizando
    bone_head = bone.head_local
    bone_tail = bone.tail_local
    print('Hueso '+name)
#    print(name+', head = ('+repr(bone_head.x)+', '+repr(bone_head.y)+', '+repr(bone_head.z)+'). ')
#    print('tail = (' +repr(bone_tail.x)+', '+repr(bone_tail.y)+', '+repr(bone_tail.z)+'). ')
	#GENERO UNA ESFERA BLANCA
    origin = (bone_head.x,bone_head.y,bone_head.z) #aqui se deben ingresar los head_local de los distintos bones
    bpy.ops.mesh.primitive_uv_sphere_add(location=origin)#genero una esfera	
    sphere = bpy.context.object#devuelve el objeto que se acaba de crear, o sea la esfera
    setMaterial(sphere, white)#le ingreso el material a la esfera
    sphere.scale.xyz = [marker_radius, marker_radius, marker_radius]#dejo la esfera de tamaño marker_radius
    sphere.name = 'sphere-'+name#modifico el nombre de la esfera para que sea igual al del hueso al que corresponde
    list_sphere.append(sphere.name)#lista con los nombres de las esferas que se crearon
    print('Esfera'+sphere.name+'\n')
 

#################################################

#data_skeleton = D.objects.data.armatures#se asume que solo existe una armadura, la que recién se importo
#skeleton = D.objects[data_skeleton[0].name]

bpy.context.scene.objects.active = skeleton#selecciono skeleton
bpy.ops.object.mode_set(mode='POSE', toggle=False)#lo llevo a pose mode
bpy.data.armatures[skeleton.name].pose_position = 'REST'#lo llevo a rest_position
bpy.ops.pose.select_all(action='TOGGLE')#deselecciono todos los huesos

    

for i in range(len(list_bones)):
    marker = D.objects[list_sphere[i]]
    armature = skeleton
    bone = skeleton.pose.bones[list_bones[i]]    
    print(bone)
    #de-selecciono todos los huesos y los marcadores
    bpy.ops.object.mode_set(mode='OBJECT', toggle=False)
    bpy.ops.object.select_all(action = 'DESELECT')    
    # select marker in object mode
    bpy.ops.object.mode_set(mode='OBJECT', toggle=False)
    marker.select = True
    # select armature
    armature.select = True
    # select bone
    armature.data.bones.active = bone.bone
    # parent
    bpy.ops.object.parent_set(type='BONE')
    if i>=0:
        bpy.ops.object.mode_set(mode='POSE', toggle=False)
        bpy.ops.pose.select_all(action='TOGGLE')#deselecciono todos los huesos
        
    



##################################
#AJUSTE DEL MODELO A LA ARMADURA(En principio solo haces los 'parent' correspondientes)

bpy.context.scene.objects.active = skeleton#selecciono skeleton
bpy.ops.object.mode_set(mode='POSE', toggle=False)#lo llevo a pose mode
bpy.data.armatures[skeleton.name].pose_position = 'POSE'#lo llevo a pose_position
bpy.ops.pose.select_all(action='TOGGLE')#deselecciono todos los huesos

list_model = ['Head', 'LeftArm', 'LeftFoot', 'LeftForeArm', 'LeftHand', 'LeftLeg', 'LeftShoulder', 'LeftUpLeg', 'LHipJoint', 'LowerBack', 'Neck1', 'RightArm', 'RightFoot', 'RightForeArm', 'RHipJoint', 'RightLeg', 'RightShoulder', 'RightUpLeg', 'RightHand', 'Spine', 'Spine1']

for i in range(len(list_model)):
    obj = D.objects[list_model[i]]#se asume que las partes del modelo tienen igual nombre que el hueso al cual deben emparentarse
    armature = skeleton
    bone = skeleton.pose.bones[list_model[i]]    
    print(bone)
    #de-selecciono todos los huesos y los marcadores
    bpy.ops.object.mode_set(mode='OBJECT', toggle=False)
    bpy.ops.object.select_all(action = 'DESELECT')
    # select marker in object mode
    bpy.ops.object.mode_set(mode='OBJECT', toggle=False)
    obj.select = True
    # select armature
    armature.select = True
    # select bone
    armature.data.bones.active = bone.bone
    # parent
    bpy.ops.object.parent_set(type='BONE')
    if i>=0:
        bpy.ops.object.mode_set(mode='POSE', toggle=False)
        bpy.ops.pose.select_all(action='TOGGLE')#deselecciono todos los huesos
        
    
bpy.context.scene.objects.active = skeleton#selecciono skeleton
bpy.ops.object.mode_set(mode='POSE', toggle=False)#lo llevo a pose mode
bpy.data.armatures[skeleton.name].pose_position = 'POSE'#lo llevo a pose_position
#bpy.ops.pose.select_all(action='TOGGLE')#deselecciono todos los huesos



######
#Llevo skeleton a la tercer Layer
bpy.ops.object.mode_set(mode='OBJECT', toggle=False)
bpy.ops.object.select_all(action = 'DESELECT')#deselecciono lo que este activo
skeleton.select = True#selecciono el esqueleto
bpy.ops.object.move_to_layer(layers=(False, False, True, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False))
bpy.ops.object.select_all(action = 'DESELECT') #deselecciono lo que haya activado

#Llevo las esferas a la segunda Layer
for name in list_sphere:    #selecciono todas las esferas
    D.objects[name].select = True

bpy.ops.object.move_to_layer(layers=(False, True, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False)) #las muevo a la segunda layer



######
#Devuelvo la información pertinente en un archivo Leanme.txt
current_path = os.getcwd()
file_name = bpy.path.display_name_from_filepath(bpy.context.blend_data.filepath)
with open(current_path + "/Leanme.txt", "w") as file: 
    file.write('Parámetros del archivo blend'+file_name+'.\n\n')
    file.write('Cantidad de Marcadores = ' + repr(len(list_sphere)) +'\n')
    file.write('Lista de marcadores = '+repr(list_sphere) +';\n')
    file.close()







##accedo a las armaduras
#arm = D.objects.data.armatures
##visualizo cuales existen
#print(arm.keys())
##Selecciono la armadura arm[0] en modo objecto
#arm_object=bpy.data.objects[arm[0].name]
#bpy.context.scene.objects.active = arm_object
##la borro
#bpy.ops.object.delete(use_global=False)


##Borrar del Current_File
##brushes
#D.objects.data.armatures.keys()#visualiza las armaduras que hay
#arms = D.objects.data.armatures
#for arm in arms:
#    arms.remove(arm)#remueve la armadura arm 

##actions
#D.objects.data.actions.keys()
#actions = D.objects.data.actions
#for action in actions:
#    actions.remove(action)#remueve la accion action
#    
#de la misma manera con materiales camaras etc
    