%AUN SE ESTA COMPLETANDO

% Main donde se construyen las matrices de proyeccion y las fundamentales a partir de
% los datos en Blender. Construye la estructura de datos y las deja en el
% workspace!
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
guardar=1;%para guardar las estructuras generadas pongo 1 
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

%% Estructura skeleton
%       name_bvh ----> nombre del .bvh asociado a skeleton
%       frame -----> estructura frame
%                   marker -->estructura marker 
%                           coord ------->Coordenadas euclidianas del marcador 
%                           name  ------->Nombre del marcador
%                           estado ------>con alguna metrica indica el estado del marcador
%                           source_cam -->conjunto de camaras que reconstruye el marcador
%                   time -------->tiempo de frame en segundos
%                   num_marker -->nro de marcadores en el frame
%       trajectory --> estructura trajectory
%                   name -----> nombre de la trayectoria
%                   members --> secuencia de nombres asociados a la trayectoria
%                   estado ---> con alguna metrica indica la calidad de la trayectoria

skeleton.name_bvh = name_bvh;
%genero la estructura frame
for k=1:n_frames %hacer para cada frame
        %inicializo los campos de la estructura frame(k)
        frame(k).marker = [];
        frame(k).n_markers = n_marcadores;
        frame(k).time = time(k);         
        for j=1:n_marcadores %hacer para cada marcador 
            frame(k).marker(j).coord = skeleton_old(j).t_xyz(:,k);
            frame(k).marker(j).name = skeleton_old(j).name;
            frame(k).marker(j).estado = 0;% 0 indica que el dato es posta y 1 la más baja calidad
            frame(k).marker(j).source_cam = nan;%en nuestro caso es ground truth
        end
end
skeleton.frame = frame;
skeleton.n_frames = n_frames;
skeleton.name = 'skeleton';

if guardar==1    
    save('saved_vars/skeleton','skeleton');
end


%% Estructura camara
%       frame --------> estructura frame
%                   marker -->estructura marker 
%                           coord ------->Coordenadas euclidianas del marcador 
%                           name  ------->Nombre del marcador
%                           estado ------>con alguna metrica indica el estado del marcador
%                           source_cam -->conjunto de camaras que reconstruye el marcador
%                   time -------->tiempo de frame en segundos
%                   num_marker -->nro de marcadores en el frame
%       trajectory --> estructura trajectory
%                   name -----> nombre de la trayectoria
%                   members --> secuencia de nombres asociados a la trayectoria
%                   estado ---> con alguna metrica indica la calidad de la trayectoria
%       info -------> estructura Info
%                   Rc ------------>matriz de rotación 
%                   Tc ------------>vector de traslación
%                   f ------------->distancia focal en metros
%                   resolution ---->=[resolución_x, resolution_y] unidades en pixeles
%                   t_vista ------->tipo de vista utilizada en la camara (PERSPECTIVA, ORTOGRAFICA, PANORAMICA)
%                   shift --------->[shift_x, shidt_y] corrimiento del centro de la camara en pixeles
%                   sensor -------->[sensor_x, sensor_y] largo y ancho del sensor en milimetros
%                   sensor_fit ---->tipo de ajuste utilizado para el sensor (AUTO, HORIZONTAL, VERTICAL)
%                   pixel_aspect -->(pixel_aspect_x)/(pixel_aspect_y) valor 1 indica pixel cuadrado
%                   Pcam ---------->matrix de proyección de la camara


for i=1:length(f) %hacer para todas las camaras
    
    %genero la estructura info para la camara
    info.Rc = Rq(:,:,i)';%matriz de rotación calculada a partir de cuaterniones
    info.Tc = [T(1,i), T(2,i), T(3,i)];
    info.f = f(i);
    info.resolution = resolution(:,i);
    info.t_vista = t_vista(i);
    info.shift = [shift_x(i), shift_y(i)];
    info.sensor = sensor(:,i);
    info.sensor_fit = sensor_fit(i);
    info.pixel_aspect = pixel_aspect_x/pixel_aspect_y;
    info.Pcam = MatrixProyection(info.f, info.resolution, info.sensor, info.sensor_fit, info.Tc, info.Rc);% matriz de rotacion asociada a la cámara;
        
    
    %genero la estructura frame para la camara
    for k=1:n_frames %hacer para cada frame
        %inicializo los campos de la estructura frame(k)
        frame(k).marker = [];
        frame(k).num_marker = n_marcadores;
        frame(k).time = time(k);         
        for j=1:n_marcadores %hacer para cada marcador 
            X = frames_marker(j, 0); %frame_marker(nro_marker, n_cam, frames) devuelve una matriz cuyas filas son coordenadas y las
            % columnas son los frames del vector "frames" asociados al marcador
            % "nro_marker" de la camara "n_cam"
            frame(k).marker(j).coord =obtain_coord_retina(X, info.Pcam);%Guardo la matriz de coordenadas homogeneas x=P*X , del marcador j en la camara i 
            frame(k).marker(j).name = nan;
            frame(k).marker(j).estado = 0;% 0 indica que el dato es posta y 1 la más baja calidad
            frame(k).marker(j).source_cam = nan;%en nuestro caso es ground truth
        end
    end
    
    
    
    
    cam(i).frame = frame;
    cam(i).info = info;
    
end
     


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