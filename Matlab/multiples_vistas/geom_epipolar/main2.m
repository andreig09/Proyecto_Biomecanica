%este script sirve para cargar los datos xml de la segmentacion en estructuras .mat dentro de la carpeta saved_vars
%n_cams= 17
%n_frames = 322
names = {'LeftFoot' 'LeftLeg' 'LeftUpLeg' 'RightFoot' 'RightLeg' 'RightUpLeg'...
    'RightShoulder' 'Head' 'LHand' 'LeftForeArm' 'LeftArm' 'RHand' 'RightForeArm' 'RightArm'}
n_markers = length(names); %nro de marcadores a detectar
archivo = 'cam'
name_bvh ='Mannaquin_con_Armadura_menos_pelotitas.bvh';

path_XML = 'C:\Users\Administrador\Desktop\Seccion_segmentacion';
list_XML=dir(fullfile(path_XML,'*.xml'));
list_XML={list_XML.name}';
n_cams = length(list_XML); %numero de camaras importadas

%%%%%%%%%%%%%%%%%%%%
index1 = strfind(list_XML{1}, '1.'); %index-1 indica donde termina el nombre y empiezan los numeros
n_files = length(list_XML); % cantidad de archivos con extensión xml
num_in_name = zeros(1, n_files);
for k=1:n_files %la idea es pasar cada numero de un nombre a un vector y luego ordenarlo
    index2 = strfind(list_XML{k}, '.') -1; %indice que indica hasta donde van los numeros finales
    num_in_name(k)=str2double(list_XML{k}(index1:index2)); %guardo el numero de archivo
end
[~, sort_index] = sort(num_in_name);
list_XML = list_XML(sort_index);
%%%%%%%%%%%%%%%%%%5


%cargo los archivos xml provenientes de la segmentacion asi como los datos de las camaras Blender
%cam_segmentacion = markersXML2mat(n_cams, n_markers, n_frames, names, archivo)
cam_segmentacion = markersXML2mat(names, path_XML, list_XML)

%inicializo una estructura skeleton para completar a medida que se trabaje con los datos de cam_segmentacion
[~ , skeleton_segmentacion]=init_structs(n_markers, n_frames, names);
skeleton_segmentacion = set_info(skeleton_segmentacion, 'name_bvh', name_bvh); %setea string nombre de la estructura

%guardo la informacion
save('saved_vars/cam14_segmentacion', 'cam_segmentacion')
save('saved_vars/skeleton14_segmentacion', 'skeleton_segmentacion')

