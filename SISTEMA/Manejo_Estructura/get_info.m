function info_out = get_info(varargin)
% Funcion que recupera informacion de estructuras skeleton o cam(i)
%% Entrada
% structure --> una estructura cam(i) o skeleton
% lista de argumento, ver la sección de ejemplos, en la misma se
% tiene todas las posibles entradas.

%% Salida
% info_out -->informacion de salida
%% EJEMPLOS
%  structure=cam(1);
% %structure = skeleton;
% % DATOS DE LA CAMARA
% Rc = get_info(structure, 'Rc') %devuelve la matriz Rc
% Tc = get_info(structure, 'Tc') %devuelve vector de traslacion Tc
% focal_dist = get_info(structure, 'focal_dist') %devuelve distancia focal en metros f
% resolution = get_info(structure, 'resolution') %devuelve [resolución_x, resolution_y] unidades en pixeles
% t_vista = get_info(structure, 't_vista') %devuelve tipo de vista utilizada en la camara (PERSPECTIVA, ORTOGRAFICA, PANORAMICA)
% shift = get_info(structure, 'shift') %devuelve [shift_x, shidt_y] corrimiento del centro de la camara en pixeles
% sensor = get_info(structure, 'sensor') %devuelve [sensor_x, sensor_y] largo y ancho del sensor en milimetros
% sensor_fit = get_info(structure, 'sensor_fit') %devuelve tipo de ajuste utilizado para el sensor (AUTO, HORIZONTAL, VERTICAL)
% pixel_aspect = get_info(structure, 'pixel_aspect') %devuelve (pixel_aspect_x)/(pixel_aspect_y) valor 1 indica pixel cuadrado
% projection_matrix = get_info(structure, 'projection_matrix') %matrix de proyección de la camara

% % DATOS DE LA ESTRUCTURA
% name = get_info(structure, 'name') %string nombre de la estructura
% %name_bvh = get_info(structure, 'name_bvh') %nombre del archivo.bvh asociado al esqueleto structure (VALIDO SOLO SI STRUCTURE ES UN SKELETON)
% n_frames = get_info(structure, 'n_frames') %numero de frames de la estructura
% init_frame = get_info(structure, 'init_frame') %frame inicial de la estructura
% end_frame = get_info(structure, 'end_frame') %frame final de la estructura
% n_paths = get_info(structure, 'n_paths') %numero de paths de la estructura
% %n_cams = get_info(structure, 'n_cams') %numero de camaras de la estructura (VALIDO SOLO SI STRUCTURE ES UN SKELETON)
% frame_rate = get_info(structure, 'frame_rate') %frame rate de los frames en la estructura

% % DATOS DE UN FRAME
% time = get_info(structure, 'frame', 1, 'time') % devuelve el tiempo asociado al frame 1 de la estructura structure
% n_markers = get_info(structure, 'frame', 1, 'n_markers') % devuelve el numero de marcadores del frame 1 de la estructura structure
% coord = get_info(structure, 'frame', 1, 'marker', 'coord') %devuelve las coordenadas de todos los marcadores en el frame 1 de structure
% name = get_info(structure, 'frame', 1, 'marker', 'name') %devuelve un cell string con los nombres de todos los marcadores en el frame 1 de structure
% state = get_info(structure, 'frame', 1, 'marker', 'state') %devuelve un vector con los estados de  todos los marcadores en el frame 1 de structure
% %source_cam = get_info(structure, 'frame', 1, 'marker', 'source_cam') %devuelve un vector con las camaras fuente de todos los marcadores
% %                                                                   en el frame 1 de structure (VALIDO SOLO SI STRUCTURE ES UN SKELETON)
% marker_coord = get_info(structure, 'frame', 1, 'marker', [2 3]) %devuelve las coordenadas de los marcadores 2 y 3 del frame 1 de structure
% marker_coord = get_info(structure, 'frame', 1, 'marker', [2, 3], 'coord') %devuelve las coordenadas de los marcadores 2 y 3 del frame 1 de structure
% marker_name = get_info(structure, 'frame', 1, 'marker', [2, 3], 'name') %devuelve un cell string con los nombres de los marcadores 2 y 3 del frame 1 de structure
% marker_state = get_info(structure, 'frame', 1, 'marker', [2, 3], 'state') %devuelve un vector con los estados de los marcadores 2 y 3 del frame 1 de structure
% %marker_source_cam = get_info(structure, 'frame', 1, 'marker', [2, 3],  'source_cam') %devuelve un vector con las camaras fuente de los marcadores
% %                                                                               2 y 3 del frame 1 de structure (VALIDO SOLO SI STRUCTURE ES UN SKELETON)

