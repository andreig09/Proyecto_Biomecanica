function structure = remove_markers(structure, frame, name)
%Funcion que remueve los marcadores cuyos nombres se encuentran en el cell array de string names de la estructura structure
%en los frames indicados en el vector frame

%% ENTRADA
%structure -->estructura de datos skeleton o cam(i)
%frame     -->vector que indica los frames donde se efectua la supresion de marcadores
%name      -->cell array con los string de nombres a suprimir
%% SALIDA
%structure -->estructura de datos actualizada

%% ---------
% Author: M.R.
% created the 23/08/2014.
%% CUERPO DE LA FUNCION


n_names=length(name);%cantidad de nombres en el vector name
n_frames = length(frame);%cantidad de frames en el vector frames 

%% Obtener informacion
%Obtengo los indices de los marcadores que poseen los nombres en 'name' a lo largo de los frames en la variable 'frame'
index_x = cell(1, length(name)); %de esta manera puedo prealocate la variable
for k=1:n_names %hacer con cada elemento de names
    %index_x{k} es una matriz de dos filas, la primera indica el indice encontrado y la segunda el frame donde se encontro
    index_x{k} = find_marker_by_name(structure, name(k), 'frame', frame); %busco en los frames indicados en el vector frame, el nombre name(k)                                 
end
index_x = cell2mat(index_x); %obtengo una matriz ordenada cuya primer fila son indices y la segunda indica nro de frame asociado

%Obtengo los numeros de path asociados a los marcadores con nombre en 'name'
name_path = find_path_by_name(structure, name);%num_path(i) indica el numero de trayectoria con el nombre name(i), en el caso que no exista un trayectoria para name(j), num_path(j)=-1  
condition = name_path ~=-1; %busco los elementos de name_path distintos de -1
name_path = name_path(condition); %me quedo solo con los elementos que cumplen la condicion anterior, o sea aquellos paths que tengo que borrar


%% Generacion de variables auxiliares
%genero variables utiles para el borrado
n_index = size(index_x, 2);%numero de indices de index_x 
str_blank=cell(1, n_index);
for i=1:n_index %relleno el cell con espacios en blanco
    str_blank{i}=' ';
end
total_frames =  get_info(structure, 'n_frames'); %numero de frames de la estructura structure

%% Borrado de informacion en las estructuras marker, frame y path
for k = 1:n_frames %hacer para cada frame
    %encuentro los indices de index_x que pertenecen al frame k
    colum = (index_x(2, :)==k);
    markers_for_delete = index_x(1,colum);
    
    n_markers = get_info(structure, 'frame', frame(k), 'n_markers', n_markers); %nro de marcadores en el frame k   
    
    markers = 1:n_markers;%vector con los indices de todos los marcadores en frame k
    markers(markers_for_delete)=-1;%los indices de los marcadores que estan para borrar se ponen en -1
    last_markers = markers(markers~=-1);%me quedo con los indices de los marcadores que no se van a borrar
    last_markers = sort(last_markers,1,'descend');%los ordeno de manera que los ultimos marcadores aparescan al principio
    
    %me quedo con los length(colum) vectores de last_markers y los utilizo para rellenar los marcadores que tengo que borrar
    
    
    
    %borro lo referente a la estructura marker 
    %la idea es sobreescribir los marcadores que se quieren borrar en el frame k con los ultimos marcadores no vacios y fuera de la lista de los
    %que se quieren borrar. Luego se borran solo los ultimos marcadores utilizados. De esta manera no se generan huecos con marcadores nulos
    %en un frame.
    
    
    
    
    
end
end

%     structure = set_info(structure, 'frame', frame(k), 'marker', index_x(1,colum), 'coord', zeros(3,n_index) ); %setea con las columnas, las coordenadas de todos los marcadores en el frame 1 de structure
%     structure = set_info(structure, 'frame', frame(k), 'marker', index_x(1,colum), 'name', str_blank); %setea con las columnas del cell string los nombres de todos los marcadores en el frame 1 de structure
%     structure = set_info(structure, 'frame', frame(k), 'marker', index_x(1,colum), 'state', zeros(1,n_index) ); %setea con las columnas,  un vector con los estados de  todos los marcadores en el frame 1 de structure
%     structure = set_info(structure, 'frame', frame(k), 'marker', index_x(1,colum), 'source_cam', zeros(1,n_index) );  %setea con las columnas, un vector con las camaras fuente de todos los marcadores en el frame 1 de structure
%     %borro lo referente a la estructura frame
%     n_markers=get_info(structure, 'frame', frame(k), 'n_markers');%obtengo el numero de marcadores en el frame
%     n_index_k = length(index_x(1, colum));%numero de indices de index_x en el frame k
%     n_markers = n_markers - n_index_k; %actualizo el numero de marcadores en el frame k
%     structure = set_info(structure, 'frame', frame(k), 'n_markers', n_markers);    
% end
% %borro lo referente a la estructura path
% for path=1:name_path %hacer para todos los paths en name_path
%     structure = set_info(structure, 'path', path, 'name', {' '}); % setea el nombre asociado a la trayectoria 
%     structure = set_info(structure, 'path', path, 'members', zeros(2, total_frames)); % setea la secuencia de nombres asociados a la trayectoria
%     structure = set_info(structure, 'path', path, 'state', -1); % setea una medida de calidad para la trayectoria
%     structure = set_info(structure, 'path', path, 'n_markers', 0); % setea el numero de marcadores totales en la trayectoria
%     structure = set_info(structure, 'path', path, 'init_frame', -1); %setea el frame inicial de la trayectoria
%     structure = set_info(structure, 'path', path, 'end_frame', -1); %setea  el frame final de la trayectoria 
% end
% %decremento el numero de paths de la estructura
% n_paths_init = get_info(structure, 'n_paths'); % numero de paths de la estructura 
% n_paths_final = n_paths_init - length(name_path);
% structure = set_info(structure, 'n_paths', n_paths_final); %setea numero de paths de la estructura
% 
% %% Ordenacion de la estructura 
% %ordeno la estructura frame para dejar los marcadores vacios al final de la lista de indices.
% %La idea es tapar los huecos con los ultimos marcadores disponibles.
% %Pregunto el numero (n_index_x) de ultimos marcadores fuera de index_x, relleno los huecos con ellos y luego los remuevo del final. 
% 
% end
% 
% 
% function structure = sort_structure(structure)
% %Funcion que permite ordenar la informacion dentro de un estructura skeleton o cam(i)
% 
% %% IDEA
% %ordeno las estructuras frame para dejar los marcadores vacios al final de la lista de indices y la estructura path para dejar los paths vacios al final.
% %La idea es tapar los huecos con las ultimas informaciones no vacias disponibles.
% %Por ejemplo para la estructura frame pregunto el numero (n_index_x) de ultimos marcadores fuera de index_x, relleno los huecos con ellos 
% %y luego los remuevo del final.
% 
% %% ---------
% % Author: M.R.
% % created the 23/08/2014.
% 
% %% CUERPO DE LA FUNCION
% 
% name = {' '}; %nombre vacio
% 
% %busco los indices de los paths con nombre vacio {' '}
% name_path = find_path_by_name(structure, name);%num_path(i) indica el numero de trayectoria con el nombre name(i), en el caso que no exista un trayectoria para name(j), num_path(j)=-1  
% n_paths = 
% 
% 
% 
% end



