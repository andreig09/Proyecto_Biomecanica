clc
close all
clear all
load('cam.mat')

%se debe tener cargada un ground truth de cam.mat para que estoy funcione

ncarpeta=1;%nro de la carpeta que contiene las matrices de proyeccion estimadas con el procedimiento 'Calibracion Laser' utilizando un cierto numero de puntos.
ncam= 1;%retina que se utiliza para comparar proyecciones 
%inicializo variables
P1=cell(1, 17);%va a contener las matrices de proyeccion obtenidas a partir de calibracion con puntos luminicos
P2 =cell(1, 17);%va a contener las matrices de proyeccion obtenidas a partir de ground truth
C1=ones(4, 17);%va a contener los centros de las camaras a partir de P1
C2=ones(4, 17);%va a contener los centros de las camaras a partir de P2
for i=1:17
    
    P1{i}=load([num2str(ncarpeta), '/camera' num2str(i) '.Pmat.cal']);
    C1(:,i)=null(P1{i});
   
    
    P2{i}=str2num(cam_seg{i}.Attributes.projection_matrix);
    C2(:,i)=null((P2{i}));
   
end

%normalizo los puntos 3D
C1=homog_norm(C1)
C2=homog_norm(C2)


%C1=T.C2 ==>T=C1/C2
T=C1/C2%T es la matriz que lleva de los C2 a los C1.

%T es la matriz de cambio de base entre la base del sistema blender y la
%base generada implicitamente con el metodo de calibracion por punto
%luminico.


%Una vez que se tiene la relacion entre los dos sistemas, el de Blender por un lado y el sistema de coordenadas asociado a la calibracion
%con el punto luminico. La idea es:
%1)Elegir puntos 3D en el espacio
%2)Obtener sus coordenadas en ambos sistemas de coordenadas
%3)Proyectar sobre una camara utilizando las matrices de proyección P2 y
%P1. Con lo cual se tendrian puntos x2=P2.X2 y x1=P1.X1.
%4) La diferencia d=x2-x1 es una medida de la incertidumbre en el calculo
%de P1 por el metodo de la calibracion por puntos luminicos.

%Genero puntos en el espacio que se encuentra entre (-3, -5, 0)<X=(x, y, z)<(3, 0, 2)
%y pertenecen al plano x=z

xcota=[-3, 3];
ycota=[ -5, 0];
zcota=[ 0, 2];
salto = 0.5;
[x,y,z] = meshgrid(xcota(1):salto:xcota(2), ycota(1):salto:ycota(2), zcota(1):salto:zcota(2));
ancho=length(x(:,1,1));
largo=length(x(1,:,1));
alto=length(x(1,1,:));
id=1;
X2=zeros(3, ancho*largo*alto);
for i=1:ancho
    for j=1:largo
        for k=1:alto            
                X2(:,id)=[x(i, j, k), y(i, j, k), z(i, j, k)]; 
                id=id+1;
        end
    end
end
%por si se quieren ver los puntos que se están probando
% plot3(X2(1,:), X2(2,:), X2(3,:), '*')


%Paso los puntos a coordenadas homogeneas
X2=euclid2homog(X2);
%Encuentro los mismos puntos escritos en el sistema de coordenadas
%provenientes de la calibracion con puntos luminicos
X1=T*X2;


%Encuentro los puntos 3D centros de las camaras proyectados en la retina
%ncam

%proyecto los X1
x1=P1{ncam}*X1;
x1=homog_norm(x1);
%proyecto los X2
x2=P2{ncam}*X2;
x2=homog_norm(x2);

%modifico el origen en el plano de retina que se utiliza para escribir los x2 para que coincida con el origen
%de las coordenadas en que fueron escritos los x1
resolution=str2num(cam_seg{i}.Attributes.resolution);
x1(1,:)=x1(1,:)-0.5;
x1(2,:)=-x1(2,:)+resolution(2)+0.5;


%Comparo ambas coordenadas
diferencia=x1-x2
ncam

%Ploteo de los puntos a comparar en la camara ncam
plot(x1(1,:), x1(2,:), '*'), hold on, plot(x2(1,:), x2(2,:), 'ro')
str=['Comparación centros de camaras proyectados sobre camara ', num2str(ncam), '.']
title(str, 'FontSize',14, 'fontweight','b')
leyenda=legend('calibracion punto luminoso', 'calibracion ground truth')
set(leyenda,'FontName','arial','FontUnits','points','FontSize',14,...
    'FontWeight','normal','FontAngle','normal');
xlabel('x (pixeles)', 'FontSize',12)
ylabel('y (pixeles)', 'FontSize',12)
