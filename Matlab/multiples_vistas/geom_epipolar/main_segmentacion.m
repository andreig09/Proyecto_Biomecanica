function cam_segmentacion = main_segmentacion(n_markers, path_vid, type_vid, path_XML )

current_dir = pwd;
path_program = [current_dir '/Seccion_segmentacion/ProgramaC']; %donde residen los programas que efectuan la segmentacion

%efectuo la segmentacion
disp('__________________________________________________')
disp('Se inicia el proceso de Segmentacion.')
list_XML = segmentacion(path_vid, type_vid, path_program, path_XML);
disp('La segmentacion ha culminado con exito.')
disp('__________________________________________________')
disp('Se inicia el pasaje de archivos .xml a estructuras .mat.')

names = 1:n_markers;%genero los nombres de los marcadores
names = cellstr(num2str(names'));

%cargo los archivos xml provenientes de la segmentacion asi como los datos de las camaras Blender
cam_segmentacion = markersXML2mat(names, path_XML, list_XML);
disp('El pasaje a la estructura .mat a culminado.')

end


