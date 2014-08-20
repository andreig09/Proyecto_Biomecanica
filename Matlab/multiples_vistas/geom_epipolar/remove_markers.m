function structure = remove_markers(structure, n_frame, names)
%Funcion que remueve los marcadores de la estructura structure cuyos nombres se encuentran en el string names

%% CUERPO DE LA FUNCION

index_x = [];
for str=names %hacer con cada elemento de names
    index_x = [index_x, find_name(structure, n_frame, str)];
end

index_x = index_x(1,:); %me quedo solo con los indices
n_index = length(index_x);%numero de indices en index_x
str_blank=cell(1, n_index);
for i=1:n_index %relleno el cell con espacios en blanco
    str_blank{i}=' ';
end
structure = set_info(structure, 'frame', n_frame, 'marker', index_x, 'coord', zeros(3,n_index) ); %setea con las columnas de "info17" las coordenadas de todos los marcadores en el frame 1 de structure
structure = set_info(structure, 'frame', n_frame, 'marker', index_x, 'name', str_blank); %setea con las columnas del cell string "info18" los nombres de todos los marcadores en el frame 1 de structure
structure = set_info(structure, 'frame', n_frame, 'marker', index_x, 'state', zeros(1,n_index) ); %setea con las columnas de "info19" un vector con los estados de  todos los marcadores en el frame 1 de structure
structure = set_info(structure, 'frame', n_frame, 'marker', index_x, 'source_cam', zeros(1,n_index) );  %setea con las columnas de "info20" un vector con las camaras fuente de todos los marcadores en el frame 1 de structure

end