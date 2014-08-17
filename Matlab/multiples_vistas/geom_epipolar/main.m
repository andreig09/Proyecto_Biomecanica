% Construye la estructura de datos y las deja en el
% workspace!
clear all
close all
clc




% %% Cargo Parametros de las camaras
% 
% InfoCamBlender %este archivo .m fue generado con Python desde Blender y contienen todos los parametros de las camaras de interes
% 
% %Verifico hipotesis de trabajo
% if (pixel_aspect_x ~= pixel_aspect_y)||any(shift_x ~= shift_y)
%    disp('Se asumen dos cosas en los calculos que siguen:')
%    disp('                1) que la variable de Blender,  Properties/ObjectData/Lens/Shift, indicado por los')
%    disp('                     parametros (X, Y) es (0, 0)')
%    disp('                2) que la variable relacion de forma en Properties/Render/Dimensions/Aspect Radio de cada camara, indicado por') 
%    disp('                    los parametros (X, Y) sea (z, z) con z cualquiera')
%    disp('Hay que corregir alguno de estos parametros para proseguir.')
%    break
% end

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

[cam, skeleton]= init_structs(n_markers, n_frames);

    
% marker = struct(...
%     'coord',        zeros(3, 1), ...%Coordenadas euclidianas del marcador 
%     'name',         blanks(15), ...%Nombre del marcador
%     'state',       0.0, ...%con alguna metrica indica el estado del marcador
%     'source_cam',   zeros(n_cams, 1) ...%conjunto de camaras que reconstruye el marcador    
%     );
% 
% like = struct(...
%     'like_cams',        1: n_cams,... %vector con los numeros asociados a cada camara sobre las que se proyecta 
%     'mapping_table',    ones(n_markers, n_cams),... %tabla de mapeo. Matriz cuyas filas son indices de marcadores que se corresponden en otras camaras,
%                                                 ... % y las columnas son camaras cuyo nombre se encuentra en la columna correspondiente de like_cams 
%     'd_min',         ones(n_markers, n_cams)... %matriz que contiene una medida de calidad para cada dato coorespondiente en mapping_table
%     );
% 
% frame = struct(...
%     'marker',       repmat(marker, 1, n_markers), ...%genero un numero n_markers de estructuras marker
%     'like',         repmat(like, 1, 1),...%genero una estructura like dentro de marker
%     'time',         0.0, ...%tiempo de frame en segundos
%     'n_markers',    n_markers ...%nro de marcadores en el frame    
%     );
% 
% path = struct(...
%     'name',         blanks(15), ...%nombre de la trayectoria
%     'members',      zeros(2, n_frames), ...%secuencia de nombres asociados a la trayectoria
%     'state',        0.0, ...%con alguna metrica indica la calidad de la trayectoria
%     'n_markers',    n_frames, ...%numero total de marcadores en la trayectoria
%     'init_frame',   1,... %frame inicial de la trayectoria
%     'end_frame',    1 ...%frame final de la trayectoria
%     );
% 
% info = struct(...
%     'Rc',               zeros(3, 3), ...%matriz de rotación
%     'Tc',               zeros(3, 1), ...%vector de traslación
%     'f' ,               0.0, ...%distancia focal en metros
%     'resolution',       zeros(1, 2), ...%=[resolución_x, resolution_y] unidades en pixeles
%     't_vista',          blanks(15), ...%tipo de vista utilizada en la camara (PERSPECTIVA, ORTOGRAFICA, PANORAMICA)
%     'shift',            zeros(1, 2), ...%[shift_x, shidt_y] corrimiento del centro de la camara en pixeles
%     'sensor',           zeros(1, 2), ...%[sensor_x, sensor_y] largo y ancho del sensor en milimetros
%     'sensor_fit',       blanks(15), ...%tipo de ajuste utilizado para el sensor (AUTO, HORIZONTAL, VERTICAL)
%     'pixels_aspect',    1, ...%(pixel_aspect_x)/(pixel_aspect_y) valor 1 indica pixel cuadrado
%     'projection_matrix',              zeros(3, 4) ...%matrix de proyección de la camara
%     );
% 
% 
% skeleton = struct(...
%     'name',         blanks(15), ...%nombre del esqueleto    
%     'name_bvh',     name_bvh, ... %nombre del .bvh asociado a skeleton
%     'frame',        repmat(frame, 1, n_frames), ...%genero un numero n_frames de estructuras frame
%     'path',         repmat(path, 1, n_markers), ...%genero una estructura path por marcador
%     'n_frames',     n_frames, ...%numero de frames totales
%     'n_paths',      n_markers, ...%numero de trayectorias totales
%     'n_cams',       n_cams, ... %numero de camras que estan filmando a skeleton 
%     'frame_rate',   time(2) ... %indica el tiempo entre cada frame    
%     );
%     
% cam = struct(...
%     'name',         NaN, ...%numero de la camara
%     'info',         info, ...
%     'frame',        repmat(frame, 1, n_frames), ...%genero un numero n_frames de estructuras frame
%     'path',         repmat(path, 1, n_markers), ...%genero una estructura path por marcador
%     'n_frames',     n_frames, ...%numero de frames totales
%     'n_paths',      n_markers, ...%numero de trayectorias totales
%     'frame_rate',   time(2) ... %indica el tiempo entre cada frame    
%     );
% cam = repmat(cam, 1, n_cams);  %genero un numero n_cams de camaras



