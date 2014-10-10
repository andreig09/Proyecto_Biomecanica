function Xh = euclid2homog(X)
%Función que lleva matriz con columnas del espacio euclideo a
%correspondiente matriz con columnas del espacio homogeneo

%% ENTRADA
% X --> matriz cuyas columnas son coordenadas euclideanas 2D o 3D
%% SALIDA
% x --> matriz cuyas columnas son coordenadas homogeneas 2D o 3D

%% Cuerpo de la funcion 
Xh =[X; ones(1,size(X, 2))];
end


