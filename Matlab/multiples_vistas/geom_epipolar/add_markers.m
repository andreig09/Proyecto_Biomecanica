function structure = add_markers(structure, frame, coord, name, state, source_cam)
%Funcion que permite agregar los marcadores 

%% ENTRADA
%structure -->estructura de datos skeleton o cam(i)
%frame    -->vector que indica los frames donde se efectua la supresion de marcadores
%coord    --> matriz cuyas columnas son las coordenadas de los marcadores a agregar. coord(:,j) indica las coordenadas del marcador name(j)
%name     -->cell array con los string de nombres a agregar
%state    -->vector donde state(j) indica el estado del marcador name(j)
%source_cam -->si la estructura es del tipo skeleton entonces se agregan las camaras que reconstruyeron el punto source_cam(:,j) indica la pareja
%de camaras del marcador name(j)
%% SALIDA
%structure -->estructura de datos actualizada

%% EJEMPLOS
% clc
% structure = skeleton;
% frame = [1, 2, 3]
% name = {'Hip' 'LeftLeg'}
% structure = remove_markers(structure, frame , name)

%% ---------
% Author: M.R.
% created the 31/08/2014.
%% CUERPO DE LA FUNCION





end
