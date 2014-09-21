function cam_segmentacion = main_segmentacion(names, path_vid, type_vid, path_XML, save_segmentation_mat, path_mat)
%Funcion que permite segmentar y junto a la informacion de la calibracion, devolver una estructura cam

%% ENTRADA
% names -----> cell array con los nombres de los marcadores
% path_vid -->string ubicacion de los videos
% type_vid -->string extension de los videos. Ejemplo '*.dvd', siempre escribir '*.' y la extension.
%           Se asume que los nombres de los videos se diferencian
%           unicamente en un numero antes de la extension.
% path_XML -->string ubicacion de los xml de salida
% save_segmentation_mat -->boolean indicando si se desea guardar cam_segmentacion en un archivo .mat
% path_mat -->string ubicacion del .mat de salida
%% SALIDA
% cam_segmentacion -->estructura cam con toda la informacion relevante de la segmentacion y la calibracion

%% ---------
% Author: M.R.
% created the 20/09/2014.

current_dir = pwd;
path_program = [current_dir '/Seccion_segmentacion/ProgramaC']; %donde residen los programas que efectuan la segmentacion

%efectuo la segmentacion
disp('__________________________________________________')
disp('Se inicia el proceso de Segmentacion.')
list_XML = segmentacion(path_vid, type_vid, path_program, path_XML);
disp('La segmentacion ha culminado con exito.')
disp('__________________________________________________')
disp('Se inicia el pasaje de archivos .xml a estructuras .mat.')



%cargo los archivos xml provenientes de la segmentacion asi como los datos de las camaras Blender
cam_segmentacion = markersXML2mat(names, path_XML, list_XML);
disp('El pasaje a la estructura .mat a culminado.')


%guardo la informacion en caso que se solicite
if  save_segmentation_mat   %¿se tiene activado el checkbox7?
    %path_mat = handles.MatPath; %donde se guardan las estructuras .mat luego de la segmentacion
    save([path_mat '/cam'], 'cam_segmentacion')
    str = ['Se a guardado el resultado de la segmentacion de las camaras en ', path_mat, '/cam.mat'];
    disp(str)
end

end


