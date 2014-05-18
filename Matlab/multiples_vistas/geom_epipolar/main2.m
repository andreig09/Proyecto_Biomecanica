% Main donde se construyen las matrices de proyeccion y las fundamentales a partir de
% los datos en Blender. Deja solo variables importantes en el workspace!


clear all
close all
clc
%% Cargo secuencia 
name_bvh = 'Mannequin_con_Armadura.bvh';
[skeleton, n_marcadores, n_frames, time] = load3D(name_bvh);
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


%% Estructura marcador
%       X -->Matriz cuyas filas son coordenadas 3D y las columnas son frames 
%       time -->Matriz con los tiempos de cada frame
%       name -->Nombre del marcador
%       n -->nro de marcador

for j=1:n_marcadores %hacer para todos los marcadores
     marker3D(j).X=skeleton(j).t_xyz;
     marker3D(j).time= time;
     marker3D(j).name= skeleton(j).name;
     marker3D(j).n = j;
end

%% Estructura camara
%   para cada cámara contiene:
%       Matriz  de rotación Rc 
%       Vector de Traslación Tc
%       Distancia focal f
%       Resolución horizontal M
%       Resolución Vertical N
%       Matriz de proyección Pcam
%       Estructura marker

for i=1:length(f) %hacer para todas las camaras
    cam(i).Rc = rotacion(c_th_x(i), c_th_y(i), c_th_z(i));
    cam(i).Tc = [c_x(i), c_y(i), c_z(i)];
    cam(i).f = f(i);
    cam(i).M = M(i);
    cam(i).N = N(i);
    cam(i).Pcam = proyeccion(f(i), M(i), N(i), sensor(i), cam(i).Tc, cam(i).Rc);% matriz de rotacion asociada a la cámara, se asume rotación XYZ
    for j=1:n_marcadores %hacer para cada marcador 
        %X=skeleton(j).t_xyz;% Obtengo la matriz del marcador j, cuyas filas son coordenadas 3D y columnas sucesivos frames
        X=marker3D(j).X;% Obtengo la matriz del marcador j, cuyas filas son coordenadas 3D y columnas sucesivos frames
        cam(i).marker(j).x=proyectar_X(X, cam(1).Pcam);%Guardo la matriz de coordenadas homogeneas x=P*X , del marcador j en la camara i        
        cam(i).marker(j).time= marker3D(j).time;
        cam(i).marker(j).name= marker3D(j).name;
        cam(i).marker(j).n= j;
    end
    %NOTACION: cam(i).marker(j).x(:, k) para acceder a las coordenadas homogeneas del marcador j en el frame k de la camara i.
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
n = 2; %nro de camara a visualizar 
%plotear(skeleton, cam(n).Pcam, cam(n).M, cam(n).N)

%% Limpio variables 
clearvars -except cam n_marcadores n_frames time name_bvh marker3D

