function structure = remove_markers(structure, frame, name)
%Funcion que remueve los marcadores cuyos nombres se encuentran en el cell array de string names de la estructura structure
%en los frames indicados en el vector frame
%El campo path de cada estructura queda desactualizado, se debe gestionar
%un nuevo tracking para completarlo
%% ENTRADA
%structure -->estructura de datos skeleton o cam(i)
%frame     -->vector que indica los frames donde se efectua la supresion de marcadores
%name      -->cell array con los string de nombres a suprimir
%% SALIDA
%structure -->estructura de datos actualizada

%% EJEMPLOS
% clc
% structure = skeleton;
% frame = [1, 2, 3]
% name = {'Hip' 'LeftLeg'}
% structure = remove_markers(structure, frame , name)

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
    index_x{k} = find_marker_by_name(structure, name{k}, 'frame', frame); %busco en los frames indicados en el vector frame, el nombre name(k)                                 
end
index_x = cell2mat(index_x); %obtengo una matriz ordenada cuya primer fila son indices y la segunda indica nro de frame asociado

%verifico que se halla encontrado algun nombre
aux = find(index_x(1,:)~=-1, 1);
if isempty(aux)
    disp('No se encontro ninguno de los nombres ingresados.')
    disp('La estructura se devuelve sin modificaciones.')
    return
end

%% Generacion de variables auxiliares
%genero variables utiles para el borrado
%n_index = size(index_x, 2);%numero de indices de index_x 
str_blank=cell(1, n_names);
for i=1:n_names %relleno el cell con espacios en blanco
    str_blank{i}=' ';
end
total_frames =  get_info(structure, 'n_frames'); %numero de frames de la estructura structure


%% Borrado de informacion en las estructuras marker, frame
for k = 1:n_frames %hacer para cada frame    
    %encuentro los indices de index_x que pertenecen al frame k
    colum = (index_x(2, :)==k);
    index_delete = index_x(1,colum);%indices de los marcadores a borrar en el frame k 
    n_delete = length(index_x(1, colum));%numero de indices de index_x en el frame k
    
    n_markers = get_info(structure, 'frame', frame(k), 'n_markers'); %nro de marcadores en el frame k   
    
    %obtengo las coordenadas y los nombres de todos los marcadores del frame k
    k_markers = get_info(structure, 'frame', frame(k), 'marker', 'coord'); %devuelve las coordenadas de todos los marcadores en el frame 1 de structure
    k_names = get_info(structure, 'frame', frame(k), 'marker', 'name'); %devuelve un cell string con los nombres de todos los marcadores en el frame 1 de structure
    %me quedo solo con los que no voy a borrar
    
    aux = true(1, n_markers);%genero un vector de unos logicos
    for j =1:n_delete
        aux(index_delete(j))=0; %pongo en cero los indices que voy a borrar
    end
    k_markers = k_markers(:,(aux));%me quedo on los indices que no se borran
    k_names = k_names(aux);
    
    %tengo mas marcadores de los que me quedan para "rellenar", entonces debo poner valores vacios lo que me falte para llenar los huecos
    need = n_delete;
    k_markers = [k_markers, zeros(3, need)];
    k_names = [k_names, str_blank];
    %k_state = [k_state, -ones(1, need)];
    
    %k_cam =  [last_cam, -ones(1, need)];%TENGO QUE GESTIONAR ESTE CAMBIO PARA ESTRUCTURAS SKELETON!!!!
       

    %relleno los marcadores actualizados, sin huecos
    structure = set_info(structure, 'frame', frame(k), 'marker', 'coord', k_markers ); %setea con las columnas, las coordenadas de todos los marcadores de index_x(1,colum) en el frame k de structure
    structure = set_info(structure, 'frame', frame(k), 'marker',  'name', k_names); %setea con las columnas del cell string los nombres de todos los marcadores de index_x(1,colum) en el frame k de structure
%     structure = set_info(structure, 'frame', frame(k), 'marker', index_x(1,colum), 'state', last_state ); %setea con las columnas,  un vector con los estados de  todos los marcadores de index_x(1,colum) en el frame k de structure
%     structure = set_info(structure, 'frame', frame(k), 'marker', index_x(1,colum), 'source_cam', last_cam );  %setea con las columnas, un vector con las camaras fuente de todos los marcadores de index_x(1,colum) en el frame k de structure
        
    %borro lo referente a la estructura frame        
    n_markers = n_markers - n_delete; %actualizo el numero de marcadores en el frame k
    structure = set_info(structure, 'frame', frame(k), 'n_markers', n_markers);    

    
end
%% Borrado informacion en la estructura path (util solo al trabajar con ground truth, en otro caso debe realizarse tracking nuevamente con las estructuras salida de esta funcion)
n_paths = get_info(structure, 'n_paths'); %numero de paths de la estructura
id = 1; %voy actualizando el numero de id de los paths que si van a quedar para que sean consecutivos
for k=1:n_paths
    path_name = get_info(structure, 'path', k, 'name');%averiguo el nombre del path k
    aux = strcmp(path_name, name);
    if sum(aux)==1 %si path_name se encuentra dentro de la lista de nombres name
        structure = set_info(structure, 'path', k, 'state', -1);
        structure = set_info(structure, 'path', k, 'members', [zeros(1, total_frames); 1:total_frames ]);
        structure = set_info(structure, 'path', k, 'n_markers', 0);
        structure = set_info(structure, 'path', k, 'init_frame', -1);
        structure = set_info(structure, 'path', k, 'end_frame', -1);
        structure = set_info(structure, 'path', k, 'id', -1);
    else
        structure = set_info(structure, 'path', k, 'id', id);        
        structure = set_info(structure, 'path', k, 'members', [id*ones(1, total_frames); 1:total_frames ]);
        id=id+1;        
    end        
end
structure = set_info(structure, 'n_paths', id); %Actualizo el nro de paths de la estructura

end




