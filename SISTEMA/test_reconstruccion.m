clear all
close all
clc
add_paths()

load 'C:\Proyecto\Proyecto_Biomecanica\Archivos_mat\CMU_8_07_hack\1600_600-100-200\Reconstruccion\skeleton.mat'

skeleton_reconstruccion = skeleton_rec;

%return;

load 'C:\Proyecto\Proyecto_Biomecanica\Archivos_mat\CMU_8_07_hack\1600_600-100-200\Ground_Truth\Reconstruccion\skeleton.mat';

skeleton_ground = skeleton_rec;

clear skeleton_rec;

%return;

Xi=[];Yi=[];

for frame=10:get_info(skeleton_reconstruccion,'n_frames')
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

%% Testeo de Error de Reconsturccion

[a,b,c,d]=rmse_segmentacion_ground(Xi,Yi);

disp([ 'Promedio = ' num2str(a*100) ' cm' ])

disp([ '99% = ' num2str(prctile(b(1,:),99)*100) ' cm' ])


disp([ 'Media = ' num2str(median(b(1,:))*100) ' cm' ])