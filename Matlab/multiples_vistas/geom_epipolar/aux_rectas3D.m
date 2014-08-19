clear all
close all
clc

% traza las rectas 3D que pasan por el foco de sus respectivas  cámaras y
% los puntos proyectados en sus retina para un frame dado.

load 'saved_vars/cam.mat';

camaras = 3;
marc_ini = 1;
marc_fin = 26;

for i = 2:camaras
    punto_retina = get_info(cam(i), 'frame', 1, 'marker', marc_ini:marc_fin);

    [F,u] = recta3D(cam(i), punto_retina);

    lambda = -1:12;
    
    for j =marc_ini:marc_fin

    x = F(1) +lambda*u(1,j);
    y = F(2) +lambda*u(2,j);
    z = F(3) +lambda*u(3,j);


    plot3(x,y,z)
    grid on
    hold on
    end

    plot3(F(1),F(2),F(3),'*r')
    axis equal
end
%distancia = dist_rectas3D (F1, u1, F2, u2)