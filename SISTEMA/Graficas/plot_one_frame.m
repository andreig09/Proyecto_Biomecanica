function plot_one_frame(varargin)
% Función que permite plotear un frame de secuencias contenidas en estructura cam(i) o skeleton
%% Entradas
% structure -->estructura cam(i) o skeleton
% n_frame ---->numero de frame a plotear
% properties --> una lista de propiedades donde cada una se componen de un string y un valor asociado, o solo un string. Pueden ir en cualquier orden
%                 'coord' -->agrega como etiquetas las coordenadas de todos los marcadores 
%                 'num'   -->agrega como etiquetas el numero de cada marcador en dicho frame  
%                 'name'  -->agrega como etiquetas los nombres de todos los marcadores 
%                 'marker'-->indica que el siguiente parametro es un vector con la lista de marcadores a plotear
%                 'fill'  -->indica que los marcadores deben tener un relleno de color asociado a su parametro de calidad state (rojo si state=1 y verde si state=0)
%                 'tiny'  -->indica que se quieren los marcadores diminutos (esta opcion sirve para visualizar las trayectorias)
                 
%% EJEMPLOS
% structure = cam(1);
% plot_one_frame(structure,  1) %plotea todos los puntos del frame 1 de la estructura structure
% plot_one_frame(structure,  1, 'coord') %plotea todos los puntos del frame 1 de la estructura structure e indica sus coordenadas
% plot_one_frame(structure,  1, 'num') %plotea todos los puntos del frame 1 de la estructura structure e indica el numero de marcador
% plot_one_frame(structure,  1, 'name') %plotea todos los puntos del frame 1 de la estructura structure e indica sus nombres
% plot_one_frame(structure,  1, 'fill') %plotea todos los puntos del frame 1 de la estructura structure e indica sus nombres
% plot_one_frame(structure,  1,  'marker', [1 2]) %plotea los marcadores 1 y 2 del frame 1
% plot_one_frame(structure,  1,  'marker', [1 2], 'fill') %plotea los marcadores 1 y 2 del frame 1 y rellena marcadores con colores
% plot_one_frame(structure,  1,  'marker', [1 2], 'coord') %plotea los marcadores 1 y 2 del frame 1 e indica sus coordenadas
% plot_one_frame(structure,  1,  'marker', [1 2], 'name') %plotea los marcadores 1 y 2 del frame 1 e indica sus nombres
% plot_one_frame(structure,  1,  'marker', [1 2], 'coord', 'fill') %plotea los marcadores 1 y 2 del frame 1, indica sus coordenadas y rellena con colores
% plot_one_frame(structure,  1,  'marker', [1 2], 'name', 'fill') %plotea los marcadores 1 y 2 del frame 1, indica sus nombres y rellena con colores


%% Cuerpo de la función

% proceso la entrada
structure = varargin{1};
n_frame = varargin{2};
any_name = any(strcmp(varargin, 'name'));%verifico que parametros existen
any_coord = any(strcmp(varargin, 'coord'));
any_num = any(strcmp(varargin, 'num'));
any_fill = any(strcmp(varargin, 'fill'));
any_tiny =  any(strcmp(varargin, 'tiny'));
index_marker = find(strcmp(varargin, 'marker'));
exist_label = any_name||any_coord||any_num;

%se gestiona la lista de marcadores a plotear
if isempty(index_marker) %no se ingresa lista de vectores
    n_markers = get_info(structure, 'frame', n_frame, 'n_markers'); %obtengo la cantidad de marcadores en el frame n_frame
    list_markers = [1:n_markers];%genero una lista con indices para todos ellos    
else %se ingresa lista con vectores a continuacion del parametro 'marker'
    list_markers = varargin{index_marker+1};
end

marker = get_info(structure,'frame', n_frame, 'marker', list_markers );%obtengo las coordenadas de los marcadores de interes

%se gestionan las etiquetas

if (any_name)&&(~any_coord) %si algun parametro es 'name' y no se encuentra 'coord', entonces devuelvo etiquetas nombres
    t_label =get_info(structure, 'frame',n_frame , 'marker', list_markers, 'name'); %cargo los nombres como etiquetas para plotear
    %exist_label = 1; %aviso que hay etiqueta
elseif (any_coord)%si algun argumento es 'coord' y no se encuentra 'name' entonces devuelvo coordenadas    
    t_label = coord2string(marker);
    %exist_label = 1; %aviso que hay etiqueta 
elseif (any_num) %por ultimo se revisa que no se esten pidiendo etiquetas num
    t_label = num2cell(list_markers);
    for i=1:length(t_label) %llevo los numeros a string
        t_label{i} = num2str(t_label{i}); 
    end
    %exist_label = 1
else %si llegue hasta aqui es que no hay etiquetas
    exist_label = 0;
end



%Cargo parametros de interes
t_structure = get_info(structure, 'name');%tipo de estructura 
last_frame = get_info(structure, 'n_frames');%ultimo frame de la estructura
state = get_info(structure, 'frame', n_frame, 'marker', list_markers, 'state'); %los colores de los marcadores van a depender del parametro state
color=[state', ones(size(state'))-state' ,zeros(size(state')) ];%genero el color para scatter, cuando state vale 1 color rojo, cuando vale 0 color verde


x = marker(1,:);%coordenada x
y = marker(2,:);%coordenada y

