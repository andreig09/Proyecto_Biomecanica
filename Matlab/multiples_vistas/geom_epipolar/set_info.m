function structure_out = set_info(varargin)
% Funcion que setea información de estructuras skeleton o cam(i)
%% Entrada
% structure --> una estructura cam(i) o skeleton
% lista de argumento, ver la sección de ejemplos, en la misma se
% tiene todas las posibles entradas.

%% Salida
% structure_out -->estructura seteada
%% EJEMPLOS
% %SE CARGAN LAS ENTRADAS PARA PROBAR LA FUNCION
%   %structure=cam(1);
% structure = skeleton;
% %DATOS DE LA CAMARA
% %  info1 = get_info(structure, 'Rc'); %devuelve la matriz Rc
% %  info2 = get_info(structure, 'Tc'); %devuelve vector de traslacion Tc
% %  info3 = get_info(structure, 'f'); %devuelve distancia focal en metros f 
% %  info4 = get_info(structure, 'resolution'); %devuelve [resolución_x, resolution_y] unidades en pixeles
% %  info5 = get_info(structure, 't_vista'); %devuelve tipo de vista utilizada en la camara (PERSPECTIVA, ORTOGRAFICA, PANORAMICA)
% %  info6 = get_info(structure, 'shift'); %devuelve [shift_x, shidt_y] corrimiento del centro de la camara en pixeles
% %  info7 = get_info(structure, 'sensor'); %devuelve [sensor_x, sensor_y] largo y ancho del sensor en milimetros
% %  info8 = get_info(structure, 'sensor_fit'); %devuelve tipo de ajuste utilizado para el sensor (AUTO, HORIZONTAL, VERTICAL)
% %  info9 = get_info(structure, 'pixel_aspect'); %devuelve (pixel_aspect_x)/(pixel_aspect_y) valor 1 indica pixel cuadrado
% %  info10 = get_info(structure, 'projection_matrix'); %matrix de proyección de la camara
% %DATOS DE LA ESTRUCTURA
%  info11 = get_info(structure, 'name'); %string nombre de la estructura
%  info12 = get_info(structure, 'name_bvh'); %nombre del archivo.bvh asociado al esqueleto structure (VALIDO SOLO SI STRUCTURE ES UN SKELETON)
%  info13 = get_info(structure, 'n_frames'); %numero de frames de la estructura
%  info14 = get_info(structure, 'n_paths'); %numero de paths de la estructura
%  info15 = get_info(structure, 'n_cams'); %numero de camaras de la estructura (VALIDO SOLO SI STRUCTURE ES UN SKELETON)
%  info16 = get_info(structure, 'frame_rate'); %frame rate de los frames en la estructura
% %DATOS DE UN FRAME
%  info17 = get_info(structure, 'frame', 1, 'marker', 'coord'); %devuelve las coordenadas de todos los marcadores en el frame 1 de structure
%  info18 = get_info(structure, 'frame', 1, 'marker', 'name'); %devuelve un cell string con los nombres de todos los marcadores en el frame 1 de structure
%  info19 = get_info(structure, 'frame', 1, 'marker', 'state'); %devuelve un vector con los estados de  todos los marcadores en el frame 1 de structure
%  info20 = get_info(structure, 'frame', 1, 'marker', 'source_cam'); %devuelve un vector con las camaras fuente de todos los marcadores 
%  %                                                                 en el frame 1 de structure (VALIDO SOLO SI STRUCTURE ES UN SKELETON)
%  info21 = get_info(structure, 'frame', 1, 'marker', [2, 3], 'coord'); %devuelve las coordenadas de los marcadores 2 y 3 del frame 1 de structure
%  info22 = get_info(structure, 'frame', 1, 'marker', [2, 3], 'name'); %devuelve un cell string con los nombres de los marcadores 2 y 3 del frame 1 de structure
%  info23= get_info(structure, 'frame', 1, 'marker', [2, 3], 'state'); %devuelve un vector con los estados de los marcadores 2 y 3 del frame 1 de structure
%  info24 = get_info(structure, 'frame', 1, 'marker', [2, 3],  'source_cam'); %devuelve un vector con las camaras fuente de los marcadores 
%   %                                                                            2 y 3 del frame 1 de structure (VALIDO SOLO SI STRUCTURE ES UN SKELETON)
%  info25 = get_info(structure, 'frame', 1, 'time'); % devuelve el tiempo asociado al frame 1 de la estructura structure
%  info26 = get_info(structure, 'frame', 1, 'n_markers'); % devuelve el numero de marcadores del frame 1 de la estructura structure
%  info27 = get_info(structure, 'frame', 1, 'mapping_table'); %devuelve la tabla de mapeo del frame 1 de la estructura structure
%  info28 = get_info(structure, 'frame', 1, 'like_cams'); %devuelve un vector cuya columna j contiene el numero de la camara  
%    %                                                           sobre las que se hizo la correspondencia en la columna j de mapping_table 
%    %                                                           del frame 1 de la estructura structure
%  info29 = get_info(structure, 'frame', 1, 'd_min'); %matriz que contiene una medida de calidad para cada dato coorespondiente en mapping_table 
%    %                                                     del frame 1 de la estructura structure
% %DATOS DE UN PATH
%  info30 = get_info(structure, 'path', 1, 'name'); % devuelve el nombre asociado a la trayectoria 1 de structure
%   info31 = get_info(structure, 'path', 1, 'members'); % devuelve una matriz 2xn_markers. la primer fila son los indices de los marcadores
% %                                                        miembros de la trayectoria 1 de la estructura structure y la fila 2 son
% %                                                        los correspondientes frames.
%   info32 = get_info(structure, 'path', 1, 'state') ;% devuelve una medida de calidad para la trayectoria 1 de la estructura structure
%   info33 = get_info(structure, 'path', 1, 'n_markers') ;% devuelve el numero de marcadores totales en la trayectoria 1 de structure
%   info34 = get_info(structure, 'path', 1, 'init_frame'); %devuelve el frame inicial de la trayectoria 1 de structure
%   info35 = get_info(structure, 'path', 1, 'end_frame'); %devuelve  el frame final de la trayectoria 1 de structure
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %EJEMPLOS PARA USOS DE FUNCION
% %DATOS DE LA CAMARA
%  structure1 = set_info(structure, 'Rc', info1); %setea la matriz Rc
%  structure2 = set_info(structure, 'Tc', info2); %setea vector de traslacion Tc
%  structure3 = set_info(structure, 'f', info3); %setea distancia focal en metros f 
%  structure4 = set_info(structure, 'resolution', info4); %setea [resolución_x, resolution_y] unidades en pixeles
%  structure5 = set_info(structure, 't_vista', info5); %setea tipo de vista utilizada en la camara (PERSPECTIVA, ORTOGRAFICA, PANORAMICA)
%  structure6 = set_info(structure, 'shift', info6); %setea [shift_x, shidt_y] corrimiento del centro de la camara en pixeles
%  structure7 = set_info(structure, 'sensor', info7); %setea [sensor_x, sensor_y] largo y ancho del sensor en milimetros
%  structure8 = set_info(structure, 'sensor_fit', info8); %setea tipo de ajuste utilizado para el sensor (AUTO, HORIZONTAL, VERTICAL)
%  structure9 = set_info(structure, 'pixel_aspect', info9); %setea (pixel_aspect_x)/(pixel_aspect_y) valor 1 indica pixel cuadrado
%  structure10 = set_info(structure, 'projection_matrix', info10); %setea matrix de proyección de la camara
% %DATOS DE LA ESTRUCTURA
%  structure11 = set_info(structure, 'name', info11); %setea string nombre de la estructura
%  structure12 = set_info(structure, 'name_bvh', info12); %setea nombre del archivo.bvh asociado al esqueleto structure (VALIDO SOLO SI STRUCTURE ES UN SKELETON)
%  structure13 = set_info(structure, 'n_frames', info13); %setea numero de frames de la estructura
%  structure14 = set_info(structure, 'n_paths', info14); %setea numero de paths de la estructura
%  structure15 = set_info(structure, 'n_cams', info15); %setea numero de camaras de la estructura (VALIDO SOLO SI STRUCTURE ES UN SKELETON)
%  structure16 = set_info(structure, 'frame_rate', info16); %setea frame rate de los frames en la estructura
% %DATOS DE FRAME
% structure17 = set_info(structure, 'frame', 1, 'marker', 'coord', info17); %setea con las columnas de "info17" las coordenadas de todos los marcadores en el frame 1 de structure
% structure18 = set_info(structure, 'frame', 1, 'marker', 'name', info18); %setea con las columnas del cell string "info18" los nombres de todos los marcadores en el frame 1 de structure
% structure19 = set_info(structure, 'frame', 1, 'marker', 'state', info19); %setea con las columnas de "info19" un vector con los estados de  todos los marcadores en el frame 1 de structure
% structure20 = set_info(structure, 'frame', 1, 'marker', 'source_cam', info20);  %setea con las columnas de "info20" un vector con las camaras fuente de todos los marcadores en el frame 1 de structure
% structure21 = set_info(structure, 'frame', 1, 'marker', [2, 3], 'coord', info21); %setea con las columnas de "info21" las coordenadas de los marcadores 2 y 3 del frame 1 de structure
% structure22 = set_info(structure, 'frame', 1, 'marker', [2, 3], 'name', info22); %setea con las columnas del cell string "info22" los nombres de los marcadores 2 y 3 del frame 1 de structure
% structure23 = set_info(structure, 'frame', 1, 'marker', [2, 3], 'state', info23); %setea con las columnas de "info23"  los estados de los marcadores 2 y 3 del frame 1 de structure
% structure24 = set_info(structure, 'frame', 1, 'marker', [2, 3], 'source_cam', info24); %setea con las columnas de "info24"  un vector con las camaras fuente de los marcadores 2 y 3 del frame 1 de structure 
% structure25 = set_info(structure, 'frame', 1, 'time', info25); % setea con el valor de "info25" el tiempo asociado al frame 1 de la estructura structure
% structure26 = set_info(structure, 'frame', 1, 'n_markers', info26); % setea con el valor de "info26" devuelve el numero de marcadores del frame 1 de la estructura structure
% structure27 = set_info(structure, 'frame', 1, 'mapping_table', info27); %setea con la matriz "info27" la tabla de mapeo del frame 1 de la estructura structure
% structure28 = set_info(structure, 'frame', 1, 'like_cams', info28); %setea con el vector "info28" el vector like_cams del frame 1 de la estructura structure
% structure29 = set_info(structure, 'frame', 1, 'd_min', info29); %setea con la matriz "info29" la matriz d_min que contiene una medida de calidad para cada dato coorespondiente en mapping_table 
% structure30 = set_info(structure, 'frame', 1, 'mapping_table','element', [1 2], info27(1,2)); %setea con el valor "info30" el elemento (1, 2) de la tabla de mapeo del frame 1 de la estructura structure
% structure31 = set_info(structure, 'frame', 1, 'like_cams', 'element', [2], info28(2)); %setea con el valor "info31" el elemento (2) el vector like_cams del frame 1 de la estructura structure
% structure32 = set_info(structure, 'frame', 1, 'd_min', 'element', [1 2], info29(1, 2)); %setea con el valor "info32" el elemento (1, 2) de la matriz d_min que contiene una medida de calidad para cada dato coorespondiente en mapping_table 
% %DATOS DE PATH
% structure33 = set_info(structure, 'path', 1, 'name', info30); % setea el nombre asociado a la trayectoria 1 de structure
% structure34 = set_info(structure, 'path', 1, 'members', info31); % setea con una matriz 2xn_markers. la primer fila son los indices de los marcadores
% %                                                        miembros de la trayectoria 1 de la estructura structure y la fila 2 son
% %                                                        los correspondientes frames.
%  structure35 = set_info(structure, 'path', 1, 'state', info32); % setea una medida de calidad para la trayectoria 1 de la estructura structure
%  structure36 = set_info(structure, 'path', 1, 'n_markers', info33); % setea el numero de marcadores totales en la trayectoria 1 de structure
%  structure37 = set_info(structure, 'path', 1, 'init_frame', info34); %setea el frame inicial de la trayectoria 1 de structure
%  structure38 = set_info(structure, 'path', 1, 'end_frame', info35); %setea  el frame final de la trayectoria 1 de structure
%  structure39 = set_info(structure, 'path', 1, 'members', 2, info31(:,2));% setea la columna 2 de la matriz con miembros de la trayectoria 1 de la estructura structure y la fila 2 son
% %                                                        los correspondientes frames.
% 
% %EVALUACION
% for i=1:39
%   eval(sprintf('isequal(structure%d, structure)', i)) %si todas la  salidas son 1 entonces funciona la prueba de codigo
%   disp(i)
% end
%% ---------
% Author: M.R.
% created the 08/07/2014.


