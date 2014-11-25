
close all
clc

%% Script que traza las rectas 3D que pasan por puntos 2D de marcadores en una retina y el foco respectivo para un frame dado.

%% CUERPO DE LA FUNCION

%Carga de Ground truth
%load '../Archivos_mat/CMU_8_07_hack/1600_600-100-100/Ground_Truth/Segmentacion/cam.mat';
%load '../Archivos_mat/CMU_8_07_hack/1600_600-100-100/Ground_Truth/Reconstruccion/skeleton.mat'
%carga de segmentacion real
%load '../Archivos_mat/CMU_8_03_hack/1600_600-100-100/Segmentacion/cam.mat';
%load '../Archivos_mat/CMU_8_03_hack/1600_600-100-100/Reconstruccion/skeleton.mat'
%load '../Archivos_mat/CMU_8_07_hack/1600_600-100-100/Tracking/skeleton.mat'

cam = cam_seg;
skeleton = skeleton_rec;
%skeleton = skeleton_track;

vec_cams = 1:17;%indica los rayos de que camaras se quieren plotear
n_cams = length(vec_cams);
markers = 1:6; %indica el indice de los marcadores que se quieren utilizar 
n_frame = 50; %nro de frame a visualizar
str='[';%voy guardando los nombres de las camaras
colors = {'g', 'm', 'c', 'y', 'b'};%permite que en cada ciclo for se cambie de color, al menos hasta i=5
index_colors = 1;%en esta variable mantengo el indice acutal de color que se utiliza
for i = 1:length(vec_cams)
    puntos_retina = get_info(cam{vec_cams(i)}, 'frame', n_frame, 'marker', 'coord', markers);
    puntos_retina = puntos_retina(:,markers);
    [F,u] = recta3D(cam{vec_cams(i)}, puntos_retina);
    %F es el foco de la cámara
    %u es el vector director del rayo de la camara al punto de la retina
    lambda = -1:12; %ayuda a moverse sobre el vector director
    for j = 1:length(markers) %plotea un rayo para cada punto de la retina especificado en markers
        x = F(1) +lambda*u(1,j);
        y = F(2) +lambda*u(2,j);
        z = F(3) +lambda*u(3,j);
        plot3(x,y,z, colors{index_colors})
    end
    index_colors = index_colors +1;
    if index_colors==6
        index_colors =1;
    end
    grid on
    hold on
    
    %plotea el centro de la camara
    plot3(F(1),F(2),F(3),'*r', 'LineWidth',4)
    %guardo el nombre de la camara
    if i==1
        str = [str num2str(vec_cams(i))];
    else
        str  =[str '; ' num2str(vec_cams(i))];
    end
end
str=[str ' ]'];

%Grafico los puntos 3D interseccion de los rayos de cada camara
X=get_info(skeleton, 'frame', n_frame, 'marker', 'coord');%obtengo todos los marcadores del frame
x = X(1,:);
y = X(2,:);
z = X(3,:);
for i=1:length(x) %ploteo todos los puntos que pude reconstruir
    hold on, plot3(x(i), y(i), z(i), 'ko', 'LineWidth',2);
end
x = x(markers);
y = y(markers);
z = z(markers);
for i=1:length(x)%ploteo solo los que se encuentran en marker pero de color rojo
    hold on, plot3(x(i), y(i), z(i), 'k*', 'LineWidth',6);
end
axis equal; 
grid minor;
xlabel('X','FontWeight', 'bold', 'FontSize',14,'FontName','Times' )
ylabel('Y', 'FontWeight', 'bold', 'FontSize',14,'FontName','Times')
zlabel('Z', 'FontWeight', 'bold', 'FontSize',14,'FontName','Times')

title(['Reconstrucción con las camaras de índices' str], 'FontWeight', 'bold', 'FontSize',19,'FontName','Times')

%la siguiente linea permite ajustar manualmente que parte del ploteo 3D se
%quiere ver [xmin, xmax, ymin, ymax, zmin, zmax]
%axis([-1, 8, -3, 2, 0, 2])
%distancia = dist_rectas3D (F1, u1, F2, u2)