% % DATOS DE UN PATH
% path_name = get_info(structure, 'path', 1, 'name') % devuelve el nombre asociado a la trayectoria 1 de structure
% path_members = get_info(structure, 'path', 1, 'members') % devuelve una matriz 2xn_markers. la primer fila son los indices de los marcadores
% %                                                        miembros de la trayectoria 1 de la estructura structure y la fila 2 son
% %                                                        los correspondientes frames.
% path_state = get_info(structure, 'path', 1, 'state') % devuelve una medida de calidad para la trayectoria 1 de la estructura structure
% path_n_markers = get_info(structure, 'path', 1, 'n_markers') % devuelve el numero de marcadores totales en la trayectoria 1 de structure
% path_init_frame = get_info(structure, 'path', 1, 'init_frame') %devuelve el frame inicial de la trayectoria 1 de structure
% path_end_frame = get_info(structure, 'path', 1, 'end_frame') %devuelve  el frame final de la trayectoria 1 de structure

%% ---------
% Author: M.R.
% created the 02/07/2014.


%% Cuerpo de la funcion

%variable auxiliares string
str1 = {'t_vista', 'sensor_fit', 'name', 'name_bvh'};
%variables auxiliares numericas
str2 = {'id', 'Rc', 'Tc', 'focal_dist', 'frame_rate', 'init_frame', 'end_frame', 'n_frames', 'n_paths', 'pixel_aspect', 'projection_matrix', ...
    'resolution', 'sensor', 'shift',};
%proceso la entrada  
structure = varargin{1};
if iscell(structure)
    structure=structure{:};
end
if sum(strcmp(varargin{2}, str1)) %si el segundo argumento es algun string de str1 se debe devolver un string    
    comando = ['structure.Attributes.', varargin{2}]; %genero el comando que me devuelve dicho argumento 
elseif sum(strcmp(varargin{2}, str2)) %%si el segundo argumento es algun string de str2 se debe devolver un valor numerico 
    comando = ['str2num(structure.Attributes.', varargin{2}, ')']; %genero el comando que me devuelve dicho argumento 
elseif strcmp(varargin{2}, 'frame') %si el segundo argumento es el string 'frame' 
    comando = 'get_info_in_frame(structure, varargin{3:nargin})'; %paso del parametro 3 en adelante a la funcion get_info_frame que se encarga de obtener info de frames
elseif strcmp(varargin{2}, 'path')   
    comando = 'get_info_in_path(structure, varargin{3:nargin})'; %paso del parametro 3 en adelante a la funcion get_info_path que se encarga de obtener info de paths    
end
%obtengo la salida
info_out = eval(comando);
end


%%Funciones auxiliares
%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%

function info_out = get_info_in_path(varargin)
% Funcion que devuelve la informacion de trayectoria de una estructura
%% Entrada

%  structure -----> estructura skeleton o cam(i) desde la cual se extrae la informacion
%  n_path -------> numero de trayectoria
%  t_dato1 -------> string que contiene el tipo de dato a devolver de una trayectoria
%                  Valores = {'name' 'members' 'state' 'n_markers' 'init_frame' 'end_frame'}

%% Salida
% info_out -->informacion de salida, su tipo depende del string t_data1 y t_data2
%% ---------
% Author: M.R.
% created the 05/07/2014.


%% Cuerpo de la funcion

    %proceso la entrada    
    structure = varargin{1}; %el primer argumento es una estructura
    n_path = varargin{2};%el segundo argumento es un numero de path
    t_dato1 = varargin{3}; % el tercer argumento t_dato1 indica lo que se desea devolver        
    %obtengo el indice del path con id=n_path
    for k=1:str2double(structure.Attributes.n_paths)
        if n_path ==str2double(structure.Attributes.id)
            n_path = k;%actualizo n_path
            break%encontre lo que queria por lo tanto salgo del ciclo for
        end
    end
    
    %genero la salida
    if strcmp(t_dato1, 'name') %se debe devolver un dato string        
        comando = 'structure.path{n_path}.Attributes.name'; %genero la direccion
    else %debo devolver un tipo de dato numerico
        comando = ['str2num(structure.path{n_path}.Attributes.', t_dato1, ')' ]; %genero la direccion donde se aloja la informacion t_dato1        
    end
    info_out=eval(comando);    

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function info_out = get_info_in_frame(varargin)
% Funcion que devuelve la informacion de un frame de una estructura
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
% info_out -->informacion de salida, su tipo depende del string t_data1 y t_data2
%% ---------
% Author: M.R.
% created the 05/07/2014.
 

