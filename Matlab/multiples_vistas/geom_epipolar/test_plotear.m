close all;
%clear all;
clc;
%% Este archivo permite probar la funcion plotear con todas las entradas posibles

%load('Variables_save/skeleton.mat')
%load('Variables_save/cam.mat')

total_marker = 26
total_frame =  322

list_marker =[1:total_marker];%marcadores que se quieren visualizar
last_frame = 100 %total_frame; %ultimo frame a graficar
n_prev =0; %graficar 3 frame anteriores al último
t_label = 1; %con etiquetas nombre (t_label=0) o numero (t_label=1)
n_cam = 1;%camara numero n_cam
radio = 2;%valor del radio de las circunferencias centradas en el último frame de cada marcador ¿valor en pixeles?

% Estructura skeleton
   %plotear(skeleton)           %se plotea secuencia 3D con etiquetas nombres
   %plotear(skeleton, t_label)   %se plotea secuencia 3D con etiquetas nombre (t_label=0) o numero (t_label=1)
   %plotear(skeleton, list_marker, last_frame, n_prev,  t_label) %se plotean trayectorias 3D con etiquetas nombre (t_label=0) o numero (t_label=1)
   
%Estructura cam
   %plotear(cam, n_cam )        %se plotea 2D con etiquetas nombres 
   %plotear(cam, n_cam, t_label) %se plotea secuencia 2D con etiquetas nombre (t_label=0) o numero (t_label=1)
   %plotear(cam, n_cam, list_marker, last_frame, n_prev, t_label, radio) %se plotean trayectorias 2D con etiquetas nombre (t_label=0) o numero (t_label=1)

   animacion=1;
   if animacion==1
       for i=1:last_frame
           if (i-n_prev)<1
               plotear(cam, n_cam, list_marker, i, i-1, t_label, radio) %se plotean trayectorias 2D con etiquetas nombre (t_label=0) o numero (t_label=1)
               pause(0.01)
           else
               plotear(cam, n_cam, list_marker, i, n_prev, t_label, radio) %se plotean trayectorias 2D con etiquetas nombre (t_label=0) o numero (t_label=1)
               pause(0.01)
           end
       end
   end