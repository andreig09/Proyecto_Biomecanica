function X = homog2euclid(Xh)
%Función que lleva matriz con columnas del espacio homogeneo a
%correspondiente matriz con columnas del espacio euclideo

%% ENTRADA
% Xh -->  matriz cuyas columnas son coordenadas homogeneas 2D o 3D
%% SALIDA
% X --> matriz cuyas columnas son coordenadas euclideanas 2D o 3D

%% Cuerpo de la funcion 
[rows, ~] = size(Xh);
Xh=homog_norm(Xh); %normalizo los vectores homogeneos
W =ones((rows-1), 1)*Xh(rows, :); 
X =Xh(1:(rows-1), :)./W; 

end