%% Cuerpo de la funcion

%variable auxiliar
str1 = {'Rc', 'Tc', 'f', 'resolution', 't_vista', 'shift', 'sensor', 'sensor_fit', 'pixel_aspect', 'projection_matrix' };
str2 = {'name', 'name_bvh', 'n_frames', 'n_paths', 'n_cams', 'frame_rate'};

%proceso la entrada
structure_out = varargin{1};
if sum(strcmp(varargin{2}, str1)) %si el segundo argumento es algun string de str1 
    %comando = sprintf('structure_out.info.%s=varargin{3};', varargin{2}); %genero el comando que me setea dicho argumento    
    comando = ['structure_out.info.', varargin{2}, '=varargin{3};', ]; %genero el comando que me setea dicho argumento    
elseif sum(strcmp(varargin{2}, str2)) %si el segundo argumento es algun string de str2
    %comando = sprintf('structure_out.%s=varargin{3};', varargin{2}); %genero el comando que me devuelve dicho argumento    
    comando = ['structure_out.', varargin{2}, '=varargin{3};']; %genero el comando que me devuelve dicho argumento    
elseif strcmp(varargin{2}, 'frame') %si el segundo argumento es el string 'frame' 
    %comando = sprintf('structure_out=set_info_in_frame(structure_out, varargin{3:nargin});'); %paso del parametro 3 en adelante a la funcion get_info_frame que se encarga de obtener info de frames
    comando = ['structure_out=set_info_in_frame(structure_out, varargin{3:nargin});']; %paso del parametro 3 en adelante a la funcion get_info_frame que se encarga de obtener info de frames
