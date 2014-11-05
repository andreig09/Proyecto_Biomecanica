function [Lab,varargout] = loadBVH(path_bvh, name_bvh, path_info_blender)
%Funcion  que permite cargar la informacion de un archivo .bvh a las estructuras cam y skeleton
%% ENTRADAS
%path_bvh --> direccion donde se almacena el bvh de interes
%name_bvh --> nombre del archivo bvh
%patn_info_blender -->direccion donde se almacena la informacion de las camaras Blender

%% SALIDAS

%% CUERPO DE LA FUNCION

%Cargo informacion de la camara
if strcmp(path_info_blender, path_bvh) %Si se tienen los mismo path
    addpath(path_info_blender)
else
    addpath(path_info_blender, path_bvh) %agrego el path donde se encuentra InfoCamBlender
end
InfoCamBlender %este archivo .m fue generado con Python desde Blender y contienen todos los parametros de las camaras de interes


%Cargo informacion del bvh
[skeleton_old, n_markers, n_frames, time] = load3D(name_bvh);%cargo el archivo .bvh

%Modifico los nombres de los marcadores que no tienen asignado uno
marker_name=cell(1, n_markers); %esta variable se debe rellenar con los nombres de los marcadores que se van a utilizar
for j=1:n_markers %Obtengo el nombre de todos los marcadores
    name = skeleton_old(j).name;
    if   strcmp(name,  ' ') %se tiene un nombre en blanco
        str = sprintf('%d', j); %se genera un string con el numero de marcador
        marker_name{j} = str;
    else %name contiene un nombre distinto de un espacio en blanco
        marker_name{j} = name;
    end
end

frame_rate = length(find(time<=1));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DESDE AQUI HASTA END DE FUNCION VERSION MAS DEPENDIENTE DE ESTRUCTURA, PERO VELOZ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Generacion estructura cam y skeleton

n_paths = n_markers;
frame = cell(1, n_frames);
parfor k=1:n_frames %hacer para cada frame de skeleton
    frame{k}.Attributes.id = num2str(k);    
    frame{k}.Attributes.n_markers = num2str_2(n_markers);    
    frame{k}.Attributes.time = num2str_2(time(k));   
    for j=1:n_markers %hacer para cada marcador
        frame{k}.marker{j}.Attributes.id = num2str(j); %agrego el nro de marcador        
        frame{k}.marker{j}.Attributes.x= num2str_2(skeleton_old(j).t_xyz(1,k));%coordenadas del marcador
        frame{k}.marker{j}.Attributes.y= num2str_2(skeleton_old(j).t_xyz(2,k));
        frame{k}.marker{j}.Attributes.z= num2str_2(skeleton_old(j).t_xyz(3,k));
        frame{k}.marker{j}.Attributes.name = marker_name{j}
%         name = skeleton_old(j).name;
%         if   strcmp(name,  ' ') %se tiene un nombre en blanco
%             str = sprintf('%d', j); %se genera un string con el numero de marcador            
%             frame{k}.marker{j}.Attributes.name = {str};
%         else %name contiene un nombre distinto de un espacio en blanco            
%             frame{k}.marker{j}.Attributes.name = {name};
%         end        
        frame{k}.marker{j}.Attributes.state = '0';     %estado del marcador, asumo que 0 indica "baja incertidumbre"
        frame{k}.marker{j}.Attributes.source_cam = '-1'; %la informacion no proviene de ninguna camara
    end
end

%genero estructura path
path_struct = cell(1,n_paths);
for k=1:n_paths
    path_struct{k}.Attributes.id = num2str(k);%numero indentificador
    path_struct{k}.Attributes.name = marker_name{k};
    path_struct{k}.Attributes.state = '0'; %estado de la trayectoria, asumo que 0 indica "baja incertidumbre"
    path_struct{k}.Attributes.n_markers = num2str_2(n_markers); %numero total de marcadores en la trayectoria
    path_struct{k}.Attributes.init_frame = '1';%frame inicial de la trayectoria
    path_struct{k}.Attributes.end_frame = num2str_2(n_frames);%frame final de la trayectoria
    path_struct{k}.Attributes.members = num2str_2([k*ones(1, n_frames); 1:n_frames ]);;%secuencia de nombres asociados a la trayectoria
