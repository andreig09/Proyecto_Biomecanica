clc
close all
clear all

load 'saved_vars/cam.mat';
%load 'saved_vars/cam_andrei.mat';
%load 'saved_vars/cam17.mat';
%load 'saved_vars/skeleton.mat';
n_cams = length(cam);
tot_markers = 26;


v_cams = [1:n_cams]; % vector de cámaras
frame = 100;
umbral = 0.05;

%% ensuciar datos
%  p = 0.80; 
%  aux_cam = dirty_cam(cam,p);
%  cam = aux_cam;

%%


Xrec = reconstruccion1frame(cam, v_cams, frame, umbral, tot_markers);



plot3(Xrec(1,:),Xrec(2,:),Xrec(3,:) ,'*')
 axis equal
 grid on


% 
% for i=1:max_frames
% Xrec = reconstruccion{i};
%  plot3(Xrec(1,:),Xrec(2,:),Xrec(3,:) ,'*')
%  axis equal
%  grid on
%  pause(0.1)
% end
% 
% 







