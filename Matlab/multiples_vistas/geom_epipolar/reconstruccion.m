clc
close all
clear all

%load 'saved_vars/cam.mat';
%load 'saved_vars/cam_andrei.mat';
%load 'saved_vars/cam17.mat';
%load 'saved_vars/cam17_andrei.mat';
%load 'saved_vars/skeleton.mat';
%load 'saved_vars/skeleton14.mat'
load 'saved_vars/cam14_segmentacion';
cam = cam_segmentacion;
%%
load 'saved_vars/skeleton14_segmentacion.mat';
estructura_salida = skeleton_segmentacion;

n_cams = length(cam);
tot_markers = 13;


v_cams = 1:n_cams; % vector de cámaras
frame = 20;
umbral = .05;

tic
for frame=1:300
%% eliminar esto %%%%%%%%% invierto coordenada y de la estructura

    for i=1:n_cams
        n_markers = get_info(cam(i), 'frame', frame, 'n_markers');
        for j=1:n_markers
            cam(i).frame(frame).marker(j).coord(2) = 300 - cam(i).frame(frame).marker(j).coord(2);
        end
    end

%% ensuciar datos
%  p = 0.80; 
%  aux_cam = dirty_cam(cam,p);
%  cam = aux_cam;

%% reconstrucción


Xrec = reconstruccion1frame(cam, v_cams, frame, umbral, tot_markers);

disp(frame)
%% ploteo
% figura = figure;
% hold off
% plot3(Xrec(1,:),Xrec(2,:),Xrec(3,:) ,'*')
% 
% 
%  X=zeros(tot_markers,1);
%  Y=zeros(tot_markers,1);
%  Z=zeros(tot_markers,1);
%  
% for h=1:tot_markers+1
%     X(h) = skeleton.frame(frame).marker(h).coord(1);
%     Y(h) = skeleton.frame(frame).marker(h).coord(2);
%     Z(h) = skeleton.frame(frame).marker(h).coord(3);
% end
% 
% 
% hold on
% plot3(X,Y,Z ,'r*')
% title(['frame: ' num2str(frame)])
%  axis equal
%  grid on
% 
% 
% saveas(figura,num2str(frame),'fig')


%% cargar estructura

n_Xrec= size(Xrec, 2); %numero de marcadores reconstruidos en el frame 'frame'
n_markers = get_info(skeleton_segmentacion, 'frame', frame, 'n_markers'); % devuelve el numero de marcadores del frame 'frame' de la estructura structure
Xrec = [Xrec, zeros(3, (n_markers - n_Xrec) )];%Si faltan marcadores para rellenar la estructura los lleno con ceros


estructura_salida = set_info(estructura_salida, 'frame', frame, 'marker', 'coord', Xrec); %ingreso los marcadores en el frame correspondiente de estructura_salida
estructura_salida = set_info(estructura_salida, 'frame', frame, 'n_markers', n_Xrec);% actualizo el numero de frame correspondiente

%%
end

toc