elseif strcmp(varargin{2}, 'path')   
    %comando = sprintf('structure_out=set_info_in_path(structure_out, varargin{3:nargin});'); %paso del parametro 3 en adelante a la funcion get_info_path que se encarga de obtener info de paths    
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
%% Ejemplos 
% %SE CARGAN LAS ENTRADAS PARA PROBAR LA FUNCION 
%  structure = skeleton;
% % %structure = cam(2);
%   info14 = get_info(structure, 'path', 1, 'name'); % devuelve el nombre asociado a la trayectoria 1 de structure
%   info15 = get_info(structure, 'path', 1, 'members'); % devuelve una matriz 2xn_markers. la primer fila son los indices de los marcadores
% %                                                        miembros de la trayectoria 1 de la estructura structure y la fila 2 son
% %                                                        los correspondientes frames.
%   info16 = get_info(structure, 'path', 1, 'state') ;% devuelve una medida de calidad para la trayectoria 1 de la estructura structure
%   info17 = get_info(structure, 'path', 1, 'n_markers') ;% devuelve el numero de marcadores totales en la trayectoria 1 de structure
%   info18 = get_info(structure, 'path', 1, 'init_frame'); %devuelve el frame inicial de la trayectoria 1 de structure
%   info19 = get_info(structure, 'path', 1, 'end_frame'); %devuelve  el frame final de la trayectoria 1 de structure
% %
% % EJEMPLOS PARA USOS DE FUNCION
%  structure14 = set_info_in_path(structure, 1, 'name', info14); % setea el nombre asociado a la trayectoria 1 de structure
%  structure15 = set_info_in_path(structure, 1, 'members', info15); % setea con una matriz 2xn_markers. la primer fila son los indices de los marcadores
% %                                                        miembros de la trayectoria 1 de la estructura structure y la fila 2 son
% %                                                        los correspondientes frames.
%  structure16 = set_info_in_path(structure, 1, 'state', info16); % setea una medida de calidad para la trayectoria 1 de la estructura structure
%  structure17 = set_info_in_path(structure, 1, 'n_markers', info17); % setea el numero de marcadores totales en la trayectoria 1 de structure
%  structure18 = set_info_in_path(structure, 1, 'init_frame', info18); %setea el frame inicial de la trayectoria 1 de structure
%  structure19 = set_info_in_path(structure, 1, 'end_frame', info19); %setea  el frame final de la trayectoria 1 de structure
%  structure20 = set_info_in_path(structure, 1, 'members', 2, info15(:,2));% setea la columna 2 de la matriz con miembros de la trayectoria 1 de la estructura structure y la fila 2 son
% %                                                        los correspondientes frames.
% %
% % EVALUACION
%  for i=14:20
%    eval(sprintf('isequal(structure%d, structure)', i)) %si todas la  salidas son 1 entonces funciona la prueba de codigo
%   disp(i)
%  end

