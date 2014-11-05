function structure_out = set_info(varargin)
% Funcion que setea información de estructuras skeleton o cam(i)
%% Entrada
% structure --> una estructura cam(i) o skeleton
% lista de argumento, ver la sección de ejemplos, en la misma se
% tiene todas las posibles entradas.

%% Salida
% structure_out -->estructura seteada

%% SE CARGAN ENTRADAS PARA PROBAR LA FUNCION EN LA SECCION  DE EJEMPLOS
% if ~exist('cam_segmentacion', 'var')
%     load saved_vars/cam13_segmentacion.mat
% end
% clc
% structure=a.Lab.cam{1};
% %structure = skeleton;
% %DATOS DE LA CAMARA
% info1 = get_info(structure, 'Rc'); %devuelve la matriz Rc
% info2 = get_info(structure, 'Tc'); %devuelve vector de traslacion Tc
% info3 = get_info(structure, 'focal_dist'); %devuelve distancia focal en metros f
% info4 = get_info(structure, 'resolution'); %devuelve [resolución_x, resolution_y] unidades en pixeles
% info5 = get_info(structure, 't_vista'); %devuelve tipo de vista utilizada en la camara (PERSPECTIVA, ORTOGRAFICA, PANORAMICA)
% info6 = get_info(structure, 'shift'); %devuelve [shift_x, shidt_y] corrimiento del centro de la camara en pixeles
% info7 = get_info(structure, 'sensor'); %devuelve [sensor_x, sensor_y] largo y ancho del sensor en milimetros
% info8 = get_info(structure, 'sensor_fit'); %devuelve tipo de ajuste utilizado para el sensor (AUTO, HORIZONTAL, VERTICAL)
% info9 = get_info(structure, 'pixel_aspect'); %devuelve (pixel_aspect_x)/(pixel_aspect_y) valor 1 indica pixel cuadrado
% info10 = get_info(structure, 'projection_matrix'); %matrix de proyección de la camara
% %DATOS DE LA ESTRUCTURA
% info11 = get_info(structure, 'name'); %string nombre de la estructura
% %info12 = get_info(structure, 'name_bvh'); %nombre del archivo.bvh asociado al esqueleto structure (VALIDO SOLO SI STRUCTURE ES UN SKELETON)
% info13 = get_info(structure, 'n_frames'); %numero de frames de la estructura
% info14 = get_info(structure, 'n_paths'); %numero de paths de la estructura
% %info15 = get_info(structure, 'n_cams'); %numero de camaras de la estructura (VALIDO SOLO SI STRUCTURE ES UN SKELETON)
% info16 = get_info(structure, 'frame_rate'); %frame rate de los frames en la estructura
% %DATOS DE UN FRAME
% info17 = get_info(structure, 'frame', 1, 'marker', 'coord'); %devuelve las coordenadas de todos los marcadores en el frame 1 de structure
% info18 = get_info(structure, 'frame', 1, 'marker', 'name'); %devuelve un cell string con los nombres de todos los marcadores en el frame 1 de structure
% info19 = get_info(structure, 'frame', 1, 'marker', 'state'); %devuelve un vector con los estados de  todos los marcadores en el frame 1 de structure
% %info20 = get_info(structure, 'frame', 1, 'marker', 'source_cam'); %devuelve un vector con las camaras fuente de todos los marcadores
% %                                                                 en el frame 1 de structure (VALIDO SOLO SI STRUCTURE ES UN SKELETON)
% info21 = get_info(structure, 'frame', 1, 'marker', [2, 3], 'coord'); %devuelve las coordenadas de los marcadores 2 y 3 del frame 1 de structure
% info22 = get_info(structure, 'frame', 1, 'marker', [2, 3], 'name'); %devuelve un cell string con los nombres de los marcadores 2 y 3 del frame 1 de structure
% info23= get_info(structure, 'frame', 1, 'marker', [2, 3], 'state'); %devuelve un vector con los estados de los marcadores 2 y 3 del frame 1 de structure
% %info24 = get_info(structure, 'frame', 1, 'marker', [2, 3],  'source_cam'); %devuelve un vector con las camaras fuente de los marcadores
% %                                                                            2 y 3 del frame 1 de structure (VALIDO SOLO SI STRUCTURE ES UN SKELETON)
% info25 = get_info(structure, 'frame', 1, 'time'); % devuelve el tiempo asociado al frame 1 de la estructura structure
% info26 = get_info(structure, 'frame', 1, 'n_markers'); % devuelve el numero de marcadores del frame 1 de la estructura structure
% 
% %DATOS DE UN PATH
% info30 = get_info(structure, 'path', 1, 'name'); % devuelve el nombre asociado a la trayectoria 1 de structure
% info31 = get_info(structure, 'path', 1, 'members'); % devuelve una matriz 2xn_markers. la primer fila son los indices de los marcadores
% %                                                        miembros de la trayectoria 1 de la estructura structure y la fila 2 son
% %                                                        los correspondientes frames.
% info32 = get_info(structure, 'path', 1, 'state') ;% devuelve una medida de calidad para la trayectoria 1 de la estructura structure
% info33 = get_info(structure, 'path', 1, 'n_markers') ;% devuelve el numero de marcadores totales en la trayectoria 1 de structure
% info34 = get_info(structure, 'path', 1, 'init_frame'); %devuelve el frame inicial de la trayectoria 1 de structure
% info35 = get_info(structure, 'path', 1, 'end_frame'); %devuelve  el frame final de la trayectoria 1 de structure
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% EJEMPLOS PARA USOS DE FUNCION
% % %DATOS DE LA CAMARA
% structure1 = set_info(structure, 'Rc', info1); %setea la matriz Rc
% structure2 = set_info(structure1, 'Tc', info2); %setea vector de traslacion Tc
% structure3 = set_info(structure2, 'focal_dist', info3); %setea distancia focal en metros f
% structure4 = set_info(structure3, 'resolution', info4); %setea [resolución_x, resolution_y] unidades en pixeles
% structure5 = set_info(structure4, 't_vista', info5); %setea tipo de vista utilizada en la camara (PERSPECTIVA, ORTOGRAFICA, PANORAMICA)
% structure6 = set_info(structure5, 'shift', info6); %setea [shift_x, shidt_y] corrimiento del centro de la camara en pixeles
% structure7 = set_info(structure6, 'sensor', info7); %setea [sensor_x, sensor_y] largo y ancho del sensor en milimetros
% structure8 = set_info(structure7, 'sensor_fit', info8); %setea tipo de ajuste utilizado para el sensor (AUTO, HORIZONTAL, VERTICAL)
% structure9 = set_info(structure8, 'pixel_aspect', info9); %setea (pixel_aspect_x)/(pixel_aspect_y) valor 1 indica pixel cuadrado
% structure10 = set_info(structure9, 'projection_matrix', info10); %setea matrix de proyección de la camara
% % %DATOS DE LA ESTRUCTURA
% structure11 = set_info(structure10, 'name', info11); %setea string nombre de la estructura
% %structure12 = set_info(structure, 'name_bvh', info12); %setea nombre del archivo.bvh asociado al esqueleto structure (VALIDO SOLO SI STRUCTURE ES UN SKELETON)
% structure13 = set_info(structure11, 'n_frames', info13); %setea numero de frames de la estructura
% structure14 = set_info(structure13, 'n_paths', info14); %setea numero de paths de la estructura
% %structure15 = set_info(structure, 'n_cams', info15); %setea numero de camaras de la estructura (VALIDO SOLO SI STRUCTURE ES UN SKELETON)
% structure16 = set_info(structure14, 'frame_rate', info16); %setea frame rate de los frames en la estructura
% % %DATOS DE FRAME
% structure17 = set_info(structure16, 'frame', 1, 'marker', 'coord', info17); %setea con las columnas de "info17" las coordenadas de todos los marcadores en el frame 1 de structure
% structure18 = set_info(structure17, 'frame', 1, 'marker', 'name', info18); %setea con las columnas del cell string "info18" los nombres de todos los marcadores en el frame 1 de structure
% structure19 = set_info(structure18, 'frame', 1, 'marker', 'state', info19); %setea con las columnas de "info19" un vector con los estados de  todos los marcadores en el frame 1 de structure
% %structure20 = set_info(structure, 'frame', 1, 'marker', 'source_cam', info20);  %setea con las columnas de "info20" un vector con las camaras fuente de todos los marcadores en el frame 1 de structure
% structure21 = set_info(structure19, 'frame', 1, 'marker', [2, 3], 'coord', info21); %setea con las columnas de "info21" las coordenadas de los marcadores 2 y 3 del frame 1 de structure
% structure22 = set_info(structure21, 'frame', 1, 'marker', [2, 3], 'name', info22); %setea con las columnas del cell string "info22" los nombres de los marcadores 2 y 3 del frame 1 de structure
% structure23 = set_info(structure22, 'frame', 1, 'marker', [2, 3], 'state', info23); %setea con las columnas de "info23"  los estados de los marcadores 2 y 3 del frame 1 de structure
% % structure24 = set_info(structure, 'frame', 1, 'marker', [2, 3], 'source_cam', info24); %setea con las columnas de "info24"  un vector con las camaras fuente de los marcadores 2 y 3 del frame 1 de structure
% structure25 = set_info(structure23, 'frame', 1, 'time', info25); % setea con el valor de "info25" el tiempo asociado al frame 1 de la estructura structure
% structure26 = set_info(structure25, 'frame', 1, 'n_markers', info26); % setea con el valor de "info26" devuelve el numero de marcadores del frame 1 de la estructura structure
% 
% %DATOS DE PATH
% structure33 = set_info(structure26, 'path', 1, 'name', info30); % setea el nombre asociado a la trayectoria 1 de structure
% structure34 = set_info(structure33, 'path', 1, 'members', info31); % setea con una matriz 2xn_markers. la primer fila son los indices de los marcadores
% % %                                                        miembros de la trayectoria 1 de la estructura structure y la fila 2 son
% % %                                                        los correspondientes frames.
% structure35 = set_info(structure34, 'path', 1, 'state', info32); % setea una medida de calidad para la trayectoria 1 de la estructura structure
% structure36 = set_info(structure35, 'path', 1, 'n_markers', info33); % setea el numero de marcadores totales en la trayectoria 1 de structure
% structure37 = set_info(structure36, 'path', 1, 'init_frame', info34); %setea el frame inicial de la trayectoria 1 de structure
% structure38 = set_info(structure37, 'path', 1, 'end_frame', info35); %setea  el frame final de la trayectoria 1 de structure
% structure39 = set_info(structure38, 'path', 1, 'members', 2, info31(:,2));% setea la columna 2 de la matriz con miembros de la trayectoria 1 de la estructura structure y la fila 2 son
% % %                                                        los correspondientes frames.
% %
%% EVALUACION
% %Para ello lo mejor es pasar todo por el xml y regresar cosa de tener todo
% %en el mismo formato
% s1.structure39 = structure39;
% struct2xml( s1, file )
% [s1]=xml2struct(file);
% structure_out=s1.structure39;
%Luego es ir viendo las difentes partes de las estructuras para ver donde
%se encuentra la diferencia y estudiarla en el codigo
% disp('----------------------------------')
% disp('structure.Attributes')
% if isequal(structure_out.Attributes, structure.Attributes)
%     disp('No se encontraron diferencias')
% else
%     disp('Se encontraron diferencias')
% end
% 
% disp('----------------------------------')
% disp('structure.frame')
% if isequal(structure_out.frame, structure.frame)
%     disp('No se encontraron diferencias')
% else
%     disp('----------------------------------')
%     disp('structure.frame.Attributes')
%     ok=1;
%     for i=1:info13 %hacer para todos los frames
%         if ~isequal(structure_out.frame{i}.Attributes, structure.frame{i}.Attributes)
%             fprintf('structure.frame{%d}.Attributes -->fallo.\n', i)
%             ok = 0;
%         end
%     end
%     if ok
%         disp('No se encontraron diferencias')
%     end
%     
%     disp('----------------------------------')
%     disp('structure.frame.marker')
%     for i=1:info13 %hacer para todos los frames
%         if ~isequal(structure_out.frame{i}.marker, structure.frame{i}.marker)
%             fprintf('structure.frame{%d}.marker -->fallo.\n', i)
%             ok = 0;
%         end
%     end
%     if ok
%         disp('No se encontraron diferencias')
%     end
%     
%     disp('----------------------------------')
%     disp('structure.frame.marker.Attributes')
%     for i=1:info13 %hacer para todos los frames        
%         for j=1:get_info(structure, 'frame', i, 'n_markers')
%             if ~isequal(structure_out.frame{i}.marker{j}.Attributes, structure.frame{i}.marker{j}.Attributes)
%                 fprintf('structure.frame{%d}.marker{%d}.Attributes -->fallo.\n', i, j)
%                 ok = 0;
%             end
%         end
%     end
%     if ok
%         disp('No se encontraron diferencias')
%     end
% end
% 
% disp('----------------------------------')
% disp('structure.path')
% if isequal(structure_out.path, structure.path)
%     disp('No se encontraron diferencias')
% else
%     for i=1:info14 %hacer para todos los paths
%         if ~isequal(structure_out.path{i}.Attributes, structure.path{i}.Attributes)
%             fprintf('structure.path{%d}.Attributes -->fallo.\n', i)
%             ok = 0;
%         end
%     end
%     if ok
%         disp('No se encontraron diferencias')
%     end
% end

