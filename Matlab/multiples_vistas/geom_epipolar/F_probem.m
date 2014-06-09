clear all
close all 
clc
%Vamos a probar las matrices fundamentales
load('Variables_save/cam.mat')

n_cam_i=4;
n_cam_d=5;

Pi=cam(n_cam_i).Pcam;
Pd=cam(n_cam_d).Pcam;

%centros de camara derecha
Cd_1 = null(Pd);%coordenadas 3D homogeneas
Cd_2 = Cd_1;

Cd = [Cd_1, Cd_2]; %centros de la camara 'derecha'

%cargo los distintos tipos de matrices que tengo, recordar que F lleva de
%camara izquierda a derecha
F1 = F_from_P( Pi, Pd);
F2 = vgg_F_from_P(Pi, Pd);

%reviso si efectivamente se cumple que todo punto de cam(n_cam_d) proyectado
%genera recta que pasa por epipolo de cam(n_cam) ---->(F*pd)=li ; ei'*li=0
pd = euclid2homog(cam(n_cam_d).marker(1).x(:,1)); %tomo un punto de camara 'derecha'
li1=F1'*pd;
li2=F2'*pd;

li=[li1, li2];%proyecciones en la camara 'izquierda'
ei=[Pi*Cd(:,1), Pi*Cd(:,2)];  %epipolos de la camara 'izquierda'

disp(fprintf('verifico recta proyectando con F1, resto(1) = %d', ei(:,1)'*li(:,1)))
disp(fprintf('verifico recta proyectando con F2, resto(2) = %d', ei(:,2)'*li(:,2)))


