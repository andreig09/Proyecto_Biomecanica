clc
close all

skeleton = [11,12;12,6;6,13;13,7;7,1;6,8;8,13;8,3;3,9;9,4;4,2;3,15;15,5;5,10];

%% Primer marcador es la articulacion

marker_i = 12;marker_j = 6;marker_k = 11;

frame_a = 10;frame_b = 60;frame_c = 110;

angulo_ijk = animar_angulo(X_out,marker_i,marker_j,marker_k);

frames = unique(X_out(4,:));

angulo_ijk = [angulo_ijk;frames];

skeleton_ax = [];skeleton_ay = [];skeleton_az = [];
skeleton_bx = [];skeleton_by = [];skeleton_bz = [];
skeleton_cx = [];skeleton_cy = [];skeleton_cz = [];

for bone=1:size(skeleton,1)
    
    skeleton_ax = [skeleton_ax;X_out(1,X_out(5,:)==skeleton(bone,1)&X_out(4,:)==frame_a),X_out(1,X_out(5,:)==skeleton(bone,2)&X_out(4,:)==frame_a)];
    skeleton_ay = [skeleton_ay;X_out(2,X_out(5,:)==skeleton(bone,1)&X_out(4,:)==frame_a),X_out(2,X_out(5,:)==skeleton(bone,2)&X_out(4,:)==frame_a)];
    skeleton_az = [skeleton_az;X_out(3,X_out(5,:)==skeleton(bone,1)&X_out(4,:)==frame_a),X_out(3,X_out(5,:)==skeleton(bone,2)&X_out(4,:)==frame_a)];

    skeleton_bx = [skeleton_bx;X_out(1,X_out(5,:)==skeleton(bone,1)&X_out(4,:)==frame_b),X_out(1,X_out(5,:)==skeleton(bone,2)&X_out(4,:)==frame_b)];
    skeleton_by = [skeleton_by;X_out(2,X_out(5,:)==skeleton(bone,1)&X_out(4,:)==frame_b),X_out(2,X_out(5,:)==skeleton(bone,2)&X_out(4,:)==frame_b)];
    skeleton_bz = [skeleton_bz;X_out(3,X_out(5,:)==skeleton(bone,1)&X_out(4,:)==frame_b),X_out(3,X_out(5,:)==skeleton(bone,2)&X_out(4,:)==frame_b)];

    skeleton_cx = [skeleton_cx;X_out(1,X_out(5,:)==skeleton(bone,1)&X_out(4,:)==frame_c),X_out(1,X_out(5,:)==skeleton(bone,2)&X_out(4,:)==frame_c)];
    skeleton_cy = [skeleton_cy;X_out(2,X_out(5,:)==skeleton(bone,1)&X_out(4,:)==frame_c),X_out(2,X_out(5,:)==skeleton(bone,2)&X_out(4,:)==frame_c)];
    skeleton_cz = [skeleton_cz;X_out(3,X_out(5,:)==skeleton(bone,1)&X_out(4,:)==frame_c),X_out(3,X_out(5,:)==skeleton(bone,2)&X_out(4,:)==frame_c)];
end

X_i = X_out(1:3,X_out(5,:)==marker_i);
X_j = X_out(1:3,X_out(5,:)==marker_j);
X_k = X_out(1:3,X_out(5,:)==marker_k);

dist_ik = sqrt(sum((X_i-X_k).^2));dist_ik = [dist_ik;frames];
dist_ij = sqrt(sum((X_i-X_j).^2));dist_ij = [dist_ij;frames];

X_a = X_out(1:3,X_out(4,:)==frame_a&(X_out(5,:)==marker_i|X_out(5,:)==marker_j|X_out(5,:)==marker_k));
L_a = X_out(5,X_out(4,:)==frame_a&(X_out(5,:)==marker_i|X_out(5,:)==marker_j|X_out(5,:)==marker_k));

X_b = X_out(1:3,X_out(4,:)==frame_b&(X_out(5,:)==marker_i|X_out(5,:)==marker_j|X_out(5,:)==marker_k));
L_b = X_out(5,X_out(4,:)==frame_b&(X_out(5,:)==marker_i|X_out(5,:)==marker_j|X_out(5,:)==marker_k));

X_c = X_out(1:3,X_out(4,:)==frame_c&(X_out(5,:)==marker_i|X_out(5,:)==marker_j|X_out(5,:)==marker_k));
L_c = X_out(5,X_out(4,:)==frame_c&(X_out(5,:)==marker_i|X_out(5,:)==marker_j|X_out(5,:)==marker_k));

close all

figure

subplot(2,1,1)

plot(dist_ij(2,:),dist_ij(1,:),'b.-',dist_ik(2,:),dist_ik(1,:),'r.-',...
    [frame_a,frame_a],[min([dist_ij(1,:),dist_ik(1,:)]),max([dist_ij(1,:),dist_ik(1,:)])],'r--',...
    [frame_b,frame_b],[min([dist_ij(1,:),dist_ik(1,:)]),max([dist_ij(1,:),dist_ik(1,:)])],'r--',...
    [frame_c,frame_c],[min([dist_ij(1,:),dist_ik(1,:)]),max([dist_ij(1,:),dist_ik(1,:)])],'r--')
title([' Distancia entre marcadores ' num2str(marker_i) '-' num2str(marker_j) ' , ' num2str(marker_i) '-' num2str(marker_k) ])
xlabel('Frames')
ylabel('Distancia (m)')

subplot(2,1,2)

plot(angulo_ijk(2,:),angulo_ijk(1,:),'b.-',...
    [frame_a,frame_a],[min(angulo_ijk(1,:)),max(angulo_ijk(1,:))],'r--',...
    [frame_b,frame_b],[min(angulo_ijk(1,:)),max(angulo_ijk(1,:))],'r--',...
    [frame_c,frame_c],[min(angulo_ijk(1,:)),max(angulo_ijk(1,:))],'r--')    
xlabel('Frames')
ylabel('Angulo (grados)')
title(['Angulo entre marcadores ' num2str(marker_j) '-' num2str(marker_i) '-' num2str(marker_k) ])

figure

plot3(X_out(1,X_out(5,:)==marker_i),X_out(2,X_out(5,:)==marker_i),X_out(3,X_out(5,:)==marker_i),'b.-',...
    X_out(1,X_out(5,:)==marker_j),X_out(2,X_out(5,:)==marker_j),X_out(3,X_out(5,:)==marker_j),'r.-',...
    X_out(1,X_out(5,:)==marker_k),X_out(2,X_out(5,:)==marker_k),X_out(3,X_out(5,:)==marker_k),'g.-',...
    skeleton_ax',skeleton_ay',skeleton_az','ko-',...
    skeleton_bx',skeleton_by',skeleton_bz','ko-',...
    skeleton_cx',skeleton_cy',skeleton_cz','ko-');

labels = cellstr(num2str([L_a,L_b,L_c]'));
text([X_a(1,:),X_b(1,:),X_c(1,:)],...
    [X_a(2,:),X_b(2,:),X_c(2,:)],...
    [X_a(3,:),X_b(3,:),X_c(3,:)],...
    labels,'VerticalAlignment','top','HorizontalAlignment','right');
title(['Trayectorias marcadores ' num2str(marker_j) '-' num2str(marker_i) '-' num2str(marker_k) ])
xlabel('X (m)');
ylabel('Y (m)');
zlabel('Z (m)');
axis equal
grid on