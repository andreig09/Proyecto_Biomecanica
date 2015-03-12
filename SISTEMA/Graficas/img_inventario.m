%% Captura 8_07_100_200 , 20 marker, 10-123, camaras 3;5;6;7;9;11;13;14;15;17, trayectoria 8

clc
close all
X_8=X_out(:,X_out(5,:)==8);

X_8_aux = X_8(:,isnan(X_8(6,:)));
X_8_fin = X_8(:,X_8(4,:)==X_8_aux(4)+1);
X_8_inicio = X_8(:,X_8(4,:)==X_8_aux(4)-1);

X_8=X_8(:,X_8(4,:)>=X_8_aux(4)-5&X_8(4,:)<X_8_aux(4));

X_8_traslado = X_8(1:3,size(X_8,2)-1:size(X_8,2))*[-1,1]';

labels = [X_8(4,:),X_8_fin(4,:)];

labels = cellstr(num2str(labels'));
for l=1:size(labels,1)
        labels{l} =sprintf('f.%s',labels{l});
end

x_labels = [X_8(1:3,:),X_8_fin(1:3,:)];

plot3(X_8(1,:),X_8(2,:),X_8(3,:),'b.-',...
    X_8_inicio(1)+[0:2]*X_8_traslado(1),X_8_inicio(2)+[0:2]*X_8_traslado(2),X_8_inicio(3)+[0:2]*X_8_traslado(3),'r.--',...   
    X_8_fin(1),X_8_fin(2),X_8_fin(3),'b.');
xlabel('X (m)');ylabel('Y (m)');zlabel('Z (m)');
title([ 'Trayectoria 8 - Frames 100-106' ]);
text(x_labels(1,:),...
    x_labels(2,:),...
    x_labels(3,:),...
    labels,'VerticalAlignment','bottom','HorizontalAlignment','right');

axis equal;
grid on