end

%Atributos de esqueleto
skeleton.Attributes.id = '1'; % numero identificador
skeleton.Attributes.name = 'skeleton_ground_truth'; %Nombre del esqueleto
skeleton.Attributes.name_bvh = name_bvh; %Nombre del bvh asociado al esqueleto
skeleton.Attributes.n_frames = num2str_2(n_frames); %numero de frames que contiene la estructura
skeleton.Attributes.init_frame = '1'; %primer frame en uso que contiene la estructura
skeleton.Attributes.end_frame = num2str_2(n_frames); %ultimo frame en uso que contiene la estructura
skeleton.Attributes.n_paths = num2str_2(n_paths); %numero de trayectorias generadas
skeleton.Attributes.frame_rate = num2str_2(frame_rate); %frame_rate con el que se va a trabajar
skeleton.Attributes.n_cams = n_cams; %numero de camaras que se utilizaron para efectuar la reconstruccion
%Elementos frame de skeleton
skeleton.frame = frame(:);
%Elementos path de skeleton
skeleton.path = path_struct(:);

disp('Se ha generado la estructura skeleton_ground_truth')

%Cargo Parametros de las camaras
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
sensor = sensor;
sensor_fit = sensor_fit;
pixel_aspect =pixel_aspect_x/pixel_aspect_y;

%Genero estructura cam
cam = cell(1, n_cams);
parfor i=1:n_cams %hacer para todas las camaras 
%for i=1:n_cams %hacer para todas las camaras 
    cam{i}.Attributes.id = num2str_2(i); % numero identificador
    cam{i}.Attributes.name = 'cam_ground_truth'; %Nombre de la camara
    cam{i}.Attributes.n_frames = num2str_2(n_frames);
    cam{i}.Attributes.n_paths = num2str_2(n_paths);
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
    cam{i}.frame = frame(:); %como tienen informacion en comun,  copio y luego modifico lo diferente
    for k=1:n_frames %hacer para cada frame
        X = get_info(skeleton, 'frame', k, 'marker', 'coord'); %obtengo todas las coordenadas de marcadores de skeleton en el frame k
        x = obtain_coord_retina(X, get_info(cam{i}, 'projection_matrix'));
        for j=1:n_markers %hacer para cada marcador
            cam{i}.frame{k}.marker{j}.Attributes.x = num2str_2(x(1, j));%Guardo la matriz de coordenadas homogeneas x=P*X , del marcador j del frame k en la camara i
            cam{i}.frame{k}.marker{j}.Attributes.y = num2str_2(x(2, j));
            cam{i}.frame{k}.marker{j}.Attributes.z = num2str_2(x(3, j));
        end
    end
    %Elementos path de cam
    cam{i}.path = path_struct(:);
end
disp('Se han generado las estructuras cam_ground_truth')
%Genero la salida Lab 
Lab.cam = cam(:)';
Lab.skeleton = skeleton(:)';
%Genero la salida opcional, que contienen todos los nombres de los marcadores a utilizar
varargout{1} = marker_name;

disp('loadBVH a finalizado con exito.')

%Restauro el path
if strcmp(path_info_blender, path_bvh) %Si se tienen los mismo path
    rmpath(path_info_blender)
