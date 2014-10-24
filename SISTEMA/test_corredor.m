    clc
clear all
close all

add_paths()

load '..\Archivos_mat\Corredor\skeleton.mat'

n_frames = get_info(skeleton,'n_frames');

Xi = [];

%for frame=1:131, plot_frames(skeleton, 'frame', frame), pause, end

%return

for frame=20:n_frames
    xi = get_info(skeleton,'frame', frame, 'marker', 'coord');
    Xi=[Xi,[xi;frame*ones(1,size(xi,2))]];
end

X_out=make_tracking(Xi,Inf);X_out = clean_tracking(X_out);

thr = histograma_tracking(X_out,98)
close all

[X_out,datos]=make_tracking(Xi,thr);;X_out = clean_tracking(X_out);


n_paths = unique(X_out(5,X_out(4,:)==max(X_out(4,:))));
%n_paths = 13;

for n_path=1:size(n_paths,2)
    path = n_paths(n_path);
    X_path = X_out(:,X_out(5,:)==path);
    figure(1)
   	plot3(X_out(1,:),X_out(2,:),X_out(3,:),'.b',...
        X_path(1,:),X_path(2,:),X_path(3,:),'o-g',...
        X_out(1,isnan(X_out(6,:))),X_out(2,isnan(X_out(6,:))),X_out(3,isnan(X_out(6,:))),'rs');
    axis equal;
    title(path);
    figure(2)
    subplot(4,1,1)
    plot(X_path(4,:),X_path(1,:),'.b')
    subplot(4,1,2)
    plot(X_path(4,:),X_path(2,:),'.b')
    subplot(4,1,3)
    plot(X_path(4,:),X_path(3,:),'.b')
    subplot(4,1,4)
    plot(X_path(4,:),X_path(7,:),'.b')
    if n_path<length(n_paths)
        pause
    end
end

for i=1:size(n_paths,2)
    disp([n_paths(i),sum(isnan(X_out(6,X_out(5,:)==n_paths(i))))*100/length(isnan(X_out(6,X_out(5,:)==n_paths(i))))]);
end;
