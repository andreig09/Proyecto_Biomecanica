clc
clear all
close all

add_paths()

frame_ini = 10;

load 'D:\Proyecto\Proyecto_Biomecanica_20141118\Archivos_mat\CMU_8_03_hack\Ground_Truth\Reconstruccion\skeleton.mat';

skeleton_ground = skeleton_rec;
n_frames = get_info(skeleton_rec,'n_frames');
Yi = [];

for frame=frame_ini:n_frames
    yi = get_info(skeleton_rec,'frame', frame, 'marker', 'coord');
    Yi=[Yi,[yi;frame*ones(1,size(yi,2));1:size(yi,2)]];
end
%}  


load 'D:\Proyecto\Proyecto_Biomecanica_20141118\Archivos_mat\CMU_8_03_hack\Reconstruccion\skeleton.mat'

n_frames = get_info(skeleton_rec,'n_frames');

Xi = [];

%for frame=1:131, plot_frames(skeleton, 'frame', frame), pause, end

%return

for frame=frame_ini:n_frames
    xi = get_info(skeleton_rec,'frame', frame, 'marker', 'coord');
    Xi=[Xi,[xi;frame*ones(1,size(xi,2))]];
end

X_out=make_tracking(Xi,Inf);

X_out = clean_tracking(X_out);

thr = histograma_tracking(X_out,98)
close all

[X_out,datos]=make_tracking(Xi,thr);

X_out = clean_tracking(X_out);


n_paths = unique(X_out(5,:));
%n_paths = 9;

for n_path=1:size(n_paths,2)
    path = n_paths(n_path);
    X_path = X_out(:,X_out(5,:)==path);
    figure(1)
   	plot3(X_out(1,:),X_out(2,:),X_out(3,:),'.b',...
        X_path(1,:),X_path(2,:),X_path(3,:),'o-g',...
        X_out(1,isnan(X_out(6,:))),X_out(2,isnan(X_out(6,:))),X_out(3,isnan(X_out(6,:))),'rs');
    axis equal;
    axis([min(X_out(1,X_out(7,:)~=0)),max(X_out(1,X_out(7,:)~=0)),...
        min(X_out(2,X_out(7,:)~=0)),max(X_out(2,X_out(7,:)~=0)),...
        min(X_out(3,X_out(7,:)~=0)),max(X_out(3,X_out(7,:)~=0)),]);
    title([ 'Trayectoria ' num2str(path)]);
    xlabel('X');ylabel('Y');zlabel('Z');
    grid on
    figure(2)
    subplot(5,1,1)
    plot(X_path(4,:),X_path(1,:),'b.-')
    subplot(5,1,2)
    plot(X_path(4,:),X_path(2,:),'b.-')
    subplot(5,1,3)
    plot(X_path(4,:),X_path(3,:),'b.-')
    subplot(5,1,4)
    plot(X_path(4,:),X_path(7,:),'b.-')
    subplot(5,1,5)
    prc_num = 97;
    prc_ = prctile(X_path(7,2:size(X_path,2))./X_path(7,1:size(X_path,2)-1),prc_num);
    plot(X_path(4,2:size(X_path,2)),X_path(7,2:size(X_path,2))./X_path(7,1:size(X_path,2)-1),'b.-',...
        X_path(4,2:size(X_path,2)),prc_*ones(size(X_path(4,2:size(X_path,2)))),'r--')
    title(num2str(prc_))

    if n_path<length(n_paths)
        pause
    end
end
%{
for i=1:size(n_paths,2)
    disp([n_paths(i),sum(isnan(X_out(6,X_out(5,:)==n_paths(i))))*100/length(isnan(X_out(6,X_out(5,:)==n_paths(i))))]);
end;
%}

%animar_tracking(X_out)

%% Testeo de Error de Tracking

[a,b,c,d,e]=rmse_segmentacion_ground(X_out,Yi);

disp([ 'Promedio = ' num2str(a*100) ' cm' ])

disp([ '99% = ' num2str(prctile(b(1,:),99)*100) ' cm' ])


disp([ 'Media = ' num2str(median(b(1,:))*100) ' cm' ])

disp('---');

labels=X_out(5,X_out(4,:)==min(X_out(4,:)));
labels=[labels(e(:,1))',e];

error_marker = [];

for i=min(b(3,:)):max(b(3,:)) 
    error_marker = [error_marker;...
        labels(labels(:,3)==i,1),...
        i,...
        mean(b(1,b(3,:)==i))*100,...
        prctile(b(1,b(3,:)==i),98)*100];
end


disp('marker_track marker_ground promedio prc_98')
disp(sortrows(error_marker,4))

%%

marker_tracking = 3;
marker_ground = 4;

X_1=X_out(:,X_out(5,:)==marker_tracking);
X_2=Yi(:,Yi(5,:)==marker_ground);
figure
plot(100*(sum((X_1(1:3,:)-X_2(1:3,:)).^2)).^0.5,'.-')
