function cam = markersXML2mat(names, path_XML, list_XML, path_vid)
%Funcion que lleva la informacion de una lista de marcadores desde un XML a la estructura de datos cam.mat

%% ENTRADA
% names    --> cell array con los nombres de los marcadores que se estan ingresando (se utiliza para inicializar las trayectorias)
%path_XML  --> direccion donde se tienen los archivos xml de trabajo
%path_vid  --> direccion donde se tienen los archivos de video y donde se
%               encuentra InfoCamBlender.m ---->El mismo contiene la información de
%               calibracion necesaria para inicializar la estructura de
%               datos cam
%list_XML  --> cell array conteniendo el nombre de los archivos xml

%% SALIDA
% cam --> estructura de datos cam.mat

%% ---------
% Author: M.R.
% created the 23/08/2014.

%% CUERPO DE LA FUNCION

n_markers = 3*length(names); %nro total de marcadores
n_cams = length(list_XML); %nro de camaras

%para poder correr el ciclo parfor debo hacer lo siguiente antes de entrar
archivo = [path_XML '/' list_XML{1}];%genero un string con el nombre del archivo a importar
s=xml2struct(archivo);
Frames = s.Detected_Markers.Frame;%cell array de estructuras con los frames relevados        
n_frames = size(Frames, 2);%nro de frames en la camara 
n_frame_const = n_frames;%guardar el numero de frames de la primer camara para saber si este parametro cambian en los siguientes ciclos
frame_rate = 0; %no puedo conocerlo a esta altura, debo ingresarlo a la funcion en versiones futuras
Lab=init_structs(n_markers, n_frames, frame_rate, n_cams, path_vid, 'cam', 'blender');%inicializo las estructuras con la info blender
cam = Lab.cam;

%[cam, ~]=init_structs(n_markers, n_frames, names);
str = 'Se ha inicializado una estructura cam';
disp(str)

%%%%%%%%%%%%%%%

parfor_progress(n_cams);%inicializo la barra de progreso
%parfor i=1:n_cams %hacer para todas las camaras
for i=1:n_cams %hacer para todas las camaras
   
    %importo el archivo XML con los datos de interes
    archivo = [path_XML '/' list_XML{i}];%genero un string con el nombre del archivo a importar    
    s=xml2struct(archivo);
    
    Frames = s.Detected_Markers.Frame;%cell array de estructuras con los frames relevados        
    n_frames = size(Frames, 2);%nro de frames en la camara i
    
    if n_frames ~= n_frame_const %avisar de que existen camaras con distinto nro de frame
        str_warning = sprintf('El XML %s posee un numero de frames distinto a algun otro XML.\nSe deben ingresar un conjunto de XML con igual numero de frame', list_XML{i});
        disp(str_warning)
    end
        
    %ingreso los datos de la camara i a la estructura cam.mat
    cam{i} = set_info(cam(i), 'name', i); %ingreso el numero de camara
    cam{i} = set_info(cam(i), 'n_frames', n_frames); %ingreso el numero de frames 
    resolution = get_info(cam(i), 'resolution');  %resolution = [res_x, res_y], obtengo las resoluciones horizontal y vertical
    for j =1:n_frames %hacer para todos los frames
        if isfield(Frames{j}, 'Marker') %Si existen marcadores en el frame j
            Markers = Frames{j}.Marker;
            n_markers = size(Markers, 2);
            if (i==17)&&(j==92)
            disp('__________')
            end
            markers= set_coordinate_origin(resolution(2), Markers, n_markers); %llevo de coordenadas pixel en estructura Marker, a coordenadas cartesianas en matriz markers
            
            cam{i} = set_info(cam(i), 'frame', j, 'n_markers', n_markers);%dejo almacenado cuantos marcadores tiene este frame
            index_frame = 1:n_markers;
            cam{i} = set_info(cam(i), 'frame', j, 'marker', index_frame, 'coord', markers); %setea con las columnas de "markers" las coordenadas de los marcadores en 'index_frame' del frame j de la camara        
        else %si el frame j no tiene marcadores 
            cam{i} = set_info(cam(i), 'frame', j, 'n_markers', 0 );%dejo almacenado cuantos marcadores tiene este frame
        end
        
    end
    
