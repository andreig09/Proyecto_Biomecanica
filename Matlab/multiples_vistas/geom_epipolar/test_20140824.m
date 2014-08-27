clc;
clear all;
close all;

load saved_vars\cam_andrei.mat;
%load saved_vars\cam.mat;


f_ini=20;
f_fin=40;

n_cam_i=3;
n_cam_j=4;

Xi=[];Xj=[];

for n_frame=f_ini:f_fin
    
    xi = get_info(cam(n_cam_i), 'frame', n_frame, 'marker', 'coord');
    xj = get_info(cam(n_cam_j), 'frame', n_frame, 'marker', 'coord');
    
    Xi=[Xi,[xi;n_frame*ones(1,size(xi,2))]];
    Xj=[Xj,[xj;n_frame*ones(1,size(xj,2))]];
    
end;

clc;X_out=make_tracking(Xi);

for marker=1:max(X_out(5,:)) plot(X_out(1,:),X_out(2,:),'k.',X_out(1,X_out(5,:)==marker),X_out(2,X_out(5,:)==marker),'g*');pause;end;

return;
