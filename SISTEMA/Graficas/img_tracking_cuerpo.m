%% salida para 8_03_100_100 , con suavizado, frame inicial 10
clc
close all
skeleton_marker = [13,12;12,8;8,14;14,4;4,6;14,9;9,8;9,3;3,5;5,1;1,7;3,10;10,2;2,11];
X_fin = X_out(:,X_out(4,:)==max(X_out(4,:)));

plot3(X_out(1,:),X_out(2,:),X_out(3,:),'b.')

skeleton_x = [];skeleton_y = [];skeleton_z = [];
for bone=1:size(skeleton_marker,1)
    skeleton_x = [skeleton_x;X_fin(1,X_fin(5,:)==skeleton_marker(bone,1)),X_fin(1,X_fin(5,:)==skeleton_marker(bone,2))];
    skeleton_y = [skeleton_y;X_fin(2,X_fin(5,:)==skeleton_marker(bone,1)),X_fin(2,X_fin(5,:)==skeleton_marker(bone,2))];
    skeleton_z = [skeleton_z;X_fin(3,X_fin(5,:)==skeleton_marker(bone,1)),X_fin(3,X_fin(5,:)==skeleton_marker(bone,2))];
end
hold on

plot3(skeleton_x',skeleton_y',skeleton_z','ro-');

labels = cellstr(num2str(X_fin(5,:)'));
text(X_fin(1,:),...
    X_fin(2,:),...
    X_fin(3,:),...
    labels,'VerticalAlignment','bottom','HorizontalAlignment','right');

marker_resaltar = 8;

hold on

plot3(X_out(1,X_out(5,:)==marker_resaltar),X_out(2,X_out(5,:)==marker_resaltar),X_out(3,X_out(5,:)==marker_resaltar),'go-');

xlabel('X (m)');
ylabel('Y (m)');
zlabel('Z (m)');
axis equal
grid on
