function plot_frames(varargin)
% Función que permite plotear un cierto numero de frames de secuencias contenidas en estructura cam(i) o skeleton
%% Entradas
% structure -->estructura cam(i) o skeleton
% properties --> una lista de propiedades donde cada una se componen de un string y un valor asociado, o solo un string. Pueden ir en cualquier orden
%                 'init_frame'-->indica que el siguiente parametro es el frame inicial a visualizar, si no se indica la secuencia empieza desde el frame 1
%                 'last_frame'-->indica que el siguiente parametro es el frame final a visualizar, si no si indica la secuencia termina en su ultimo frame disponible
%                 'frame'     -->indica que el siguiente parametro es el unico frame a visualizar
%                 'n_prev'-->indica que el siguiente parametro es la cantidad de frames previos se desean visualizar, si no se indica n_prev=0
%                 'coord' -->si se coloca agrega como etiquetas las coordenadas de todos los marcadores 
%                 'num'   -->agrega como etiquetas el numero de cada marcador en dicho frame  
%                 'name'  -->si se coloca agrega como etiquetas los nombres de todos los marcadores 
%                 'marker'-->indica que el siguiente parametro es un vector con la lista de marcadores a plotear, si no se coloca se asume que se quiere devolver todos los marcadores
%                 'fill'  -->si se coloca indica que los marcadores deben tener un relleno de color asociado a su parametro de calidad state (rojo si state=1 y verde si state=0)

%% EJEMPLOS
% structure = cam(1);
% plot_frames(structure,  'frame', 1) %plotea el frame 1 de la estructura structure 
% plot_frames(structure,  'frame', 1, 'coord') %plotea todos los puntos del frame 1 de la estructura structure e indica sus coordenadas hasta el final
% plot_frames(structure,   'frame', 1, 'num') %plotea todos los puntos del frame 1 de la estructura structure e indica el numero de marcador
% plot_frames(structure,  'frame', 1, 'name') %plotea todos los puntos del frame 1 de la estructura structure e indica sus nombres hasta el final
% plot_frames(structure,  'frame', 1, 'fill') %plotea todos los puntos del frame 1 de la estructura structure e indica sus nombres hasta el final
% plot_frames(structure,  'frame', 1,  'marker', [1 2]) %plotea los marcadores 1 y 2 del frame 1 hasta el final
% plot_frames(structure,  'frame', 1,  'marker', [1 2], 'fill') %plotea los marcadores 1 y 2 del frame 1 y rellena marcadores con colores hasta el final
% plot_frames(structure,  'frame', 1,  'marker', [1 2], 'coord') %plotea los marcadores 1 y 2 del frame 1 e indica sus coordenadas hasta el final
% plot_frames(structure,  'frame', 1,  'marker', [1 2], 'name') %plotea los marcadores 1 y 2 del frame 1 e indica sus nombres hasta el final
% plot_frames(structure,  'frame', 1,  'marker', [1 2], 'coord', 'fill') %plotea los marcadores 1 y 2 del frame 1, indica sus coordenadas y rellena con colores hasta el final
% plot_frames(structure,  'frame', 1,  'marker', [1 2], 'name', 'fill') %plotea los marcadores 1 y 2 del frame 1, indica sus nombres y rellena con colores hasta el final
% plot_frames(structure,  'frame', 1, 'last_frame', 4) %plotea todos los puntos desde el frame 1 de la estructura structure hasta el frame 4
% plot_frames(structure,  'frame', 1, 'last_frame', 20, 'n_prev', 3) %plotea todos los puntos desde el frame 1 de la estructura structure hasta el frame 20 y se muestran los 3 previos
% plot_frames(structure,  'frame', 40, 'n_prev', 3) %plotea todos los puntos desde el frame 1 de la estructura structure hasta el frame 20 y se muestran los 3 previos
%% Cuerpo de la funcion

% proceso la entrada
structure = varargin{1};
%verifico que parametros existen
index_init = find(strcmp(varargin, 'init_frame'));
index_last = find(strcmp(varargin, 'last_frame'));
index_frame = find(strcmp(varargin, 'frame'));
index_prev = find(strcmp(varargin, 'n_prev'));
any_name = any(strcmp(varargin, 'name'));
any_coord = any(strcmp(varargin, 'coord'));
any_num = any(strcmp(varargin, 'num'));
any_fill = any(strcmp(varargin, 'fill'));
index_marker = find(strcmp(varargin, 'marker'));


%gestion de parametros que afectan iteracion
if ~isempty(index_init) %si existe un indice inicial de frame se ingresa
    init_frame = varargin{index_init+1};
else %de lo contrario se empieza desde el primer frame
    init_frame = 1;
end

if ~isempty(index_last) %si existe un indice final de frame se ingresa
    last_frame = varargin{index_last+1};
else %de lo contrario se termina en el ultimo frame
    last_frame = get_info(structure, 'n_frames');
end

