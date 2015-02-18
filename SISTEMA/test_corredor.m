clc
close all

clear all

add_paths()

frame_ini = 10;

%%

load 'C:\Proyecto\Base_de_datos\Sujeto_CMU_08\08_07\Ground_Truth\1600_600-100-200\Reconstruccion\skeleton.mat';

skeleton_ground = skeleton_rec;
n_frames = get_info(skeleton_rec,'n_frames');
%n_frames = 30;

Yi = [];

for frame=frame_ini:n_frames
    yi = get_info(skeleton_rec,'frame', frame, 'marker', 'coord');
    Yi=[Yi,[yi;frame*ones(1,size(yi,2));1:size(yi,2)]];
end


%%

load 'C:\Proyecto\Base_de_datos\Sujeto_CMU_08\08_07\Datos_Procesados\1600_600-100-200\Reconstruccion\skeleton.mat'

n_frames = get_info(skeleton_rec,'n_frames');
%n_frames = 30;

Xi = [];

%for frame=1:131, plot_frames(skeleton, 'frame', frame), pause, end

%return

for frame=frame_ini:n_frames
    xi = get_info(skeleton_rec,'frame', frame, 'marker', 'coord');
    Xi=[Xi,[xi;frame*ones(1,size(xi,2));1:size(xi,2)]];
end

%%

[X_out,datos_aux]=make_tracking(Xi,Inf);
X_out = clean_tracking(X_out);

marker_ground = 10;

%% FILTRADO GLOBAL

[X_out,datos_aux]=make_tracking(Xi,prctile(X_out(7,:),97));
%[X_out,datos_aux]=make_tracking(Xi,prctile(X_out(7,:),99));
X_out = clean_tracking(X_out);


%% FILTRADO INDIVIDUAL

%[~,thr] = filter_tracking(X_out);
%[X_out,thr] = filter_tracking(X_out);

%%

%thr = histograma_tracking(X_out,99)
%close all

%[X_out,datos]=make_tracking(Xi,prctile(X_out(6,:),99.78));
%X_out = clean_tracking(X_out);

%animar_tracking(X_out)

%% Testeo de Error de Tracking

[promedio_error,errores,~,~,etiquetas_ground,rmse_i_t]=rmse_segmentacion_ground(X_out,Yi);

disp([ 'Promedio = ' num2str(mean(rmse_i_t(1,:))*100) ' cm' ])

disp([ '99% = ' num2str(prctile(errores(1,:),99)*100) ' cm' ])


disp([ 'Media = ' num2str(median(errores(1,:))*100) ' cm' ])

disp('---');

