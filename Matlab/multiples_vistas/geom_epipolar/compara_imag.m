%clear all
close all
clc


%Voy a intentar graficar imagenes de las camaras blender con los puntos que
%tengo del ground truth




total_marker = size(cam(1).marker, 2);
total_frame =  size(cam(1).frame, 2);

list_marker =[1:total_marker];%marcadores que se quieren visualizar
init_frame =1; %primer frame a graficar
last_frame =1; %ultimo frame a graficar
n_prev = 0;
t_label = 1; %con etiquetas nombre (t_label=0) o numero (t_label=1)
n_cam = 2;%camara numero n_cam
radio = 0.5*14;%valor del radio de las circunferencias centradas en el último frame de cada marcador ¿valor en pixeles?
res_x = cam(n_cam).resolution(1,:); %resolucion horizontal
res_y = cam(n_cam).resolution(2,:); %resolucion vertical

correccion=0;
if correccion==0
    dX=0;
    dY=0;
else
    dX=0.3;%correccion de X en pixeles
    dY=-0.5;%correccion de Y en pixeles
end
cam_aux=cam; %en esta camara voy a guardar las coordenadas invertidas para graficar con los pixeles
for j=1:total_marker
    X=cam(n_cam).marker(j).x(1, :); % al final X(k) indica las coordenadas 'x' del marcador j frame k
    Y=cam(n_cam).marker(j).x(2, :); % al final Y(k) indica las coordenadas 'y' del marcador j frame k
    x=[1, 0; 0, -1]*[X; Y]+ [0.5, 0; 0, (res_y+0.5)]*ones(2, length(X));
    cam_aux(n_cam).marker(j).x= x;
    %cam_aux(n_cam).marker(j).x(1,:)= (X +dX); %Por algún motivo tengo que hacer estas correcciones para que se solapen los marcadores   
    %cam_aux(n_cam).marker(j).x(2,:)=( (res_y - Y)+1 +dY);

end


%% Cargo las imagenes
im=[];
for k=1:last_frame %guardo el nombre de cada frame en la matriz im   
    if k<10
        str = sprintf('Frames_cam%d/cam%d_000%d.png',n_cam, n_cam, k);
    else if k<100
        str = sprintf('Frames_cam%d/cam%d_00%d.png',n_cam, n_cam, k);
        else 
          str = sprintf('Frames_cam%d/cam%d_0%d.png', n_cam, n_cam, k);
        end
    end
    im=[im; str];
end
%A=imread(im(last_frame));% si quisiera cargar la matriz de imagen de last_frame

%% Ploteos

%esto es para que la pantalla me salga maximizada
screen_size=get(0,'ScreenSize'); % averiguo el tamaño de mi pantalla
f1=figure(1);

for k=init_frame:last_frame %desde el frame inicial al final
     %imshow(im(k, :));
     image(imread(im(k, :)));
     set(f1,'Position',screen_size-[0 0 0 70] );% Ajusta la ventana activa al tamaño de la pantalla 
     axis([1, res_x, 1, res_y]);
      hold on
      plotear(cam_aux, n_cam, list_marker, k, n_prev, t_label, radio);
      grid on
      grid minor
     
     pause(0.01)
end
%[XX,YY] = meshgrid(0:res_x,0:res_y);
%plot(XX, YY, 'g.')
% imshow(A(1,1,1))%, hold on
%  plot(1.5, 1, 'g*')