if ~isempty(index_frame) %no se quiere iterar simplemente se quiere un frame (no podemos tener parametros init_frame o last_frame)    
    init_frame = varargin{index_frame+1};
    last_frame = init_frame;
    if ~(isempty(index_init)||isempty(index_last>1)) %no estan vacios los parametros imcompatibles con 'frame'
        str = ['Se a ingresado parametros incompatibles de frame '];
        error('frame:IndicesIncompatibles',str)
        return
    end
elseif (isempty(index_init>1)||isempty(index_last>1)) %simplemente no se ingreso nada
    str = ['Debe ingresarse algun parametro para frame '];
    error('frame:IndicesInexistentes',str)
    return
end



if ~isempty(index_prev) %si existe un indice final de frame se ingresa
    n_prev = varargin{index_prev+1};    
else %de lo contrario no se tienen frames previos
    n_prev = 0;
end


%gestion de argumentos de entrada que afectan los parametros para llamar a plot_one_frame
if ~isempty(index_marker) %si existe un indice de marcadores se ingresa
    marker = varargin{index_marker+1};
    str_marker = sprintf(', ''marker'', marker');
else
    str_marker = sprintf('');%texto vacio pues no se ingresa lista con  marcadores
end


if any_num %si existe el texto 'num'
    str_label = sprintf(', ''num''');
elseif any_coord %si existe el texto 'coord'
    str_label = sprintf(', ''coord''');
elseif any_name %si existe el texto 'name'
    str_label = sprintf(', ''name''');
else
    str_label = sprintf('');%texto vacio
end

if any_fill %si existe el texto 'fill'
    str_fill = sprintf(', ''fill''');
else
    str_fill = sprintf('');%texto vacio
end


%iteraciones
str = [sprintf('plot_one_frame(structure, k'), str_marker, str_label, str_fill, ')'];
str2 = [sprintf('plot_one_frame(structure, j'), str_marker ', ''tiny'')'];%este llamado se deja para marcadores previos
%frame_rate=get_info(structure, 'frame_rate');%por si quiero ver el frame rate original
for k = init_frame:last_frame
    %tic
    eval(str) 
    %toc
    %%%%%%ESTE CICLO FOR SE QUITARIA si UTILIZO LAS TRAYECTORIAS DIRECTAMENTE, O SEA SACO LOS INDICES DE UNA TRAYECTORIA, RECOLECTO LOS PUNTOS Y LUEGO PLOTEAR
    %%%%%%OTRA ES RECOLECTAR PUNTOS DE FRAME Y LUEGO PLOTEAR, PARA ELLO DEBO CAMBIAR LA FORMA DE PLOT_ONE_FRAME O UTILIZAR OTRA FUNCION QUE ES LO
    %%%%%%MAS RAZONABLE CREO, ALGUNA LLAMADA PLOT_PATH
    if (k-n_prev<=0)%quiere decir que algunos frames previos que se piden no existen, en ese caso empiezo desde el frame 1        
        hold on
        for j=1:(k-1) 
            eval(str2)
        end 
        
        hold off
    elseif (n_prev~=0) %no se quieren marcadores previos o se tienen todos listos para plotear         
        hold on
        for j=(k-n_prev):(k-1)
            eval(str2)
        end
        hold off
    end
    pause(0.002)%esta linea esta solo para que se vean todos los frames
end


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
    xlabel('\fontsize{11}{x (metros)}', 'fontweight','b');
    ylabel('\fontsize{11}{y (metros)}','fontweight','b');
    zlabel('\fontsize{11}{z (metros)}','fontweight','b');
    str = sprintf('Secuencia de %s. \n Frame %d de %d.',t_structure, n_frame, last_frame);
 
else %se tiene una estructura camara
    
    %genero relleno de marcadores
%     if (any_fill)&&(~any_tiny) %se quieren marcadores con relleno y que no sean puntos
%          h_scatter=scatter(x, y,...%coordenadas
%              70, ...%tamano de marcadores, debe haber uno por cada marcador
%              color, 'fill' ...%colores de los marcadores acorde al estado de los mismos
%              ); 
%     else %se quieren marcadores sin relleno
%          h_scatter=scatter(x, y, ...%coordenadas
%              70 ...%tamano de marcadores, debe haber uno por cada marcador
%                  ); 
%     end
     plot(x, y, 'rx', 'LineWidth', 2)


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
     
%      %titulo y nombre de ejes
%      xlabel('\fontsize{11}{x (pixeles)}', 'fontweight','b');
%      ylabel('\fontsize{11}{y (pixeles)}','fontweight','b');
%      str = sprintf('Secuencia de camara %d. \n Frame %d de %d.',t_structure, n_frame, last_frame); %genero titulo
end

% %propiedades comunes a ambos ploteos
% if any_tiny
%     set(h_scatter, 'MarkerEdgeColor', 'k', 'LineWidth', 2, 'Marker', '.');%marcadores como puntos
% else
%     set(h_scatter, 'MarkerEdgeColor', 'k', 'LineWidth', 2 );%marcadores normales
% end
% title(['\fontsize{14}{',str, '}'],'fontweight','b');%coloco el titulo
% grid minor

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




