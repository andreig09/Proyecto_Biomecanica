function Lab=init_structs(n_markers, n_frames, frame_rate, n_cams, path_vid,  varargin)
%Funcion que inicializa las estructuras a utilizar.
%Para cambiar las estructuras de trabajo se debe modificar este archivo,
%el archivo loadBVH.m así como get_info y set_info

%% ENTRADA
%n_markers -->numero de marcadores inicializados que se desea tener en las estructuras
%n_frames -->numero de frames inicializados que se desea tener en las estructuras
%frame_rate -->frames por segundo
%names   -->cell array de strings con los nombres de los marcadores que se tengan en el primer frame
%n_cams -->numero de camaras utilizadas
%path_vid  --> direccion donde se tienen los archivos de video y donde se
%               encuentra InfoCamBlender.m ---->El mismo contiene la información de
%               calibracion necesaria para inicializar la estructura de
%               datos cam
%varargout -->en el caso que se desee solo una estructura cam o skeleton se debe agregar un string 'cam' o 'skeleton' respectivamente
            %Ademas se puede ingresar un string 'blender' que indica que se debe rellenar la camara con la informacion de InfoCamBlender
%% SALIDA
%Lab --> estructura que contiene la informacion de camaras y esqueletos
    %cam --> estructura que contiene la informacion de todas las camaras. Solo se devuelve esta estructura si se agrega el numero de camara como
    %parametro final
    %skeleton -->estructura que contiene la informacion 3D del esqueleto

%% ---------
% Author: M.R.
% created the 12/08/2014.

%% CUERPO DE LA FUNCION

%gestiono la entrada
location_blender = find(strcmp(varargin, 'blender'), 1);%si se ingreso un string 'Blender'
location_cam = find(strcmp(varargin, 'cam'), 1); %si se ingreso un string 'cam'
location_skeleton = find(strcmp(varargin, 'skeleton'), 1);%si se ingreso un string 'skeleton'

%% Generacion de camara con info contenida en InfoCamBlender.m


time_frame = 1/frame_rate; %tiempo de un frame
n_paths = n_markers;
frame = cell(1, n_frames); %inicializo la estructura frame
marker = cell(1,n_markers);
%genero estructura marker
for j=1:n_markers %para cada marcador
    marker{j}.Attributes.id = num2str(j); %agrego el nro de marcador
    marker{j}.Attributes.name = blanks(15); %Nombre del marcador
    marker{j}.Attributes.state = '-1';%con alguna metrica indica el estado del marcador
    marker{j}.Attributes.x = '0'; %coordenadas euclideas del marcador
    marker{j}.Attributes.y = '0';
    marker{j}.Attributes.z = '0'; %las coordenadas 2D siempre son homogeneas
end
%genero estructura frame
for k = 1:n_frames %para cada frame    
    %Atributos de frame
    frame{k}.Attributes.id = num2str(k);
    frame{k}.Attributes.time = num2str_2(time_frame*k);
    frame{k}.Attributes.n_markers = '0';
    %Elementos marker de frame
    frame{k}.marker = marker(:);%coloco todos los marcadores en el frame
end
%genero estructura path
path_struct = cell(1,n_paths);
members = num2str_2(zeros(2, n_frames));
for k=1:n_paths
    path_struct{k}.Attributes.id = num2str(k);%numero indentificador
    path_struct{k}.Attributes.name = blanks(15);
    path_struct{k}.Attributes.state = '0.0'; %con alguna metrica indica la calidad de la trayectoria
    path_struct{k}.Attributes.n_markers = '0'; %numero total de marcadores en la trayectoria
    path_struct{k}.Attributes.init_frame = '0';%frame inicial de la trayectoria
    path_struct{k}.Attributes.end_frame = '0';%frame final de la trayectoria
    path_struct{k}.Attributes.members = members;%secuencia de nombres asociados a la trayectoria    
end

