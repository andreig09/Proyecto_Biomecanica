clc
close all
clear all
run add_paths

%% GROUND TRUTH

%load D:\Proyecto\Proyecto_GIT\Archivos_mat\CMU_9_07_hack\1600_600-100-200\Ground_Truth\cam_ground_truth.mat;
load C:\Proyecto\Base_20150202\Base_de_datos\Sujeto_CMU_09\09_12\Ground_Truth\1600_600-100-100\Segmentacion\cam.mat;

cam = cam_seg;

%% SEGMENTACION

%load D:\Proyecto\Proyecto_GIT\Archivos_mat\CMU_9_07_hack\1600_600-100-200\cam.mat;
load C:\Proyecto\Base_20150202\Base_de_datos\Sujeto_CMU_09\09_12\Datos_Procesados\1600_600-100-100\Segmentacion\cam.mat;

cam_segmentacion = cam_seg;

%%

clear cam_seg;

rmse_i_total = [];

%for n_cam = 1:size(cam_segmentacion,2)
for n_cam = 1:17
    
    figure(n_cam)
    
    frame_ini = 10;
    frame_fin = min([get_info(cam_segmentacion(n_cam),'n_frames'),get_info(cam(n_cam),'n_frames')]);
    %frame_fin = 200;
    
    Xi=[];Yi=[];
    for n_frame=frame_ini:frame_fin
        
        xi = get_info(cam_segmentacion(n_cam), 'frame',n_frame, 'marker', 'coord');
        Xi=[Xi,[xi;n_frame*ones(1,size(xi,2))]];
        
        yi= get_info(cam(n_cam), 'frame',n_frame, 'marker', 'coord');
        Yi=[Yi,[yi;n_frame*ones(1,size(yi,2));1:size(yi,2)]];
        
    end
    
    %Yi = Yi(:,Yi(2,:)>0&Yi(2,:)<600);
    
    subplot(3,1,1)
    plot(Yi(1,:),Yi(2,:),'b.');axis equal;
    title(['Ground Truth - fr.(' num2str(frame_ini) ...
        '-' num2str(frame_fin) ...
        '), ' num2str(size(Yi,2)) ' puntos']);
    subplot(3,1,2)
    plot(Xi(1,:),Xi(2,:),'b.');axis equal;
    title(['Segmentacion - fr.(' num2str(frame_ini) ...
        '-' num2str(frame_fin) ...
        '), ' num2str(size(Xi,2)) ' puntos']);
    subplot(3,1,3)
    plot(Yi(1,:),Yi(2,:),'r.',Xi(1,:),Xi(2,:),'b.');axis equal;
    [rmse,rmse_i,~,~,~,rmse_i_t]=rmse_segmentacion_ground(Xi,Yi);
    
    figure
    
    plot(Yi(1,:),Yi(2,:),'r.',Xi(1,:),Xi(2,:),'b.');axis equal;
    [rmse,rmse_i,~,~,~,rmse_i_t]=rmse_segmentacion_ground(Xi,Yi);
    axis equal
    title([' Segmentacion - Camara ' num2str(n_cam) ])
    legend('Ground Truth','Segmentacion');
    xlabel('X (pixel)');
    ylabel('Y (pixel)');
    rmse_i_total = [rmse_i_total,...
        [rmse_i;n_cam*ones(1,size(rmse_i,2))]...
        ];
    
    porcentaje = 99;
    
    disp(['Camara ' num2str(n_cam) ...
        ' - fr.(' num2str(frame_ini) '-' num2str(frame_fin) ...
        '), deteccion = ' num2str(100*size(Xi,2)/size(Yi,2),4) ...
        '%, RMSE = ' num2str(mean(rmse_i_t(1,:))) ...
        ' pixels, P_' sprintf('%d%',porcentaje) ' = ' num2str(prctile(rmse_i(1,:),porcentaje))]);
    %{
    figure
    Z=Xi;
    for frame=1:(min(Z(4,:))+max(Z(4,:))+1)
        
        close all,for i=min(Xi(4,:)):max(Xi(4,:)) plot(Xi(1,Xi(4,:)==i),Xi(2,Xi(4,:)==i),'bo'),axis equal,axis([min(Xi(1,:)),max(Xi(1,:)),min(Xi(2,:)),max(Xi(2,:))]),title(i),set(gcf,'units','normalized','outerposition',[0 0 1 1]),pause(0.01),end;
        
    end
    %}
end