clc

%load('cam.mat')
%load('skeleton.mat')
%se debe tener cargada un ground truth de cam.mat para que estoy funcione
%además se debe estar en la carpeta que contiene los archivos 'camera%d.Pmat.cal'

ncam= 3;%retina que se utiliza para comparar proyecciones 
%inicializo variables
P1=cell(1, 17);%va a contener las matrices de proyeccion obtenidas a partir de calibracion con puntos luminicos
P2 =cell(1, 17);%va a contener las matrices de proyeccion obtenidas a partir de ground truth
C1=ones(4, 17);%va a contener los centros de las camaras a partir de P1
C2=ones(4, 17);%va a contener los centros de las camaras a partir de P2
for i=1:17
    
    P1{i}=load(['camera' num2str(i) '.Pmat.cal']);
    C1(:,i)=null(P1{i});
   
    
    P2{i}=str2num(cam_seg{i}.Attributes.projection_matrix);
    C2(:,i)=null((P2{i}));
   
end

%normalizo los puntos 3D
C1=homog_norm(C1)
C2=homog_norm(C2)




%C1=T.C2 ==>T=C1/C2
T=C1/C2%T es la matriz que lleva de los C2 a los C1.

%Por ahora esto no da igual pues se debe corregir el efecto de inverción de
%ejes
P1{ncam}*T-(P2{ncam});%FALTA SOLUCIONAR


%Encuentro los puntos 3D centros de las camaras proyectados en la retina
%ncam

%proyecto los C1
x1=P1{ncam}*C1;
x1=homog_norm(x1);
%proyecto los C2
x2=P2{ncam}*C2;
x2=homog_norm(x2);

%modifico el origen en el plano de retina que se utiliza para escribir los x2 para que coincida con el origen
%de las coordenadas en que fueron escritos los x1
resolution=str2num(cam_seg{i}.Attributes.resolution);
x1(1,:)=x1(1,:)-0.5;
x1(2,:)=-x1(2,:)+resolution(2)+0.5;



%Comparo ambas coordenadas
diferencia=x1-x2

 plot(x1(1,:), x1(2,:), '*'), hold on, plot(x2(1,:), x2(2,:), 'ro')
 str=['Comparación centros de camaras proyectados sobre camara ', num2str(ncam), '.']
 title(str)
 legend('calibracion punto luminoso', 'calibracion ground truth')




ncam