%     
%     
%     %[frames_XML, n_frames] = importXML(archivo);
%     %     %relevo informacion del XML asociado a la camara i
% %     aux={frames_XML(:).name};
% %     isempt_aux = cellfun(@isempty,aux);   %Encuentra indices vacios dentro del cell
% %     [ ~ , emptyIndex] = find(isempt_aux); %encuentro el numero total de indices vacios
% %     if ~isempty(emptyIndex) %solo efectuo cambios si se tiene algun indice vacio
% %         [frames_XML(isempt_aux).name] = deal(java.lang.String('1'));  %Lleno los nombres vacios con el string '1'
% %         [frames_XML(isempt_aux).X] = deal(zeros(3, 1));%distribuyendo en todos los lugares vacios de frame_XML un marcador con coordenadas nulas
% %     end
%     
%     index = str2num([frames_XML(:).name]); %obtengo los indices de los marcadores de cada frame y los ubico consecutivamente en un vector de enteros
%     markers = [frames_XML(:).X]; %obtengo una matriz cuyas columnas son los marcadores de todos los frames
%     resolution = get_info(cam(i), 'resolution');  %resolution = [res_x, res_y], obtengo las resoluciones horizontal y vertical
%     [markers, marker_empty ]= set_coordinate_origin(resolution(2), markers); %llevo de coordenadas pixel a coordenadas cartesianas
%     markers(3,:) = ones(1,length(index)); %dejo los puntos 2D en coordenadas homogeneas normalizadas
%     index_frames = find(index==1); %se obtienen todos los indices donde se cambia de frame
%     
%     
%     
    
%     
%     %ingreso los datos de la camara i a la estructura cam.mat
%     cam{i} = set_info(cam(i), 'name', i); %ingreso el numero de camara
%     cam{i} = set_info(cam(i), 'n_frames', n_frames); %ingreso el numero de frames
%     n = n_frames;
%     for j=1:(n-1) %para cada frame menos el ultimo
%         init_frame = index_frames(j);
%         end_frame= index_frames(j+1)-1;
%         index_in_frame = index(init_frame:end_frame ); %indices de los marcadores en el frame j
%         markers_frame = markers(:,init_frame:end_frame ); %marcadores en el frame j 
%         
%         if markers_frame == marker_empty*ones(1, size(markers_frame, 2)) %si el frame no tiene marcadores esta condicion es verdadera
%             cam{i} = set_info(cam(i), 'frame', j, 'n_markers', 0 );%dejo almacenado cuantos marcadores tiene este frame            
%         else%de lo contrario se tiene marcadores en el frame
%             cam{i} = set_info(cam(i), 'frame', j, 'n_markers', length(index_in_frame) );%dejo almacenado cuantos marcadores tiene este frame
%             cam{i} = set_info(cam(i), 'frame', j, 'marker', index_in_frame, 'coord', markers_frame); %setea con las columnas de "markers" las coordenadas de los marcadores en 'index_frame' del frame j de la camara        
%         end
%         
%             %cam{i} = set_info(cam(i), 'frame', j, 'n_markers', length(index_in_frame) );%dejo almacenado cuantos marcadores tiene este frame
%             %cam{i} = set_info(cam(i), 'frame', j, 'marker', index_in_frame, 'coord', markers_frame); %setea con las columnas de "markers" las coordenadas de los marcadores en 'index_frame' del frame j de la camara        
%     end
%     index_in_frame = index(index_frames(n):length(index)); %indices de los marcadores en el frame j
%     markers_frame = markers(:,index_frames(n):length(index)); %marcadores en el frame j
%     
%     
%         if markers_frame == marker_empty*ones(1, size(markers_frame, 2)) %si el frame no tiene marcadores esta condicion es verdadera
%             cam{i} = set_info(cam(i), 'frame', j, 'n_markers', 0 );%dejo almacenado cuantos marcadores tiene este frame            
%         else%de lo contrario se tiene marcadores en el frame
%             cam{i} = set_info(cam(i), 'frame', j, 'n_markers', length(index_in_frame) );%dejo almacenado cuantos marcadores tiene este frame
%             cam{i} = set_info(cam(i), 'frame', j, 'marker', index_in_frame, 'coord', markers_frame); %setea con las columnas de "markers" las coordenadas de los marcadores en 'index_frame' del frame j de la camara        
%         end
%     
    %cam{i} = set_info(cam(i), 'frame', n, 'n_markers', length(index_in_frame) );%dejo almacenado cuantos marcadores tiene este frame
    %cam{i} = set_info(cam(i), 'frame', n, 'marker', index_in_frame, 'coord', markers_frame); %setea con las columnas de "markers" las coordenadas de los marcadores en 'index_frame' del frame j de la camara
    
    
    %str = sprintf('Se han ingresado los datos en la camara %d\n', i );
    %disp(str)
    
    %genero barra de progreso         
    parfor_progress;