%% ---------
% Author: M.R.
% created the 08/07/2014.


%% Cuerpo de la funcion

%variable auxiliares string
str1 = {'t_vista', 'sensor_fit', 'name', 'name_bvh'};
%variables auxiliares numericas
str2 = {'id', 'Rc', 'Tc', 'focal_dist', 'frame_rate', 'init_frame', 'end_frame', 'n_frames', 'n_paths', 'pixel_aspect', 'projection_matrix', ...
    'resolution', 'sensor', 'shift',};

%proceso la entrada
structure_out = varargin{1};
if iscell(structure_out)
    structure_out=structure_out{:};
end
if sum(strcmp(varargin{2}, str1)) %si el segundo argumento es algun string de str1     
    comando = ['structure_out.Attributes.', varargin{2}, '=varargin{3};', ]; %genero el comando que me setea dicho argumento    
elseif sum(strcmp(varargin{2}, str2)) %%si el segundo argumento es algun string de str2 se debe colocar un valor numerico pasado a string 
    comando = ['structure_out.Attributes.', varargin{2}, '=num2str_2(varargin{3});']; %genero el comando que me devuelve dicho argumento    
    %comando = ['structure_out.Attributes.', varargin{2}, '=(varargin{3});']; %genero el comando que me devuelve dicho argumento    
