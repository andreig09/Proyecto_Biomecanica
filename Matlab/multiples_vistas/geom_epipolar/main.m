% Construye la estructura de datos y las deja en el
% workspace!
clear all
close all
clc

%% Cargo secuencia 

%name_bvh = 'pelotita.bvh';
%name_bvh = 'Mannequin.bvh';
%name_bvh ='Marcador_en_origen.bvh';
name_bvh ='Mannaquin_con_Armadura_menos_pelotitas.bvh';

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

markers_name=cell(1, n_markers); %esta variable se debe rellenar con los nombres de los marcadores que se van a utilizar
for j=1:n_markers
    if   strcmp(skeleton_old(j).name,  ' ') %se tiene un nombre en blanco
            str = sprintf('%d', j); %se genera un string con el numero de marcador
            markers_name{j} = str;
    else
        markers_name{j} = skeleton_old(j).name;
    end
end
[cam, skeleton]= init_structs(n_markers, n_frames, markers_name); %para visualizar la forma de la estructura de datos ingresar a esta funcion

%% Relleno la estructura skeleton con la info del name_bvh

%skeleton.name = 'skeleton';
skeleton = set_info(skeleton, 'name', 'skeleton_ground_truth');
%skeleton.name_bvh = name_bvh;
skeleton = set_info(skeleton, 'name_bvh', name_bvh);
%skeleton.n_frames = n_frames;
skeleton = set_info(skeleton, 'n_frames', n_frames);
%skeleton.frame_rate = time(2);
skeleton = set_info(skeleton, 'frame_rate', time(2));

for k=1:skeleton.n_frames %hacer para cada frame de skeleton 
    %skeleton.frame(k).n_markers = n_marcadores;
    skeleton = set_info(skeleton, 'frame', k, 'n_markers', n_marcadores);
    %skeleton.frame(k).time = time(k);    
    skeleton = set_info(skeleton, 'frame', k, 'time', time(k));    
    skeleton = set_info(skeleton, 'frame', k, 'mapping_table', -1); %setea con un valor que invalida la tabla de mapeo
    skeleton = set_info(skeleton, 'frame', k, 'like_cams', -1); %setea con un valor que invalida el vector like_cams
    skeleton = set_info(skeleton, 'frame', k, 'd_min', -1); %setea con un valor que invalida la matriz d_min 
    for j=1:n_marcadores %hacer para cada marcador 
        %skeleton.frame(k).marker(j).coord = skeleton_old(j).t_xyz(:,k);
        skeleton = set_info(skeleton,'frame', k, 'marker', j, 'coord', skeleton_old(j).t_xyz(:,k));        
        %skeleton.frame(k).marker(j).name = skeleton_old(j).name;
        name = skeleton_old(j).name;
        if   strcmp(name,  ' ') %se tiene un nombre en blanco
            str = sprintf('%d', j); %se genera un string con el numero de marcador
            skeleton = set_info(skeleton,'frame', k, 'marker', [j], 'name', {str});
        else %name contiene un nombre distinto de un espacio en blanco
            skeleton = set_info(skeleton,'frame', k, 'marker', [j], 'name', {name});        
        end
        skeleton.frame(k).marker(j).state = 0;% 0 indica que el dato es posta y 1 la más baja calidad
        skeleton = set_info(skeleton, 'frame', k, 'marker', [j],  'state', 0);% 0 indica que el dato es posta y 1 la más baja calidad
skeleton.frame(k).marker(j).source_cam = -1;%en nuestro caso es ground truth
    end
end





%% Relleno la estructura cam con la info del name_bvh

n_cams = size(cam, 2);
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

% for i=1:n_cams %hacer para todas las camaras  
%     
%     for k=1:cam(i).n_frames %hacer para cada frame
%         %cam(i).frame(k).like.like_cams = [1:n_cams];%genero un vector con los nombres de cada camara       
%         for ii=1:n_cams
%             if i~=ii %si las camaras son distintas
%                 [~, ~, index_table, d_min] = cam2cam(cam(i), cam(ii), k, 'show');%devuelve todos los puntos de cam(i) del frame n_frame con indice en index_xi y sus correspondientes contrapartes xd de cam(ii)
%                 cam(i).frame(k).like.mapping_table(:,ii) = index_table(:,2); %me quedo solo con los correspondientes en cam(ii)
%                 cam(i).frame(k).like.d_min(:,ii) = d_min; 
%             else %si las camaras son la misma
%                 cam(i).frame(k).like.mapping_table(:,ii) = [1:n_markers]';%cada marcador se corresponde consigo mismo
%                 cam(i).frame(k).like.d_min(:,ii) = zeros(n_markers, 1);
%             end
%         end
%     end
%     
%     str=sprintf('Se cargo por completo la tabla de mapeo de la camara %d', i);
%     disp(str)
% end







%% Remuevo los marcadores que no uso


markers_work = {'LeftFoot' 'LeftLeg' 'LeftUpLeg' 'RightFoot' 'RightLeg' 'RightUpLeg'...
    'RightShoulder' 'LHand' 'LeftForeArm' 'LeftArm' 'RHand' 'RightForeArm' 'RightArm'};%cell array con los marcadores que se van a usar

%obtengo un cell array con los nombres de los marcadores a suprimir 
n_work = length(markers_work);
index = ones(1, n_work);
remove_name = cell(1, (n_markers - n_work));
i=1;
for k=1:n_markers %hacer para todos los  marcadores
    aux = strcmp(markers_name(k), markers_work);%markers_name es un cell array con los nombres de todos los marcadores    
    if sum(aux)==0%si no existe coincidencia quiere decir que no se va a trabajar con ese punto por lo tanto se debe remover
        remove_name(i)=markers_name(k);
        i=i+1;%este indice unicamente sirve para llevar la cuenta de los marcadores a remover
    end    
end
frame = 1:n_frames;

%remuevo los marcadores listados en remove_name
skeleton = remove_markers(skeleton, frame, remove_name);
disp('Se removieron los marcadores inutiles de la estructura skeleton')
for i=1:n_cams %hacer para todas las camaras
    cam(i)=remove_markers(cam(i), frame, remove_name);
    str = sprintf('Se removieron los marcadores inutiles de la estructura cam%d', i);
    disp(str)
end



%% Guardo y Limpio variables 
if guardar==1    
    save('saved_vars/skeleton13_ground_truth','skeleton');
    save('saved_vars/cam13_ground_truth','cam');    
end

clearvars -except cam n_cams n_markers n_frames name_bvh skeleton F
disp('Variables cargadas en Workspace ;)')
