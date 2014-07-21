%Reconstruir un punto 3D
%1)cam2cam -->a la salida obtengo dos puntos relacionados
%2)dlt------->a la salida obtengo el punto 3D
%3) x= obtain_coord_retina(X, P) -->reproyecta en otras camaras
close all
load saved_vars/cam.mat
n_cam_i=1;
n_cam_d=2;
n_frame=100;



[xi, xd, index_table, d_min]= cam2cam(cam(n_cam_i), cam(n_cam_d), n_frame); %devuelve todos los puntos xi de camara izquierda y sus correspondientes contrapartes xd de camara derecha

Pi = get_info(cam(n_cam_i), 'projection_matrix'); %matrix de proyección de la camara izquierda
Pd = get_info(cam(n_cam_d), 'projection_matrix'); %matrix de proyección de la camara derecha

X = dlt(xi,xd,Pi,Pd); %efectúo dlt para triangulación
X = homog_norm(X); % normalizo el vector homogeneo 3D
X = X([1:3], :); %me quedo solo con las coordenadas euclideas


%proyecto sobre una tercer camara
n_cam3 = 4; %numero que indica el indice de la tercer camara
P3 = get_info(cam(n_cam3), 'projection_matrix'); %matrix de proyección de la tercer camara

x3= obtain_coord_retina(X, P3);% proyecto los puntos 3D sobre la camara3

[~, x3_i, index_table_3i, d_min_3i] = cam2cam(cam(n_cam_i), cam(n_cam3), n_frame); %devuelve todos los puntos x3_i contrapartes de xi en camara 3
[~, x3_d, index_table_3d, d_min_3d] = cam2cam(cam(n_cam_d), cam(n_cam3), n_frame); %devuelve todos los puntos x3_d contrapartes de xd en camara 3


%Ahora voy a obtener para cada xi la correspondiente rectas proyectada sobre la camara 3 (li3= F*xi)
Fi3 = F_from_P(Pi, P3);
li3 = Fi3*xi; %obtengo rectas homogeneas en camara 3
li3 = homog_norm(li3);%normalizo vector de recta homogenea 

%Ahora voy a obtener para cada xd la correspondiente rectas proyectada sobre la camara 3 (li3= F*xi)
Fd3 = F_from_P(Pd, P3);
ld3 = Fd3*xd; %obtengo rectas homogeneas en camara 3
ld3 = homog_norm(ld3);%normalizo vector de recta homogenea 





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% %verifico triangulacion estereo, comparo con la posta3D que tengo
% load('saved_vars/skeleton.mat')
% posta3D = get_info(skeleton, 'frame', n_frame, 'marker', 'coord');
% 
% plot3(X(1, :),X(2, :),X(3, :),'*')
% axis equal
% grid on
% hold on
% plot3(posta3D(1,:),posta3D(2,:),posta3D(3,:),'or')
% hold off
% Y = X - posta3D ;

