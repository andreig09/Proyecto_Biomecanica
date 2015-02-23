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

%%%%%%%%%%%%%%%%%%%%% auxiliar que devuelve los indices de las camaras en list_XML
vec_cams=zeros(length(list_XML), 1);%en este vector se van a guardar los indices de las camaras que se encuentran en list_XML
for i=1:length(list_XML)
    id_punto = strfind(list_XML{i}, '.');
    vec_cams(i)=str2double(list_XML{i}(4:(id_punto-1))); %el 4 es porque los numeros de las camaras siempre empiezan en el cuarto caracter   
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n_cams =  max(vec_cams); %nro de camaras que se puede inferir se encuentran en el laboratorio, dada la numeracion de los xml

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
%parfor i=1:length(vec_cams)%hacer para todas las camaras de vec_cams  
%for i=1:n_cams %hacer para todas las camaras
for i=1:length(vec_cams)%hacer para todas las camaras de vec_cams  
    %importo el archivo XML con los datos de interes
    archivo = [path_XML '/' list_XML{i}];%genero un string con el nombre del archivo a importar    
    s=xml2struct(archivo);
    
    Frames = s.Detected_Markers.Frame;%cell array de estructuras con los frames relevados        
    n_frames = size(Frames, 2);%nro de frames en la camara i
    
    if n_frames ~= n_frame_const %avisar de que existen camaras con distinto nro de frame
        str_warning = sprintf('El XML %s posee un numero de frames distinto a algun otro XML.\nSe deben ingresar un conjunto de XML con igual numero de frame', list_XML{i});
        disp(str_warning)
    end
    num_cam = vec_cams(i);%numero de la camara que se trabaja en esta iteracion    
    %ingreso los datos de la camara i a la estructura cam.mat
    cam{num_cam} = set_info(cam(num_cam), 'name', i); %ingreso el numero de camara
    cam{num_cam} = set_info(cam(num_cam), 'n_frames', n_frames); %ingreso el numero de frames 
    resolution = get_info(cam(num_cam), 'resolution');  %resolution = [res_x, res_y], obtengo las resoluciones horizontal y vertical
    for j =1:n_frames %hacer para todos los frames
        if isfield(Frames{j}, 'Marker') %Si existen marcadores en el frame j
            Markers = Frames{j}.Marker;
            n_markers = size(Markers, 2);
%             if (i==17)&&(j==92)
%             disp('__________')
%             end
            markers= set_coordinate_origin(resolution(2), Markers, n_markers); %llevo de coordenadas pixel en estructura Marker, a coordenadas cartesianas en matriz markers
            
            cam{num_cam} = set_info(cam(num_cam), 'frame', j, 'n_markers', n_markers);%dejo almacenado cuantos marcadores tiene este frame
            index_frame = 1:n_markers;
            cam{num_cam} = set_info(cam(num_cam), 'frame', j, 'marker', index_frame, 'coord', markers); %setea con las columnas de "markers" las coordenadas de los marcadores en 'index_frame' del frame j de la camara        
        else %si el frame j no tiene marcadores 
            cam{num_cam} = set_info(cam(num_cam), 'frame', j, 'n_markers', 0 );%dejo almacenado cuantos marcadores tiene este frame
        end
        
    end
    
    
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
