function X = get_frames_marker(varargin)
% Función que devuelve una matriz cuyas filas son coordenadas y las
% columnas son los frames del vector "list_frames" asociados al marcador
% "n_marker" de la estructura "structure".
%En el caso de que para algun frame no existe marcador asociado a "n_marker" se devuelve "NaN"
%% Entrada
%  n_marker -->numero de marcador.
%  structure --------->estructura skeleton o cam(i) desde la cual se extrae la informacion.
%  list_frames ------>vector que contiene los frames a extraer, si este parametro no se coloca por defecto se devuelven todos los frames.
%% Salida
%  X ---------->matriz cuyas filas son coordenadas y las columnas frames
%
%% ---------
% Author: M.R.
% created the 28/06/2014.
% Copyright T.R.U.C.H.A.

    %proceso la entrada
    if length(varargin)==2 %se devuelven todos los frames, en el caso de que para algun frame no existe marcador asociado a n_marker se devuelve "NaN"
        n_marker = varargin{1};
        structure = varargin{2}; 
        list_frames = -1;
    elseif length(varargin)==3
        n_marker = varargin{1};
        structure = varargin{2}; 
        list_frames = varargin{3}; 
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
    
    %genero la salida
    X = ones(3, n_frames);% inicializo variable de salida        
    for k=1:n_frames  %para cada uno de los frames de list_frames
        %verifico si existe el marcador con indice n_marker en el frame k
        if (structure.frame(list_frames(k)).n_markers >= n_marker)  %existe el marcador en el frame k
            X(:,k) = structure.frame(list_frames(k)).marker(n_marker).coord;
        else %no existe el marcador con indice n_marker en el indice k de list_frames, por lo tanto se rellena con "NaN" y se genera una advertencia
            X(:,k) = NaN;             
            str1=sprintf('ADVERTENCIA:\tEn el/los indice/s %s de list_frames no existe el numero de marcador %d', num2str(k), n_marker);
            disp(str1);
        end
    end
    
    %     indice=find([structure.frame(list_frames).n_markers] >= n_marker); % vector con los indices de list_frames donde existe el marcador
%     if sum(indice)~=0 %existe algun indice 
%         for k=1:length(indice)
%             X(:,k) = structure.frame(list_frames(k)).marker(n_marker).coord;
%         end
%     end
%     
%     indice=find([structure.frame(list_frames).n_markers] < n_marker); % vector con los indices de list_frames donde no existe el marcador 
%     if sum(indice)~=0 %existe algun indice 
%         X(:,indice)= NaN;   
%         str1=sprintf('ADVERTENCIA:\tEn el/los indice/s %s de list_frames no existe el numero de marcador %d', num2str(indice), n_marker);
%         disp(str1);
%     end
    
end


