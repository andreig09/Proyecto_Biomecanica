clc
close all

%clear all

if ~exist('cam')
    load saved_vars\cam13_ground_truth.mat
end;

if ~exist('cam_segmentacion')
    load saved_vars\cam13_segmentacion.mat
end;

%1,2,10

for n_cam = 1:size(cam,2)
    
    figure(n_cam)
    
    frame_ini = 20;
    frame_fin = get_info(cam(n_cam),'n_frames');
    %frame_fin = 30;
    
    Xi=[];Yi=[];
    for n_frame=frame_ini:frame_fin
        
        xi = get_info(cam_segmentacion(n_cam), 'frame',n_frame, 'marker', 'coord');
        Xi=[Xi,[xi;n_frame*ones(1,size(xi,2))]];
        
        yi= get_info(cam(n_cam), 'frame',n_frame, 'marker', 'coord');
        Yi=[Yi,[yi;n_frame*ones(1,size(yi,2));1:size(yi,2)]];
        
    end
    
    subplot(1,2,1)
    plot(Yi(1,:),Yi(2,:),'b.');axis square;
    title(['Ground Truth - fr.(' num2str(frame_ini) '-' num2str(frame_fin) '), ' num2str(size(Yi,2)) ' puntos']);
    subplot(1,2,2)
    plot(Xi(1,:),Xi(2,:),'b.');axis square;
    title(['Segmentacion - fr.(' num2str(frame_ini) '-' num2str(frame_fin) '), ' num2str(size(Xi,2)) ' puntos']);
    disp(['Camara ' num2str(n_cam) ' - fr.(' num2str(frame_ini) '-' num2str(frame_fin) '), deteccion = ' num2str(100*size(Xi,2)/size(Yi,2),4) '%, RMSE = ' num2str(rmse_segmentacion_ground(Xi,Yi)) ' pixels']);
    %{
    figure
    Z=Xi;
    for frame=1:(min(Z(4,:))+max(Z(4,:))+1)
        
    end
    %}
end