elseif strcmp(varargin{2}, 'frame') %si el segundo argumento es el string 'frame'     
    comando = ['structure_out=set_info_in_frame(structure_out, varargin{3:nargin});']; %paso del parametro 3 en adelante a la funcion get_info_frame que se encarga de obtener info de frames
elseif strcmp(varargin{2}, 'path')       
    comando = ['structure_out=set_info_in_path(structure_out, varargin{3:nargin});']; %paso del parametro 3 en adelante a la funcion get_info_path que se encarga de obtener info de paths    
end
%obtengo la salida
eval(comando);
end

%% Funciones auxiliares
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function structure_out = set_info_in_path(varargin)
% Funcion que setea la informacion de trayectoria de una estructura
%% Entrada

%  structure -----> estructura skeleton o cam(i) desde la cual se extrae la informacion
%  n_path -------> numero de trayectoria
%  t_dato1 -------> string que contiene el tipo de dato a devolver de una trayectoria
%                  Valores = {'name' 'members' 'state' 'n_markers' 'init_frame' 'end_frame'}

%% Salida
% structure_out -->informacion de salida, su tipo depende del string t_data1 y t_data2

%% ---------
% Author: M.R.
% created the 05/07/2014.
% Copyright T.R.U.C.H.A. 

%% Cuerpo de la funcion

