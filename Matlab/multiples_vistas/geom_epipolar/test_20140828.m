clc
close all

if ~(exist('Xi')&exist('Yi'))
    
    clear all
    
    load saved_vars\skeleton13_segmentacion_mm.mat
    
    load saved_vars\skeleton13_ground_truth.mat
    
    f_ini=1;
    f_fin=322;
    
    Xi = [];Yi=[];
    
    for n_frame=f_ini:f_fin
        
        xi = get_info(skeleton_segmentacion,'frame', n_frame, 'marker', 'coord');
        Xi=[Xi,[xi;n_frame*ones(1,size(xi,2))]];
        
        yi = get_info(skeleton,'frame', n_frame, 'marker', 'coord');
        Yi=[Yi,[yi;n_frame*ones(1,size(yi,2))]];
        
    end
    
end


%%

f_ini=20;
f_fin=100;

X_in = Xi;
%X_in = Yi;


X_in = X_in(:,(X_in(4,:)<=f_fin)&(X_in(4,:)>=f_ini));

clc;
close all;

[X_out,datos]=make_tracking(X_in);

%X_out = X_out(:,X_out(6,:)~=0);

%return;

%X_out=X_out(:,X_out(4,:)<=max(X_out(4,X_out(5,:)~=0)));

figure

%marker_fin = max(X_out(5,:)); marker_ini = 1;
marker_fin = 1; marker_ini = marker_fin; 

for marker=marker_ini:marker_fin
    plot3(X_out(1,:),X_out(2,:),X_out(3,:),'kx',...
        Yi(1,Yi(4,:)<=f_fin&Yi(4,:)>=f_ini),Yi(2,Yi(4,:)<=f_fin&Yi(4,:)>=f_ini),Yi(3,Yi(4,:)<=f_fin&Yi(4,:)>=f_ini),'.',...
        X_out(1,X_out(5,:)==marker),X_out(2,X_out(5,:)==marker),X_out(3,X_out(5,:)==marker),'go-');
    title(['Trayectoria ' num2str(marker)]);
    xlabel('X');
    ylabel('Y')
    zlabel('Z');
    axis equal;
    axis([...
        min(Yi(1,Yi(4,:)<=max(X_out(4,X_out(5,:)~=0)))),...
        max(Yi(1,Yi(4,:)<=max(X_out(4,X_out(5,:)~=0)))),...
        min(Yi(2,Yi(4,:)<=max(X_out(4,X_out(5,:)~=0)))),...
        max(Yi(2,Yi(4,:)<=max(X_out(4,X_out(5,:)~=0)))),...
        min(Yi(3,Yi(4,:)<=max(X_out(4,X_out(5,:)~=0)))),...
        max(Yi(3,Yi(4,:)<=max(X_out(4,X_out(5,:)~=0)))) ]);
    if marker~=marker_fin
        pause;
    end
    
end;

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

hist(X_out(7,X_out(7,:)~=(-Inf)&X_out(7,:)~=(0)),20);
title('Distribucion de distancias enlazadas');
%{
figure
marker = 1;
plot(X_out(4,X_out(5,:)==marker),X_out(7,X_out(5,:)==marker),'.-')
title(['Evolucion distancia de enlaces , marcador ' num2str(marker)]);
xlabel('Frame');
ylabel('Distancia');
%}