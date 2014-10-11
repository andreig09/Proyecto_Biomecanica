clc
close all

%if ~(exist('Xi')&exist('Yi'))
    
    clear all
    
    load saved_vars\skeleton_segmentacion17.mat
    
    load saved_vars\skeleton13_ground_truth.mat
    
    Xi = [];Yi=[];
    
    for n_frame=1:min([get_info(skeleton,'n_frames'),get_info(skeleton_segmentacion,'n_frames')])
        
        xi = get_info(skeleton_segmentacion,'frame', n_frame, 'marker', 'coord');
        %xi = filtrar_entrada(xi,2);
        Xi=[Xi,[xi;n_frame*ones(1,size(xi,2))]];
        
        yi = get_info(skeleton,'frame', n_frame, 'marker', 'coord');
        Yi=[Yi,[yi;n_frame*ones(1,size(yi,2));1:size(yi,2)]];
        
    end
    
%end


%%

f_ini=20;
f_fin=300;

X_in = Xi;
%X_in = Yi;


X_in = X_in(:,(X_in(4,:)<=f_fin)&(X_in(4,:)>=f_ini));

clc;
close all;

[X_out,datos]=make_tracking(X_in,0.055);

%% Limpieza de puntos no trackeados
X_out = X_out(:,X_out(5,:)~=0);

%% Limpieza de trayectorias truncas

total_frames = max(X_out(4,:))-min(X_out(4,:))

for n_path=1:max(X_out(5,:))
    if size(X_out(:,X_out(5,:)==n_path),2)<0.9*total_frames
        X_out = X_out(:,X_out(5,:)~=n_path);
    end
end
%return;

%figure

marker_fin = max(X_out(5,:)); marker_ini = 1;
marker_fin = 5; marker_ini = marker_fin; 

for marker=marker_ini:marker_fin
    figure(1)
    plot3(X_out(1,:),X_out(2,:),X_out(3,:),'kx',...
        Yi(1,Yi(4,:)<=f_fin&Yi(4,:)>=f_ini),Yi(2,Yi(4,:)<=f_fin&Yi(4,:)>=f_ini),Yi(3,Yi(4,:)<=f_fin&Yi(4,:)>=f_ini),'.',...
        X_out(1,X_out(5,:)==marker),X_out(2,X_out(5,:)==marker),X_out(3,X_out(5,:)==marker),'go-',...
        X_out(1,isnan(X_out(6,:))==1),X_out(2,isnan(X_out(6,:))==1),X_out(3,isnan(X_out(6,:))==1),'rs');
    title(['Trayectoria ' num2str(marker)]);
    xlabel('X');
    ylabel('Y')
    zlabel('Z');
    axis equal;
    %{
    axis([...
        min(Yi(1,Yi(4,:)<=max(X_out(4,X_out(5,:)~=0)))),...
        max(Yi(1,Yi(4,:)<=max(X_out(4,X_out(5,:)~=0)))),...
        min(Yi(2,Yi(4,:)<=max(X_out(4,X_out(5,:)~=0)))),...
        max(Yi(2,Yi(4,:)<=max(X_out(4,X_out(5,:)~=0)))),...
        min(Yi(3,Yi(4,:)<=max(X_out(4,X_out(5,:)~=0)))),...
        max(Yi(3,Yi(4,:)<=max(X_out(4,X_out(5,:)~=0)))) ]);
    %}
    figure(2)
    subplot(4,1,1)
    plot(X_out(4,X_out(5,:)==marker),X_out(7,X_out(5,:)==marker),'b.-')
    title([ ' Path ' num2str(marker) ' , Distancia entre frames (velocidad)' ]);
    subplot(4,1,2)
    plot(X_out(4,X_out(5,:)==marker),X_out(1,X_out(5,:)==marker),'b.-')
    title([ ' Path ' num2str(marker) ' , X' ]);
    subplot(4,1,3)
    plot(X_out(4,X_out(5,:)==marker),X_out(2,X_out(5,:)==marker),'b.-')
    title([ ' Path ' num2str(marker) ' , Y' ]);
    subplot(4,1,4)
    plot(X_out(4,X_out(5,:)==marker),X_out(3,X_out(5,:)==marker),'b.-')
    title([ ' Path ' num2str(marker) ' , Z' ]);
    if marker~=marker_fin
        pause;
    end
    
end;

thr = histograma_tracking(X_out,99);

return;

figure

plot(X_out(4,:),X_out(7,:),'.');
title('Distancias Entre Enlaces');
xlabel('Frame');
ylabel('Distancia')
%{
figure

plot(X_out(4,:),X_out(6,:),'.');
title('Aceleracion Entre Enlaces');
xlabel('Frame');
ylabel('Aceleracion')
%}
figure

frames = unique(X_out(4,:));

cantidad_enlazados = [];
cantidad_detectados = [];

for i=1:length(frames)
    test = X_out(:,((X_out(4,:)==frames(i))));
    cantidad_enlazados(i) = size(test(:,test(5,:)~=0&test(5,:)~=(-Inf)),2);
    cantidad_detectados(i) = size(test,2);
end

plot(frames,cantidad_enlazados,'b.-',frames,cantidad_detectados,'r.-');
legend('enlazados','detectados');
title('Cantidad de Enlaces');
xlabel('Frame');
ylabel('Cantidad');

figure

hist(X_out(7,X_out(7,:)~=(-Inf)&X_out(7,:)~=(0)),30);
title('Distribucion de distancias enlazadas');
%{
figure
marker = 1;
plot(X_out(4,X_out(5,:)==marker),X_out(7,X_out(5,:)==marker),'.-')
title(['Evolucion distancia de enlaces , marcador ' num2str(marker)]);
xlabel('Frame');
ylabel('Distancia');
%}