end
parfor_progress(0);%finalizo la barra de progreso
end

function markers_out = set_coordinate_origin(res_y, Markers, n_markers)
%Funcion que permite llevar del sistema de coordenadas pixel con origen en la esquina superior izquierda al sistema cartesiano con origen en la esquina inferior
%izquierda

%% ENTRADA
%res_y       --> resolucion vertical de la imagen
%Markers     --> cell array de estructuras con las coordenadas de marcadores
%n_markers   -->numero total de marcadores
%% SALIDA
%markers_out --> se devuelven las coordenadas homogeneas normalizadas de cada marcador Markers pero
%               segun el origen del sistema cartesiano y ubicado en las columnas de
%               markers_out. markers_out tiene dimension (3, n_markers)
%               donde la ultima fila son unos.

%% ---------
% Author: M.R.
% created the 5/09/2014.

%% CUERPO DE LA FUNCION
markers_out = ones(3, n_markers);
if (n_markers==1)%si solo se tiene un marcador Markers no es un array, por lo que el direccionamiento Markers{k} no funciona
    markers_out(1) = str2double(Markers.Centroid.Attributes.x) + 0.5; %esto es debido a que las coordenadas pixel el (0, 0) origen pixel esta segun las coordenadas cartesianas en (-0.5, res_y + 0.5)
    markers_out(2) = res_y - str2double(Markers.Centroid.Attributes.y) +0.5;
else
    for k=1:n_markers
        markers_out(1,k) = str2double(Markers{k}.Centroid.Attributes.x) + 0.5; %esto es debido a que las coordenadas pixel el (0, 0) origen pixel esta segun las coordenadas cartesianas en (-0.5, res_y + 0.5)
        markers_out(2,k) = res_y - str2double(Markers{k}.Centroid.Attributes.y) +0.5;
    end
end
end

function [salida, n_frames] = importXML(archivo)
% Funcion que permite importar archivos XML

%% ENTRADA
% archivo --> es un string con la direccion de los archivos a cargar, por ejemplo saved_vars/camj.xml con j=1,2,...n_cams

%% SALIDA
%salida --> estructura de datos con la informacion del XML

%% CUERPO DE LA FUNCION

xml = xmlread(archivo);
children = xml.getChildNodes;
Detected_Markers = children.item(0);
frames = Detected_Markers.getChildNodes;
n_frames = frames.getLength;

k=1;
for i=0:(n_frames-1)
    if strcmp(frames.item(i).getNodeName, 'Frame')
        salida(k)= parsearFrame(frames.item(i));
        k = k+1;
    end
end
n_frames = k-1;%numero total de frames no vacios
end

function frameI = parsearFrame(Frame)
%Puede pasar que un frame no tenga marcadores
if (Frame.hasChildNodes) && (Frame.getLength > 1)
    k=1;
    markers = Frame.getChildNodes;
    
    totalMarkers = markers.getLength;
    
    for i = 0:(totalMarkers - 1)
        if strcmp(markers.item(i).getNodeName,'Marker')
            %Agregar nombre del marcador a frame.name
            frameI.name(k) = getMarkerName(markers.item(i));
            %Crear matriz de coordenadas
            frameI.X(:,k) = getMarkerPosition(markers.item(i));
            k = k+1;
        end
    end
else
    %frameI.name = NULL;
    frameI.name = [];
    %frameI.X = NULL;
    frameI.X = [];
end
end

function name = getMarkerName(Marker)
name = Marker.getAttribute('id');
end

function xyz = getMarkerPosition(Marker)
centroid =  Marker.getChildNodes.item(1);
coordenadas = centroid.getAttributes;
xyz = [str2num(coordenadas.item(0).getValue.toString); str2num(coordenadas.item(1).getValue.toString); 0];
end