else
    rmpath(path_info_blender, path_bvh) 
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%VERSION POCO MAS INDEPENDENTE DE FORMA DE ESTRUCTURA, PERO MUCHO MAS LENTA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Lab= init_structs(n_markers, n_frames, frame_rate(1), n_cams); %para visualizar la forma de la estructura de datos ingresar a esta funcion
% cam = Lab.cam;
% skeleton = Lab.skeleton;
% 
% %Relleno la estructura skeleton con la info del archivo name_bvh
% skeleton = set_info(skeleton, 'name', 'skeleton_ground_truth');
% skeleton = set_info(skeleton, 'name_bvh', name_bvh);
% skeleton = set_info(skeleton, 'n_frames', n_frames);
% 
% n_frames = get_info(skeleton, 'n_frames');
% frame = cell(1, n_frames);
% for k=1:n_frames %hacer para cada frame de skeleton    
%     skeleton = set_info(skeleton, 'frame', k, 'n_markers', n_markers);    
%     skeleton = set_info(skeleton, 'frame', k, 'time', time(k));    
%     for j=1:n_markers %hacer para cada marcador        
%         skeleton = set_info(skeleton,'frame', k, 'marker', j, 'coord', skeleton_old(j).t_xyz(:,k));        
%         name = skeleton_old(j).name;
%         if   strcmp(name,  ' ') %se tiene un nombre en blanco
%             str = sprintf('%d', j); %se genera un string con el numero de marcador
%             skeleton = set_info(skeleton,'frame', k, 'marker', j, 'name', {str});           
%         else %name contiene un nombre distinto de un espacio en blanco
%             skeleton = set_info(skeleton,'frame', k, 'marker', j, 'name', {name});            
%         end
%         skeleton = set_info(skeleton, 'frame', k, 'marker', j, 'state', 0);% 0 indica que el dato es posta y 1 la más baja calidad        
%         skeleton = set_info(skeleton, 'frame', k, 'marker', j, 'source', -1);%en nuestro caso es ground truth        
%     end
% end
% 
% skeleton.frame = frame(:);
% n_paths = n_markers;
% for k = 1:n_paths %relleno las trayectorias
%     skeleton = set_info(skeleton, 'path', k, 'name', skeleton_old(j).name);
%     skeleton = set_info(skeleton, 'path', k, 'state',  '0'); %con alguna metrica indica la calidad de la trayectoria
%     skeleton = set_info(skeleton, 'path', k, 'n_markers', num2str_2(n_markers) ); %numero total de marcadores en la trayectoria
%     skeleton = set_info(skeleton, 'path', k, 'init_frame', '1' );%frame inicial de la trayectoria
%     skeleton = set_info(skeleton, 'path', k, 'end_frame', num2str_2(n_frames) );%frame final de la trayectoria
%     skeleton = set_info(skeleton, 'path', k, 'members', num2str_2( k*ones(1, n_frames)) );%secuencia de nombres asociados a la trayectoria
% end
% 
% %Cargo Parametros de las camaras
% %Verifico hipotesis de trabajo
% if (pixel_aspect_x ~= pixel_aspect_y)||any(shift_x ~= shift_y)
%     disp('Se asumen dos cosas en los calculos que siguen:')
%     disp('                1) que la variable de Blender,  Properties/ObjectData/Lens/Shift, indicado por los')
%     disp('                     parametros (X, Y) es (0, 0)')
%     disp('                2) que la variable relacion de forma en Properties/Render/Dimensions/Aspect Radio de cada camara, indicado por')
%     disp('                    los parametros (X, Y) sea (z, z) con z cualquiera')
%     disp('Hay que corregir alguno de estos parametros para proseguir.')
%     return
% end
% %por algun motivo el parfor no me carga las variables vectoriales de InfoCamBlender, tengo que sobreescribirlas nuevamente
% T=T;
% f=f;
% t_vista = t_vista;
% shift_x = shift_x;
% shift_y = shift_y;
% snesor = sensor;
% sensor_fit = sensor_fit;
% pixel_aspect =pixel_aspect_x/pixel_aspect_y;
% parfor i=1:n_cams %hacer para todas las camaras
%     %genero la estructura frame para la camara
%     cam{i} = set_info(cam{i}, 'n_frames', n_frames);
%     cam{i} = set_info(cam{i}, 'n_paths', n_paths);
%     cam{i} = set_info(cam{i}, 'Rc',  Rq(:,:,i)' );
%     cam{i} = set_info(cam{i}, 'Tc', [T(1,i); T(2,i); T(3,i)] ); %vector de traslacion hasta el centro de la camara
%     cam{i} = set_info(cam{i}, 'focal_dist',  f(i) );%distancia focal de la camara en metros
%     cam{i} = set_info(cam{i}, 'resolution', resolution(:,i) ); %%=[resolución_x, resolution_y] unidades en pixeles
%     cam{i} = set_info(cam{i}, 't_vista',  t_vista(i) ); %tipo de vista utilizada en la camara (PERSPECTIVA, ORTOGRAFICA, PANORAMICA)
%     cam{i} = set_info(cam{i}, 'shift', [shift_x(i), shift_y(i)] );%[shift_x, shidt_y] corrimiento del centro de la camara en pixeles
%     cam{i} = set_info(cam{i}, 'sensor', sensor(:,i) );%[sensor_x, sensor_y] largo y ancho del sensor en milimetros
%     cam{i} = set_info(cam{i}, 'sensor_fit',  sensor_fit(i) );%tipo de ajuste utilizado para el sensor (AUTO, HORIZONTAL, VERTICAL)
%     cam{i} = set_info(cam{i}, 'pixel_aspect', pixel_aspect);%(pixel_aspect_x)/(pixel_aspect_y) valor 1 indica pixel cuadrado
%     cam{i} = set_info(cam{i}, 'projection_matrix',  MatrixProjection(f(i), resolution, sensor, sensor_fit{i}, [T(1,i); T(2,i); T(3,i)] , Rq(:,:,i)' ) );% matriz de rotacion asociada a la camara;
%     
%    
%     cam{i}.frame = frame(:); %como tienen informacion en comun,  copio y luego modifico lo diferente
%     for k=1:n_frames %hacer para cada frame
%         X = get_info(skeleton, 'frame', k, 'marker', 'coord'); %obtengo todas las coordenadas de marcadores de skeleton en el frame k
%         x = obtain_coord_retina(X, get_info(cam{i}, 'projection_matrix'));
%         for j=1:n_markers %hacer para cada marcador
%             cam{i} = set_info(cam{i}, 'frame', k, 'marker', j, 'coord', x(:, j));%Guardo la matriz de coordenadas homogeneas x=P*X , del marcador j del frame k en la camara i            
%         end
%     end 
%     cam{i}.path = skeleton.path(:);
% end
% 
% 
% Lab.cam = cam(:);
% Lab.skeleton = skeleton(:);
% 
% disp('Se han cargado los datos basicos de las estructuras.')
% rmpath(path_info_blender, path_bvh)%dejo el path como estaba
end


function [skeleton, n_marcadores, n_frames, time] = load3D(name_bvh)
%Esta función devuelve parámetros básicos para trabajar con el ground truth
%% ENTRADA
%name.bvh --> string que indica el nombre de la secuencia .bvh
%% SALIDA
%time --> matriz cuyas columnas son los tiempos en segundos de cada frame
%n_marcadores --> indica el nro de marcadores de la armadura (esqueleto)
%n_frames --> indica nro de frames de la secuencia
%skeleton --> estructura que guarda la información de las junturas.
%skeleton(j) -->accede a la información de la juntura j
%skeleton(j).name --> devuelve el nombre de la juntura j
%skeleton(j).t_xyz --> matriz cuyas filas son las coordenadas 3D y las
%columnas los correspondientes frames de la juntura j
%EJEMPLO: skeleton(j).t_xyz(:, k) --> devuelve las coordenadas 3D de la juntura j en el
%frame k

%% Cargo  ground truth
[skeleton,time]=loadbvh(name_bvh);
n_frames = length(time);
n_marcadores = size(skeleton,2);
end

function [skeleton,time] = loadbvh(fname)
%% LOADBVH  Load a .bvh (Biovision) file.
%
% Loads BVH file specified by FNAME (with or without .bvh extension)
% and parses the file, calculating joint kinematics and storing the
% output in SKELETON.
%
% Some details on the BVH file structure are given in "Motion Capture File
% Formats Explained": http://www.dcs.shef.ac.uk/intranet/research/resmes/CS0111.pdf
% But most of it is fairly self-evident.

%% Load and parse header data
%
% The file is opened for reading, primarily to extract the header data (see
% next section). However, I don't know how to ask Matlab to read only up
% until the line "MOTION", so we're being a bit inefficient here and
% loading the entire file into memory. Oh well.

% add a file extension if necessary:
if ~strncmpi(fliplr(fname),'hvb.',4)
    fname = [fname,'.bvh'];
end

fid = fopen(fname);
C = textscan(fid,'%s');
fclose(fid);
C = C{1};


%% Parse data
%
% This is a cheap tokeniser, not particularly clever.
% Iterate word-by-word, counting braces and extracting data.

% Initialise:
skeleton = [];
ii = 1;
nn = 0;
brace_count = 1;

while ~strcmp( C{ii} , 'MOTION' )
    
    ii = ii+1;
    token = C{ii};
    
    if strcmp( token , '{' )
        
        brace_count = brace_count + 1;
        
    elseif strcmp( token , '}' )
        
        brace_count = brace_count - 1;
        
    elseif strcmp( token , 'OFFSET' )
        
        skeleton(nn).offsetFromParent = [str2double(C(ii+1)) ; str2double(C(ii+2)) ; str2double(C(ii+3))];
        ii = ii+3;
        
    elseif strcmp( token , 'CHANNELS' )
        
        skeleton(nn).Nchannels = str2double(C(ii+1));
        
        % The 'order' field is an index corresponding to the order of 'X' 'Y' 'Z'.
        % Subtract 87 because char numbers "X" == 88, "Y" == 89, "Z" == 90.
        if skeleton(nn).Nchannels == 3
            skeleton(nn).order = [C{ii+2}(1),C{ii+3}(1),C{ii+4}(1)]-87;
        elseif skeleton(nn).Nchannels == 6
            skeleton(nn).order = [C{ii+5}(1),C{ii+6}(1),C{ii+7}(1)]-87;
        else
            error('Not sure how to handle not (3 or 6) number of channels.')
        end
        
        if ~all(sort(skeleton(nn).order)==[1 2 3])
            error('Cannot read channels order correctly. Should be some permutation of [''X'' ''Y'' ''Z''].')
        end
        
        ii = ii + skeleton(nn).Nchannels + 1;
        
    elseif strcmp( token , 'JOINT' ) || strcmp( token , 'ROOT' )
        % Regular joint
        
        nn = nn+1;
        
        skeleton(nn).name = C{ii+1};
        skeleton(nn).nestdepth = brace_count;
        
        if brace_count == 1
            % root node
            skeleton(nn).parent = 0;
        elseif skeleton(nn-1).nestdepth + 1 == brace_count;
            % if I am a child, the previous node is my parent:
            skeleton(nn).parent = nn-1;
        else
            % if not, what is the node corresponding to this brace count?
            prev_parent = skeleton(nn-1).parent;
            while skeleton(prev_parent).nestdepth+1 ~= brace_count
                prev_parent = skeleton(prev_parent).parent;
            end
            skeleton(nn).parent = prev_parent;
        end
        
        ii = ii+1;
        
    elseif strcmp( [C{ii},' ',C{ii+1}] , 'End Site' )
        % End effector; unnamed terminating joint
        %
        % N.B. The "two word" token here is why we don't use a switch statement
        % for this code.
        
        nn = nn+1;
        
        skeleton(nn).name = ' ';
        skeleton(nn).offsetFromParent = [str2double(C(ii+4)) ; str2double(C(ii+5)) ; str2double(C(ii+6))];
        skeleton(nn).parent = nn-1; % always the direct child
        skeleton(nn).nestdepth = brace_count;
        skeleton(nn).Nchannels = 0;
        
    end
    
end

%% Initial processing and error checking

Nnodes = numel(skeleton);
Nchannels = sum([skeleton.Nchannels]);
Nchainends = sum([skeleton.Nchannels]==0);

% Calculate number of header lines:
%  - 5 lines per joint
%  - 4 lines per chain end
%  - 4 additional lines (first one and last three)
Nheaderlines = (Nnodes-Nchainends)*5 + Nchainends*4 + 4;

rawdata = importdata(fname,' ',Nheaderlines);

index = strncmp(rawdata.textdata,'Frames:',7);
Nframes = sscanf(rawdata.textdata{index},'Frames: %f');

index = strncmp(rawdata.textdata,'Frame Time:',10);
frame_time = sscanf(rawdata.textdata{index},'Frame Time: %f');

time = frame_time*(0:Nframes-1);

if size(rawdata.data,2) ~= Nchannels
    error('Error reading BVH file: channels count does not match.')
end

if size(rawdata.data,1) ~= Nframes
    warning('LOADBVH:frames_wrong','Error reading BVH file: frames count does not match; continuing anyway.')
end

%% Load motion data into skeleton structure
%
% We have three possibilities for each node we come across:
% (a) a root node that has displacements already defined,
%     for which the transformation matrix can be directly calculated;
% (b) a joint node, for which the transformation matrix must be calculated
%     from the previous points in the chain; and
% (c) an end effector, which only has displacement to calculate from the
%     previous node's transformation matrix and the offsetFromParent of the end
%     joint.
%
% These are indicated in the skeleton structure, respectively, by having
% six, three, and zero "channels" of data.
% In this section of the code, the channels are read in where appropriate
% and the relevant arrays are pre-initialised for the subsequent calcs.

channel_count = 0;

for nn = 1:Nnodes
    
    if skeleton(nn).parent
        skeleton(nn).head0 = skeleton(nn).offsetFromParent + skeleton(skeleton(nn).parent).head0;
    else
        skeleton(nn).head0 = skeleton(nn).offsetFromParent; % Root Node has a global position
    end
    
    
    if skeleton(nn).Nchannels == 6 % root node
        %NOTE: this might be the source of a bug. Although in typical
        %situations the only element that has 6 channels is the root there
        %are in fact cases where other bones also have 6 channels.
        %Specifically cases where the children are offset.
        % None of the code in this file takes this case into account
        % and so the hope is that even if there are offsets that the actual
        % skeleton stays the same throughout which would mean
        % that the xyz part of the 6 channels has no additional meaning and
        % can be ingored (which is what is done in this file...)
        
        
        % assume translational data is always ordered XYZ
        % The following is ONLY relevant for the rootnode and will be
        % overwritten later on for other nodes with 6 channels
        skeleton(nn).t_xyz = repmat(skeleton(nn).offsetFromParent,[1 Nframes]) + rawdata.data(:,channel_count+[1 2 3])';
        
        %This is valid for all 6 channel nodes
        skeleton(nn).R_xyz(skeleton(nn).order,:) = rawdata.data(:,channel_count+[4 5 6])';
        
        % Kinematics of the root element (will be overwritten for other
        % nodes with 6 channels)
        skeleton(nn).T = nan(4,4,Nframes);
        for ff = 1:Nframes
            skeleton(nn).T(:,:,ff) = transformation_matrix(skeleton(nn).t_xyz(:,ff) , skeleton(nn).R_xyz(:,ff) , skeleton(nn).order);
        end
        
    elseif skeleton(nn).Nchannels == 3 % joint node
        
        skeleton(nn).R_xyz(skeleton(nn).order,:) = rawdata.data(:,channel_count+[1 2 3])';
        skeleton(nn).t_xyz  = nan(3,Nframes);
        skeleton(nn).T = nan(4,4,Nframes);
        
    elseif skeleton(nn).Nchannels == 0 % end node
        skeleton(nn).t_xyz  = nan(3,Nframes);
    end
    
    channel_count = channel_count + skeleton(nn).Nchannels;
    
    skeleton(nn).children = [];
end

for nn = 1:Nnodes
    if skeleton(nn).parent
        skeleton(skeleton(nn).parent).children = [skeleton(skeleton(nn).parent).children nn];
    end
end

for nn = 1:Nnodes
    if skeleton(nn).Nchannels % then it has children
        skeleton(nn).tail0 = mean([skeleton(skeleton(nn).children).head0]',1)';
    end
end

for nn=1:Nnodes
    
    if skeleton(nn).Nchannels
        yvec = skeleton(nn).tail0' - skeleton(nn).head0';
        zvec = [0 0 1];
        xvec = cross(yvec,zvec);
        zvec = cross(xvec,yvec);
        skeleton(nn).R0 = [xvec'/norm(xvec) yvec'/norm(yvec) zvec'/norm(zvec)];
    else
        skeleton(nn).R0 = eye(3)';
    end
end


%% Calculate kinematics
%
% No calculations are required for the root nodes.

% For each joint, calculate the transformation matrix and for convenience
% extract each position in a separate vector.
for nn = find([skeleton.parent] ~= 0 & [skeleton.Nchannels] ~= 0)
    
    parent = skeleton(nn).parent;
    
    for ff = 1:Nframes
        transM = transformation_matrix( skeleton(nn).offsetFromParent , skeleton(nn).R_xyz(:,ff) , skeleton(nn).order );
        skeleton(nn).T(:,:,ff) = skeleton(parent).T(:,:,ff) * transM;
        skeleton(nn).t_xyz(:,ff) = skeleton(nn).T([1 2 3],4,ff);
    end
    
    % In the above trans calculation the angles are relative to the base
    % rotations which means that if we multiply
    % Thus the following gives a Rotation matrix whose columns point along the local bone
    % axes : sk(i).T(1:3,1:3,j)*sk(i).R0
    
    
end

% For an end effector we don't have rotation data;
% just need to calculate the final position.
for nn = find([skeleton.Nchannels] == 0)
    
    parent = skeleton(nn).parent;
    
    for ff = 1:Nframes
        transM = skeleton(parent).T(:,:,ff) * [eye(3), skeleton(nn).offsetFromParent; 0 0 0 1];
        skeleton(nn).t_xyz(:,ff) = transM([1 2 3],4);
    end
    
end

end



function transM = transformation_matrix(displ,rxyz,order)
% Constructs the transformation for given displacement, DISPL, and
% rotations RXYZ. The vector RYXZ is of length three corresponding to
% rotations around the X, Y, Z axes.
%
% The third input, ORDER, is a vector indicating which order to apply
% the planar rotations. E.g., [3 1 2] refers applying rotations RXYZ
% around Z first, then X, then Y.
%
% Years ago we benchmarked that multiplying the separate rotation matrices
% was more efficient than pre-calculating the final rotation matrix
% symbolically, so we don't "optimise" by having a hard-coded rotation
% matrix for, say, 'ZXY' which seems more common in BVH files.
% Should revisit this assumption one day.
%
% Precalculating the cosines and sines saves around 38% in execution time.

c = cosd(rxyz);
s = sind(rxyz);

RxRyRz(:,:,1) = [1 0 0; 0 c(1) -s(1); 0 s(1) c(1)];
RxRyRz(:,:,2) = [c(2) 0 s(2); 0 1 0; -s(2) 0 c(2)];
RxRyRz(:,:,3) = [c(3) -s(3) 0; s(3) c(3) 0; 0 0 1];

rotM = RxRyRz(:,:,order(1))*RxRyRz(:,:,order(2))*RxRyRz(:,:,order(3));

transM = [rotM, displ; 0 0 0 1];

end