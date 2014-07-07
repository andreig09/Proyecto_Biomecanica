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
% Copyright T.R.U.C.H.A. 

%% Cuerpo de la funcion

    %proceso la entrada    
    structure = varargin{1}; %el primer argumento es una estructura
    n_path = varargin{2};%el segundo argumento es un numero de frame
    t_dato1 = varargin{3}; % el tercer argumento t_dato1 indica lo que se desea devolver 
    %genero la salida
    comando = sprintf('structure.path(n_path).%s', t_dato1 ); %genero la dirección donde se aloja la informacion t_dato1
    info_out=eval(comando);    

end