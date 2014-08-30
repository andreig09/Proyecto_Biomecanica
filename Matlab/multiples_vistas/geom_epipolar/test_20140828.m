clc
close all

if ~(exist('Xi')&exist('Yi'))
    
    clear all
    
    load saved_vars\skeleton14.mat
    
    load saved_vars\skeleton14_segmentacion2.mat
    
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
f_fin=30;

X_in = Xi;
%X_in = Yi;


X_in = X_in(:,(X_in(4,:)<=f_fin)&(X_in(4,:)>=f_ini));

clc;
close all;

X_out=make_tracking(X_in);


figure

for marker=1:max(X_out(5,:))
    plot3(X_out(1,:),X_out(2,:),X_out(3,:),'k.',X_out(1,X_out(5,:)==marker),X_out(2,X_out(5,:)==marker),X_out(3,X_out(5,:)==marker),'g*-');
    title(['Trayectoria ' num2str(marker)]);
    xlabel('X');
    ylabel('Y')
    zlabel('Z');
    axis equal;
    %axis([min(Yi(1,:)),max(Yi(1,:)),min(Yi(2,:)),max(Yi(2,:)),min(Yi(3,:)),max(Yi(3,:))]);
    pause(1);
    
end;



figure

plot(X_out(4,:),X_out(7,:),'.');
title('Distancias Entre Enlaces');
xlabel('Frame');
ylabel('Distancia')

figure

plot(X_out(4,:),X_out(6,:),'.');
title('Aceleracion Entre Enlaces');
xlabel('Frame');
ylabel('Aceleracion')
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

hist(X_out(7,X_out(7,:)~=(-Inf)&X_out(7,:)~=(0)));
title('Distribucion de distancias enlazadas');

figure
marker = 3;
plot(X_out(4,X_out(5,:)==marker),X_out(7,X_out(5,:)==marker),'.-')
title(['Evolucion distancia de enlaces , marcador ' num2str(marker)]);
xlabel('Frame');
ylabel('Distancia');