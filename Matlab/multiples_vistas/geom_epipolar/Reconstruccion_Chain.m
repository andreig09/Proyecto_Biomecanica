clc;
close all;
clear all;

% 1) el objetivo primario es obtener una cadena con (N marcadores) X (f frames) en 3D

% 2) el objetivo secundario es tener frame a frame, los marcadores entre
%   camaras, alineados. Lease, dado un frame, todas las camaras tienen los marcadores ordenados de la misma manera

% 3) el objetivo terciario es que en caso de que la cantidad de marcadores
%   por camara no sea la misma, poder reconstruir todos los marcadores en 3D,
%   y rellenar aquellos que faltan en cada camara individual

load saved_vars/cam.mat

% Elijo las camaras "origen" que van a generar la reconstruccion
n_cam_i=3;
n_cam_j=4;
n_cam_k=5;

Xi=[];Xj=[];Z=[];

% Elijo frame inicial 20, debido al movimiento erratico previo del macaco

for n_frame=20:100
    % Alineo los marcadores, asumiendo misma cantidad de marcadores entre
    % camaras, frame a frame
    [xi, xj, index_table, d_min]= cam2cam(cam(n_cam_i), cam(n_cam_j), n_frame);
    xk = get_info(cam(n_cam_k), 'frame', n_frame, 'marker', 'coord');
    
    % Acumulo los marcadores frame a frame, agrego linea de indice de
    % frames
    
    Xi=[Xi,[xi;n_frame*ones(1,size(xi,2))]];
    Xj=[Xj,[xj;n_frame*ones(1,size(xj,2))]];
    
end;

Pi = get_info(cam(n_cam_i), 'projection_matrix'); %matrix de proyección de la camara izquierda
Pj = get_info(cam(n_cam_j), 'projection_matrix'); %matrix de proyección de la camara derecha

% En vez de hacer la reconstruccion frame a frame, aprovecho tener los
% puntos alineados y acumulados para hacer DLT de una sola pasada, desde
% afuera de la iteracion de frames

% ATENCION:Cuando se comience a reconstruir con camaras parciales, se va a tener que
% hacer reconstruccion frame a frame, y no desde afuera

Z = dlt(Xi,Xj,Pi,Pj); %efectúo dlt para triangulación
Z = homog_norm(Z); % normalizo el vector homogeneo 3D
Z = [Z(1:3,:);Xi(4,:)]; %me quedo solo con las coordenadas euclideas, agrego linea de indices de frame

return;

% Desde aqui, se puede plotear todas las frames, tanto de 3D, como de las
% multiples camaras 2D, comentar el return

figure(1)
subplot(1,3,1)
plot(Xi(1,:),Xi(2,:),'.');
subplot(1,3,2)
plot(Xj(1,:),Xj(2,:),'.');
subplot(1,3,3)
plot3(Z(1,:),Z(2,:),Z(3,:),'.');
