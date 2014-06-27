% Main donde se construyen las matrices de proyeccion y las fundamentales a partir de
% los datos en Blender. Deja solo variables importantes en el workspace!
clear all
close all
clc

%% Cargo secuencia 
%name_bvh = 'pelotita.bvh';
name_bvh = 'Mannequin.bvh';
%name_bvh ='Marcador_en_origen.bvh';
[skeleton_old, n_marcadores, n_frames, time] = load3D(name_bvh);
%descomentar la siguiente linea si se quiere ver la secuencia 3D
%plotear(skeleton, eye(3)) 

%% Cargo Parametros de las camaras

InfoCamBlender %este archivo .m fue generado con Python desde Blender y contienen todos los parametros de interes

%Verifico hipotesis de trabajo
if (pixel_aspect_x ~= pixel_aspect_y)|any(shift_x ~= shift_y)
   disp('Se asumen dos cosas en los calculos que siguen:')
   disp('                1) que la variable de Blender,  Properties/ObjectData/Lens/Shift, indicado por los')
   disp('                     parametros (X, Y) es (0, 0)')
   disp('                2) que la variable relacion de forma en Properties/Render/Dimensions/Aspect Radio de cada camara, indicado por') 
   disp('                    los parametros (X, Y) sea (z, z) con z cualquiera')
   disp('Hay que corregir alguno de estos parametros para proseguir.')
   break
end


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

% q=quaternion(q); %transformo en tipo de dato cuaternion
% R=RotationMatrix(q);%Obtengo las matrices de rotación a partir de los cuaterniones. R(:,:,i) es la matriz de rotación de la camara i

for i=1:length(f) %hacer para todas las camaras
    cam(i).Rq = R(:,:,i)';%calculo con cuaterniones 
    cam(i).Rc = rotacion(angles(1,i), angles(2,i), angles(3,i));    
    cam(i).Tc = [T(1,i), T(2,i), T(3,i)];
    cam(i).f = f(i);
    cam(i).resolution = resolution(:,i);
    %cam(i).N = resolution(2,i);
    cam(i).name_bvh = name_bvh;
    cam(i).Pcam = MatrixProyection(f(i), resolution(:,i), sensor(:,i), sensor_fit(i), cam(i).Tc, cam(i).Rc);% matriz de rotacion asociada a la cámara, se asume rotación XYZ
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
% i=2; %elegir la camara de entrada
% j=4; %elegir la camara de salida
% F= F_from_P(cam(i).Pcam, cam(j).Pcam);


%% Guardo y Limpio variables 
guardar=0;
if guardar==1
    save('Variables_save/cam','cam');
    save('Variables_save/skeleton','skeleton');
    save('Variables_save/marker3D','marker3D');
    save('Variables_save/frame3D','frame3D');
end
clearvars -except cam n_marcadores n_frames name_bvh skeleton F
disp('Variables cargadas en Workspace ;)')

