function [xi, xd, index_table, d_min]= cam2cam(varargin)
%Funcion que devuelve en el frame "n_frame"
%los coorespondientes "n_points" mejores puntos xd's de la camara cam_d,
%para los xi de entrada pertenecientes a la camara cam_i, ordenados de mejor a peor.
% Por lo tanto se logra un estimativo de la correspondencia de puntos entre
% dos vistas
%% Entrada
%cam_i = varargin{1};%camara "izquierda" o de origen
%cam_d = varargin{2};%camara "derecha" o de destino 
%n_frame = varargin{3}; %numero de frame 
%index_xi -->vector con indices de marcadores de cam_i en frame n_frame a proyectar sobre cam_d 
%n_points ----->indica la cantidad de puntos a devolver de la camara derecha ordenados por cercania a la recta ld. Otra manera de decirlo nro de puntos mas cercanos a devolver.
%umbral ------->indica la maxima distancia a la recta epipolar de xi para buscar puntos xd que se correspondan, las unidades son en pixeles
%% Salida
% xi   ----------->vector cuyas columnas son coordenadas de marcadores en el frame n_frame de camara cam_i 
% xd   ----------->cell array cuyos elementos son los mejores "n_points" puntos asociados a un coorespondiente xi
%                   EJEMPLO: xd{1} devuelve una matriz cuyas columnas son los "n_points" puntos de cam_d asociados al punto xi(:,1) de cam_i. 
%                   Ordenados de mejor a peor, esto quiere decir que la primer columna de x{1} es el punto mas cercano a la recta epipolar de xi. 
% d_min  --------->matriz ordenada con las distancias entre rectas epipolares y puntos
%                   d_min(i, j) indica la distancia entre la recta epipolar del punto index_table(i, 1) de cam_i con el punto index_table(i, j+1)
%                   en coordenadas de pixel
% index_table ---->matriz con las correspondencias entre indices. 
%                   index_table(i, 1) indica el indice del punto xi(:,i), el resto de la fila i son los indices de los puntos xd ordenados por
%                   cercania a la recta ld asociada al punto xi(:,i)
%                   O sea index_table(i, j) indica el indice del punto xd{i}(:,j)
% Para ver estos detalles claramente correr los ejemplos y ver las salidas.
            