%% ---------
% Author: M.R.
% created the 05/07/2014.
% Copyright T.R.U.C.H.A. 

%% Cuerpo de la funcion

    %proceso la entrada    
    structure_out = varargin{1}; %el primer argumento es una estructura
    n_path = varargin{2};%el segundo argumento es un numero de frame
    t_dato1 = varargin{3}; % el tercer argumento t_dato1 indica lo que se desea setear  
    if (isequal(size(varargin{4}), [1 1]))&& strcmp(t_dato1, 'members') %si tiene una columna de una lista de miembros 
        list_member = varargin{4}; %contiene el miembro a cambiar       
        info = varargin{5}; %debe contener un vector 2x1 cuya primera fila es el indice de marcador y la segunda el frame correspondiente
        column=num2cell(info, 1); %coloca los vectores columnas de "info" dentro de un cell que compone un cell array.
        %comando = sprintf('structure_out.path(n_path).%s(:,list_member)=column{:};', t_dato1 ); %copia cada elemento del cell array "colums" en una correspondiente columna de members
        comando = ['structure_out.path(n_path).', t_dato1 ,'(:,list_member)=column{:};']; %copia cada elemento del cell array "colums" en una correspondiente columna de members
    else %el argumento es información para ingresar
        info = varargin{4};
        %comando = sprintf('structure_out.path(n_path).%s=info;', t_dato1 ); %genero la salida       
        comando = ['structure_out.path(n_path).', t_dato1 ,'=info;']; %genero la salida       
    end%genero la salida
    eval(comando);    

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
%% Ejemplos
% %SE CARGAN LAS ENTRADAS PARA PROBAR LA FUNCION
% structure = skeleton;
% %structure = cam(2);
%  info1 = get_info(structure, 'frame', 1, 'marker', 'coord'); %devuelve las coordenadas de todos los marcadores en el frame 1 de structure
%  info2 = get_info(structure, 'frame', 1, 'marker', 'name'); %devuelve un cell string con los nombres de todos los marcadores en el frame 1 de structure
%  info3 = get_info(structure, 'frame', 1, 'marker', 'state'); %devuelve un vector con los estados de  todos los marcadores en el frame 1 de structure
%  info4 = get_info(structure, 'frame', 1, 'marker', 'source_cam'); %devuelve un vector con las camaras fuente de todos los marcadores 
% %                                                                  en el frame 1 de structure (VALIDO SOLO SI STRUCTURE ES UN SKELETON)
%  info5 = get_info(structure, 'frame', 1, 'marker', [2, 3], 'coord'); %devuelve las coordenadas de los marcadores 2 y 3 del frame 1 de structure
%  info6 = get_info(structure, 'frame', 1, 'marker', [2, 3], 'name'); %devuelve un cell string con los nombres de los marcadores 2 y 3 del frame 1 de structure
%  info7 = get_info(structure, 'frame', 1, 'marker', [2, 3], 'state'); %devuelve un vector con los estados de los marcadores 2 y 3 del frame 1 de structure
%  info8 = get_info(structure, 'frame', 1, 'marker', [2, 3],  'source_cam'); %devuelve un vector con las camaras fuente de los marcadores 
%  %                                                                             2 y 3 del frame 1 de structure (VALIDO SOLO SI STRUCTURE ES UN SKELETON)
%  info9 = get_info(structure, 'frame', 1, 'time'); % devuelve el tiempo asociado al frame 1 de la estructura structure
%  info10 = get_info(structure, 'frame', 1, 'n_markers'); % devuelve el numero de marcadores del frame 1 de la estructura structure
%  info11 = get_info(structure, 'frame', 1, 'mapping_table'); %devuelve la tabla de mapeo del frame 1 de la estructura structure
%  info12 = get_info(structure, 'frame', 1, 'like_cams'); %devuelve un vector cuya columna j contiene el numero de la camara  
%   %                                                            sobre las que se hizo la correspondencia en la columna j de mapping_table 
%   %                                                            del frame 1 de la estructura structure
%  info13 = get_info(structure, 'frame', 1, 'd_min'); %matriz que contiene una medida de calidad para cada dato coorespondiente en mapping_table 
%    %                                                     del frame 1 de la estructura structure
% %EJEMPLOS PARA USOS DE FUNCION
% structure1 = set_info_in_frame(structure, 1, 'marker', 'coord', info1); %setea con las columnas de "info1" las coordenadas de todos los marcadores en el frame 1 de structure
% structure2 = set_info_in_frame(structure, 1, 'marker', 'name', info2); %setea con las columnas del cell string "info2" los nombres de todos los marcadores en el frame 1 de structure
% structure3 = set_info_in_frame(structure, 1, 'marker', 'state', info3); %setea con las columnas de "info3" un vector con los estados de  todos los marcadores en el frame 1 de structure
% structure4 = set_info_in_frame(structure, 1, 'marker', 'source_cam', info4);  %setea con las columnas de "info4" un vector con las camaras fuente de todos los marcadores en el frame 1 de structure
% structure5 = set_info_in_frame(structure, 1, 'marker', [2, 3], 'coord', info5); %setea con las columnas de "info5" las coordenadas de los marcadores 2 y 3 del frame 1 de structure
% structure6 = set_info_in_frame(structure, 1, 'marker', [2, 3], 'name', info6); %setea con las columnas del cell string "info6" los nombres de los marcadores 2 y 3 del frame 1 de structure
% structure7 = set_info_in_frame(structure, 1, 'marker', [2, 3], 'state', info7); %setea con las columnas de "info7"  los estados de los marcadores 2 y 3 del frame 1 de structure
% structure8 = set_info_in_frame(structure, 1, 'marker', [2, 3], 'source_cam', info8); %setea con las columnas de "info8"  un vector con las camaras fuente de los marcadores 2 y 3 del frame 1 de structure 
% structure9 = set_info_in_frame(structure,  1, 'time', info9); % setea con el valor de "info9" el tiempo asociado al frame 1 de la estructura structure
% structure10 = set_info_in_frame(structure,  1, 'n_markers', info10); % setea con el valor de "info10" devuelve el numero de marcadores del frame 1 de la estructura structure
% structure11 = set_info_in_frame(structure, 1, 'mapping_table', info11); %setea con la matriz "info11" la tabla de mapeo del frame 1 de la estructura structure
% structure12 = set_info_in_frame(structure,  1, 'like_cams', info12); %setea con el vector "info12" el vector like_cams del frame 1 de la estructura structure
% structure13 = set_info_in_frame(structure,  1, 'd_min', info13); %setea con la matriz info13 la matriz d_min que contiene una medida de calidad para cada dato coorespondiente en mapping_table 
% structure14 = set_info_in_frame(structure, 1, 'mapping_table','element', [1 2], info11(1, 2)); %setea con el valor "info11" el elemento (1, 2) de la tabla de mapeo del frame 1 de la estructura structure
% structure15 = set_info_in_frame(structure,  1, 'like_cams', 'element', [2], info12(2)); %setea con el valor "info12" el elemento (2) el vector like_cams del frame 1 de la estructura structure
% structure16 = set_info_in_frame(structure,  1, 'd_min', 'element', [1 2], info13(1, 2)); %setea con el valor "info11" el elemento (1, 2) de la matriz d_min que contiene una medida de calidad para cada dato coorespondiente en mapping_table 
%                                                        
% %EVALUACION
% for i=1:16
%   eval(sprintf('isequal(structure%d, structure)', i)) %si todas la  salidas son 1 entonces funciona la prueba de codigo   
%   disp(i)
% end
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
        %t_dato1 = 'marker'; 
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
        
    elseif sum(strcmp(t_info1, {'like_cams', 'mapping_table', 'd_min'})) % se quiere setear informacion de la estructura like
        if strcmp(varargin{4}, 'element') %se quiere setear un solo elemento
            indice = varargin{5}; %contiene el indice del miembro a setear       
            info_in = varargin{6}; %contiene la info del miembro a setear
            %column=num2cell(info, 1); %coloca los vectores columnas de "info" dentro de un cell que compone un cell array.
            if isequal(size(indice), [1 1]) %se tiene un numero y entonces se quiere setear like_cams
                %comando = sprintf('structure_out.frame(n_frame).like.%s(indice(1))=info_in;', t_info1 ); %copia cada elemento del cell array "colums" en una correspondiente columna de members            
                comando = ['structure_out.frame(n_frame).like.', t_info1  , '(indice(1))=info_in;']; %copia cada elemento del cell array "colums" en una correspondiente columna de members            
            else %se quiere setear un dato de una matriz en mapping_table o dmin
                %comando = sprintf('structure_out.frame(n_frame).like.%s(indice(1), indice(2))=info_in;', t_info1 ); %copia cada elemento del cell array "colums" en una correspondiente columna de members            
                comando = ['structure_out.frame(n_frame).like.', t_info1, '(indice(1), indice(2))=info_in;']; %copia cada elemento del cell array "colums" en una correspondiente columna de members            
            end            
        else % se quiere setear un campo completo
            info_in = varargin{4};
            comando = ['structure_out.frame(n_frame).like.', t_info1 ,'=info_in;'];%dejo los posibles comandos en funcion del parametro "t_dato1"    
        end          
    else %solo se quiere setear informacion del frame actual fuera de subestructuras marker o like
        info_in = varargin{4};
        %comando = sprintf('structure_out.frame(n_frame).%s=info_in;', t_info1 ); %genero la dirección donde se aloja la informacion t_dato1        
        comando = ['structure_out.frame(n_frame).', t_info1 ,'=info_in;']; %genero la dirección donde se aloja la informacion t_dato1        
    end
    eval(comando);

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
%% Ejemplos
% %SE CARGAN LAS ENTRADAS PARA PROBAR LA FUNCION
% structure = skeleton;
% %structure = cam(2);
%  info1 = get_info(structure, 'frame', 1, 'marker', 'coord'); %devuelve las coordenadas de todos los marcadores en el frame 1 de structure
%  info2 = get_info(structure, 'frame', 1, 'marker', 'name'); %devuelve un cell string con los nombres de todos los marcadores en el frame 1 de structure
%  info3 = get_info(structure, 'frame', 1, 'marker', 'state'); %devuelve un vector con los estados de  todos los marcadores en el frame 1 de structure
%  info4 = get_info(structure, 'frame', 1, 'marker', 'source_cam'); %devuelve un vector con las camaras fuente de todos los marcadores 
% %                                                                  en el frame 1 de structure (VALIDO SOLO SI STRUCTURE ES UN SKELETON)
%  info5 = get_info(structure, 'frame', 1, 'marker', [2, 3], 'coord'); %devuelve las coordenadas de los marcadores 2 y 3 del frame 1 de structure
%  info6 = get_info(structure, 'frame', 1, 'marker', [2, 3], 'name'); %devuelve un cell string con los nombres de los marcadores 2 y 3 del frame 1 de structure
%  info7 = get_info(structure, 'frame', 1, 'marker', [2, 3], 'state'); %devuelve un vector con los estados de los marcadores 2 y 3 del frame 1 de structure
%  info8 = get_info(structure, 'frame', 1, 'marker', [2, 3],  'source_cam'); %devuelve un vector con las camaras fuente de los marcadores 
%  %                                                                             2 y 3 del frame 1 de structure (VALIDO SOLO SI STRUCTURE ES UN SKELETON)
% %EJEMPLOS PARA USOS DE FUNCION
% structure1 = set_markers_in_frame(structure, 1, 'coord', info1); %setea con las columnas de "info1" las coordenadas de todos los marcadores en el frame 1 de structure
% structure2 = set_markers_in_frame(structure, 1, 'name', info2); %setea con las columnas del cell string "info2" los nombres de todos los marcadores en el frame 1 de structure
% structure3 = set_markers_in_frame(structure, 1, 'state', info3); %setea con las columnas de "info3" un vector con los estados de  todos los marcadores en el frame 1 de structure
% structure4 = set_markers_in_frame(structure, 1, 'source_cam', info4);  %setea con las columnas de "info4" un vector con las camaras fuente de todos los marcadores en el frame 1 de structure
% structure5 = set_markers_in_frame(structure, 1, [2, 3], 'coord', info5); %setea con las columnas de "info5" las coordenadas de los marcadores 2 y 3 del frame 1 de structure
% structure6 = set_markers_in_frame(structure, 1, [2, 3], 'name', info6); %setea con las columnas del cell string "info6" los nombres de los marcadores 2 y 3 del frame 1 de structure
% structure7 = set_markers_in_frame(structure, 1, [2, 3], 'state', info7); %setea con las columnas de "info7"  los estados de los marcadores 2 y 3 del frame 1 de structure
% structure8 = set_markers_in_frame(structure, 1, [2, 3], 'source_cam', info8); %setea con las columnas de "info8"  un vector con las camaras fuente de los marcadores 2 y 3 del frame 1 de structure 
% %EVALUACION
% for i=1:8
%   eval(sprintf('isequal(structure%d, structure)', i)) %si todas la  salidas son 1 entonces funciona la prueba de codigo
%   disp(i)
% end

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
    if n_frame > structure.n_frames
        str = ['Se solicita un numero de frame mayor al que contiene la estructura ' ...
            structure.name];
        error('n_frame:IndiceFueraDeRango',str)
    end
    
    
    n_markers = get_info(structure, 'frame', n_frame, 'n_markers'); %nro de marcadores con informacion en el frame n_frame
    
    %verifico que se intenga setear un marcador que no existe en la estructura    
    if  sum(list_markers > (n_markers+1)) 
        str = ['En list_markers se solicita al menos un indice de marcador mayor al que contiene la estructura ' ...
            structure.name sprintf(' en el frame %d .\n', n_frame )];
        error('list_markers:IndiceNoContiguo',str) %se lanza excepcion pues se estan seteando marcadores inexistentes   
    end
    
    
          
    %obtengo la salida    
    if (length(list_markers)==1) && (list_markers == -1) %en este caso se devuelven todos los marcadores 
        if strcmp(t_info, 'name') %en el caso ya se tiene un cell array en la entrada
            columns = info;
        else %en este caso la entrada tiene matrices de numeros
            columns=num2cell(info, 1); %coloca los vectores columnas de "dato" dentro de un cell que compone un cell array.
        end
        %eval(sprintf('[structure.frame(n_frame).marker(1:n_markers).%s]=columns{:};', t_info)); %copia cada elemento del cell array "colums" en un correspondiente marcador
        eval(['[structure.frame(n_frame).marker(1:n_markers).', t_info  , ']=columns{:};']); %copia cada elemento del cell array "colums" en un correspondiente marcador
    else
        if strcmp(t_info, 'name') %en el caso ya se tiene un cell array en la entrada
            columns = info;
        else %en este caso la entrada tiene matrices de numeros
            columns=num2cell(info, 1); %coloca los vectores columnas de "dato" dentro de un cell que compone un cell array.
        end
        %eval(sprintf('[structure.frame(n_frame).marker(list_markers).%s]=columns{:};', t_info)); %copia cada elemento del cell array "colums" en un correspondiente marcador 
        eval(['[structure.frame(n_frame).marker(list_markers).', t_info, ']=columns{:};']); %copia cada elemento del cell array "colums" en un correspondiente marcador 
    end
    
    
end