%proceso la entrada    
    structure_out = varargin{1}; %el primer argumento es una estructura
    n_path = varargin{2};%el segundo argumento es un numero de path
    t_dato = varargin{3}; % el tercer argumento t_dato1 indica lo que se desea setear  
    info = varargin{4};
    %genero la salida
    if strcmp(t_dato, 'name') %se debe setear un dato string                
        structure_out.path{n_path}.Attributes.name = info; %devuelvo la direccion
    elseif strcmp(t_dato, 'members') %se debe setear los miembros del path
        if isscalar(info) %si info es un escalar entonces se quiere modificar solo un indice de members
            list_members = info;
            info = varargin{5};
            members = str2num(structure_out.path{n_path}.Attributes.members);
            members(:,list_members)= info;
            structure_out.path{n_path}.Attributes.members = num2str_2(members);
        else %se van a pasar todos los miembros
            structure_out.path{n_path}.Attributes.members = num2str_2(info);
        end            
    else %debo setear un tipo de dato numerico distinto a members
        eval(['structure_out.path{n_path}.Attributes.' t_dato '=num2str_2(info);']); %genero la direccion donde se aloja la informacion t_dato1        
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function structure_out = set_info_in_frame(varargin)
% Función que modifica datos de un cierto frame

%% Entrada

