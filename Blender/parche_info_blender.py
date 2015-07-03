import bpy
import os
import xml.dom.minidom#util para generar .xml


list_bones = ['LeftUpLeg', 'LeftLeg', 'LeftFoot', 'RightUpLeg', 'RightLeg', 'RightFoot', 'Head',  'LeftArm', 'LeftForeArm', 'LeftHand',  'RightArm', 'RightForeArm', 'RightHand', 'Spine']#huesos donde se quiere poner un marcador en su head

#genero un string con los nombres de list_bones en el formtato de un cell array de matlab
str_list_bones = "{'"
for bones in list_bones:
    str_list_bones = str_list_bones + bones + "', '"
    
str_list_bones= str_list_bones[:(len(str_list_bones)-3)]#borro el último punto y coma
str_list_bones = str_list_bones + '}'
    


######
#Devuelvo la información pertinente en un archivo Leanme.txt
current_path = os.getcwd()
file_name = bpy.path.display_name_from_filepath(bpy.context.blend_data.filepath)
with open(current_path + "/Informacion_del_Modelo.txt", "w") as file: 
    file.write('Parámetros del archivo blend'+file_name+'.\n\n')
    file.write('Cantidad de Marcadores = ' + repr(len(list_bones)) +'\n')
    file.write('Lista de marcadores = '+str_list_bones +';\n')
    file.close()




##########Generacion de un archivo .xml con informacion del renderizado
doc = xml.dom.minidom.Document()#objeto documento
#Genero un nodo raiz
root=doc.createElement('blender_info')
doc.appendChild(root)
#Ingreso un texto al elemento root
comment = doc.createTextNode('Informacion del sujeto de captura del archivo blend'+file_name)
root.appendChild(comment)
#Agrego los atributos al elemento root
root.setAttribute('Cantidad_de_Marcadores',  repr(len(list_bones)) )
root.setAttribute('Lista_de_marcadores', str_list_bones)
#Exporto la informacion a un archivo
file_object = open(current_path + '/Info_Blender.xml', "w")#Abro un archivo Info_Blender.xml
file_object.write(doc.toprettyxml(indent="  "))
file_object.close()
####CODIGO GENERADO CON AYUDA DE http://www.boddie.org.uk/python/XML_intro.html