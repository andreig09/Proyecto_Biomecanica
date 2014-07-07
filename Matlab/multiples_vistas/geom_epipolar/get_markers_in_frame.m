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
% Copyright T.R.U.C.H.A.

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
        n_markers = size(structure.frame(n_frame).marker, 2);
    else %solo se devuelven los marcadores de list_markers
        n_markers = length(list_markers);
    end
    
    %genero los comandos por defecto para obtener la salida info_out
    comando1 = sprintf('[structure.frame(n_frame).marker.%s]',t_dato);%dejo los posibles comandos en funcion del parametro "dato"
    comando2 = sprintf('[structure.frame(n_frame).marker(list_markers).%s]', t_dato);
    
    %Inicializo variable de salida de acuerdo al tipo de dato    
    if strcmp(t_dato,'coord')
        info_out = ones(3, n_markers);
    elseif (strcmp(t_dato,'name'))
        info_out = cell(1, n_markers ); 
        %comando1 = sprintf('{structure.frame(n_frame).marker.%s}',t_dato);%debo devolver un cell de string en lugar de vector con valores
        %comando2 = sprintf('{structure.frame(n_frame).marker(list_markers).%s}', t_dato);
    elseif strcmp(t_dato,'estado')
        info_out = ones(1, n_markers);
    elseif (strcmp(t_dato, 'source_cam'))%esta opción es valida solo cuando structure=skeleton
        n_cams = structure.n_cams;
        info_out = ones(n_cams, n_markers);            
    end
        
    %obtengo la salida 
    if (length(list_markers)==1) && (list_markers == -1) %en este caso se devuelven todos los marcadores
        info_out =  eval(comando1);        
    else % se devuelven solo los marcadores en la lista list_markers        
        info_out =  eval(comando2);
    end                    
end


