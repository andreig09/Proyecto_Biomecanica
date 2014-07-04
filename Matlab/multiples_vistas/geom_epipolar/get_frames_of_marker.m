function X = get_frames_of_marker(varargin)
% Función que regresa datos de un marcador en varios frames

%% Entrada
%  n_marker -->numero de marcador.
%  structure --------->estructura skeleton o cam(i) desde la cual se extrae la informacion.
%  list_frames ------>vector que contiene los frames a extraer, si este parametro no se coloca por defecto se devuelven todos los frames.
%% Salida
%  X ---------->matriz cuyas filas son coordenadas y las columnas frames
%
%% EJEMPLOS
% n_marker = 10;
% structure = skeleton;
% %structure = cam;
% X = get_frames_of_marker(1, structure)               %devuelve las coordenadas en todos los frames del marcador 1 de structure, en el caso de que para algun frame no existe marcador asociado a "n_marker" se devuelve "NaN"
% X = get_frames_of_marker(1, structure, 'coord')      %devuelve las coordenadas en todos los frames del marcador 1 de structure
% X = get_frames_of_marker(1, structure, 'name')       %devuelve un cell string con los nombres en todos los frames del marcador 1 de structure
% X = get_frames_of_marker(1, structure, 'state')      %devuelve un vector con los estados en  todos los frames del marcador 1 de structure
% X = get_frames_of_marker(1, structure, 'source_cam') %devuelve un vector con las camaras fuente en todos los frames del marcador 1 de structure
% X = get_frames_of_marker(1, structure, [2 3])        %devuelve las coordenadas en los frames 2 y 3 del marcador 1 de structure
% X = get_frames_of_marker(1, structure, [2, 3], 'coord')      %devuelve las coordenadas en los frames 2 y 3 del marcador 1 de structure
% X = get_frames_of_marker(1, structure, [2, 3], 'name')       %devuelve un cell string con los nombres en los frames 2 y 3 del marcador 1 de structure
% X = get_frames_of_marker(1, structure, [2, 3], 'state')      %devuelve un vector con los estados en los frames 2 y 3 del marcador 1 de structure
% X = get_frames_of_marker(1, structure, [2, 3], 'source_cam') %devuelve un vector con las camaras fuente en los frames 2 y 3 del marcador 1 de structure

%% ---------
% Author: M.R.
% created the 28/06/2014.
% Copyright T.R.U.C.H.A.

%% Cuerpo de la funcion

    %proceso la entrada
    n_marker = varargin{1};
    structure = varargin{2};   
    list_frames = -1;% se devuelven todos los frames
    dato = 'coord'; 
    if (length(varargin)==3)
        if ischar(varargin{3}) %si varargin es un caracter
            dato = varargin{3};
        else %de lo contrario estan pasando un vector
            list_frames = varargin{3};
        end
    elseif length(varargin)==4        
        list_frames = varargin{3};
        dato = varargin{4};
    end
      
        
    %verifico que no se este pidiendo un frame que no existe en la estructura
    if  sum(list_frames > structure.n_frames) %se lanza excepcion pues se esta pidiendo al menos un frame que no se tiene
        str = ['En lista_frame se solicita al menos un indice de frame mayor al que contiene la estructura ' structure.name '.\n'];
        error('lista_frames:IndiceFueraDeRango',str)
    end
    
    %preparo los frames a devolver
    n_frames = length(list_frames);
    if ((n_frames==1)&&(list_frames == -1)) %se devuelven todos los frames
        n_frames = structure.n_frames;%averiguo el total de frames de la estructura        
        list_frames = [1:n_frames];%actualizo la lista de indices para que contenga todos los frames   
    end
    
    %genero los comandos para obtener la salida X
    comando1 = sprintf('structure.frame(list_frames(k)).marker(n_marker).%s',dato);%dejo los posibles comandos en funcion del parametro "dato"
       
    %Inicializo variable de salida de acuerdo al tipo de dato
    if strcmp(dato,'coord')
        X = ones(3, n_frames);
    elseif (strcmp(dato,'name'))
        X = cell(1, n_frames ); 
        comando1 = sprintf('{structure.frame(list_frames(k)).marker(n_marker).%s}',dato);%debo devolver un cell de string en lugar de vector con valores        
    elseif strcmp(dato,'estado')
        X = ones(1, n_frames);
    elseif (strcmp(dato, 'source_cam'))%esta opción es valida solo cuando structure=skeleton
        n_cams = structure.n_cams;
        X = ones(n_cams, n_frames);
    end
    
    
    %genero la salida
   for k=1:n_frames  %para cada uno de los frames de list_frames
        %verifico si existe el marcador con indice n_marker en el frame k
        if (structure.frame(list_frames(k)).n_markers >= n_marker)  %existe el marcador en el frame k
            X(:,k) = eval(comando1);
            %X(:,k) = structure.frame(list_frames(k)).marker(n_marker).coord;
        else %no existe el marcador con indice n_marker en el indice k de list_frames, por lo tanto se rellena con "NaN" y se genera una advertencia
            X(:,k) = NaN;             
            str1=sprintf('ADVERTENCIA:\tEn el/los indice/s %s de list_frames no existe el numero de marcador %d', num2str(k), n_marker);
            disp(str1);
        end
    end
       
end


