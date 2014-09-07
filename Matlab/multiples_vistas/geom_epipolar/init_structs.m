function [cam, skeleton]=init_structs(n_markers, n_frames, names)
%Funcion que inicializa las estructuras a utilizar

%% ENTRADA
%n_markers -->numero de marcadores inicializados que se desea tener en las estructuras
%n_frames -->numero de frames inicializados que se desea tener en las estructuras
%names   -->cell array de strings con los nombres de los marcadores que se tengan en el primer frame

%% SALIDA
%cam --> estructura que contiene la informacion de todas las camaras
%skeleton -->estructura que contiene la informacion 3D del esqueleto

%% ---------
% Author: M.R.
% created the 12/08/2014.

%% Cargo Parametros de las camaras

InfoCamBlender %este archivo .m fue generado con Python desde Blender y contienen todos los parametros de las camaras de interes

%Verifico hipotesis de trabajo
if (pixel_aspect_x ~= pixel_aspect_y)||any(shift_x ~= shift_y)
   disp('Se asumen dos cosas en los calculos que siguen:')
   disp('                1) que la variable de Blender,  Properties/ObjectData/Lens/Shift, indicado por los')
   disp('                     parametros (X, Y) es (0, 0)')
   disp('                2) que la variable relacion de forma en Properties/Render/Dimensions/Aspect Radio de cada camara, indicado por') 
   disp('                    los parametros (X, Y) sea (z, z) con z cualquiera')
   disp('Hay que corregir alguno de estos parametros para proseguir.')
   return
end


%% Generacion e inicializacion de estructuras (se reserva memoria)
    
marker = struct(...
    'coord',        zeros(3, 1), ...%Coordenadas euclidianas del marcador 
    'name',         blanks(15), ...%Nombre del marcador
    'state',       0.0, ...%con alguna metrica indica el estado del marcador
    'source_cam',   zeros(n_cams, 1) ...%conjunto de camaras que reconstruye el marcador    
    );

like = struct(...
    'like_cams',        1: n_cams,... %vector con los numeros asociados a cada camara sobre las que se proyecta 
    'mapping_table',    ones(n_markers, n_cams),... %tabla de mapeo. Matriz cuyas filas son indices de marcadores que se corresponden en otras camaras,
                                                ... % y las columnas son camaras cuyo nombre se encuentra en la columna correspondiente de like_cams 
    'd_min',         ones(n_markers, n_cams)... %matriz que contiene una medida de calidad para cada dato coorespondiente en mapping_table
    );

frame = struct(...
    'marker',       repmat(marker, 1, n_markers), ...%genero un numero n_markers de estructuras marker
    'like',         repmat(like, 1, 1),...%genero una estructura like dentro de marker
    'time',         0.0, ...%tiempo de frame en segundos
    'n_markers',    n_markers ...%nro de marcadores en el frame    
    );

path = struct(...
    'name',         blanks(15), ...%nombre de la trayectoria
    'members',      zeros(2, n_frames), ...%secuencia de nombres asociados a la trayectoria
    'state',        0.0, ...%con alguna metrica indica la calidad de la trayectoria
    'n_markers',    n_frames, ...%numero total de marcadores en la trayectoria
    'init_frame',   1,... %frame inicial de la trayectoria
    'end_frame',    1 ...%frame final de la trayectoria
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
    'projection_matrix',              zeros(3, 4) ...%matrix de proyección de la camara
    );


skeleton = struct(...
    'name',         blanks(15), ...%nombre del esqueleto    
    'name_bvh',     blanks(15), ... %nombre del .bvh asociado a skeleton
    'frame',        repmat(frame, 1, n_frames), ...%genero un numero n_frames de estructuras frame
    'path',         repmat(path, 1, n_markers), ...%genero una estructura path por marcador
    'n_frames',     n_frames, ...%numero de frames totales
    'n_paths',      n_markers, ...%numero de trayectorias totales
    'n_cams',       n_cams, ... %numero de camras que estan filmando a skeleton 
    'frame_rate',   -1 ... %indica el tiempo entre cada frame    
    );
    
cam = struct(...
    'name',         NaN, ...%numero de la camara
    'info',         info, ...
    'frame',        repmat(frame, 1, n_frames), ...%genero un numero n_frames de estructuras frame
    'path',         repmat(path, 1, n_markers), ...%genero una estructura path por marcador
    'n_frames',     n_frames, ...%numero de frames totales
    'n_paths',      n_markers, ...%numero de trayectorias totales
    'frame_rate',   -1 ... %indica el tiempo entre cada frame    
    );
cam = repmat(cam, 1, n_cams);  %genero un numero n_cams de camaras

%% Se agrega la info de las camaras contenida en InfoCamBlender.m

    for i=1:n_cams %hacer para todas las camaras 
        cam(i).name = i;
        cam(i).n_frames = n_frames;        
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
        cam(i).info.projection_matrix = MatrixProjection(cam(i).info.f, cam(i).info.resolution, ...
                                        cam(i).info.sensor, cam(i).info.sensor_fit{1}, cam(i).info.Tc, cam(i).info.Rc);% matriz de rotacion asociada a la camara; 
    end
%% se ingresan los nombres de marcadores en 'name' a la estructura path en el frame 1 tanto en skeleton como en las camaras

for k = 1:length(names)%para todos los nombres contenidos en 'name'
    skeleton = set_info(skeleton, 'path', k, 'name', names{k}); % setea el nombre asociado a la trayectoria k
    for i=1:n_cams %hacer para todas las camaras
        cam(i) = set_info(cam(i), 'path', k, 'name', names{k}); % setea el nombre asociado a la trayectoria k        
    end
end

end

