% structure21 = set_info(structure, 'frame', 1, 'marker', [2, 3], 'coord', info21); %setea con las columnas de "info21" las coordenadas de los marcadores 2 y 3 del frame 1 de structure
% structure22 = set_info(structure, 'frame', 1, 'marker', [2, 3], 'name', info22); %setea con las columnas del cell string "info22" los nombres de los marcadores 2 y 3 del frame 1 de s
function cam = markersXML2mat(n_cams, n_markers, n_frames, archivo)
%Funcion que lleva la informacion de una lista de marcadores desde un XML a la estructura de datos cam.mat 

%% ENTRADA
% n_cams -->numero de camaras, este parametro indica el numero de archivos XML a cargar
% n_markers -->numero de marcadores en el esqueleto 3D
% n_frames --> numero de frames utilizados 
% archivo -->string que indica la ubicacion del archivo XML asi como su 'prefijo'. Los archivos para distintas camaras de un unico experimento deben diferir
%           en el numero al final del nombre, por ejemplo los archivos de nombre saved_vars/camj.xml con j=1,2,...n_cams indican un unico experimento 
%           que contiene n_cams camaras. Para cargar todas las camaras con esta funcion se debe ingresar archivo =  'saved_vars/cam'
%           

%% SALIDA
% cam --> estructura de datos cam.mat 

%% CUERPO DE LA FUNCION

    %inicializo la estructura de salida acorde a las necesidades
        [cam, ~]=init_structs(n_markers, n_frames);
        str = 'Se ha inicializado una estructura cam';
        disp(str)
        
    for i=1:n_cams %para cada camara        
        
        %importo el archivo XML con los datos de interes
        archivo_aux = sprintf('%s%d.xml', archivo, i); %genero un string con el nombre del archivo a importar  
        %archivo = sprintf('saved_vars/markers_cam%d.xml', i); 
        str=['Cargando datos de ', archivo_aux];
        disp(str);
        frames_XML = importXML(archivo_aux); 
        
        %relevo informacion del XML asociado a la camara i
        index = str2num([frames_XML(:).name]); %obtengo los indices de los marcadores de cada frame y los ubico consecutivamente en un vector de enteros
        markers = [frames_XML(:).X]; %obtengo una matriz cuyas columnas son los marcadores de todos los frames
        markers(3,:) = ones(1,length(index)); %dejo los puntos 2D en coordenadas homogeneas normalizadas
        index_frames = find(index==1); %se tienen los indices donde se cambia de frame        
        
        %ingreso los datos de la camara i a la estructura cam.mat
        cam(i) = set_info(cam(i), 'name', i); %ingreso el numero de camara 
                
        n = length(index_frames);
        for j=1:(n-1) %para cada frame menos el ultimo            
            init_frame = index_frames(j);
            end_frame= index_frames(j+1)-1;
            index_in_frame = index(init_frame:end_frame ); %indices de los marcadores en el frame j
            markers_frame = markers(:,init_frame:end_frame ); %marcadores en el frame j
            cam(i) = set_info(cam(i), 'frame', j, 'marker', index_in_frame, 'coord', markers_frame); %setea con las columnas de "markers" las coordenadas de los marcadores en 'index_frame' del frame j de la camara                    
            cam(i) = set_info(cam(i), 'frame', j, 'n_markers', length(index_in_frame) );%dejo almacenado cuantos marcadores tiene este frame
        end
        index_in_frame = index(index_frames(n):length(index)); %indices de los marcadores en el frame j
        markers_frame = markers(:,index_frames(n):length(index)); %marcadores en el frame j
        cam(i) = set_info(cam(i), 'frame', n, 'marker', index_in_frame, 'coord', markers_frame); %setea con las columnas de "markers" las coordenadas de los marcadores en 'index_frame' del frame j de la camara        
        cam(i) = set_info(cam(i), 'frame', n, 'n_markers', length(index_in_frame) );%dejo almacenado cuantos marcadores tiene este frame
        
        str = sprintf('Se han ingresado los datos en la camara %d\n', i );
        disp(str)
    end
end