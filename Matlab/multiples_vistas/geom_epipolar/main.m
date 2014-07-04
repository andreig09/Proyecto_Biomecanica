% Construye la estructura de datos y las deja en el
% workspace!
clear all
close all
clc

%% Cargo Parametros de las camaras

InfoCamBlender %este archivo .m fue generado con Python desde Blender y contienen todos los parametros de las camaras de interes

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

%% Cargo secuencia 

%name_bvh = 'pelotita.bvh';
name_bvh = 'Mannequin.bvh';
%name_bvh ='Marcador_en_origen.bvh';

[skeleton_old, n_marcadores, n_frames, time] = load3D(name_bvh);%cargo el archivo .bvh


%% Parametros de main

guardar=0;%para guardar las estructuras generadas pongo 1 
graficar = 0; % si se desea ver la estructura skeleton_old
n_markers = n_marcadores; %numero total de marcadores en skeleton
n_frames = n_frames; %numero total de frames a tratar

if graficar == 1
 plotear(skeleton_old, eye(3)) 
end

%% Generacion e inicializacion de estructuras (se reserva memoria)

marker = struct(...
    'coord',        zeros(3, 1), ...%Coordenadas euclidianas del marcador 
    'name',         blanks(15), ...%Nombre del marcador
    'state',       0.0, ...%con alguna metrica indica el estado del marcador
    'source_cam',   zeros(n_cams, 1) ...%conjunto de camaras que reconstruye el marcador
    );


frame = struct(...
    'marker',       repmat(marker, 1, n_markers), ...%genero un numero n_markers de estructuras marker
    'time',         0.0, ...%tiempo de frame en segundos
    'n_markers',    n_markers ...%nro de marcadores en el frame
    );

path = struct(...
    'name',         blanks(15), ...%nombre de la trayectoria
    'members',      zeros(1, n_frames), ...%secuencia de nombres asociados a la trayectoria
    'state',       0.0, ...%con alguna metrica indica la calidad de la trayectoria
    'n_markers',    n_frames ...%numero total de marcadores en la trayectoria
    );

info = struct(...
    'Rc',               zeros(3, 3), ...%matriz de rotación
    'Tc',               zeros(3, 1), ...%vector de traslación
    'f' ,               0.0, ...%distancia focal en metros
    'resolution',       zeros(1, 2), ...%=[resolución_x, resolution_y] unidades en pixeles
    't_vista',          blanks(15), ...%tipo de vista utilizada en la camara (PERSPECTIVA, ORTOGRAFICA, PANORAMICA)
    'shift',            zeros(1, 2), ...%[shift_x, shidt_y] corrimiento del centro de la camara en pixeles
    'sensor',           zeros(1, 2), ...%[sensor_x, sensor_y] largo y ancho del sensor en milimetros
    'sensor_fit',       blanks(15), ...%tipo de ajuste utilizado para el sensor (AUTO, HORIZONTAL, VERTICAL)
    'pixels_aspect',    1, ...%(pixel_aspect_x)/(pixel_aspect_y) valor 1 indica pixel cuadrado
    'Pcam',              zeros(3, 4) ...%matrix de proyección de la camara
    );

skeleton = struct(...
    'name',         blanks(15), ...%nombre del esqueleto    
    'name_bvh',     name_bvh, ... %nombre del .bvh asociado a skeleton
    'frame',        repmat(frame, 1, n_frames), ...%genero un numero n_frames de estructuras frame
    'path',         repmat(path, 1, n_markers), ...%genero una estructura path por marcador
    'n_frames',     n_frames, ...%numero de frames totales
    'n_paths',      n_markers, ...%numero de trayectorias totales
    'n_cams',       n_cams, ... %numero de camras que estan filmando a skeleton 
    'frame_rate',   time(2) ... %indica el tiempo entre cada frame    
    );
    