labels=X_out(5,X_out(4,:)==min(X_out(4,:)));
labels=[labels(etiquetas_ground(:,1))',etiquetas_ground];

error_marker = [];

label_ground = get_info(skeleton_ground,'frame', frame_ini,'marker','name');

for i=min(errores(3,:)):max(errores(3,:))
    if ~isempty(labels(labels(:,3)==i,1))
        error_marker = [error_marker;...
            labels(labels(:,3)==i,1),...
            i,...
            mean(errores(1,errores(3,:)==i))*100,...
            prctile(errores(1,errores(3,:)==i),99)*100];
        disp([ num2str(i) ' - ' label_ground{i}]);
        
    end
end


disp('marker_track marker_ground promedio prc_99')
disp(sortrows(error_marker,2))

%%

figure;
subplot(1,2,1)
hist(errores(1,:)*100,20);
xlabel('Error De Marcador (cm)');
ylabel('Cantidad');
title(['Histograma ( ' num2str(size(errores(1,:),2)) ' marcadores)']);
subplot(1,2,2)
plot(prctile(errores(1,:),90:0.01:100)*100,90:0.01:100,'b.-')
xlabel('Error De Marcador (cm)');
ylabel('Porcentaje (%)');
title('Distribucion Acumulada');
grid on;

marker_tracking = error_marker(error_marker(:,2)==marker_ground,1);


X_1=X_out(:,X_out(5,:)==marker_tracking);
X_2=Yi(:,Yi(5,:)==marker_ground&Yi(4,:)<=max(X_out(4,:)));

X_1 = X_1(:,1:min([length(X_1),length(X_2)])); X_2 = X_2(:,1:min([length(X_1),length(X_2)]));

figure
plot(X_out(4,X_out(5,:)==marker_tracking),100*(sum((X_1(1:3,:)-X_2(1:3,:)).^2)).^0.5,'.-')
title([' Error - Tracking: ' num2str(marker_tracking) ' ,Ground: ' num2str(marker_ground)])
xlabel('Frame')
ylabel('Error (cm)')
figure
plot3(X_out(1,X_out(5,:)==marker_tracking),X_out(2,X_out(5,:)==marker_tracking),X_out(3,X_out(5,:)==marker_tracking),'b.-',...
    X_out(1,X_out(5,:)==marker_tracking&isnan(X_out(6,:))),X_out(2,X_out(5,:)==marker_tracking&isnan(X_out(6,:))),X_out(3,X_out(5,:)==marker_tracking&isnan(X_out(6,:))),'rs',...
    Yi(1,Yi(5,:)==marker_ground),Yi(2,Yi(5,:)==marker_ground),Yi(3,Yi(5,:)==marker_ground),'r.-'),axis equal
grid on;
title([' Trayectorias - Tracking: ' num2str(marker_tracking) ' ,Ground: ' num2str(marker_ground)]);
xlabel('X (m)');ylabel('Y (m)');zlabel('Z (m)')


n_paths = unique(X_out(5,:));

n_paths = marker_tracking;

for n_path=1:size(n_paths,2)
    path = n_paths(n_path);
    X_path = X_out(:,X_out(5,:)==path);
    if ~isempty(X_path)
        figure
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
        figure
        %{
    subplot(6,1,1)
    plot(X_path(4,:),X_path(1,:),'b.-')
    title(['Marker ' num2str(n_paths(n_path)) ' - X']);
    subplot(6,1,2)
    plot(X_path(4,:),X_path(2,:),'b.-')
    title(['Marker ' num2str(n_paths(n_path)) ' - Y']);
    subplot(6,1,3)
    plot(X_path(4,:),X_path(3,:),'b.-')
    title(['Marker ' num2str(n_paths(n_path)) ' - Z']);
        %}
        subplot(3,1,1)
        velocidad = sum((X_path(1:3,2:size(X_path,2))-X_path(1:3,1:size(X_path,2)-1)).^2).^(1/2);
        plot(X_path(4,2:size(X_path,2)),velocidad,'b.-',...
            [min(X_path(4,3:size(X_path,2))),max(X_path(4,3:size(X_path,2)))],median(prctile(velocidad,90:0.1:100))*[1,1],'r--')
        title(['Marker ' num2str(n_paths(n_path)) ' - Velocidad']);
        xlabel('Frame');ylabel('metro/frame');
        
        subplot(3,1,2)
        aceleracion = sum((-X_path(1:3,3:size(X_path,2))+2*X_path(1:3,2:size(X_path,2)-1)-X_path(1:3,1:size(X_path,2)-2)).^2).^(1/2);
        plot(X_path(4,3:size(X_path,2)),aceleracion,'b.-',...
            [min(X_path(4,3:size(X_path,2))),max(X_path(4,3:size(X_path,2)))],median(prctile(aceleracion,90:0.1:100))*[1,1],'r--')
        title(['Marker ' num2str(n_paths(n_path)) ' - Aceleracion']);
        xlabel('Frame');ylabel('metro/frame^2');
        subplot(3,1,3)
        v_aceleracion = sum((-X_path(1:3,4:size(X_path,2))+3*X_path(1:3,3:size(X_path,2)-1)-3*X_path(1:3,2:size(X_path,2)-2)+X_path(1:3,1:size(X_path,2)-3)).^2).^(1/2);
        plot(X_path(4,4:size(X_path,2)),v_aceleracion,'b.-',...
            [min(X_path(4,3:size(X_path,2))),max(X_path(4,3:size(X_path,2)))],median(prctile(v_aceleracion,90:0.1:100))*[1,1],'r--')
        title(['Marker ' num2str(n_paths(n_path)) ' - Var.Aceleracion']);
        xlabel('Frame');ylabel('metro/frame^3');
        if n_path<length(n_paths)
            pause
        end
    end
end
%{
for i=1:size(n_paths,2)
    disp([n_paths(i),sum(isnan(X_out(6,X_out(5,:)==n_paths(i))))*100/length(isnan(X_out(6,X_out(5,:)==n_paths(i))))]);
end;
%}