%  structure -----> estructura skeleton o cam(i) desde la cual se extrae la informacion
%  n_frame -------> numero de frame
%  t_dato1 -------> string que contiene el tipo de dato a devolver de un frame
%                  Valores = {'marker' 'time' 'n_markers'}
%  x_index ---------> util unicamente cuando se pide informacion de un marcador.
%                   Vector que contiene los indices de marcadores a extraer, si este parametro no se coloca por defecto se devuelven todos los marcadores
%  t_dato2     ---> string que contiene el tipo de dato a devolver de un marcador. 
%                  Valores = {'coord', 'name', 'estado', 'source_cam'}
%% Salida
%  structure ---------->
%

%% ---------
% Author: M.R.
% created the 8/07/2014.
% Copyright T.R.U.C.H.A.


%% Cuerpo de la funcion

    %proceso la entrada    
    structure_out = varargin{1}; %el primer argumento es una estructura
    n_frame = varargin{2};%el segundo argumento es un numero de frame
    t_info1 = varargin{3}; % el tercer argumento t_dato1 indica si se necesitan argumentos posteriores
    
    if strcmp(t_info1, 'marker') %se quiere setear la informacion de un grupo de marcadores        
        if ischar(varargin{4})%no se ingresaron indices de marcadores, entonces se deben devolver todos los marcadores
            t_info2 = varargin{4};
            info_in = varargin{5};
            structure_out = set_markers_in_frame(structure_out, n_frame, t_info2, info_in);
        else %se tiene los indices de marcadores a setear
            x_index = varargin{4};%lista de indices de marcadores sobre los que se debe setear la informacion           
            t_info2 = varargin{5};%indica que se quiere setear del marcador
            info_in = varargin{6};
            structure_out = set_markers_in_frame(structure_out, n_frame, x_index, t_info2, info_in);
        end
        return %ya se devuelve la salida
        
    else  %solo se quiere un atributo del frame actual, todos son numericos.
        info_in = varargin{4};        
        eval( ['structure_out.frame{n_frame}.Attributes.', t_info1 ,'=num2str_2(info_in);']); %genero la direccion donde se aloja la informacion t_dato1        
    end    

end

