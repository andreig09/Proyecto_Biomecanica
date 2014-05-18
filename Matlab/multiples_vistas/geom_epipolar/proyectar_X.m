function x= proyectar_X(X, P)
% Esta función lleva una matriz X de puntos 3D a otra matriz x de puntos homogeneos 2D
% pertenecientes a la retina de una camara cuya matriz de proyección es P.
%% ENTRADA
% X -->matriz cuyas columnas son puntos 3D 
% P -->matriz de proyección asociada a una camara
%% SALIDA
% x -->matriz de proyecciones cuyas columnas son puntos 2D homogeneos
    if size(X, 1)==3
        X=[X;ones(1, size(X, 2))];%Paso las columnas de coordenadas 3D a coordenadas homogeneas en espacio proyectivo 3D
    end
    x=P*X;% obtengo la proyección de todas las columnas de dicha matriz en la retina de la camara con matriz de proyección P, 
    %observar que las filas de x son coordenadas homogeneas en el espacio proyectivo 2D
end