if strfind(t_structure, 'skeleton') %si el nombre de la estructura tiene la palabra skeleton entonces es una estructura skeleton 
    z=marker(3,:);%coordenada z 
    
    %genero relleno de marcadores
    if (any_fill)&&(~any_tiny) %se quieren marcadores con relleno         
            h_scatter=scatter3(x, y, z,...%coordenadas
             70, ...%tamano de marcadores, debe haber uno por cada marcador
             color, 'fill' ...%colores de los marcadores acorde al estado de los mismos
             );        
    else %se quieren marcadores sin relleno
         h_scatter=scatter3(x, y, z, ...%coordenadas
             70 ...%tamano de marcadores, debe haber uno por cada marcador
             ); 
    end
    
    %genero ejes 
    Xmin = [-2  -5  0]; %cargo dimensiones de desplazamiento en metros
    Xmax = [2   0  1.8];
    axis([Xmin(1) Xmax(1) Xmin(2) Xmax(2) Xmin(3) Xmax(3)])  
    
    %agrego etiquetas a los marcadores
    if exist_label == 1 % si se piden etiquetas las ingreso
        h_text=text(x, y, z, ...%cooordenadas
            t_label... %etiquetas
            );
        set(h_text,  'VerticalAlignment','bottom', 'HorizontalAlignment','right', 'FontSize',10, 'fontweight','b', 'Color', 'b')%opciones para el texto
    end
    
    %titulo y nombre de ejes
    xlabel({'x metros'}, 'FontSize', 16, 'FontWeight','b', 'FontName', 'Times');
    ylabel({'y metros'}, 'FontSize', 16, 'FontWeight','b', 'FontName', 'Times');
    zlabel({'z metros'}, 'FontSize', 16, 'FontWeight','b', 'FontName', 'Times');
    str = sprintf('Secuencia de %s. \n Frame %d de %d.',t_structure, n_frame, last_frame);
 
else %se tiene una estructura camara
    
    %genero relleno de marcadores
    if (any_fill)&&(~any_tiny) %se quieren marcadores con relleno y que no sean puntos
         h_scatter=scatter(x, y,...%coordenadas
             70, ...%tamano de marcadores, debe haber uno por cada marcador
             color, 'fill' ...%colores de los marcadores acorde al estado de los mismos
             ); 
    else %se quieren marcadores sin relleno
         h_scatter=scatter(x, y, ...%coordenadas
             70 ...%tamano de marcadores, debe haber uno por cada marcador
                 ); 
    end
     


     %genero ejes 
     resolution = get_info(structure, 'resolution');
     if resolution(1)*resolution(2)~=0 %alguna resolucion es nula             
     axis([0 resolution(1) 0 resolution(2)])  
     else
         axis equal
     end
     
     %agrego etiquetas a los marcadores
     if exist_label == 1 % si se piden etiquetas las ingreso
         h_text=text(x,...%coordenada x 
             y,...%coordenada y
             t_label);
         set(h_text,  'VerticalAlignment','bottom', 'HorizontalAlignment','right', 'FontSize',10, 'fontweight','b', 'Color', 'b')%opciones para el texto
     end
     
     %titulo y nombre de ejes
     xlabel({'x pixeles'}, 'FontSize', 16, 'FontWeight','b', 'FontName', 'Times');
    ylabel({'y pixeles'}, 'FontSize', 16, 'FontWeight','b', 'FontName', 'Times');
     str = sprintf('Secuencia de camara %s. \n Frame %d de %d.',t_structure, n_frame, last_frame); %genero titulo
end

%propiedades comunes a ambos ploteos
if any_tiny
    set(h_scatter, 'MarkerEdgeColor', 'k', 'LineWidth', 2, 'Marker', '.');%marcadores como puntos
else
    set(h_scatter, 'MarkerEdgeColor', 'k', 'LineWidth', 2 );%marcadores normales
end
title(str, 'FontSize', 20, 'FontWeight','b', 'FontName', 'Times', 'interpreter', 'none');%coloco el titulo
grid minor
set(gca,...
    'Units', 'normalized',...
    'FontUnits', 'points',...
    'FontWeight', 'normal', ...
    'FontSize', 12)

return

function marker_str =coord2string(marker)
%Devuelve las coordenadas en marker dentro de un cell en un cell array de string 
%% ENTRADA
%markers --> matriz cuyas columnas son conjunto de coordenadas para pasar a string
%% Cuerpo de la funcion 

    n_markers = size(marker, 2); %numero de marcadores
    marker_str = cell(1, n_markers) ; %marker_str es un cell array de string con las coordenadas de marker
    is_2D = ( marker(3,:)==ones(1, n_markers) );%verifico si tengo coordenadas homogeneas normalizadas 2D, para 2D solo se guardan este tipo de coord
    if is_2D
        marker = marker([1 2],:); %Me quedo con las dos primeras coordenadas que son las euclideas
        for j=1:n_markers %para todas los marcadores
            str=sprintf('( %0.2f , %0.2f )', marker(:,j));%paso columna j de numero a un string con dos numeros decimales
            marker_str{j}=str; %guardo string    
        end
    else
        for j=1:n_markers %para todas los marcadores
            str=sprintf('( %0.2f , %0.2f, %0.2f )', marker(:,j));%paso columna j de numero a un string con dos numeros decimales
            marker_str{j}=str; %guardo string
            %marker_str{2,j}=num2str(marker(2,j)); %paso fila 2 columna j de numero a un string
            %marker_str{3,j}=num2str(marker(3,j)); %paso fila 3 columna j de numero a un string
        end
    end
return