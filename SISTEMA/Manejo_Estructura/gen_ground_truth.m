clear all
clc


% ENTRADAS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%booleano que indica si se desea salvar o no la salida en un xml;
save_xml = 1;
%booleano que indica si se desea salvar o no la salida en un mat;
save_mat = 1;

%path donde se encuentra la informacion de la secuencia a trabajar
path_seq = '/home/sun/Documentos/Fing/Base_de_datos/Sujeto_CMU_09/09_12/';
%nombre de la carpeta de renderizado
name_render = '400_150-100-100';
%nombre del archivo bvh a cargar
name_bvh = 'CMU_9_12_blend_100-100.bvh';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%DIRECCIONES AUTOMATICAS PARA TRABAJAR CON LA ARQUITECTURA DE LA BASE DE
%%%%DATOS
%path donde se encuentra el archivo bvh a cargar
path_bvh = [path_seq, '/Datos_Imagen'];
%path donde se encuentra el archivo InfoCamBlender.m, el cual contiene la informacion de las camaras Blender
path_info_blender = [path_bvh, '/', name_render];
%path donde se desea guardar los archivos xml
path_save = [path_seq, '/Ground_Truth/', name_render];



%cell array de strings con los nombres de los marcadores con los cuales se desea trabajar, el resto son removidos
% de las estructuras
s=xml2struct([path_bvh,  '/Info_Blender.xml']); %la información se encuentra en Info_Blender.xml
string=['markers_name = ', s.blender_info.Attributes.Lista_de_marcadores, ';']; 
eval(string); %Obtengo el nombre de los marcadores

%markers_name = {'LeftUpLeg', 'LeftLeg', 'LeftFoot', 'RightUpLeg', 'RightLeg', 'RightFoot', 'Head', 'LeftArm', 'LeftForeArm', 'LeftHand', 'RightArm', 'RightForeArm', 'RightHand', 'Spine'};
%markers_name = {'LeftUpLeg', 'LeftLeg', 'LeftFoot', 'RightUpLeg', 'RightLeg', 'RightFoot', 'Head', 'LeftArm', 'LeftForeArm', 'LeftHand', 'RightArm', 'RightForeArm', 'RightHand'};


%% Preparo el ground truth
[skeleton_track, cam_seg] = prepare_ground_truth(path_bvh, name_bvh, path_info_blender, markers_name);
skeleton_rec = skeleton_track;

%% Guardo y Limpio variables 
Lab.cam = cam_seg;
Lab.skeleton = skeleton_track;
s.Lab= Lab;
if ((save_mat==1) || (save_xml==1))
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
    if save_mat==1
        save([path_save,'/Reconstruccion/skeleton.mat'] ,'skeleton_rec');
        save([path_save,'/Tracking/skeleton.mat'] ,'skeleton_track');
        disp('La variable skeleton.mat ha sido guardada')
        save([path_save,'/Segmentacion/cam.mat'],'cam_seg'); 
        disp('La variable cam.mat ha sido guardada')
    end
    %Archivos.xml
    if save_xml==1
        s1.lab.cam_seg=cam_seg;
        s2.skeleton_rec=skeleton_rec;
        s3.skeleton_track=skeleton_track;
        struct2xml( s1, [path_save,'/Segmentacion/cam.xml'])
        disp('El archivo cam.xml ha sido generado')
        struct2xml( s2, [path_save,'/Reconstruccion/skeleton.xml'])
        struct2xml( s3, [path_save,'/Tracking/skeleton.xml'])        
        disp('Los archivos skeleton.xml han sido generados')
        disp('__________________________________________________________________')
    end
end