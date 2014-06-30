%AUN SE ESTÄ COMPLETANDO

function X = nube_markers(varargin)
% Función que devuelve una matriz cuyas filas son coordenadas y las
% columnas son los marcadores del vector "list_markers" asociados al frame
% "nro_frame" de la camara "n_cam"
%% Entrada
%  nro_frame -->numero de frame
%  n_cam --------->nro de camara, si se coloca cam=0 devuelve las coordenadas 3D del esqueleto
%  list_markers ------>vector que contiene los marcadores a extraer, si este parametro no se coloca por defecto se devuelven todos los marcadores
%% Salida
%  X ---------->matriz cuyas filas son coordenadas y las columnas  marcadores
%
%% Observacion
% Se asume que se tiene una estructura cam.mat y skeleton.mat en las
% direcciones  ~/saved_vars/cam.mat y ~/saved_vars/skeleton.mat
%
% ---------
% Author: M.R.
% created the 30/06/2014.
% Copyright T.R.U.C.H.A.

    %proceso la entrada
    if length(varargin)==2 %en este caso se devuelven todos los frames
        nro_frame = varargin{1};
        n_cam = varargin{2}; 
        list_markers = -1;
    elseif length(varargin)==3
        nro_frame = varargin{1};
        n_cam = varargin{2}; 
        list_markers = varargin{3}; 
    end
    
    
    %preparo segun la camara que se devuelve
    if n_cam==0 %en este caso se quieren las coordenadas 3D de skeleton
        structure = load('saved_vars/skeleton.mat'); 
        structure = structure.skeleton;
    else %de lo contrario se devuelve la estructura de la camara n_cam
        structure = load('saved_vars/cam.mat');
        structure = structure.cam(n_cam);
    end
    
    %preparo segun que marcadores se devuelven    
    if (length(list_markers)==1) && (list_markers == -1) %en este caso se devuelven todos los marcadores
        %averiguo cuantos marcadores tiene el frame "nro_frame"
        list_markers = [1:];    
    else
        struct_frame = structure.frame(list_frames); %me quedo solo con los frames que necesito
    end
    
    
    %obtengo la salida
    X =  [structure.frame(nro_frame).marker(list_markers).coord];    
end
