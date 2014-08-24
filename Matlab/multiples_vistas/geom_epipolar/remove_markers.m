function structure = remove_markers(structure, frame, name)
%Funcion que remueve los marcadores cuyos nombres se encuentran en el string names de la estructura structure
%en los frames indicados en el vector frame

%% CUERPO DE LA FUNCION


n_names=length(name);
n_frames = length(frame);

%Obtengo los indices de los marcadores que poseen los nombres en 'name' a lo largo de los frames en la variable 'frame'
index_x = cell(1, length(name)); %de esta manera puedo prealocate la variable
for k=1:n_names %hacer con cada elemento de names
    index_x{k} = find_marker_by_name(structure, name(k), 'frame', frame); %busco en los frames indicados en el vector frame, el nombre name(k) 
    %index_x{k} es una matriz de dos filas, la primera indica el indice encontrado y la segunda el frame donde se encontro
end
index_x = cell2mat(index_x); %obtengo una matriz ordenada cuya primer fila son indices y la segunda indica nro de frame asociado


n_index = size(index_x, 2);%numero de indices de index_x 
str_blank=cell(1, n_index);
for i=1:n_index %relleno el cell con espacios en blanco
    str_blank{i}=' ';
end
 
for k = 1:n_frames %hacer para cada frame
    %encuentro los indices de index_x que pertenecen al frame k
    colum = (index_x(2, :)==k);
    %borro lo referente a la estructura marker
    structure = set_info(structure, 'frame', frame(k), 'marker', index_x(1,colum), 'coord', zeros(3,n_index) ); %setea con las columnas, las coordenadas de todos los marcadores en el frame 1 de structure
    structure = set_info(structure, 'frame', frame(k), 'marker', index_x(1,colum), 'name', str_blank); %setea con las columnas del cell string los nombres de todos los marcadores en el frame 1 de structure
    structure = set_info(structure, 'frame', frame(k), 'marker', index_x(1,colum), 'state', zeros(1,n_index) ); %setea con las columnas,  un vector con los estados de  todos los marcadores en el frame 1 de structure
    structure = set_info(structure, 'frame', frame(k), 'marker', index_x(1,colum), 'source_cam', zeros(1,n_index) );  %setea con las columnas, un vector con las camaras fuente de todos los marcadores en el frame 1 de structure
    %borro lo referente a la estructura frame
    n_markers=get_info(structure, 'frame', frame(k), 'n_markers');%obtengo el numero de marcadores en el frame
    n_index_k = length(index_x(1, colum));%numero de indices de index_x en el frame k
    n_markers = n_markers - n_index_k; %actualizo el numero de marcadores en el frame k
    structure = set_info(structure, 'frame', frame(k), 'n_markers', n_markers); 
    %borro lo referente a la estructura path
end

%ordeno la estructura frame para dejar los marcadores vacios al final de la
%lista de indices.
%La idea seria tapar los huecos con los ultimos marcadores disponibles.
%Pregunto cuales son los (n_index_x) ultimos marcadores fuera de index_x, relleno los 
%huecos con ellos y luego los remuevo del final. 

end