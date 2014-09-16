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
%  info_out = get_info(structure, 'name_bvh') %nombre del archivo.bvh asociado al esqueleto structure (VALIDO SOLO SI STRUCTURE ES UN SKELETON)
%  info_out = get_info(structure, 'n_frames') %numero de frames de la estructura
%  info_out = get_info(structure, 'n_paths') %numero de paths de la estructura
%  info_out = get_info(structure, 'n_cams') %numero de camaras de la estructura (VALIDO SOLO SI STRUCTURE ES UN SKELETON)
%  info_out = get_info(structure, 'frame_rate') %frame rate de los frames en la estructura
% DATOS DE UN FRAME
%  info_out = get_info(structure, 'frame', 1, 'time') % devuelve el tiempo asociado al frame 1 de la estructura structure
%  info_out = get_info(structure, 'frame', 1, 'n_markers') % devuelve el numero de marcadores del frame 1 de la estructura structure
%  info_out = get_info(structure, 'frame', 1, 'marker', 'coord') %devuelve las coordenadas de todos los marcadores en el frame 1 de structure
%  info_out = get_info(structure, 'frame', 1, 'marker', 'name') %devuelve un cell string con los nombres de todos los marcadores en el frame 1 de structure
%  info_out = get_info(structure, 'frame', 1, 'marker', 'state') %devuelve un vector con los estados de  todos los marcadores en el frame 1 de structure
%  info_out = get_info(structure, 'frame', 1, 'marker', 'source_cam') %devuelve un vector con las camaras fuente de todos los marcadores 
%                                                                   en el frame 1 de structure (VALIDO SOLO SI STRUCTURE ES UN SKELETON)
%  info_out = get_info(structure, 'frame', 1, 'marker', [2 3]) %devuelve las coordenadas de los marcadores 2 y 3 del frame 1 de structure
%  info_out = get_info(structure, 'frame', 1, 'marker', [2, 3], 'coord') %devuelve las coordenadas de los marcadores 2 y 3 del frame 1 de structure
%  info_out = get_info(structure, 'frame', 1, 'marker', [2, 3], 'name') %devuelve un cell string con los nombres de los marcadores 2 y 3 del frame 1 de structure
%  info_out = get_info(structure, 'frame', 1, 'marker', [2, 3], 'state') %devuelve un vector con los estados de los marcadores 2 y 3 del frame 1 de structure
%  info_out = get_info(structure, 'frame', 1, 'marker', [2, 3],  'source_cam') %devuelve un vector con las camaras fuente de los marcadores 
%                                                                               2 y 3 del frame 1 de structure (VALIDO SOLO SI STRUCTURE ES UN SKELETON)
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
%% Ejemplos 
% structure = skeleton;
% %structure = cam(2);
% info_out = get_info_in_path(structure, 1, 'name') % devuelve el nombre asociado a la trayectoria 1 de structure
% info_out = get_info_in_path(structure, 1, 'members') % devuelve una matriz 2xn_markers. la primer fila son los indices de los marcadores
%                                                        miembros de la trayectoria 1 de la estructura structure y la fila 2 son
%                                                        los correspondientes frames.
% info_out = get_info_in_path(structure, 1, 'state) % devuelve una medida de calidad para la trayectoria 1 de la estructura structure
% info_out = get_info_in_path(structure, 1, 'n_markers') % devuelve el numero de marcadores totales en la trayectoria 1 de structure
% info_out = get_info_in_path(structure, 1, 'init_frame') %devuelve el frame inicial de la trayectoria 1 de structure
% info_out = get_info_in_path(structure, 1, 'end_frame') %devuelve  el frame final de la trayectoria 1 de structure
%% ---------
% Author: M.R.
% created the 05/07/2014.


%% Cuerpo de la funcion

    %proceso la entrada    
    structure = varargin{1}; %el primer argumento es una estructura
    n_path = varargin{2};%el segundo argumento es un numero de frame
    t_dato1 = varargin{3}; % el tercer argumento t_dato1 indica lo que se desea devolver 
    %genero la salida
    comando = sprintf('structure.path(n_path).%s', t_dato1 ); %genero la dirección donde se aloja la informacion t_dato1
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
%% Ejemplos 
% structure = skeleton;
% %structure = cam(2);
% info_out = get_info_in_frame(structure, 1, 'time') % devuelve el tiempo asociado al frame 1 de la estructura structure
% info_out = get_info_in_frame(structure, 1, 'n_markers') % devuelve el numero de marcadores del frame 1 de la estructura structure
% info_out = get_info_in_frame(structure, 1, 'marker', 'coord') %devuelve las coordenadas de todos los marcadores en el frame 1 de structure
% info_out = get_info_in_frame(structure, 1, 'marker', 'name') %devuelve un cell string con los nombres de todos los marcadores en el frame 1 de structure
% info_out = get_info_in_frame(structure, 1, 'marker', 'state') %devuelve un vector con los estados de  todos los marcadores en el frame 1 de structure
% info_out = get_info_in_frame(structure, 1, 'marker', 'source_cam') %devuelve un vector con las camaras fuente de todos los marcadores en el frame 1 de structure
% info_out = get_info_in_frame(structure, 1, 'marker', [2 3]) %devuelve las coordenadas de los marcadores 2 y 3 del frame 1 de structure
% info_out = get_info_in_frame(structure, 1, 'marker', [2, 3], 'coord') %devuelve las coordenadas de los marcadores 2 y 3 del frame 1 de structure
% info_out = get_info_in_frame(structure, 1, 'marker', [2, 3], 'name') %devuelve un cell string con los nombres de los marcadores 2 y 3 del frame 1 de structure
% info_out = get_info_in_frame(structure, 1, 'marker', [2, 3], 'state') %devuelve un vector con los estados de los marcadores 2 y 3 del frame 1 de structure
% info_out = get_info_in_frame(structure, 1, 'marker', [2, 3], 'source_cam') %devuelve un vector con las camaras fuente de los marcadores 2 y 3 del frame 1 de structure
% info_out = get_info_in_frame(structure, 1, 'mapping_table') %devuelve la tabla de mapeo del frame 1 de la estructura structure
% info_out = get_info_in_frame(structure, 1, 'like_cams') %devuelve un vector cuya columna j contiene el numero de la camara  
%                                                               sobre las que se hizo la correspondencia en la columna j de mapping_table 
%                                                               del frame 1 de la estructura structure
% info_out = get_info_in_frame(structure, 1, 'd_min') %matriz que contiene una medida de calidad para cada dato coorespondiente en mapping_table 
%                                                         del frame 1 de la estructura structure 

%% ---------
% Author: M.R.
% created the 05/07/2014.
 

%% Cuerpo de la funcion

    %proceso la entrada    
    structure = varargin{1}; %el primer argumento es una estructura
    n_frame = varargin{2};%el segundo argumento es un numero de frame
    t_dato1 = varargin{3}; % el tercer argumento t_dato1 indica si se necesitan argumentos posteriores
    
    if strcmp(t_dato1, 'marker') %se quiere devolver la informacion de un grupo de marcadores
        %t_dato1 = 'marker'; 
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
        
    elseif sum(strcmp(t_dato1, {'like_cams', 'mapping_table', 'd_min'})) % se quiere devolver informacion de la estructura like
        comando = sprintf('structure.frame(n_frame).like.%s',t_dato1);%dejo los posibles comandos en funcion del parametro "t_dato1"    
    else %solo se quiere informacion del frame actual fuera de subestructuras marker o like
        comando = sprintf('structure.frame(n_frame).%s', t_dato1 ); %genero la dirección donde se aloja la informacion t_dato1        
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
%% Ejemplos
% structure = skeleton;
% %structure = cam(2);
% info_out = get_markers_in_frame(structure, 1) %devuelve las coordenadas de todos los marcadores en el frame 1 de structure
% info_out = get_markers_in_frame(structure, 1, 'coord') %devuelve las coordenadas de todos los marcadores en el frame 1 de structure
% info_out = get_markers_in_frame(structure, 1, 'name') %devuelve un cell string con los nombres de todos los marcadores en el frame 1 de structure
% info_out = get_markers_in_frame(structure, 1, 'state') %devuelve un vector con los estados de  todos los marcadores en el frame 1 de structure
% info_out = get_markers_in_frame(structure, 1, 'source_cam') %devuelve un vector con las camaras fuente de todos los marcadores en el frame 1 de structure
% info_out = get_markers_in_frame(structure, 1, [2, 3]) %devuelve las coordenadas de los marcadores 2 y 3 del frame 1 de structure
% info_out = get_markers_in_frame(structure, 1, [2, 3], 'coord') %devuelve las coordenadas de los marcadores 2 y 3 del frame 1 de structure
% info_out = get_markers_in_frame(structure, 1, [2, 3], 'name') %devuelve un cell string con los nombres de los marcadores 2 y 3 del frame 1 de structure
% info_out = get_markers_in_frame(structure, 1, [2, 3], 'state') %devuelve un vector con los estados de los marcadores 2 y 3 del frame 1 de structure
% info_out = get_markers_in_frame(structure, 1, [2, 3], 'source_cam') %devuelve un vector con las camaras fuente de los marcadores 2 y 3 del frame 1 de structure 

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
    if n_frame > structure.n_frames
        str = ['Se solicita un numero de frame mayor al que contiene la estructura ' ...
            structure.name];
        error('n_frame:IndiceFueraDeRango',str)
    end
        
    %verifico que se este pidiendo un marcador que existe en la estructura
    if  sum(list_markers > structure.frame(n_frame).n_markers) %se lanza excepcion pues se esta pidiendo al menos un marcador que no se tiene
        str = ['En lista_markers se solicita al menos un indice de marcador mayor al que contiene la estructura ' ...
            structure.name sprintf(' en el frame %d .\n', n_frame )];
        error('lista_markers:IndiceFueraDeRango',str)
    end
    
    
    %encuentro cuantos marcadores se deben regresar
    if (length(list_markers)==1) && (list_markers == -1) %en este caso se devuelven todos los marcadores        
        n_markers = structure.frame(n_frame).n_markers;
        list_markers = [1:n_markers];
    else %solo se devuelven los marcadores de list_markers
        n_markers = length(list_markers);
    end
    
    %genero los comandos por defecto para obtener la salida info_out
    %comando1 = sprintf('[structure.frame(n_frame).marker(list_markers).%s]', t_dato);
    comando1 = ['[structure.frame(n_frame).marker(list_markers).' t_dato ']'];
    
    %Inicializo variable de salida de acuerdo al tipo de dato    
    if strcmp(t_dato,'coord')
        info_out = ones(3, n_markers);
    elseif (strcmp(t_dato,'name'))
        info_out = cell(1, n_markers ); 
        %debo devolver un cell de string en lugar de vector con valores
        comando1 = sprintf('{structure.frame(n_frame).marker(list_markers).%s}', t_dato);
    elseif strcmp(t_dato,'state')
        info_out = ones(1, n_markers);
    elseif (strcmp(t_dato, 'source_cam'))%esta opción es valida solo cuando structure=skeleton
        n_cams = structure.n_cams;
        info_out = ones(n_cams, n_markers);            
    end
        
    info_out =  eval(comando1);        
end