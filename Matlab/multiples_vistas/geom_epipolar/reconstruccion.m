clc
close all
clear all

%load 'saved_vars/cam.mat';
%load 'saved_vars/cam_andrei.mat';
%load 'saved_vars/cam17.mat';
%load 'saved_vars/cam17_andrei.mat';
%load 'saved_vars/skeleton.mat';
load 'saved_vars/cam14_segmentacion';
cam = cam_segmentacion;
%%
n_cams = length(cam);
tot_markers = 14;


v_cams = [1:n_cams]; % vector de cámaras
frame = 20;
umbral = .05;

for frame=40:300
%% eliminar esto %%%%%%%%% invierto coordenada y de la estructura

for i=1:5
    n_markers = get_info(cam(i), 'frame', frame, 'n_markers');
for j=1:n_markers
    cam(i).frame(frame).marker(j).coord(2) = 300 - cam(i).frame(frame).marker(j).coord(2);
end
end

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
pause(0.1)


end