%% Relleno la estructura skeleton con la info del name_bvh

%skeleton.name = 'skeleton';
skeleton = set_info(skeleton, 'name', 'ground_truth');
%skeleton.name_bvh = name_bvh;
skeleton = set_info(skeleton, 'name_bvh', name_bvh);
%skeleton.n_frames = n_frames;
skeleton = set_info(skeleton, 'n_frames', n_frames);
skeleton.frame_rate = time(2);
skeleton = set_info(skeleton, 'frame_rate', time(2));

for k=1:skeleton.n_frames %hacer para cada frame de skeleton 
    %skeleton.frame(k).n_markers = n_marcadores;
    skeleton = set_info(skeleton, 'frame', k, 'n_markers', n_marcadores);
    %skeleton.frame(k).time = time(k);    
    skeleton = set_info(skeleton, 'frame', k, 'time', time(k));    
    for j=1:n_marcadores %hacer para cada marcador 
        %skeleton.frame(k).marker(j).coord = skeleton_old(j).t_xyz(:,k);
        skeleton = set_info(skeleton,'frame', k, 'marker', 'coord', skeleton_old(j).t_xyz(:,k));        
        %skeleton.frame(k).marker(j).name = skeleton_old(j).name;
        name = skeleton_old(j).name;
        if   strcmp(name,  ' ') %se tiene un nombre en blanco
            str = sprintf('%d', j); %se genera un string con el numero de marcador
            skeleton = set_info(skeleton,'frame', k, 'marker', [j], 'name', str);
        else %name contiene un nombre distinto de un espacio en blanco
            skeleton = set_info(skeleton,'frame', k, 'marker', [j], 'name', name);        
        end
        skeleton.frame(k).marker(j).state = 0;% 0 indica que el dato es posta y 1 la más baja calidad
        skeleton = set_info(skeleton, 'frame', k, 'marker', 'state', 0);% 0 indica que el dato es posta y 1 la más baja calidad
skeleton.frame(k).marker(j).source_cam = -1;%en nuestro caso es ground truth
    end
end



if guardar==1    
    save('saved_vars/skeleton','skeleton');
end

%% Relleno la estructura cam con la info del name_bvh

for i=1:n_cams %hacer para todas las camaras  
    
