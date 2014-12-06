clc
close all

skeleton = [13,14;14,10;10,7;7,1;1,15;10,12;12,7;12,5;5,4;4,2;2,11;5,8;8,9;9,6];

marker_i = 14;marker_j = 13;marker_k = 10;

frame_a = 14;frame_b = 45;frame_c = 76;

angulo_ijk = animar_angulo(X_out,marker_i,marker_j,marker_k);


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

X_a = X_out(1:3,X_out(4,:)==frame_a&(X_out(5,:)==marker_i|X_out(5,:)==marker_j|X_out(5,:)==marker_k));
L_a = X_out(5,X_out(4,:)==frame_a&(X_out(5,:)==marker_i|X_out(5,:)==marker_j|X_out(5,:)==marker_k));

X_b = X_out(1:3,X_out(4,:)==frame_b&(X_out(5,:)==marker_i|X_out(5,:)==marker_j|X_out(5,:)==marker_k));
L_b = X_out(5,X_out(4,:)==frame_b&(X_out(5,:)==marker_i|X_out(5,:)==marker_j|X_out(5,:)==marker_k));

X_c = X_out(1:3,X_out(4,:)==frame_c&(X_out(5,:)==marker_i|X_out(5,:)==marker_j|X_out(5,:)==marker_k));
L_c = X_out(5,X_out(4,:)==frame_c&(X_out(5,:)==marker_i|X_out(5,:)==marker_j|X_out(5,:)==marker_k));

close all

figure

subplot(1,2,1)

frames = unique(X_out(4,:));

plot(frames,angulo_ijk,'b.-')
xlabel('Frames')
ylabel('Angulo')
title(['Angulo entre marcadores ' num2str(marker_i) ',' num2str(marker_j) ',' num2str(marker_k) ])

subplot(1,2,2)

plot3(X_out(1,X_out(5,:)==marker_i),X_out(2,X_out(5,:)==marker_i),X_out(3,X_out(5,:)==marker_i),'b.-',...
    X_out(1,X_out(5,:)==marker_j),X_out(2,X_out(5,:)==marker_j),X_out(3,X_out(5,:)==marker_j),'r.-',...
    X_out(1,X_out(5,:)==marker_k),X_out(2,X_out(5,:)==marker_k),X_out(3,X_out(5,:)==marker_k),'g.-',...
    skeleton_ax',skeleton_ay',skeleton_az','bo-',...
    skeleton_bx',skeleton_by',skeleton_bz','bo-',...
    skeleton_cx',skeleton_cy',skeleton_cz','bo-');

labels = cellstr(num2str([L_a,L_b,L_c]'));
text([X_a(1,:),X_b(1,:),X_c(1,:)],...
    [X_a(2,:),X_b(2,:),X_c(2,:)],...
    [X_a(3,:),X_b(3,:),X_c(3,:)],...
    labels,'VerticalAlignment','bottom','HorizontalAlignment','right');
axis equal
grid on