%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%
function structure = set_markers_in_frame(varargin)
% Función que modifica datos de marcadores de un cierto frame

%% Entrada

%  structure ----->estructura skeleton o cam(i) desde la cual se extrae la informacion
%  n_frame ------->numero de frame
%  list_markers -->vector que contiene los marcadores a setear, si este parametro no se coloca por defecto se setean todos los marcadores
%  t_dato     ---->string que contiene el tipo de dato a setear. 
%                  Valores = {'coord', 'name', 'estado', 'source_cam', 'like_markers', 'like_cams', 'dist_min'}
%  
%% Salida
%  structure ---------->estructura de entrada con el dato ya modificado
%
%% ---------
% Author: M.R.
% created the 8/07/2014.
% Copyright T.R.U.C.H.A.

%% Cuerpo de la funcion

    %proceso la entrada
    
    structure = varargin{1};   
    n_frame = varargin{2};
    list_markers = -1;% se setean todos los marcadores
    if ischar(varargin{3}) %si varargin es un caracter
        t_info = varargin{3};
        info = varargin{4};
    else %de lo contrario estan pasando un vector
        list_markers = varargin{3};
        t_info = varargin{4};
        info = varargin{5};        
    end
    
    
    %verifico que se este pidiendo un frame que existe en la estructura
    if n_frame > str2double(structure.Attributes.n_frames)
        str = ['Se solicita un numero de frame mayor al que contiene la estructura ' ...
            structure.Attributes.name];
        error('n_frame:IndiceFueraDeRango',str)
    end
    
    
    n_markers = str2double(structure.frame{n_frame}.Attributes.n_markers); %nro de marcadores con informacion en el frame n_frame
    
    %verifico que se intenga setear un marcador que no existe en la estructura    
    if  sum(list_markers > (n_markers+1)) 
        str = ['En list_markers se solicita al menos un indice de marcador mayor al que contiene la estructura ' ...
            structure.Attributes.name sprintf(' en el frame %d .\n', n_frame )];
        error('list_markers:IndiceNoContiguo',str) %se lanza excepcion pues se estan seteando marcadores inexistentes   
    end
    
    %encuentro cuantos marcadores se deben ingresar
    if (length(list_markers)==1) && (list_markers == -1) %en este caso se devuelven todos los marcadores        
        n_markers = str2double(structure.frame{n_frame}.Attributes.n_markers);
        list_markers = 1:n_markers;
    else %solo se devuelven los marcadores de list_markers
        n_markers = length(list_markers);
    end
          
    %obtengo la salida    
    if strcmp(t_info, 'coord') %se setean ambas coordenadas
        for j=1:n_markers %con cada elemento de list_markers            
            structure.frame{n_frame}.marker{list_markers(j)}.Attributes.x = num2str_2(info(1, j));
            structure.frame{n_frame}.marker{list_markers(j)}.Attributes.y = num2str_2(info(2, j));
            structure.frame{n_frame}.marker{list_markers(j)}.Attributes.z = num2str_2(info(3, j));            
        end        
    elseif strcmp(t_info, 'name') %se tiene que setear un string a partir de cell array de strings
        for j=1:n_markers %con cada elemento de list_markers
            structure.frame{n_frame}.marker{list_markers(j)}.Attributes.name = info{j};
        end
    elseif strcmp(t_info, 'state') %se setea el estado de los marcadores
        for j=1:n_markers %con cada elemento de list_markers
            structure.frame{n_frame}.marker{list_markers(j)}.Attributes.state = num2str_2(info(j));
        end        
    else %se setea las camaras de origen de los marcadores
        for j=1:n_markers %con cada elemento de list_markers
            structure.frame{n_frame}.marker{list_markers(j)}.Attributes.source_cam = num2str_2(info(:,j));
        end        
    end    
end

%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%

function str = num2str_2(num)
%Funcion que permite llevar los numero a string en un formato adecuado para
%el xml y las resoluciones que se necesitan
str = num2str(num, '%30.13g');
end

