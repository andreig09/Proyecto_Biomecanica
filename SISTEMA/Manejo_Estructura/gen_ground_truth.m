clear all
clc


%path donde se encuentra el archivo bvh a cargar
path_bvh = '/home/sun/Documentos/Fing/Blender/renders/CMU_9_12_hack/';
%nombre del archivo bvh a cargar
name_bvh = 'CMU_9_12_blend_100-100.bvh';
%path donde se encuentra el archivo InfoCamBlender.m, el cual contiene la informacion de las camaras Blender
path_info_blender = '/home/sun/Documentos/Fing/Blender/renders/CMU_9_12_hack/1600_600-100-100';
%booleano que indica si se desea salvar o no la salida en un xml;
save_vars = 1;
%path donde se desea guardar los archivos xml
path_save = '/home/sun/Documentos/Fing/Proyecto_Biomecanica/Archivos_mat/CMU_9_12_hack/1600_600-100-100/Ground_Truth';
%nombre del archivo xml
name_save = 'CMU_9_12';
%cell array de strings con los nombres de los marcadores con los cuales se desea trabajar, el resto son removidos
% de las estructuras
markers_name = {'LeftUpLeg', 'LeftLeg', 'LeftFoot', 'RightUpLeg', 'RightLeg', 'RightFoot', 'Head', 'LeftArm', 'LeftForeArm', 'LeftHand', 'RightArm', 'RightForeArm', 'RightHand', 'Spine'};


%% Preparo el ground truth
[skeleton_track, cam_seg] = prepare_ground_truth(path_bvh, name_bvh, path_info_blender, markers_name);
skeleton_rec = skeleton_track;

%% Guardo y Limpio variables 
Lab.cam = cam_seg;
Lab.skeleton = skeleton_track;
s.Lab= Lab;
if save_vars==1 
    disp(' ');
    disp('_________________________________________')
    disp('Guardando las variables pertinentes')
    
    %Verifico que exista el nuevo path y en caso negativo lo creo
    if ~isdir([path_save, '/Segmentacion'])
        mkdir(path_save, '/Segmentacion')    
    end
    if ~isdir([path_save, '/Reconstruccion'])
        mkdir(path_save, '/Reconstruccion')
    end
    if ~isdir([path_save, '/Tracking'])
        mkdir(path_save, '/Tracking')
    end
    %Archivos.mat
    save([path_save,'/Reconstruccion/skeleton.mat'] ,'skeleton_rec');
    save([path_save,'/Tracking/skeleton.mat'] ,'skeleton_track');
    disp('La variable skeleton ha sido guardada')
    save([path_save,'/Segmentacion/cam.mat'],'cam_seg'); 
    disp('La variable cam ha sido guardada')
    %Archivos.xml
    %struct2xml( s, [path_save,'/',  name_save, '.xml'] )
    %str = sprintf('%s.xml a sido guardado', name_save);
    %disp(str)
end