cam = struct(...
    'name',         NaN, ...%numero de la camara
    'info',         info, ...
    'frame',        repmat(frame, 1, n_frames), ...%genero un numero n_frames de estructuras frame
    'path',         repmat(path, 1, n_markers), ...%genero una estructura path por marcador
    'n_frames',     n_frames, ...%numero de frames totales
    'n_paths',      n_markers, ...%numero de trayectorias totales
    'frame_rate',   time(2) ... %indica el tiempo entre cada frame    
    );
cam = repmat(cam, 1, n_cams);  %genero un numero n_cams de camaras



%% Relleno la estructura skeleton con la info del name_bvh

skeleton.name = 'skeleton';
skeleton.name_bvh = name_bvh;
skeleton.n_frames = n_frames;
skeleton.frame_rate = time(2);

for k=1:skeleton.n_frames %hacer para cada frame de skeleton 
    skeleton.frame(k).n_markers = n_marcadores;
    skeleton.frame(k).time = time(k);    
    for j=1:n_marcadores %hacer para cada marcador 
        skeleton.frame(k).marker(j).coord = skeleton_old(j).t_xyz(:,k);
        skeleton.frame(k).marker(j).name = skeleton_old(j).name;
        skeleton.frame(k).marker(j).state = 0;% 0 indica que el dato es posta y 1 la más baja calidad
        skeleton.frame(k).marker(j).source_cam = -1;%en nuestro caso es ground truth
    end
end


if guardar==1    
    save('saved_vars/skeleton','skeleton');
end

%% Relleno la estructura cam con la info del name_bvh

for i=1:length(cam) %hacer para todas las camaras  
    
    cam(i).name = i;
    cam(i).n_frames = n_frames;
    cam(i).frame_rate = time(2);
    %genero la estructura info para la camara
    cam(i).info.Rc = Rq(:,:,i)';%matriz de rotación calculada a partir de cuaterniones
    cam(i).info.Tc = [T(1,i); T(2,i); T(3,i)];
    cam(i).info.f = f(i);
    cam(i).info.resolution = resolution(:,i);
    cam(i).info.t_vista = t_vista(i);
    cam(i).info.shift = [shift_x(i), shift_y(i)];
    cam(i).info.sensor = sensor(:,i);
    cam(i).info.sensor_fit = sensor_fit(i);
    cam(i).info.pixel_aspect = pixel_aspect_x/pixel_aspect_y;
    cam(i).info.Pcam = MatrixProjection(cam(i).info.f, cam(i).info.resolution, ...
        cam(i).info.sensor, cam(i).info.sensor_fit{1}, cam(i).info.Tc, cam(i).info.Rc);% matriz de rotacion asociada a la cámara; 
    
    %genero la estructura frame para la camara
    for k=1:cam(i).n_frames %hacer para cada frame
        cam(i).frame(k).n_marker = n_marcadores;
        frame(k).time = time(k);     
        X = get_markers_of_frame(k, skeleton); %get_nube_marker(n_frame, structure, list_markers) 
        x = obtain_coord_retina(X, cam(i).info.Pcam);
        for j=1:n_marcadores %hacer para cada marcador             
            cam(i).frame(k).marker(j).coord =x(:, j);%Guardo la matriz de coordenadas homogeneas x=P*X , del marcador j del frame k en la camara i
            cam(i).frame(k).marker(j).name = skeleton.frame(k).marker(j).name;
            cam(i).frame(k).marker(j).state = 0;% 0 indica que el dato es posta y 1 la más baja calidad
            cam(i).frame(k).marker(j).source_cam = -1;%en nuestro caso es ground truth
        end
    end    
end

if guardar==1
    save('saved_vars/cam','cam');    
end
%% Matrices fundamentales
%  matriz fundamental que mapea un punto de camara i en recta de camara j
% i=2; %elegir la camara de entrada
% d=4; %elegir la camara de salida
% Pi = get_Pcam(cam(i));
% Pd = get_Pcam(cam(d));
% F= F_from_P(Pi, Pd);

%% Guardo y Limpio variables 

clearvars -except cam n_cams n_markers n_frames name_bvh skeleton F
disp('Variables cargadas en Workspace ;)')
