close all;
clear all;
clc;
%% Este archivo permite probar la funcion plotear con todas las entradas posibles

load('Variables_save/skeleton.mat')
load('Variables_save/cam.mat')

list_marker =[1 2 20 15];%marcadores que se quieren visualizar
last_frame = 200; %ultimo frame a graficar
t_label = 1; %con etiquetas nombre (t_label=0) o numero (t_label=1)
n_cam = 3;%camara numero n_cam

% Estructura skeleton
   %plotear(skeleton)           %se plotea secuencia 3D con etiquetas nombres
   %plotear(skeleton, t_label)   %se plotea secuencia 3D con etiquetas nombre (t_label=0) o numero (t_label=1)
   plotear(skeleton, list_marker, last_frame, t_label) %se plotean trayectorias 3D con etiquetas nombre (t_label=0) o numero (t_label=1)
   
%Estructura cam
   %plotear(cam, n_cam )        %se plotea 2D con etiquetas nombres 
   %plotear(cam, n_cam, t_label) %se plotea secuencia 2D con etiquetas nombre (t_label=0) o numero (t_label=1)
   %plotear(cam, n_cam, list_marker, last_frame, t_label) %se plotean trayectorias 2D con etiquetas nombre (t_label=0) o numero (t_label=1)

