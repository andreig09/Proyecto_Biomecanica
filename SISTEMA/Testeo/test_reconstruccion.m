clear all
close all
clc
add_paths()

frame_ini = 10;

load 'C:\Proyecto\PB_2014_12_03\Archivos_mat\CMU_8_03_hack\1600_600-100-100\Reconstruccion\skeleton.mat'

skeleton_reconstruccion = skeleton_rec;

%return;
load 'C:\Proyecto\PB_2014_12_03\Archivos_mat\CMU_8_03_hack\1600_600-100-100\Ground_Truth\Reconstruccion\skeleton.mat';

skeleton_ground = skeleton_rec;

clear skeleton_rec;

%return;

Xi=[];Yi=[];

for frame=frame_ini:get_info(skeleton_reconstruccion,'n_frames')
    xi = get_info(skeleton_reconstruccion,'frame', frame, 'marker', 'coord');
    
    Xi=[Xi,...
        [xi;...
        frame*ones(1,size(xi,2));...
        1:size(xi,2)]...
        ];
    
    X_aux1 = [Xi(:,Xi(4,:)==frame)];
    X_aux2 = sortrows(unique(X_aux1','rows'),4)';
    
    if size(X_aux1,2)~=size(X_aux1,2)
    
    size(X_aux1,2)
    
    size(X_aux1,2)
        
    disp(frame)
    
    disp('-----');
    
    end
end

for frame=frame_ini:get_info(skeleton_ground,'n_frames')
    yi = get_info(skeleton_ground,'frame', frame, 'marker', 'coord');
    Yi=[Yi,...
        [yi;...
        frame*ones(1,size(yi,2));...
        1:size(yi,2)]];
end

%% Testeo de Error de Reconsturccion

[rmse,rmse_i,~,~,~,rmse_i_t]=rmse_segmentacion_ground(Xi,Yi);

porcentaje = 99;

disp([ 'Promedio = ' num2str(mean(rmse_i_t(1,:))*100) ' cm' ])

disp([ sprintf('%d%%',porcentaje) ' = ' num2str(prctile(rmse_i(1,:),porcentaje)*100) ' cm' ])


disp([ 'Media = ' num2str(median(rmse_i(1,:))*100) ' cm' ])

disp([ num2str(max(rmse_i(3,:))) ' markers' ]);
%animar_tracking(Xi(:,Xi(1,:)<=max(Yi(1,:))&Xi(2,:)<=max(Yi(2,:))&Xi(3,:)<=max(Yi(3,:))&Xi(1,:)>=min(Yi(1,:))&Xi(2,:)>=min(Yi(2,:))&Xi(3,:)>=min(Yi(3,:))))