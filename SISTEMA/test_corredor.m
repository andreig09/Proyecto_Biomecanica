clc
clear all
close all

add_paths()

frame_ini = 10;

load 'C:\Proyecto\PB_2014_11_23\Archivos_mat\CMU_8_07_hack\1600_600-100-200\Ground_Truth\Reconstruccion\skeleton.mat';

skeleton_ground = skeleton_rec;
n_frames = get_info(skeleton_rec,'n_frames');
Yi = [];

for frame=frame_ini:n_frames
    yi = get_info(skeleton_rec,'frame', frame, 'marker', 'coord');
    Yi=[Yi,[yi;frame*ones(1,size(yi,2));1:size(yi,2)]];
end
%}  


load 'C:\Proyecto\PB_2014_11_23\Archivos_mat\CMU_8_07_hack\1600_600-100-200\Reconstruccion\skeleton.mat'

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

%%
[X_out,thr] = filter_tracking(X_out);
thr
%{
%%

thr = histograma_tracking(X_out,99)
close all

[X_out,datos]=make_tracking(Xi,thr);
X_out = clean_tracking(X_out);
%}
n_paths = unique(X_out(5,:));
n_paths = 6;

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
    subplot(6,1,1)
    plot(X_path(4,:),X_path(1,:),'b.-')
    title(['Marker ' num2str(n_paths(n_path)) ' - X']);
    subplot(6,1,2)
    plot(X_path(4,:),X_path(2,:),'b.-')
    title(['Marker ' num2str(n_paths(n_path)) ' - Y']);
    subplot(6,1,3)
    plot(X_path(4,:),X_path(3,:),'b.-')
    title(['Marker ' num2str(n_paths(n_path)) ' - Z']);
    subplot(6,1,4)
    velocidad = sum((X_path(1:3,2:size(X_path,2))-X_path(1:3,1:size(X_path,2)-1)).^2).^(1/2);
    plot(X_path(4,2:size(X_path,2)),velocidad,'b.-',...
        [min(X_path(4,3:size(X_path,2))),max(X_path(4,3:size(X_path,2)))],median(prctile(velocidad,90:0.1:100))*[1,1],'r--')
    title(['Marker ' num2str(n_paths(n_path)) ' - Velocidad']);
    
    subplot(6,1,5)
    aceleracion = sum((-X_path(1:3,3:size(X_path,2))+2*X_path(1:3,2:size(X_path,2)-1)-X_path(1:3,1:size(X_path,2)-2)).^2).^(1/2);
    plot(X_path(4,3:size(X_path,2)),aceleracion,'b.-',...
        [min(X_path(4,3:size(X_path,2))),max(X_path(4,3:size(X_path,2)))],median(prctile(aceleracion,90:0.1:100))*[1,1],'r--')
    title(['Marker ' num2str(n_paths(n_path)) ' - Aceleracion']);
    subplot(6,1,6)
    v_aceleracion = sum((-X_path(1:3,4:size(X_path,2))+3*X_path(1:3,3:size(X_path,2)-1)-3*X_path(1:3,2:size(X_path,2)-2)+X_path(1:3,1:size(X_path,2)-3)).^2).^(1/2);
    plot(X_path(4,4:size(X_path,2)),v_aceleracion,'b.-',...
        [min(X_path(4,3:size(X_path,2))),max(X_path(4,3:size(X_path,2)))],median(prctile(v_aceleracion,90:0.1:100))*[1,1],'r--')
	title(['Marker ' num2str(n_paths(n_path)) ' - Var.Aceleracion']);

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

marker_tracking = 13;
marker_ground = 1;

X_1=X_out(:,X_out(5,:)==marker_tracking);
X_2=Yi(:,Yi(5,:)==marker_ground);
figure
plot(X_out(4,X_out(5,:)==marker_tracking),100*(sum((X_1(1:3,:)-X_2(1:3,:)).^2)).^0.5,'.-')
title([' Error - Tracking: ' num2str(marker_tracking) ' ,Ground: ' num2str(marker_ground)])
xlabel('Frame')
ylabel('Error (cm)')
figure
plot3(X_out(1,X_out(5,:)==marker_tracking),X_out(2,X_out(5,:)==marker_tracking),X_out(3,X_out(5,:)==marker_tracking),'b.',...
    Yi(1,Yi(5,:)==marker_ground),Yi(2,Yi(5,:)==marker_ground),Yi(3,Yi(5,:)==marker_ground),'r.'),axis equal
