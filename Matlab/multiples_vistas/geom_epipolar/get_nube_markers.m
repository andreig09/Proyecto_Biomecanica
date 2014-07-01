function X = get_nube_markers(varargin)
% Función que devuelve una matriz cuyas filas son coordenadas y las
% columnas son los marcadores del vector "list_markers" asociados al frame
% "n_frame" de la estructura "structure".
%En el caso de que para algun frame no existe marcador asociado a "n_marker" se devuelve "NaN"
%% Entrada
%  n_frame -->numero de frame
%  structure --------->estructura skeleton o cam(i) desde la cual se extrae la informacion
%  list_markers ------>vector que contiene los marcadores a extraer, si este parametro no se coloca por defecto se devuelven todos los marcadores
%% Salida
%  X ---------->matriz cuyas filas son coordenadas y las columnas  marcadores
%
%% Ejemplos
% X = get_nube_markers(1, skeleton) %devuelve todos los marcadores en el frame 1 de skeleton
% X = get_nube_markers(1, cam(4), [2 3]) %devuelve los marcadores 2 y 3 del frame 1 de cam(4)
%% ---------
% Author: M.R.
% created the 30/06/2014.
% Copyright T.R.U.C.H.A.

    %proceso la entrada
    if length(varargin)==2 %en este caso se devuelven todos los frames
        n_frame = varargin{1};
        structure = varargin{2}; 
        list_markers = -1;
    elseif length(varargin)==3
        n_frame = varargin{1};
        structure = varargin{2}; 
        list_markers = varargin{3}; 
    end
    
    %verifico que no se este pidiendo un marcador que no existe en la estructura
    if  sum(list_markers > structure.frame(n_frame).n_markers) %se lanza excepcion pues se esta pidiendo al menos un marcador que no se tiene
        str = ['En lista_markers se solicita al menos un indice de marcador mayor al que contiene la estructura ' ...
            structure.name sprintf(' en el frame %d .\n', n_frame )];
        error('lista_markers:IndiceFueraDeRango',str)
    end
    
    %obtengo la salida    
    if (length(list_markers)==1) && (list_markers == -1) %en este caso se devuelven todos los marcadores        
        X =  [structure.frame(n_frame).marker.coord];
    else % se devuelven solo los marcadores en la lista list_markers
        X =  [structure.frame(n_frame).marker(list_markers).coord];
    end    
        
end
