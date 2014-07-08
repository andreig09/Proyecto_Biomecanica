clc
clear all
close all

load('saved_vars/cam.mat')


%%
N1 = get_info(cam(2), 'frame', 1,'marker', 'coord');
N2 = get_info(cam(3), 'frame', 1,'marker', 'coord');

P1 = get_info(cam(2), 'projection_matrix');
P2 = get_info(cam(3), 'projection_matrix');

y = dlt(N1,N2,P1,P2);


y1 = y(1,:)./y(4,:);
y2 = y(2,:)./y(4,:);
y3 = y(3,:)./y(4,:);

%%
load('saved_vars/skeleton.mat')
posta3D = get_info(skeleton, 'frame', 1, 'marker', 'coord');

plot3(y1,y2,y3,'*')
axis equal
grid on

hold on
plot3(posta3D(1,:),posta3D(2,:),posta3D(3,:),'or')

Y = [y1;y2;y3] - posta3D ;

