% Main donde se construyen las matrices de proyeccion y las fundamentales a partir de
% los datos en Blender. Deja solo variables importantes en el workspace!


clear all
close all
clc
%% Cargo secuencia 
name_bvh = 'Mannequin_con_Armadura.bvh';
[skeleton_old, n_marcadores, n_frames, time] = load3D(name_bvh);
%descomentar la siguiente línea si se quiere ver la secuencia 3D
%plotear(skeleton, eye(3)) 

%% Parámetros de las camaras
%Se asumen dos cosas en los calculos que siguen:
%                   1) que la variable de Blender,  Properties/Object Data/Lens/Shift, indicado por los
%                       parametros (X, Y) es (0, 0)
%                   2) que la variable relacion de forma en Properties/Render/Dimensions/Aspect Radio, indicado por 
%                       los parametros (X, Y) es (1, 1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%CAMARA 1 (toma superior)
f = 40;     %dist. focal en mm
M = 800;    % resolución horizontal en píxeles
N = 300;    % resolución vertical en píxeles
sensor = 32;    % tamaño en mm del sensor (se considera el lado más largo, en este caso el horizontal)
% posición xyz cámara 1, todas las medidas son en metros
c_x = 0.02353001;
c_y = -2.5;
c_z = 8;
% angulos de rotacion cam1 en grados
c_th_x = 180;
c_th_y = 180;
c_th_z = -90;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%CAMARA2 (toma posterior izquierda)
f = [f, 50];     %dist. focal en mm
M = [M, 800];    % resolución horizontal en píxeles
N = [N, 300];    % resolución vertical en píxeles
sensor= [sensor, 32]; % tamaño en mm del sensor (se considera el lado más largo, en este caso el horizontal)
% posición xyz cámara 2, todas las medidas son en metros
c_x = [c_x, 7.5];
c_y = [c_y, 2.5];
c_z = [c_z, 1.2];
% angulos de rotacion cam2 en grados
c_th_x = [c_th_x, 267.067];
c_th_y = [c_th_y, 180.439];
c_th_z = [c_th_z, -57.198];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%CAMARA3 (toma delantera izquierda)
f = [f, 50];     %dist. focal en mm
M = [M, 800];    % resolución horizontal en píxeles
N = [N,300];    % resolución vertical en píxeles
sensor= [sensor, 32]; % tamaño en mm del sensor (se considera el lado más largo, en este caso el horizontal)
% posición xyz cámara 3, todas las medidas son en metros
c_x = [c_x, 7.5];
c_y = [c_y, -7.5];
c_z = [c_z, 1.2];
% angulos de rotacion cam3 en grados
c_th_x = [c_th_x, 267.067];
c_th_y = [c_th_y, 180.439];
c_th_z = [c_th_z, -121.198];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%CAMARA4 (toma  delantera derecha)
f = [f, 50];     %dist. focal en mm
M = [M, 800];    % resolución horizontal en píxeles
N = [N, 300];    % resolución vertical en píxeles
sensor= [sensor, 32]; % tamaño en mm del sensor (se considera el lado más largo, en este caso el horizontal)
% posición xyz cámara 4, todas las medidas son en metros
c_x = [c_x, -7.5];
c_y = [c_y, -7.5];
c_z = [c_z, 1.2];
% angulos de rotacion cam4 en grados
c_th_x = [c_th_x, 267.067];
c_th_y = [c_th_y, 180.439];
c_th_z = [c_th_z, -237.198];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%CAMARA5 (toma posterior derecha)
f = [f, 50];     %dist. focal en mm
M = [M, 800];    % resolución horizontal en píxeles
N = [N, 300];    % resolución vertical en píxeles
sensor= [sensor, 32]; % tamaño en mm del sensor (se considera el lado más largo, en este caso el horizontal)
% posición xyz cámara 5, todas las medidas son en metros
c_x = [c_x,  -7.5];
c_y = [c_y, 2.5];
c_z = [c_z, 1.2];
% angulos de rotacion cam5 en grados
c_th_x = [c_th_x, 267.067];
c_th_y = [c_th_y, 180.439];
c_th_z = [c_th_z, -301.198];


%% Estructura marcador 3D
%       X -->Matriz cuyas filas son coordenadas 3D y las columnas son frames 
%       time -->Matriz con los tiempos de cada frame
%       name -->Nombre del marcador
%       n -->nro de marcador

for j=1:n_marcadores %hacer para todos los marcadores
     marker3D(j).X=skeleton_old(j).t_xyz;
     marker3D(j).time= time;
     marker3D(j).name= skeleton_old(j).name;
     marker3D(j).n = j;
end
%NOTACION
%       marker3D(j).X(:, k)   --->para acceder a las coordenadas del marcador j en el frame k 

%% Estructura frame3D
%       X -->Matriz cuyas filas son coordenadas 3D y las columnas son nro de marcador 
%       time -->tiempo de frame
%       name -->Array de strings con nombre del marcador de cada columna de X
%       n -->vector fila que contiene el nro asociado a cada marcador de la columna de X


for k=1:n_frames %hacer para cada frame
        %inicializo los campos de la estructura frame(k)
        frame3D(k).X = [];
        frame3D(k).name = {}; % los nombres los guardo en un array de string, no problem se accede de la misma manera que un vector.
        frame3D(k).n = [];
        frame3D(k).time = time*k;         
        for j=1:n_marcadores %hacer para cada marcador 
            frame3D(k).X = [frame3D(k).X, marker3D(j).X(:,k)]; % las columnas de frame(k).X son nro de marcador
            frame3D(k).name= [frame3D(k).name, marker3D(j).name]; 
            frame3D(k).n = [frame3D(k).n, j];
        end
end
     %NOTACION: 
    %        skeleton.frame(k).x(:, j)  para acceder a las coordenadas del marcador j en el frame k de la camara i
    %        skeleton.frame(k).name(j)  para acceder al nombre del marcador j en el frame k de la camara i

%% Estructura skeleton
%       marker -->estructura marker3D
%       frame --> estructura frame3D
%       name_bvh -->nombre del .bvh de origen

skeleton.marker = marker3D;
skeleton.frame = frame3D;
skeleton.name_bvh = name_bvh;
%ACLARACION: las estructuras 'marker' y 'frame' son dos enfoques distintos de ordenar la misma información, la idea es utilizar lo
    %conveniente en cada caso.
    %NOTACION: 
    %        skeleton.marker(j).x(:, k) para acceder a las coordenadas del marcador j en el frame k de la camara i.
    %        skeleton.frame(k).x(:, j)  para acceder a las coordenadas del marcador j en el frame k de la camara i
    %        skeleton.frame(k).name(j)  para acceder al nombre del marcador j en el frame k de la camara i

    
    
%% Estructura camara
%   para cada cámara contiene:
%     Rc -->matriz de rotación 
%     Tc -->vector de traslación
%     f ---->distancia focal en metros
%     M --->resolución horizontal en pixeles
%     name.bvh -->nombre del .bvh de origen
%     N --->resolución vertical en pixeles
%     Pcam -->matriz de proyección de la camara
%     marker -->estructura de datos de los marcadores en dicha camara, similar a marker3D
%     frame --> estructura de datps de los marcadores en dicha camara, similar a frame3D  

for i=1:length(f) %hacer para todas las camaras
    cam(i).Rc = rotacion(c_th_x(i), c_th_y(i), c_th_z(i));
    cam(i).Tc = [c_x(i), c_y(i), c_z(i)];
    cam(i).f = f(i);
    cam(i).M = M(i);
    cam(i).N = N(i);
    cam(i).name_bvh = name_bvh;
    cam(i).Pcam = proyeccion(f(i), M(i), N(i), sensor(i), cam(i).Tc, cam(i).Rc);% matriz de rotacion asociada a la cámara, se asume rotación XYZ
    for j=1:n_marcadores %hacer para cada marcador 
        %X=skeleton(j).t_xyz;% Obtengo la matriz del marcador j, cuyas filas son coordenadas 3D y columnas sucesivos frames
        X=marker3D(j).X;% Obtengo la matriz del marcador j, cuyas filas son coordenadas 3D y columnas sucesivas frames
        cam(i).marker(j).x=proyectar_X(X, cam(i).Pcam);%Guardo la matriz de coordenadas homogeneas x=P*X , del marcador j en la camara i        
        cam(i).marker(j).time= marker3D(j).time;
        cam(i).marker(j).name= marker3D(j).name;
        cam(i).marker(j).n= j;
    end    
    for k=1:n_frames %hacer para cada frame
        %inicializo los campos de la estructura cam(i).frame(k)
        cam(i).frame(k).x = [];
        cam(i).frame(k).name = {}; % los nombres los guardo en un array de string, no problem se accede de la misma manera que un vector.
        cam(i).frame(k).n = [];
        cam(i).frame(k).time = time*k;         
        for j=1:n_marcadores %hacer para cada marcador 
            cam(i).frame(k).x = [cam(i).frame(k).x, cam(i).marker(j).x(:,k)]; %las columnas de cam(i).frame(k).x son nro de marcador
            cam(i).frame(k).name= [cam(i).frame(k).name, cam(i).marker(j).name]; 
            cam(i).frame(k).n = [cam(i).frame(k).n, j];
        end
    end
    %ACLARACION: las estructuras 'marker' y 'frame' son dos enfoques distintos de ordenar la misma información, la idea es utilizar lo
    %conveniente en cada caso.
    %NOTACION: 
    %        cam(i).marker(j).x(:, k) para acceder a las coordenadas del marcador j en el frame k de la camara i.
    %        cam(i).frame(k).x(:, j)  para acceder a las coordenadas del marcador j en el frame k de la camara i
    %        cam(i).frame(k).name(j)  para acceder al nombre del marcador j en el frame k de la camara i
    
end

     


%% Matrices fundamentales
%  matriz fundamental que mapea un punto de camara i en recta de camara j
i=2; %elegir la camara de entrada
j=4; %elegir la camara de salida
F = vgg_F_from_P(cam(i).Pcam, cam(j).Pcam);
%% Example of using vgg_gui_F  (ALGO NO FUNCIONA O NO SE ESTA CALCULANDO BIEN LA MATRIZ FUNDAMENTAL O EL PROGRAMA vgg_gui_F ESTA MAL)
%%read in chapel images
%im1 = imread('cam2.bmp');
%im2 = imread('cam4.bmp');
%%view epipolar geometry in GUI, move mouse with button down
%%in either window to see transferred point
%%NB function uses F transpose
%vgg_gui_F(im1, im2, F')

%% Visualización de las proyecciones
n_cam = 3; %nro de camara a visualizar 
%plotear(skeleton, cam(n).Pcam, cam(n).M, cam(n).N)
%plotear(cam, n_cam, 'number');
plotear(skeleton, 'number');
%% Limpio variables 
clearvars -except cam n_marcadores n_frames name_bvh skeleton
disp('Variables cargadas en Workspace ;)')

