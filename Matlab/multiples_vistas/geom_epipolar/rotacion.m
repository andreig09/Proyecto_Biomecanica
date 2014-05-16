function R = rotacion(th_x, th_y, th_z)
% Funcion que devuelve una matriz de rotacion que lleva del sistema del mundo al sistema de la camara,
%los angulos de entrada son los correspondientes a rotaciones sobre los
%ejes x, y, z, se asume que dichos angulos fueron sacados de Blender utilizando orden de rotación XYZ

%% Matriz de rotacion respecto al eje x
    th =  -th_x; %como a continuacion se utiliza la matriz de rotacion Alibis se invierte el signo de los angulos para obtener una del tipo Axis

    Rx = [  1    0          0
            0   cosd(th)     -sind(th)
            0   sind(th)     cosd(th)]; 


%% Matriz de rotacion respecto al eje y
% th =  -th_y;
% 
% Ry = [  cosd(th)    0          sind(th)
%         0          1          0
%         -sind(th)   0          cosd(th)];

%Otra manera es poner directamente la matriz de rotación Axis
    Ry = [  cosd(th_y)    0          -sind(th_y)
            0          1          0
            sind(th_y)   0          cosd(th_y)];

%% Matriz de rotacion respecto al eje z
    Rz = [  cosd(th_z)    sind(th_z)    0
            -sind(th_z)    cosd(th_z)     0
            0           0          1];%matriz de rotacion Axis
    
%%  Matriz de rotacion total (son rotaciones extrinsecas, siempre referidas a la base del mundo)  
    %R = Rz*(Ry*Rx); %rotacion XYZ intrinseca
    R = Rx*Ry*Rz; %rotación XYZ extrinseca
end