%% EJEMPLOS
%       n_frame = 1;
%       index_xi = [1 2];
%       [xi, xd, index_table, d_min]= cam2cam(cam(1), cam(2), n_frame, 'index', index_xi)%devuelve todos los puntos de cam(1) del frame n_frame con indice en index_xi y sus correspondientes contrapartes xd de cam(2)
%       [xi, xd, index_table, d_min]= cam2cam(cam(1), cam(2), n_frame) %devuelve todos los puntos xi de cam1 y sus correspondientes contrapartes xd de cam2
%       [xi, xd, index_table, d_min]= cam2cam(cam(1), cam(2), n_frame, 'show') %a diferencia de la linea anterior se devuelven
%       %index_table y d_min no como cell sino como matrices, facilitando la visualizacion por consola de los resultados, el parametro 'show'
%       %puede ponerse siempre
%       [xi, xd, index_table, d_min]= cam2cam(cam(1), cam(2), n_frame, 'index', index_xi, 'n_points', 2)%devuelve todos los puntos de cam(1) del
%       %frame n_frame con indice en index_xi y sus correspondientes 2 mejores contrapartes xd's de cam(2), ordenadas de mejor a peor.
%       [xi, xd, index_table, d_min]= cam2cam(cam(1), cam(2), n_frame, 'n_points', 2) %devuelve todos los puntos xi de cam1 y sus
%       %correspondientes 2 mejores contrapartes xd's de cam2. O sea que para un xi devuelve los 2 puntos mas cercanos a la recta ld=F*xi de la camara cam2 
%       [xi, xd, index_table, d_min]= cam2cam(cam(1), cam(2), n_frame, 'umbral', 1) %devuelve todos los puntos de cam(1) del
%       %frame n_frame con indice en index_xi y sus correspondientes contrapartes xd's de cam(2) que se encuentren a una distancia menor a "umbral" de la recta epipolar.
%IMPORTANTE -->luego de correr cam2cam se puede ver si existe algun punto cuya asociacion es dudosa
% imponiendo un "umbral" que de cuenta de la distancia maxima que puede tener el correspondiente punto de cam_d con la recta epipolar de xi. 
% Los indices de puntos xi con asociacion dudosa pueden encontrarse con:
%       index_table ( find(d_min(:,1) > umbral) , 1 ) %se debe tener tanto index_table como d_min en forma matricial
%% CUERPO DE LA FUNCION

    %proceso la entrada
    cam_i = varargin{1};%camara "izquierda" o de origen
    cam_d = varargin{2};%camara "derecha" o de destino 
    n_frame = varargin{3};%numero de frame  
    location_index = find(strcmp(varargin, 'index'), 1);
    location_n_points = find(strcmp(varargin, 'n_points'), 1); 
    location_umbral = find(strcmp(varargin, 'umbral'), 1);  
    visual = find(strcmp(varargin, 'show'), 1);  
    
    n_markers_i = get_info(cam_i,'frame', n_frame, 'n_markers'); %numero de marcadores en la camara izquierda
    n_markers_d = get_info(cam_d,'frame', n_frame, 'n_markers'); %numero de marcadores en la camara derecha
    
    if isempty(location_index) %si no se ingreso un indice
        %index_xi = [1:get_info(cam_i,'frame', n_frame, 'n_markers')];%genero un indice para cada marcadores de cam_i en el frame n_frame
        index_xi = [1:n_markers_i];%genero un indice para cada marcadores de cam_i en el frame n_frame
    else % se ingreso un indice
        index_xi=varargin{ location_index + 1};%la entrada que le sigue a string 'index' es el indice    
    end
    
    if (isempty(location_umbral)) %si no se ingreso un umbral
        if (isempty(location_n_points)) % si no se ingreso numero minimo de puntos cercanos a devolver
            n_points = 1;%solo se devuelve el primer minimo
        else %se ingreso numero minimo de puntos cercanos a devolver
            %n_points= varargin{ find(strcmp(varargin, 'n_points'))+1};%la entrada que le sigue a string 'umbral' es el valor de umbral
            n_points= varargin{location_n_points +1};%la entrada que le sigue a string 'n_points' es el valor de n_points        
        end
    else %se ingreso un umbral
        umbral = varargin{location_umbral +1};%la entrada que le sigue a string 'umbral' es el valor de umbral  
        n_points = n_markers_d;%hago que se ordenen por cercania a la recta epipolar todos los puntos de la camara derecha
    end
                
    %encuentro cuantos puntos xi quiero proyectar en cam_d
    n_xi = size(index_xi, 2);
    
    %genero salidas    
    xi = get_info(cam_i,'frame', n_frame,'marker', index_xi, 'coord');%vector con los puntos de cam_i en frame n_frame a proyectar sobre cam_d     
    
    if (n_xi == 1) %tengo un solo punto xi para proyectar
        [xd, index_table, d_min] = xd_from_xi(cam_i, cam_d, n_frame, 'point', xi, index_xi, 'n_points', n_points);
        %devuelvo un cell array a menos que se utilice 'show' como parametro de entrada
        index_table = {index_table};
        d_min = {d_min};
    else %tengo mas de un punto
        %inicializo salidas
        xd=cell(1, n_xi);
        %index_table=ones(n_xi, n_points+1);%la cantidad de filas viene dado por la cantidad de puntos a proyectar, mientras que las columnas se corresponden con la cantidad de minimos a mostrar
        %d_min=ones(n_xi, n_points);
        index_table=cell(1,n_xi);%se tiene un elemento por punto a proyectar
        d_min=cell(1,n_xi);
        for j=1:n_xi%para todos los puntos xi a proyectar
            %[xd{j}, index_table(j, :), d_min(j,:)] = xd_from_xi(cam_i, cam_d, n_frame, 'point', xi(:,j), index_xi(j), 'n_points', n_points);    
            [xd{j}, index_table{j}, d_min{j}] = xd_from_xi(cam_i, cam_d, n_frame, 'point', xi(:,j), index_xi(j), 'n_points', n_points);    
        end
    end
    
   if (~isempty(location_umbral))%si se ingreso un umbral efectuo un tratamiento extra para devolver solo aquellos puntos que verifican el umbral   
       aux_d_min = cell2mat(d_min)';%genero una matriz con los valores de d_min, lo puedo hacer en esta instancia pues todos los elementos del cell tienen igual dimension
       [row, column]=find(aux_d_min < umbral); %encuentro los puntos que verifican la condicion de umbral
       %max_n_points = 0;%necesito saber cual fue la maxima cantidad de puntos que verificaron umbral 
       for j=1:n_xi %para cada punto xi a proyectar
           rows_j = find(row==j);%encuentro las filas asociadas al marcador i de cam_i que verificaron la condicion umbral
           n_points = length(rows_j); %solo me intereza saber cuantos puntos del marcador i verifican la condicion de umbral
           %index_table(j,(n_points+2):(n_markers_d+1) ) = -1;% anulo los indices de los puntos que no cumplen la condicion de umbral %el agregado de +2 y +1 en las columnas es por la naturaleza de index_table (los puntos xd aparecen a partir de la segunda columna)
           %d_min(j, (n_points +1):n_markers_d) = -1;%anulo las distancias de los puntos que no cumplen la condicion de umbral 
           index_table{j}=index_table{j}(1:n_points+1);% me quedo solo con los indices de puntos que verificaron umbral
           d_min{j}=d_min{j}(1:n_points);% me quedo solo con las distancias de puntos que verificaron umbral
           xd{j}=xd{j}(:, 1:n_points);%dejo en xd{i} solo aquellos puntos que verifican la condicion de umbral, como originalmente xd{i} ya esta ordenado de menor a mayor distancia, unicamente me quedo con los n_points primeros            
           %             if (max_n_points < n_points)%actualizo el maximo
           %                 max_n_points = n_points;
           %             end
       end
       %         %borro lo que no contiene informacion util
       %         index_table = index_table(:,1:(max_n_points+1))
       %         d_min = d_min(:,1:max_n_points)   
   end
   
   if ~isempty(visual)%se quiere devolver matrices y no cell array para visualizar los valores en consola
       [index_table, d_min]=show(index_table, d_min);
   end
   
