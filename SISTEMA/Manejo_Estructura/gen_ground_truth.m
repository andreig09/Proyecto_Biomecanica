clear all
clc

%path donde se encuentra el archivo bvh a cargar
path_bvh = '/home/sun/Documentos/Fing/Blender/renders/CMU_8_07_hack';
%nombre del archivo bvh a cargar
name_bvh = 'CMU_8_07_blend_100-100.bvh';
%path donde se encuentra el archivo InfoCamBlender.m, el cual contiene la informacion de las camaras Blender
path_info_blender = '/home/sun/Documentos/Fing/Blender/renders/CMU_8_07_hack/1600_600-100-100';
%booleano que indica si se desea salvar o no la salida en un xml;
save_vars = 1;
%path donde se desea guardar los archivos xml
path_save = '/home/sun/Documentos/Fing/Proyecto_Biomecanica/Archivos_mat/CMU_8_07_hack/1600_600-100-100/Ground_Truth';
%nombre del archivo xml
name_save = 'CMU_8_07';
%cell array de strings con los nombres de los marcadores con los cuales se desea trabajar, el resto son removidos
% de las estructuras
markers_name = {'LeftUpLeg', 'LeftLeg', 'LeftFoot', 'RightUpLeg', 'RightLeg', 'RightFoot', 'Head', 'LeftArm', 'LeftForeArm', 'LeftHand', 'RightArm', 'RightForeArm', 'RightHand', 'Spine'};

[skeleton, cam] = prepare_ground_truth(path_bvh, name_bvh, path_info_blender, save_vars, path_save, name_save, markers_name);