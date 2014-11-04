function [skeleton, cam] = prepare_ground_truth(path_bvh, name_bvh, path_info_blender, varargin)
%Funcion que permite cargar y preparar el ground truth proveniente de secuencias bvh

%% ENTRADA
% path_bvh -->path donde se encuentra el archivo bvh a cargar= '/home/sun/Documentos/Proyecto/Git_Proyecto_Biomecanica/Matlab/multiples_vistas/geom_epipolar';
% name_bvh --> nombre del archivo bvh a cargar
% path_info_blender -->path donde se encuentra el archivo InfoCamBlender.m, el cual contiene la informacion de las camaras Blender
% path_save -->path donde se desea guardar los archivos xml
% name_save -->nombre del archivo xml
% save_vars --> booleano que indica si se desea salvar o no la salida en un xml;
% varargin -->puede agregarse un cell array de strings con los nombres de los marcadores con los cuales se desea trabajar, el resto son removidos
% de las estructuras
%% SALIDA
%skeleton -->estructura para esqueleto de ground truth
%cam -->cam{i} es una estructura asociada a la camra i

%% ---------
% Author: M.R.
% created the 30/09/2014.
%% CUERPO DE LA FUNCION
disp(['Cargando el archivo ', name_bvh, '.'])
[Lab, markers_name] = loadBVH(path_bvh, name_bvh, path_info_blender);
skeleton = Lab.skeleton;
cam = Lab.cam;

%% Remuevo los marcadores que no uso
if ~isempty(varargin)
    markers_work = varargin{1}; %cell array conteniendo los nombres de los marcadores con los que se desea trabajar
    %markers_work = {'LeftFoot' 'LeftLeg' 'LeftUpLeg' 'RightFoot' 'RightLeg' 'RightUpLeg'...
    %   'RightShoulder' 'LHand' 'LeftForeArm' 'LeftArm' 'RHand' 'RightForeArm' 'RightArm'};%cell array con los marcadores que se van a usar
    disp('_________________________________________')
    disp('Removiendo los marcadores que no se van a utilizar')    
    n_markers = length(markers_name);
    %obtengo un cell array con los nombres de los marcadores a suprimir
    n_work = length(markers_work);
    remove_name = cell(1, (n_markers - n_work));
    i=1;
    for k=1:n_markers %hacer para todos los  marcadores
        aux = strcmp(markers_name{k}, markers_work);%markers_name es un cell array con los nombres de todos los marcadores
        if sum(aux)==0%si no existe coincidencia quiere decir que no se va a trabajar con ese punto por lo tanto se debe remover
            remove_name(i)=markers_name(k);
            i=i+1;%este indice unicamente sirve para llevar la cuenta de los marcadores a remover
        end
    end
    n_frames = get_info(skeleton, 'n_frames');
    n_cams = length(cam);
    frames = 1:n_frames;
    
    %remuevo los marcadores listados en remove_name
    skeleton = remove_markers(skeleton, frames, remove_name);
    disp('Se removieron los marcadores inutiles de la estructura skeleton')
    parfor i=1:n_cams %hacer para todas las camaras
        cam{i}=remove_markers(cam{i}, frames, remove_name);
        str = sprintf('Se removieron los marcadores inutiles de la estructura cam{%d}', i);
        disp(str)
    end
end

end