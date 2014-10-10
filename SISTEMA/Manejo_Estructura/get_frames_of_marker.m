function X = get_frames_of_marker(structure, init_frame, end_frame)
% Función que regresa datos de un marcador en varios frames

%% Entrada
%  structure --------->estructura skeleton o cam(i) desde la cual se extrae la informacion.
%  init_frame ------>frame inicial
%  end_frame -------->frame final
%% Salida
%  X ---------->matriz cuyas filas son coordenadas y las columnas frames
%


%% ---------
% Author: M.R.
% created the 28/06/2014.
% Copyright T.R.U.C.H.A.

%% Cuerpo de la funcion

    %verifico que no se este pidiendo un frame que no existe en la estructura
    
    if  (end_frame > get_info(structure, 'n_frames')) %se lanza excepcion pues se esta pidiendo al menos un frame que no se tiene        
        error('lista_frames:IndiceFueraDeRango',['En lista_frame se solicita al menos un indice de frame mayor al que contiene la estructura ' structure.name '.\n'])
    end
    
    %preparo los frames a devolver
    n_frames = end_frame - init_frame +1;
    
    %Inicializo variable de salida de acuerdo al tipo de dato
    X=cell(1,  n_frames);
    
   %genero la salida
   for frame = init_frame:end_frame  %para cada uno de los frames a devolver
        coord = get_info(structure, 'frame', frame, 'marker', 'coord');%coordenaddas de los marcadores   
        n_markers = size(coord, 2); %numero de marcadores en el frame
        X{frame}=[coord; frame*ones(1,length(coord)); 1:n_markers];%se agrega una fila con el nro de frame y otra con el numero de marcador                    
   end
   X = cell2mat(X);
    
end


