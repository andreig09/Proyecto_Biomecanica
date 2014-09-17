function X = get_frames_of_marker(structure, init_frame, end_frame)
% Función que regresa datos de un marcador en varios frames

%% Entrada
%  structure --------->estructura skeleton o cam(i) desde la cual se extrae la informacion.
%  init_frame ------>frame inicial
% end_frame -------->frame final
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

    %verifico que no se este pidiendo un frame que no existe en la estructura
    if  end_frame > structure.n_frames) %se lanza excepcion pues se esta pidiendo al menos un frame que no se tiene        
        error('lista_frames:IndiceFueraDeRango',['En lista_frame se solicita al menos un indice de frame mayor al que contiene la estructura ' structure.name '.\n'])
    end
    
    %preparo los frames a devolver
    n_frames = end_frame - init_frame +1;
    
    %Inicializo variable de salida de acuerdo al tipo de dato
    X=cell(1,  n_frames);
    
   %genero la salida
   for frame = init_frame:end_frame  %para cada uno de los frames a devolver
        coord = get_info(structure, 'frame', frame, 'markers', 'coord');%coordenaddas de los marcadores
        X(frame)=[coord; frame*ones(1,length(coord))]%se agrega una fila con ekl nro de frame                    
   end
   X = cell2mat(X);
    
end


