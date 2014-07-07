function info_out = get_info(varargin)
% Funcion que recupera información de estructuras skeleton o cam(i)
%% Entrada
% structure --> una estructura cam(i) o skeleton
% lista de argumento, ver la sección de ejemplos, en la misma se
% tiene todas las posibles entradas.

%% Salida
% info_out -->informacion de salida
%% EJEMPLOS
%  structure=cam(1);
% DATOS DE LA CAMARA
%  info_out = get_info(structure, 'Rc') %devuelve la matriz Rc
%  info_out = get_info(structure, 'Tc') %devuelve vector de traslacion Tc
%  info_out = get_info(structure, 'f') %devuelve distancia focal en metros f 
%  info_out = get_info(structure, 'resolution') %devuelve [resolución_x, resolution_y] unidades en pixeles
%  info_out = get_info(structure, 't_vista') %devuelve tipo de vista utilizada en la camara (PERSPECTIVA, ORTOGRAFICA, PANORAMICA)
%  info_out = get_info(structure, 'shift') %devuelve [shift_x, shidt_y] corrimiento del centro de la camara en pixeles
%  info_out = get_info(structure, 'sensor') %devuelve [sensor_x, sensor_y] largo y ancho del sensor en milimetros
%  info_out = get_info(structure, 'sensor_fit') %devuelve tipo de ajuste utilizado para el sensor (AUTO, HORIZONTAL, VERTICAL)
%  info_out = get_info(structure, 'pixel_aspect') %devuelve (pixel_aspect_x)/(pixel_aspect_y) valor 1 indica pixel cuadrado
%  info_out = get_info(structure, 'projection_matrix') %matrix de proyección de la camara
% DATOS DE LA ESTRUCTURA
%  info_out = get_info(structure, 'name') %string nombre de la estructura
%  info_out = get_info(structure, 'projection_matrix') %nombre del archivo.bvh asociado al esqueleto structure (VALIDO SOLO SI STRUCTURE ES UN SKELETON)
%  info_out = get_info(structure, 'n_frames') %numero de frames de la estructura
%  info_out = get_info(structure, 'n_paths') %numero de paths de la estructura
%  info_out = get_info(structure, 'n_cams') %numero de camaras de la estructura (VALIDO SOLO SI STRUCTURE ES UN SKELETON)
% DATOS DE UN FRAME
%  info_out = get_info(structure, 'frame_rate') %frame rate de los frames en la estructura
%  info_out = get_info(structure, 'frame', 1, 'time') % devuelve el tiempo asociado al frame 1 de la estructura structure
%  info_out = get_info(structure, 'frame', 1, 'n_markers') % devuelve el numero de marcadores del frame 1 de la estructura structure
%  info_out = get_info(structure, 'frame', 1, 'marker', 'coord') %devuelve las coordenadas de todos los marcadores en el frame 1 de structure
%  info_out = get_info(structure, 'frame', 1, 'marker', 'name') %devuelve un cell string con los nombres de todos los marcadores en el frame 1 de structure
%  info_out = get_info(structure, 'frame', 1, 'marker', 'state') %devuelve un vector con los estados de  todos los marcadores en el frame 1 de structure
%  info_out = get_info(structure, 'frame', 1, 'marker', 'source_cam') %devuelve un vector con las camaras fuente de todos los marcadores en el frame 1 de structure
%  info_out = get_info(structure, 'frame', 1, 'marker', [2 3]) %devuelve las coordenadas de los marcadores 2 y 3 del frame 1 de structure
%  info_out = get_info(structure, 'frame', 1, 'marker', [2, 3], 'coord') %devuelve las coordenadas de los marcadores 2 y 3 del frame 1 de structure
%  info_out = get_info(structure, 'frame', 1, 'marker', [2, 3], 'name') %devuelve un cell string con los nombres de los marcadores 2 y 3 del frame 1 de structure
%  info_out = get_info(structure, 'frame', 1, 'marker', [2, 3], 'state') %devuelve un vector con los estados de los marcadores 2 y 3 del frame 1 de structure
%  info_out = get_info(structure, 'frame', 1, 'marker', [2, 3], 'source_cam') %devuelve un vector con las camaras fuente de los marcadores 2 y 3 del frame 1 de structure
%  info_out = get_info(structure, 'frame', 1, 'mapping_table') %devuelve la tabla de mapeo del frame 1 de la estructura structure
%  info_out = get_info(structure, 'frame', 1, 'like_cams') %devuelve un vector cuya columna j contiene el numero de la camara  
%                                                               sobre las que se hizo la correspondencia en la columna j de mapping_table 
%                                                               del frame 1 de la estructura structure
%  info_out = get_info(structure, 'frame', 1, 'd_min') %matriz que contiene una medida de calidad para cada dato coorespondiente en mapping_table 
%                                                         del frame 1 de la estructura structure
% DATOS DE UN PATH
%  info_out = get_info(structure, 'path', 1, 'name') % devuelve el nombre asociado a la trayectoria 1 de structure
%  info_out = get_info(structure, 'path', 1, 'members') % devuelve una matriz 2xn_markers. la primer fila son los indices de los marcadores
%                                                        miembros de la trayectoria 1 de la estructura structure y la fila 2 son
%                                                        los correspondientes frames.
%  info_out = get_info(structure, 'path', 1, 'state') % devuelve una medida de calidad para la trayectoria 1 de la estructura structure
%  info_out = get_info(structure, 'path', 1, 'n_markers') % devuelve el numero de marcadores totales en la trayectoria 1 de structure
%  info_out = get_info(structure, 'path', 1, 'init_frame') %devuelve el frame inicial de la trayectoria 1 de structure
%  info_out = get_info(structure, 'path', 1, 'end_frame') %devuelve  el frame final de la trayectoria 1 de structure

%% ---------
% Author: M.R.
% created the 02/07/2014.
% Copyright T.R.U.C.H.A.

%% Cuerpo de la funcion

%variable auxiliar
str1 = {'Rc', 'Tc', 'f', 'resolution', 't_vista', 'shift', 'sensor', 'sensor_fit', 'pixel_aspect', 'projection_matrix' };
str2 = {'name', 'name_bvh', 'n_frames', 'n_paths', 'n_cams', 'frame_rate'};

%proceso la entrada
structure = varargin{1};
if sum(strcmp(varargin{2}, str1)) %si el segundo argumento es algun string de str1 
    comando = sprintf('structure.info.%s', varargin{2}); %genero el comando que me devuelve dicho argumento    
elseif sum(strcmp(varargin{2}, str2)) %si el segundo argumento es algun string de str2
    comando = sprintf('structure.%s', varargin{2}); %genero el comando que me devuelve dicho argumento    
elseif strcmp(varargin{2}, 'frame') %si el segundo argumento es el string 'frame' 
    comando = sprintf('get_info_in_frame(structure, varargin{3:nargin})'); %paso del parametro 3 en adelante a la funcion get_info_frame que se encarga de obtener info de frames
elseif strcmp(varargin{2}, 'path')   
    comando = sprintf('get_info_in_path(structure, varargin{3:nargin})'); %paso del parametro 3 en adelante a la funcion get_info_path que se encarga de obtener info de paths    
end
%obtengo la salida
info_out = eval(comando);
end