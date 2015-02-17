#La idea de este script es automatizar la colocación de los marcadores en el esqueleto modelo.

#!/usr/local/bin/python2.7
import bpy
import os
import xml.dom.minidom#util para generar .xml


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

white = makeMaterial('White',(1,0,0),(1,0,0),1)
marker_radius = 0.050#unidades en metros
salto = 0.5
xcota=[int(-3/salto), int(3/salto)]
ycota=[int(-5/salto), int(0/salto)]
zcota=[int( 0/salto), int(2/salto)]




ancho=range(xcota[0], xcota[1], 1)
largo=range(ycota[0], ycota[1], 1)
alto=range(zcota[0], zcota[1], 1)
list_sphere = []  
print('A continuación se generan las esferas asociadas a los huesos indicados en la variable  list_bones.\n Correspondencias entre huesos y esferas:')    
for x in ancho:
    for y in largo:
        for z in alto:
            #GENERO UNA ESFERA BLANCA
            origin = (salto*x,salto*y,salto*z) #origen de la esfera
            bpy.ops.mesh.primitive_uv_sphere_add(location=origin)#genero una esfera	
            sphere = bpy.context.object#devuelve el objeto que se acaba de crear, o sea la esfera
            setMaterial(sphere, white)#le ingreso el material a la esfera
            sphere.scale.xyz = [marker_radius, marker_radius, marker_radius]#dejo la esfera de tamaño marker_radius
            sphere.name = repr(x)+repr(y)+repr(z)#modifico el nombre de la esfera para que sea igual al del hueso al que corresponde
            list_sphere.append(sphere.name)#lista con los nombres de las esferas que se crearon
            print('Esfera'+sphere.name+'\n')
            
            
            
            
            
 

#################################################






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
    