end
          

 function [xd, index_table, d_min] = xd_from_xi(varargin)
% Funcion que devuelve los n_points puntos xd de la camara cam_d que minimizan
% |xd'*(F*xi)|, donde xi pertenece a la camara cam_i.
% Se logra un estimativo de la correspondencia de puntos entre
% dos vistas
%% Entrada
% 
% cam_i ---->camara "izquierda" o de origen
% cam_d ---->camara "derecha" o de destino
% n_frame -->numero de frame
% t_var -->string que indica el tipo de variable que se introduce a continuacion
%       t_var = {'point' 'umbral'}
% xi -->punto de la camara cam_i
% index_xi(j) -->indice del punto xi (se decide ingresarlo junto al punto para ahorrar tiempo preguntando alguno de los dos en este nivel del programa)
% n_points ---->escalar que indica el numero de marcadores mas cercanos a
%           devolver
%% Salida
% xd   ---->n_points puntos de la camara cam_d asociados a xi en orden de
%           importancia
% d_min  -->minimo distancia a la recta epipolar en unidades de pixel
% index_table   -->vector donde la primer columna es el indice de xi y la segunda del xd asociado
%% EJEMPLOS
%   [xd, index_table, d_min] = cam2cam2(cam(1), cam(2), 100, 'point', xi, 'n_points', 1)
%   [xd, index_table, d_min] = cam2cam2(cam(1), cam(2), 100, 'point', xi, 'n_points', 10)
%% CUERPO DE LA FUNCION
%     proceso la entrada
    cam_i=varargin{1}; 
    cam_d=varargin{2};
    n_frame = varargin{3};
    xi=varargin{ find(strcmp(varargin, 'point'))+1};%la entrada que le sigue a string 'index' es el indice
    index_xi = varargin{ find(strcmp(varargin, 'point'))+2};%la entrada que le sigue a string 'index' es el indice
    if isempty(find(strcmp(varargin, 'n_points'))+1)
        n_points = 1;%solo se devuelve el primer minimo
    else
        n_points= varargin{ find(strcmp(varargin, 'n_points'))+1};%la entrada que le sigue a string 'umbral' es el valor de umbral        
    end
   

    %obtengo las matrices de proyeccion
    Pi = get_info(cam_i, 'projection_matrix');
    Pd = get_info(cam_d, 'projection_matrix');       
    %obtengo las rectas epipolares y los puntos de cam_d
    ld = recta_epipolar(Pi, Pd, xi);
    xd = get_info(cam_d,'frame', n_frame, 'marker', 'coord'); %obtengo todos las coordenadas de los marcadores en el frame n_frame de la camara derecha (destino)
        
    %encuentro las correspondencias y genero salida    
    if (n_points==1) %encuentro el primer punto mas cercano
        index_table = ones(1, 2); %inicializo la tabla de indices
        [d_min, index_table(2)]=min(abs(xd'*ld));%encuentro el punto xd que minimice la metrica |xd'*ld| (o sea que el punto que mejor verifique la ecuacion de la recta, un valor grande con esta metrica indica una mayor distancia del punto a la recta)
        %igual a encontrar el valor de (xd'*ld) mas cercano al cero (agradecer simplicidad a que utilizamos coordenadas homogeneas ;) )
        %esta distancia d_min es igual a la distancia euclidea entre el punto y la recta a menos de una constante 
        %d_min_euclidea = d_min_homogenea/sqrt((b/c)^2+(a/c)^2), donde la recta ld:ax+by+c=0, o sea ld=(a/c, b/c, 1) en homogeneas normalizadas
        
    else %de lo contrario encuentro todos los primeros n puntos minimos que indique umbral
        %inicializo la salida
        index_table = ones(1, n_points+1);
        d_min = ones(1, n_points);
        [d_min, index_table]=minimos(xd, ld, n_points);%encuentro los puntos xd que minimice la metrica |xd'*ld| (o sea que el punto que mejor verifique la ecuacion de la recta, un valor grande con esta metrica indica una mayor distancia del punto a la recta)
        %igual a encontrar el valor de (xd'*ld) mas cercano al cero (agradecer simplicidad a que utilizamos coordenadas homogeneas ;) )
    end  
    
    %transformo d_min a distancias euclideas (unidades pixel)
    d_min = d_min./sqrt( ld(2)^2+ld(1)^2 );
    
    xd=xd(:,index_table(2:length(index_table))); %devuelvo solo los minimos encontrados
    index_table(1)=index_xi; %agrego en la primera columna de tabla de indices el indice de xi
%     %%%%PARA DEBUG 
%     figure(1);hold on; plot_frames(cam_i,  'frame', 1, 'num')
%     figure(2);hold on; plot_frames(cam_d,  'frame', 1, 'num')  
%     figure(2);hold on; plot_rectas(ld)
end

function [d_min, index_table] = minimos(xd, ld, n_points)
%Funcion que devuelve los primeros n minimos de abs(xd'*ld)
%% Entrada
%xd -->conjunto de puntos de camara derecha
%ld -->recta en coordenadas homogeneas
%n_points --->nro de puntos mas cercanos a devolver

%% Salida
%d_min -->distancia minima de los n puntos encontrados 
%index_table -->indice de los n puntos de xd encontrados 

%% Cuerpo de la funcion
    %metrica a encontrar minimos
    d = abs(xd'*ld);    
    
    %manera 1 de hacerlo    
    [d index_origin] = sort(d);%ordeno los valores de menor a mayor y conservo los indices iniciales
    d_min = d(1:n_points);
    index_table = ones(1, n_points+1);
    index_table(2: n_points+1) = index_origin(1:n_points);
    
    %manera 2 de hacerlo
%    %inicializo la salida   
%     index_table = ones(1, n_points+1);
%     d_min = ones(1, n_points);
%     for i=1:n_points %repetir n_points veces, para encontrar los n_points primeros minimos
%         [d_min(i), index_table(i+1)]= min(abs(d));%guardo la minima distancia
%         d(index_table(i+1))=inf;%lo saco de la busqueda
%     end
%     
end

function [index_table_out, d_min_out] = show(index_table, d_min)
% Funcion que devuelve index_table y d_min como matrices en lugar de cell. Los lugares que no ofrecen datos de interes se rellenan con -1
    n_xi = length(d_min);
    n_max = ones(n_xi, 1); %utilizo esta variable para saber el maximo de puntos xd encontrados en un xi 
    for j=1:n_xi %para cada punto xi proyectado
        n_max(j) = length(d_min{j});
    end    
    index_table_out = -ones(n_xi, max(n_max)+1);%genero una matriz que pueda albergar todos los indices xd, el +1 es por la naturaleza de index_table
    d_min_out = -ones(n_xi, max(n_max));%genero una matriz que pueda albergar todos las distancias
    for j=1:n_xi %para cada punto xi proyectado
        index_table_out(j,1:(n_max(j)+1)) = index_table{j};
        d_min_out(j, 1:n_max(j)) = d_min{j};
    end    
end



