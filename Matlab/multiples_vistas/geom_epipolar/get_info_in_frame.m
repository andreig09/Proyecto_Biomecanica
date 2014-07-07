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
% Copyright T.R.U.C.H.A. 

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