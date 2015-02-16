clear all
close all
clc

%addpath('../BlueCCal/MultiCamValidation/CoreFunctions')
addpath('../../../SISTEMA/Utiles')


%%
%Puntos del calibrador posicionado en el sistema de coordenadas de Blender
Xcal_real = [.5, -2 , 0; 0 , -2, 0; 0, -2.5, 0; 0, -2, .5]';


%%
% Se marcan los puntos del calibrador proyectados en dos de las cámaras

cam1 = input('Seleccione una cámara: ','s');
imshow(['cam' cam1 '.png'])
x1 = ginput(4);
close all


cam2 = input('Seleccione una cámara: ','s');
imshow(['cam' cam2 '.png'])
x2 = ginput(4);
close all

x1 = x1';
x2 = x2';

%%
% Se corrigen la coordenada 'y' de las imágenes
resy = 600;

x1(1,:)=x1(1,:)-0.5;
x1(2,:)=-x1(2,:)+(resy+1);

x2(1,:)=x2(1,:)-0.5;
x2(2,:)=-x2(2,:)+(resy+1);


%%
% Se cargan las matrices de proyección obtenidas de la calibración
P1 = load(['../resultados/1/camera' cam1 '.Pmat.cal']);
P2 = load(['../resultados/1/camera' cam2 '.Pmat.cal']);


%%
% se reconstruyen los puntos 3D del calibrador a partir de los puntos 2D
% marcados en ambas cámaras utilizando las matrices de proyección P1 y P2

X = dlt(x1,x2,P1,P2);
X = homog_norm(X); % se normalizan los puntos 3D


%%
%{
h1=plot3(X(1,1),X(2,1),X(3,1),'r*');
hold on
h2=plot3(X(1,2),X(2,2),X(3,2),'b*');
h3=plot3(X(1,3),X(2,3),X(3,3),'k*');
h4=plot3(X(1,4),X(2,4),X(3,4),'g*');

legend([h1,h2,h3,h4],'Eje y','Origen','Eje x','Eje z')
%}

%%
% se obtiene la matriz que pasa de las coordenadas del sistema obtenido en
% la calibración al sistema de coordenadas de Blender

Xcal_real = [Xcal_real; ones(1,4)];

T = Xcal_real * pinv(X);


% se aplica la transformación a los puntos X obteniéndose los puntos del
% calibrador reconstruidos
Xcal_rec = T * X;

%%

X = Xcal_real;

h1=plot3(X(1,1),X(2,1),X(3,1),'r*');
hold on
h2=plot3(X(1,2),X(2,2),X(3,2),'b*');
h3=plot3(X(1,3),X(2,3),X(3,3),'k*');
h4=plot3(X(1,4),X(2,4),X(3,4),'g*');


X = Xcal_rec;
X = homog_norm(X);

h1c=plot3(X(1,1),X(2,1),X(3,1),'ro');
hold on
h2c=plot3(X(1,2),X(2,2),X(3,2),'bo');
h3c=plot3(X(1,3),X(2,3),X(3,3),'ko');
h4c=plot3(X(1,4),X(2,4),X(3,4),'go');

legend([h1,h2,h3,h4,h1c,h2c,h3c,h4c],'Eje y real','Origen real','Eje x real','Eje z real','Eje y','Origen','Eje x','Eje z')

axis square

