% Main donde se construyen las matrices de proyeccion y las fundamentales a partir de
% los datos en Blender. Deja solo variables importantes en el workspace!


clear all
close all
clc
%% Cargo secuencia 
%name_bvh = 'pelotita.bvh';
name_bvh = 'Mannequin.bvh';
[skeleton_old, n_marcadores, n_frames, time] = load3D(name_bvh);
%descomentar la siguiente linea si se quiere ver la secuencia 3D
%plotear(skeleton, eye(3)) 

%% Parametros de las camaras
%Se asumen dos cosas en los calculos que siguen:
%                   1) que la variable de Blender,  Properties/Object Data/Lens/Shift, indicado por los
%                       parametros (X, Y) es (0, 0)
%                   2) que la variable relacion de forma en Properties/Render/Dimensions/Aspect Radio, indicado por 
%                       los parametros (X, Y) es (1, 1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%dist. focal en mm
%        cam1        cam2       cam3        cam4        cam5
f =      [40         50         50          50          50     ];
% resolucion horizontal en pixeles
M =      [800        800        800         800         800    ];
% resolucion vertical en pixeles
N =      [300        300        300         300         300    ];
sensor = [32         32         32          32          32     ]; 
% posicion xyz del centro de las camaras, todas las medidas son en metros
c_x =    [0.2353001  7.5        7.5        -7.5        -7.5   ];
c_y =    [-2.5       2.5       -7.5        -7.5         2.5    ];
c_z =    [8          1.2        1.2         1.2         1.2    ];
% angulos de rotacion cam1 en grados
c_th_x = [180        267.067    267.067     267.067     267.067];
c_th_y = [180        180.439    180.439     180.439     180.439];
c_th_z = [-90       -57.198     121.198    -237.198    -301.198];

% rotacion a partir de cuaternion
q1=[-0.707, -0.000001, 0.000, -0.707];
q1=quaternion(q1); %convierto el vector a cuaternion
q2=[-0.345, -0.332, -0.603, -0.638];
q2=quaternion(q2); %convierto el vector a cuaternion
q3=[0.630, 0.601, 0.336, 0.358];
q3=quaternion(q3); %convierto el vector a cuaternion
q4=[0.638, 0.603, -0.332, -0.345];
q4=quaternion(q4); %convierto el vector a cuaternion
q5=[0.358, 0.336, -0.601, -0.630];
q5=quaternion(q5); %convierto el vector a cuaternion





% f = 40;     %dist. focal en mm
% M = 800;    % resolucion horizontal en pixeles
% N = 300;    % resolucion vertical en pixeles
% sensor = 32;    % tama�o en mm del sensor (se considera el lado mas largo, en este caso el horizontal)
% % posicion xyz camara 1, todas las medidas son en metros
% c_x = 0.2353001;
% c_y = -2.5;
% c_z = 8;
% % angulos de rotacion cam1 en grados
% c_th_x = 180;
% c_th_y = 180;
% c_th_z = -90;
% % rotacion a partir de cuaternion
% q1=[-0.707, -0.000001, 0.000, -0.707];
% q1=quaternion(q1); %convierto el vector a cuaternion
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %CAMARA2 (toma posterior izquierda)
% f = [f, 50];     %dist. focal en mm
% M = [M, 800];    % resolucion horizontal en pixeles
% N = [N, 300];    % resolucion vertical en pixeles
% sensor= [sensor, 32]; % tama�o en mm del sensor (se considera el lado mas largo, en este caso el horizontal)
% % posicion xyz camara 2, todas las medidas son en metros
% c_x = [c_x, 7.5];
% c_y = [c_y, 2.5];
% c_z = [c_z, 1.2];
% % angulos de rotacion cam2 en grados
% c_th_x = [c_th_x, 267.067];
% c_th_y = [c_th_y, 180.439];
% c_th_z = [c_th_z, -57.198];
% % rotación a partir de cuaternion
% q2=[-0.345, -0.332, -0.603, -0.638];
% q2=quaternion(q2); %convierto el vector a cuaternion
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %CAMARA3 (toma delantera izquierda)
% f = [f, 50];     %dist. focal en mm
% M = [M, 800];    % resolución horizontal en píxeles
% N = [N,300];    % resolución vertical en píxeles
% sensor= [sensor, 32]; % tamaño en mm del sensor (se considera el lado más largo, en este caso el horizontal)
% % posición xyz cámara 3, todas las medidas son en metros
% c_x = [c_x, 7.5];
% c_y = [c_y, -7.5];
% c_z = [c_z, 1.2];
% % angulos de rotacion cam3 en grados
% c_th_x = [c_th_x, 267.067];
% c_th_y = [c_th_y, 180.439];
% c_th_z = [c_th_z, -121.198];
% % rotación a partir de cuaternion
% q3=[0.630, 0.601, 0.336, 0.358];
% q3=quaternion(q3); %convierto el vector a cuaternion
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %CAMARA4 (toma  delantera derecha)
% f = [f, 50];     %dist. focal en mm
% M = [M, 800];    % resolución horizontal en píxeles
% N = [N, 300];    % resolución vertical en píxeles
% sensor= [sensor, 32]; % tamaño en mm del sensor (se considera el lado más largo, en este caso el horizontal)
% % posición xyz cámara 4, todas las medidas son en metros
% c_x = [c_x, -7.5];
% c_y = [c_y, -7.5];
% c_z = [c_z, 1.2];
% % angulos de rotacion cam4 en grados
% c_th_x = [c_th_x, 267.067];
% c_th_y = [c_th_y, 180.439];
% c_th_z = [c_th_z, -237.198];
% % rotación a partir de cuaternion
% q4=[0.638, 0.603, -0.332, -0.345];
% q4=quaternion(q4); %convierto el vector a cuaternion
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %CAMARA5 (toma posterior derecha)
% f = [f, 50];     %dist. focal en mm
% M = [M, 800];    % resolución horizontal en píxeles
% N = [N, 300];    % resolución vertical en píxeles
% sensor= [sensor, 32]; % tamaño en mm del sensor (se considera el lado más largo, en este caso el horizontal)
% % posición xyz cámara 5, todas las medidas son en metros
% c_x = [c_x,  -7.5];
% c_y = [c_y, 2.5];
% c_z = [c_z, 1.2];
% % angulos de rotacion cam5 en grados
% c_th_x = [c_th_x, 267.067];
% c_th_y = [c_th_y, 180.439];
% c_th_z = [c_th_z, -301.198];
% % rotación a partir de cuaternion
% q5=[0.358, 0.336, -0.601, -0.630];
% q5=quaternion(q5); %convierto el vector a cuaternion



%% Estructura marcador 3D
%       X -->Matriz cuyas filas son coordenadas 3D y las columnas son frames 
%       time -->Matriz con los tiempos de cada frame
%       name -->Nombre del marcador
%       n -->nro de marcador

for j=1:n_marcadores %hacer para todos los marcadores
     marker3D(j).X=skeleton_old(j).t_xyz;
     marker3D(j).time= time;
     marker3D(j).name= skeleton_old(j).name;
     marker3D(j).n = j;
end
%NOTACION
%       marker3D(j).X(:, k)   --->para acceder a las coordenadas del marcador j en el frame k 

%% Estructura frame3D
%       X -->Matriz cuyas filas son coordenadas 3D y las columnas son nro de marcador 
%       time -->tiempo de frame
%       name -->Array de strings con nombre del marcador de cada columna de X
%       n -->vector fila que contiene el nro asociado a cada marcador de la columna de X


for k=1:n_frames %hacer para cada frame
        %inicializo los campos de la estructura frame(k)
        frame3D(k).X = [];
        frame3D(k).name = {}; % los nombres los guardo en un array de string, no problem se accede de la misma manera que un vector.
        frame3D(k).n = [];
        frame3D(k).time = time*k;         
        for j=1:n_marcadores %hacer para cada marcador 
            frame3D(k).X = [frame3D(k).X, marker3D(j).X(:,k)]; % las columnas de frame(k).X son nro de marcador
            frame3D(k).name= [frame3D(k).name, marker3D(j).name]; 
            frame3D(k).n = [frame3D(k).n, j];
        end
end
     %NOTACION: 
    %        skeleton.frame(k).x(:, j)  para acceder a las coordenadas del marcador j en el frame k de la camara i
    %        skeleton.frame(k).name(j)  para acceder al nombre del marcador j en el frame k de la camara i

%% Estructura skeleton
%       marker -->estructura marker3D
%       frame --> estructura frame3D
%       name_bvh -->nombre del .bvh de origen

skeleton.marker = marker3D;
skeleton.frame = frame3D;
skeleton.name_bvh = name_bvh;
%ACLARACION: las estructuras 'marker' y 'frame' son dos enfoques distintos de ordenar la misma información, la idea es utilizar lo
    %conveniente en cada caso.
    %NOTACION: 
    %        skeleton.marker(j).x(:, k) para acceder a las coordenadas del marcador j en el frame k de la camara i.
    %        skeleton.frame(k).x(:, j)  para acceder a las coordenadas del marcador j en el frame k de la camara i
    %        skeleton.frame(k).name(j)  para acceder al nombre del marcador j en el frame k de la camara i

    
    
%% Estructura camara
%   para cada cámara contiene:
%     Rc -->matriz de rotación 
%     Tc -->vector de traslación
%     f ---->distancia focal en metros
%     M --->resolución horizontal en pixeles
%     name.bvh -->nombre del .bvh de origen
%     N --->resolución vertical en pixeles
%     Pcam -->matriz de proyección de la camara
%     marker -->estructura de datos de los marcadores en dicha camara, similar a marker3D
%     frame --> estructura de datps de los marcadores en dicha camara, similar a frame3D  

q=[q1;q2;q3;q4;q5]; %agrupo todos los cuaterniones
R=RotationMatrix(q);%Obtengo las matrices de rotación a partir de los cuaterniones. R(:,:,i) es la matriz de rotación de la camara i

for i=1:length(f) %hacer para todas las camaras
    %cam(i).Rc = R(:,:,i)';%calculo con cuaterniones TENGO QUE VER PORQUE DEBO HACER LA INVERSA
    cam(i).Rc = rotacion(c_th_x(i), c_th_y(i), c_th_z(i));    
    cam(i).Tc = [c_x(i), c_y(i), c_z(i)];
    cam(i).f = f(i);
    cam(i).M = M(i);
    cam(i).N = N(i);
    cam(i).name_bvh = name_bvh;
    cam(i).Pcam = MatrixProyection(f(i), M(i), N(i), sensor(i), cam(i).Tc, cam(i).Rc);% matriz de rotacion asociada a la cámara, se asume rotación XYZ
    for j=1:n_marcadores %hacer para cada marcador 
        %X=skeleton(j).t_xyz;% Obtengo la matriz del marcador j, cuyas filas son coordenadas 3D y columnas sucesivos frames
        X=marker3D(j).X;% Obtengo la matriz del marcador j, cuyas filas son coordenadas 3D y columnas sucesivas frames
        cam(i).marker(j).x=proyectar_X(X, cam(i).Pcam);%Guardo la matriz de coordenadas homogeneas x=P*X , del marcador j en la camara i        
        cam(i).marker(j).time= marker3D(j).time;
        cam(i).marker(j).name= marker3D(j).name;
        cam(i).marker(j).n= j;
    end    
    for k=1:n_frames %hacer para cada frame
        %inicializo los campos de la estructura cam(i).frame(k)
        cam(i).frame(k).x = [];
        cam(i).frame(k).name = {}; % los nombres los guardo en un array de string, no problem se accede de la misma manera que un vector.
        cam(i).frame(k).n = [];
        cam(i).frame(k).time = time*k;         
        for j=1:n_marcadores %hacer para cada marcador 
            cam(i).frame(k).x = [cam(i).frame(k).x, cam(i).marker(j).x(:,k)]; %las columnas de cam(i).frame(k).x son nro de marcador
            cam(i).frame(k).name= [cam(i).frame(k).name, cam(i).marker(j).name]; 
            cam(i).frame(k).n = [cam(i).frame(k).n, j];
        end
    end
    %ACLARACION: las estructuras 'marker' y 'frame' son dos enfoques distintos de ordenar la misma información, la idea es utilizar lo
    %conveniente en cada caso.
    %NOTACION: 
    %        cam(i).marker(j).x(:, k) para acceder a las coordenadas del marcador j en el frame k de la camara i.
    %        cam(i).frame(k).x(:, j)  para acceder a las coordenadas del marcador j en el frame k de la camara i
    %        cam(i).frame(k).name(j)  para acceder al nombre del marcador j en el frame k de la camara i
    
end
%     %Lo siguiente es para comparar matrices calculadas por cuaterniones y
%     %por rotaciones
%     disp('________________________________________________________')
%     cam(i).Rc
%     R(:,:,i)
%     disp('________________________________________________________')
%     disp('________________________________________________________')
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

     


%% Matrices fundamentales
%  matriz fundamental que mapea un punto de camara i en recta de camara j
i=2; %elegir la camara de entrada
j=4; %elegir la camara de salida
F= F_from_P(cam(i).Pcam, cam(j).Pcam);


%% Guardo y Limpio variables 
save('Variables_save/cam','cam');
save('Variables_save/skeleton','skeleton');
save('Variables_save/marker3D','marker3D');
save('Variables_save/frame3D','frame3D');
clearvars -except cam n_marcadores n_frames name_bvh skeleton F
disp('Variables cargadas en Workspace ;)')

