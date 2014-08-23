function structure = remove_markers(structure, n_frame, names)
%Funcion que remueve los marcadores de la estructura structure cuyos nombres se encuentran en el string names
%para un cierto frame

%% CUERPO DE LA FUNCION

%Obtengo los indices de los marcadores que poseen los nombres en 'names'
n_names=length(names);
index_x = cell(1, length(names)); %de esta manera puedo prealocate la variable
for k=1:n_names %hacer con cada elemento de names
    index_x{k} = find_name(structure, n_frame, names(k));
end
index_x = cell2mat(index_x); %obtengo una matriz ordenada cuya primer fila son indices y la segunda indica nro camara

 
index_x = index_x(1,:); %me quedo solo con los indices
n_index = length(index_x);%numero de indices en index_x
str_blank=cell(1, n_index);
for i=1:n_index %relleno el cell con espacios en blanco
    str_blank{i}=' ';
end
%borro lo referente a la estructura marker
structure = set_info(structure, 'frame', n_frame, 'marker', index_x, 'coord', zeros(3,n_index) ); %setea con las columnas de "info17" las coordenadas de todos los marcadores en el frame 1 de structure
structure = set_info(structure, 'frame', n_frame, 'marker', index_x, 'name', str_blank); %setea con las columnas del cell string "info18" los nombres de todos los marcadores en el frame 1 de structure
structure = set_info(structure, 'frame', n_frame, 'marker', index_x, 'state', zeros(1,n_index) ); %setea con las columnas de "info19" un vector con los estados de  todos los marcadores en el frame 1 de structure
structure = set_info(structure, 'frame', n_frame, 'marker', index_x, 'source_cam', zeros(1,n_index) );  %setea con las columnas de "info20" un vector con las camaras fuente de todos los marcadores en el frame 1 de structure
%borro lo referente a la estructura frame
n_markers=get_info(structure, 'frame', n_frame, 'n_markers');%obtengo el numero de marcadores en el frame
n_markers = n_markers - n_index; %actualizo el numero de marcadores en el frame
structure = set_info(structure, 'frame', n_frame, 'n_markers', n_markers); 


%ordeno la estructura frame para dejar los marcadores vacios al final de la
%lista de indices.
%La idea seria tapar los huecos con los ultimos marcadores disponibles.
%Pregunto cuales son los (n_index_x) ultimos marcadores fuera de index_x, relleno los 
%huecos con ellos y luego los remuevo del final. 

end