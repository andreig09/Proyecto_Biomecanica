% version 4.1

% funcion que lee imagenes tomadas del objeto de calibracion para cada una 
% de las cámaras y devuelve la matriz de proyección correspondiente a cada
% cámara. La matriz de proyección P relaciona un punto M en el espacio 3D
% con su correspondiente proyeccion m 2D en la cámara tal que m = P*M.

% http://www.daesik80.com/matlabfns/function/CalibNormDLT.m



function [P1,P2] = calibracion(img, calibrador)







imshow(img)
[x_cam1, y_cam1] = ginput(8);





calibrador = calibrador./100;

X = calibrador(:,1)';
Y = calibrador(:,2)';
Z = calibrador(:,3)';


% normalizacion de puntos: se pasa el origen de coordenadas al centroide de
% los puntos y se impone que la distancia media al origen sea igual a sqrt(2)

%% normalizo los valores de la imagen de la camara 1


centroide_cam1x = mean(x_cam1);
x_cam1 = x_cam1 - centroide_cam1x;

centroide_cam1y = mean(y_cam1);
y_cam1 = y_cam1 - centroide_cam1y;

dist_media_cam1 = mean(sqrt(x_cam1.^2 + y_cam1.^2));

escala_cam1 = sqrt(2)/dist_media_cam1;

x_cam1 = x_cam1 * escala_cam1;
y_cam1 = y_cam1 * escala_cam1;

T1 = [ escala_cam1,     0,        - escala_cam1*centroide_cam1x;
           0,        escala_cam1, - escala_cam1*centroide_cam1y;
           0,           0,                       1];

  

       
%% normalizo los puntos 3D del objeto de calibracion

centroide3D = mean([X;Y;Z]')';
X = X - centroide3D(1);
Y = Y - centroide3D(2);
Z = Z - centroide3D(3);

dist_media_3D = mean(sqrt(X.^2 + Y.^2 + Z.^2));

escala_3D = sqrt(2)/dist_media_3D;

X = X * escala_3D;
Y = Y * escala_3D;
Z = Z * escala_3D;

T3D = [ escala_3D,  0,  0,  -escala_3D*centroide3D(1);
        0,  escala_3D,  0,  -escala_3D*centroide3D(2);
        0,  0,  escala_3D,  -escala_3D*centroide3D(3);
        0,  0,  0,  1
        
    ];


%% obtengo la matriz P1 para la camara 1
X1 = [];
Y1 = [];

P = [X',Y', Z',ones(8,1)];
b = [];

for i=1:8
   
    b = [P(i,:), zeros(1,4), -P(i,:)*x_cam1(i);
        zeros(1,4), P(i,:), -P(i,:)*y_cam1(i)
       
    ];
         
    X1 =  [X1;b];
    %Y1 = [Y1; x_cam1(i); y_cam1(i)];
end
    

%L1 = (X1'*X1)\(X1'*Y1);
    

[U,D,V] = svd(X1);
P1 = reshape(V(:,12),4,3)';
P1 = inv(T1)*P1*T3D;






%% error reproyección

p1 = [];
p2 = [];

for i=1:size(calibrador,1)
    p = P1*[calibrador(i,:)'; 1];
    p1 = [p1,p];
    
  
end

% figura 1
figure(1)

imshow(img)
hold on
plot(p1(1,:)./p1(3,:),p1(2,:)./p1(3,:),'*')
title ('Reproyección')


