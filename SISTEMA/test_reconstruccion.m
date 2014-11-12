clear all
close all
clc
add_paths()

load 'D:\Proyecto\Proyecto_GIT\Archivos_mat\Nuevos\CMU_9_12_hack\1600_600-100-100\Reconstruccion\skeleton.mat'

skeleton_reconstruccion = skeleton_rec;

%return;

load 'D:\Proyecto\Proyecto_GIT\Archivos_mat\Nuevos\CMU_9_12_hack\1600_600-100-100\Ground_Truth\Reconstruccion\skeleton.mat';

skeleton_ground = skeleton_rec;

clear skeleton_rec;

%return;

Xi=[];Yi=[];

for frame=1:get_info(skeleton_reconstruccion,'n_frames')
    xi = get_info(skeleton_reconstruccion,'frame', frame, 'marker', 'coord');
    
    Xi=[Xi,[xi;frame*ones(1,size(xi,2))]];
    
    X_aux1 = [Xi(:,Xi(4,:)==frame)];
    X_aux2 = sortrows(unique(X_aux1','rows'),4)';
    
    if size(X_aux1,2)~=size(X_aux1,2)
    
    size(X_aux1,2)
    
    size(X_aux1,2)
        
    disp(frame)
    
    disp('-----');
    
    end
end

for frame=1:get_info(skeleton_ground,'n_frames')
    yi = get_info(skeleton_ground,'frame', frame, 'marker', 'coord');
    Yi=[Yi,[yi;frame*ones(1,size(yi,2))]];
end

[a,b,c,d]=rmse_segmentacion_ground(Xi,Yi);

disp(a)