if isempty(location_skeleton) %solo se ejecuta mientras no se haya agregado un string 'skeleton'
    %genero estructura cam
    cam = cell(1, n_cams);
    if isempty(location_blender) %si no se ingreso el string 'blender'
        parfor i = 1:n_cams
            %for i = 1:n_cams
            %Atributos de camara
            cam{i}.Attributes.id = num2str_2(i); % numero identificador
            cam{i}.Attributes.name = 'cam'; %Nombre de la camara
            cam{i}.Attributes.n_frames = '0';
            cam{i}.Attributes.n_paths = '0';
            cam{i}.Attributes.frame_rate = num2str_2(frame_rate); %frame_rate con el que se va a trabajar
            cam{i}.Attributes.Rc = num2str_2( zeros(3));%matriz de rotación calculada a partir de cuaterniones
            cam{i}.Attributes.Tc = num2str_2(zeros(3,1)); %vector de traslacion hasta el centro de la camara
            cam{i}.Attributes.focal_dist = '0'; %distancia focal de la camara en metros
            cam{i}.Attributes.resolution = num2str_2(zeros(2, 1)); %%=[resolución_x, resolution_y] unidades en pixeles
            cam{i}.Attributes.t_vista = blanks(15); %tipo de vista utilizada en la camara (PERSPECTIVA, ORTOGRAFICA, PANORAMICA)
            cam{i}.Attributes.shift = num2str_2(zeros(2, 1));%[shift_x, shidt_y] corrimiento del centro de la camara en pixeles
            cam{i}.Attributes.sensor = num2str_2(zeros(2, 1));%[sensor_x, sensor_y] largo y ancho del sensor en milimetros
            cam{i}.Attributes.sensor_fit = blanks(15);%tipo de ajuste utilizado para el sensor (AUTO, HORIZONTAL, VERTICAL)
            cam{i}.Attributes.pixel_aspect = '0';%(pixel_aspect_x)/(pixel_aspect_y) valor 1 indica pixel cuadrado
            cam{i}.Attributes.projection_matrix = num2str_2( zeros(3, 4));% matriz de proyeccion asociada a la camara;
            %Elementos frame de cam
            cam{i}.frame = frame(:);
            %Elementos path de cam
            cam{i}.path = path_struct(:);
        end
    else %Se ingreso el string 'blender' como parametro de entrada, por lo que se dispone de la calibracion de las camaras
        %Cargo Parametros de las camaras
        
        
        %AQUI SE CARGA INFOCAMBLENDER%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
        %InfoCamBlender.m fue generado con Python desde Blender(en el caso de base de datos sintética) o por otra vía y contienen todos los parametros de las camaras de interes
        addpath(path_vid, '-end')%se ingresa la dirección donde se encuentra el archivo InfoCamBlender que se debe utilizar
        InfoCamBlender %se cargan las variables que contiene dicho archivo                
        choose_cam;%script que deja disponibles solo las camaras indicadas por vec_cam, SE CARGA EL InfoCamBlender AQUI!!!!!!!! 
        rmpath(path_vid)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
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
        %por algun motivo el parfor no me carga las variables vectoriales de InfoCamBlender, tengo que sobreescribirlas nuevamente
        T=T;
        f=f;
        t_vista = t_vista;
        shift_x = shift_x;
        shift_y = shift_y;
        snesor = sensor;
        sensor_fit = sensor_fit;
        pixel_aspect =pixel_aspect_x/pixel_aspect_y;
        parfor i = 1:n_cams
            %for i = 1:n_cams
            %Atributos de camara
            cam{i}.Attributes.id = num2str_2(i); % numero identificador
            cam{i}.Attributes.name = 'cam'; %Nombre de la camara
            cam{i}.Attributes.n_frames = '0';
            cam{i}.Attributes.n_paths = '0';
            cam{i}.Attributes.frame_rate = num2str_2(frame_rate); %frame_rate con el que se va a trabajar
            cam{i}.Attributes.Rc = num2str_2( Rq(:,:,i)');%matriz de rotación calculada a partir de cuaterniones
            cam{i}.Attributes.Tc = num2str_2([T(1,i); T(2,i); T(3,i)]); %vector de traslacion hasta el centro de la camara
            cam{i}.Attributes.focal_dist = num2str_2(f(i) ); %distancia focal de la camara en metros
            cam{i}.Attributes.resolution = num2str_2(resolution(:,i)); %%=[resolución_x, resolution_y] unidades en pixeles
            cam{i}.Attributes.t_vista = t_vista{i}; %tipo de vista utilizada en la camara (PERSPECTIVA, ORTOGRAFICA, PANORAMICA)
            cam{i}.Attributes.shift = num2str_2([shift_x(i), shift_y(i)]);%[shift_x, shidt_y] corrimiento del centro de la camara en pixeles
            cam{i}.Attributes.sensor = num2str_2(sensor(:,i));%[sensor_x, sensor_y] largo y ancho del sensor en milimetros
            cam{i}.Attributes.sensor_fit = sensor_fit{i} ;%tipo de ajuste utilizado para el sensor (AUTO, HORIZONTAL, VERTICAL)
            cam{i}.Attributes.pixel_aspect = num2str_2(pixel_aspect);%(pixel_aspect_x)/(pixel_aspect_y) valor 1 indica pixel cuadrado
            cam{i}.Attributes.projection_matrix = num2str_2( MatrixProjection(f(i), resolution, sensor, sensor_fit{i}, [T(1,i); T(2,i); T(3,i)] , Rq(:,:,i)' ) );% matriz de proyeccion asociada a la camara;
            %Elementos frame de cam
            cam{i}.frame = frame(:);
            %Elementos path de cam
            cam{i}.path = path_struct(:);
        end
    end
    Lab.cam = cam(:)';
end

%% Generacion de estructura skeleton (utilizo lo que ya tengo de la estructura cam)
if isempty(location_cam) %solo se ejecuta mientras no se haya agregado un string 'cam'
    %n_paths = n_markers;
    for j=1:n_markers %para cada marcador
        marker{j}.Attributes.z = '0';%coordenada z
        marker{j}.Attributes.source_cam = '0'; %vector conteniendo el indice de las camaras que se utilizaron para reconstruir el punto 3D
    end
    %genero estructura frame
    frame = cell(1, n_frames); %inicializo la estructura frame
    for k = 1:n_frames %para cada frame
        %Atributos de frame
        frame{k}.Attributes.id = num2str_2(k);
        frame{k}.Attributes.time = num2str_2(time_frame*k);
        frame{k}.Attributes.n_markers = '0';
        %Elementos marker de frame
        frame{k}.marker = marker(:);%coloco todos los marcadores en el frame
    end
    
    
    %Atributos de esqueleto
    skeleton.Attributes.id = num2str_2(1); % numero identificador
    skeleton.Attributes.name = 'skeleton'; %Nombre del esqueleto
    skeleton.Attributes.name_bvh = blanks(15); %Nombre del bvh asociado al esqueleto
    skeleton.Attributes.n_frames = '0'; %numero de frames que contiene la estructura
    skeleton.Attributes.init_frame = '0'; %primer frame en uso que contiene la estructura
    skeleton.Attributes.end_frame = '0'; %ultimo frame en uso que contiene la estructura
    skeleton.Attributes.n_paths = '0'; %numero de trayectorias generadas
    skeleton.Attributes.frame_rate = num2str_2(frame_rate); %frame_rate con el que se va a trabajar
    skeleton.Attributes.n_cams = n_cams; %numero de camaras que se utilizaron para efectuar la reconstruccion
    %Elementos frame de skeleton
    skeleton.frame = frame(:);
    %Elementos path de skeleton
    skeleton.path = path_struct(:);
    
    Lab.skeleton = skeleton(:)';
end
end

function str = num2str_2(num)
%Funcion que permite llevar los numero a string en un formato adecuado para
%el xml y las resoluciones que se necesitan
str = num2str(num, '%30.13g');
end
