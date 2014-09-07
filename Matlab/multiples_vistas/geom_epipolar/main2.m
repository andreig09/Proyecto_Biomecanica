%este script es el prototipo del sistema completo permite integrar todas las partes

%Con esto se pretende tener un tratamiento en paralelo de algunos ciclos for
if matlabpool('size') == 0 % revisar si aun no se tiene algun matlabpool abierto   
    matlabpool open 
end


%% Parametros de entrada
names = {'LeftFoot' 'LeftLeg' 'LeftUpLeg' 'RightFoot' 'RightLeg' 'RightUpLeg'...
    'RightShoulder' 'Head' 'LHand' 'LeftForeArm' 'LeftArm' 'RHand' 'RightForeArm' 'RightArm'};
name_bvh ='Mannaquin_con_Armadura_menos_pelotitas.bvh';
current_dir = pwd;
%path_XML = 'C:\Users\Administrador\Desktop\Seccion_segmentacion';
path_vid = [current_dir '/Seccion_segmentacion/Videos'];
type_vid = '*.dvd'; %el nombre de la extension siempre debe escribirse como '*.extension'
path_program = [current_dir '/Seccion_segmentacion/ProgramaC']; %donde residen los programas que efectuan la segmentacion
path_XML = [current_dir '/Seccion_segmentacion']; %donde se quieren los archivos xml luego de la segmentacion
path_mat = [current_dir '/saved_vars']; %donde se guardan las estructuras .mat luego de la segmentacion
name = '13_segmentacion'; %parte final del nombre de los archvos .mat a generar

%% Segmentacion

disp('__________________________________________________')
disp('Se inicia el proceso de Segmentacion.')
list_XML = segmentacion(path_vid, type_vid, path_program, path_XML);
disp('La segmentacion a culminado con exito.')
% %%%%%%%%%%%%%%%%%%%% Esto se tiene que borrar una vez que Andréi solucione lo de los nombres en Source
% list_XML=dir(fullfile(path_XML,'*.xml'));
% list_XML={list_XML.name}';
% 
% index1 = strfind(list_XML{1}, '1.'); %index-1 indica donde termina el nombre y empiezan los numeros
% n_files = length(list_XML); % cantidad de archivos con extensi�n xml
% num_in_name = zeros(1, n_files);
% for k=1:n_files %la idea es pasar cada numero de un nombre a un vector y luego ordenarlo
%     index2 = strfind(list_XML{k}, '.') -1; %indice que indica hasta donde van los numeros finales
%     num_in_name(k)=str2double(list_XML{k}(index1:index2)); %guardo el numero de archivo
% end
% [~, sort_index] = sort(num_in_name);
% list_XML = list_XML(sort_index);
% %%%%%%%%%%%%%%%%%%5


%% Pasaje a estructuras .mat
disp('__________________________________________________')
disp('Se inicia el pasaje de archivos .xml a estructuras .mat.')

n_cams = length(list_XML); %numero de camaras importadas
n_markers = length(names); %nro de marcadores a detectar

%cargo los archivos xml provenientes de la segmentacion asi como los datos de las camaras Blender
cam_segmentacion = markersXML2mat(names, path_XML, list_XML);

n_frames = get_info(cam_segmentacion(1), 'n_frames');%obtengo el numero de frames de la camara 1. 
                                                    %(supuestamente todas las camaras deberian tener igual nro de frames). Si esto no ocurre
                                                    %deberia haber algun warning en la terminal matlab producido por markersXML2mat.

%inicializo una estructura skeleton para completar a medida que se trabaje con los datos de cam_segmentacion
[~ , skeleton_segmentacion]=init_structs(n_markers, n_frames, names);
skeleton_segmentacion = set_info(skeleton_segmentacion, 'name_bvh', name_bvh); %setea string nombre de la estructura

%guardo la informacion
save([path_mat '/cam' name ], 'cam_segmentacion')
str = sprintf('Se a guardado el resultado de la segmentacion de las camaras en %s/cam%s', path_mat, name);
disp(str)
save([path_mat '/cam' name ], 'skeleton_segmentacion')
disp('El pasaje a estructuras .mat a culminado.')

%% Reconstruccion

vec_cams = 1:n_cams;
umbral = 0.05;
Xrec = cell(1, 300);
disp('__________________________________________________')
disp('Se inicia el proceso de Reconstruccion')
parfor frame=1:n_frames %hacer para cada frame (Se efectua en paralelo)
    %efectuo la reconstruccion de un frame
    Xrec{frame} = reconstruccion1frame(cam, v_cams, frame, umbral, tot_markers);
    %genero aviso
    str=sprintf('Se a reconstruido el frame %d', frame);
    disp(str)    
end

for  frame=1:n_frames %hacer para cada frame (Se efectua secuencialmente)     
    n_Xrec= size(Xrec{frame}, 2); %numero de marcadores reconstruidos en el frame 'frame'
    n_markers = get_info(skeleton_segmentacion, 'frame', frame, 'n_markers'); % devuelve el numero de marcadores del frame 'frame' de la estructura structure
    Xrec{frame} = [Xrec{frame}, zeros(3, (n_markers - n_Xrec) )];%Si faltan marcadores para rellenar la estructura los lleno con ceros
    
    skeleton_segmentacion = set_info(skeleton_segmentacion, 'frame', frame, 'marker', 'coord', Xrec); %ingreso los marcadores en el frame correspondiente de estructura_salida
    skeleton_segmentacion = set_info(skeleton_segmentacion, 'frame', frame, 'n_markers', n_Xrec);% actualizo el numero de frame correspondiente
end


%% Tracking






