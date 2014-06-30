function X = frames_marker(varargin)
% Función que devuelve una matriz cuyas filas son coordenadas y las
% columnas son los frames del vector "list_frames" asociados al marcador
% "n_marker" de la camara "n_cam".
%En el caso de que para algun frame no existe marcador asociado a "n_marker" se devuelve "NaN"
%% Entrada
%  n_marker -->numero de marcador
%  n_cam --------->nro de camara, si se coloca cam=0 devuelve las coordenadas 3D del esqueleto
%  list_frames ------>vector que contiene los frames a extraer, si este parametro no se coloca por defecto se devuelven todos los frames
%% Salida
%  X ---------->matriz cuyas filas son coordenadas y las columnas frames
%
%% Observacion
% Se asume que se tiene una estructura cam.mat y skeleton.mat en las
% direcciones  ~/saved_vars/cam.mat y ~/saved_vars/skeleton.mat
%
% ---------
% Author: M.R.
% created the 28/06/2014.
% Copyright T.R.U.C.H.A.

    %proceso la entrada
    if length(varargin)==2 %se devuelven todos los frames, en el caso de que para algun frame no existe marcador asociado a n_marker se devuelve "NaN"
        n_marker = varargin{1};
        n_cam = varargin{2}; 
        list_frames = -1;
    elseif length(varargin)==3
        n_marker = varargin{1};
        n_cam = varargin{2}; 
        list_frames = varargin{3}; 
    end
    
        
    %obtengo el tipo de estructura 
    if n_cam==0 %en este caso se quieren las coordenadas 3D de skeleton
        structure = load('saved_vars/skeleton.mat'); 
        structure = structure.skeleton;
    else %en este caso se quiere coordenadas 2D de la camara n_cam
        structure = load('saved_vars/cam.mat');
        structure = structure.cam(n_cam);
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
        struct_frame = structure.frame; %me quedo con todos los frames
        list_frames = [1:n_frames];%actualizo la lista de indices para que contenga todos los frames   
    else
        struct_frame = structure.frame(list_frames); %me quedo solo con los frames que necesito
    end
    
    %genero la salida
    X = ones(3, n_frames);% inicializo variable de salida
    for k=1:length(list_frames)  %para cada uno de los frames de list_frames
        %verifico si existe el marcador con indice n_marker en el frame k
        if (struct_frame(k).n_markers >= n_marker)  %existe el marcador en el frame k
            X(:,k) = struct_frame(k).marker(n_marker).coord;
        else %no existe el marcador con indice n_marker en el frame k, por lo tanto se rellena con "NaN" y se genera una advertencia
            X(:,k) = NaN;             
            str1=sprintf('ADVERTENCIA:\tEn el frame %d no existe el numero de marcador %d', k, n_marker);
            disp(str1);
        end
    end
    
end