%% Cuerpo de la funcion

    %proceso la entrada    
    structure = varargin{1}; %el primer argumento es una estructura
    n_frame = varargin{2};%el segundo argumento es un numero de frame
    t_dato1 = varargin{3}; % el tercer argumento t_dato1 indica si se necesitan argumentos posteriores
    
    if strcmp(t_dato1, 'marker') %se quiere devolver la informacion de un grupo de marcadores        
        if ischar(varargin{4})%no se ingresaron indices de marcadores, entonces se deben devolver todos los marcadores
            t_dato2 = varargin{4};
            info_out = get_markers_in_frame(structure, n_frame, t_dato2);
        else %se tiene los indices de marcadores a devolver
            x_index = varargin{4};%lista de indices de marcadores sobre los que se debe devolver la informacion
            if (nargin < 5) % se quieren devolver solo las coordenadas de los marcadores en x_index
                info_out = get_markers_in_frame(structure, n_frame, x_index);    
            else % se puede llegar a querer alguna informacion adicional de los marcadores de x_index
                t_dato2 = varargin{5};%indica que se quiere devolver del marcador
                info_out = get_markers_in_frame(structure, n_frame, x_index, t_dato2);
            end
        end
        return %ya se devuelve la salida
        
    else %solo se quiere un atributo del frame actual, todos son numericos.
        comando = ['str2num(structure.frame{n_frame}.Attributes.', t_dato1, ')' ]; %genero la direccion donde se aloja la informacion t_dato1        
    end
    info_out=eval(comando);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function info_out = get_markers_in_frame(varargin)
% Función que regresa datos de marcadores de un cierto frame

%% Entrada

%  structure ----->estructura skeleton o cam(i) desde la cual se extrae la informacion
%  n_frame ------->numero de frame
%  list_markers -->vector que contiene los marcadores a extraer, si este parametro no se coloca por defecto se devuelven todos los marcadores
%  t_dato     ---->string que contiene el tipo de dato a devolver. 
%                  Valores = {'coord', 'name', 'estado', 'source_cam', 'like_markers', 'like_cams', 'dist_min'}
%  
%% Salida
%  info_out ---------->depende el tipo de dato que se pida, leer los ejemplos para ver los formatos de salida
%
%% ---------
% Author: M.R.
% created the 30/06/2014.


%% Cuerpo de la funcion

    %proceso la entrada
    
    structure = varargin{1};   
    n_frame = varargin{2};
    list_markers = -1;% se devuelven todos los marcadores
    t_dato = 'coord'; 
    if (nargin==3)
        if ischar(varargin{3}) %si varargin es un caracter
            t_dato = varargin{3};
        else %de lo contrario estan pasando un vector
            list_markers = varargin{3};
        end
    elseif nargin==4        
        list_markers = varargin{3};
        t_dato = varargin{4};
    end
    
    %verifico que se este pidiendo un frame que existe en la estructura
    if n_frame > str2double(structure.Attributes.n_frames)
        str = ['Se solicita un numero de frame mayor al que contiene la estructura ' ...
            structure.Attributes.name];
        error('n_frame:IndiceFueraDeRango',str)
    end
        
    %verifico que se este pidiendo un marcador que existe en la estructura
    if  sum(list_markers > str2double(structure.frame{n_frame}.Attributes.n_markers)) %se lanza excepcion pues se esta pidiendo al menos un marcador que no se tiene
        str = ['En lista_markers se solicita al menos un indice de marcador mayor al que contiene la estructura ' ...
            structure.Attributes.name sprintf(' en el frame %d .\n', n_frame )];
        error('lista_markers:IndiceFueraDeRango',str)
    end
    
    
    %encuentro cuantos marcadores se deben regresar
    if (length(list_markers)==1) && (list_markers == -1) %en este caso se devuelven todos los marcadores        
        n_markers = str2double(structure.frame{n_frame}.Attributes.n_markers);
        list_markers = 1:n_markers;
    else %solo se devuelven los marcadores de list_markers
        n_markers = length(list_markers);
    end
    
    %genero los comandos por defecto para obtener la salida info_out
    info_out = cell(1,n_markers);
    if strcmp(t_dato, 'coord') %se piden ambas coordenadas
        for j=1:n_markers %con cada elemento de list_markers            
            info_out{j} = ...
                [str2double(structure.frame{n_frame}.marker{list_markers(j)}.Attributes.x);...
                str2double(structure.frame{n_frame}.marker{list_markers(j)}.Attributes.y);...
                str2double(structure.frame{n_frame}.marker{list_markers(j)}.Attributes.z)];
        end
        info_out = cell2mat(info_out); %devuelvo una matriz cuyas columnas son las coordenadas de los marcadores en list_markers
    elseif strcmp(t_dato, 'name') %se tiene que devolver un string
        %debo devolver un cell de string en lugar de vector con valores
        for j=1:n_markers %con cada elemento de list_markers
            info_out{j} = structure.frame{n_frame}.marker{list_markers(j)}.Attributes.name;
        end
    elseif strcmp(t_dato, 'state') %se devuelve el estado de los marcadores
        for j=1:n_markers %con cada elemento de list_markers
            info_out{j} = str2double(structure.frame{n_frame}.marker{list_markers(j)}.Attributes.state);
        end
        info_out = cell2mat(info_out); %devuelvo un vector cuyas columnas son los estados de los marcadores en list_markers        
    else %se devuelve las camaras de origen de los marcadores
        for j=1:n_markers %con cada elemento de list_markers
            info_out{j} = str2num(structure.frame{n_frame}.marker{list_markers(j)}.Attributes.source_cam);
        end
        info_out = cell2mat(info_out); %devuelvo un vector cuyas columnas son los estados de los marcadores en list_markers
    end
           
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