%     cam(i).name = i;
%     cam(i).n_frames = n_frames;
%     cam(i).frame_rate = time(2);
%     %genero la estructura info para la camara
%     cam(i).info.Rc = Rq(:,:,i)';%matriz de rotación calculada a partir de cuaterniones
%     cam(i).info.Tc = [T(1,i); T(2,i); T(3,i)];
%     cam(i).info.f = f(i);
%     cam(i).info.resolution = resolution(:,i);
%     cam(i).info.t_vista = t_vista(i);
%     cam(i).info.shift = [shift_x(i), shift_y(i)];
%     cam(i).info.sensor = sensor(:,i);
%     cam(i).info.sensor_fit = sensor_fit(i);
%     cam(i).info.pixel_aspect = pixel_aspect_x/pixel_aspect_y;
%     cam(i).info.projection_matrix = MatrixProjection(cam(i).info.f, cam(i).info.resolution, ...
%         cam(i).info.sensor, cam(i).info.sensor_fit{1}, cam(i).info.Tc, cam(i).info.Rc);% matriz de rotacion asociada a la cámara; 
    
    %genero la estructura frame para la camara
    for k=1:cam(i).n_frames %hacer para cada frame
        cam(i).frame(k).n_markers = n_marcadores;
        cam(i).frame(k).time = time(k);     
        X = get_info(skeleton, 'frame', k, 'marker', 'coord'); %obtengo todas las coordenadas de marcadores de skeleton en el frame k
        x = obtain_coord_retina(X, cam(i).info.projection_matrix);
        for j=1:n_marcadores %hacer para cada marcador             
            cam(i).frame(k).marker(j).coord =x(:, j);%Guardo la matriz de coordenadas homogeneas x=P*X , del marcador j del frame k en la camara i
            cam(i).frame(k).marker(j).name = skeleton.frame(k).marker(j).name;
            cam(i).frame(k).marker(j).state = 0;% 0 indica que el dato es posta y 1 la más baja calidad
            cam(i).frame(k).marker(j).source_cam = -1;%en nuestro caso es ground truth            
        end        
    end    
end
disp('Se han cargado los datos basicos de las estructuras. \nRestan las tablas de mapeo')
%asignaciones que se deben hacer luego de completar todas las camaras

for i=1:n_cams %hacer para todas las camaras  
    
    for k=1:cam(i).n_frames %hacer para cada frame
        %cam(i).frame(k).like.like_cams = [1:n_cams];%genero un vector con los nombres de cada camara       
        for ii=1:n_cams
            if i~=ii %si las camaras son distintas
                [~, ~, index_table, d_min] = cam2cam(cam(i), cam(ii), k, 'show');%devuelve todos los puntos de cam(i) del frame n_frame con indice en index_xi y sus correspondientes contrapartes xd de cam(ii)
                cam(i).frame(k).like.mapping_table(:,ii) = index_table(:,2); %me quedo solo con los correspondientes en cam(ii)
                cam(i).frame(k).like.d_min(:,ii) = d_min; 
            else %si las camaras son la misma
                cam(i).frame(k).like.mapping_table(:,ii) = [1:n_markers]';%cada marcador se corresponde consigo mismo
                cam(i).frame(k).like.d_min(:,ii) = zeros(n_markers, 1);
            end
        end
    end
    
    str=sprintf('Se cargo por completo la tabla de mapeo de la camara %d', i);
    disp(str)
end



if guardar==1
    save('saved_vars/cam','cam');    
end
%% Matrices fundamentales
%  matriz fundamental que mapea un punto de camara i en recta de camara j
% i=2; %elegir la camara de entrada
% d=4; %elegir la camara de salida
% Pi = get_projection_matrix(cam(i));
% Pd = get_projection_matrix(cam(d));
% F= F_from_P(Pi, Pd);

%% Guardo y Limpio variables 

clearvars -except cam n_cams n_markers n_frames name_bvh skeleton F
disp('Variables cargadas en Workspace ;)')
