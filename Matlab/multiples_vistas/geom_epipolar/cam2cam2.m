function [xi, xd, index_table, d_min]= cam2cam(varargin)
%Funcion que devuelve en el frame "n_frame"
%los coorespondientes "n_min" mejores puntos xd's de la camara cam_d,
%para los xi de entrada pertenecientes a la camara cam_i, ordenados de mejor a peor.
% Por lo tanto se logra un estimativo de la correspondencia de puntos entre
% dos vistas
%% Entrada
%cam_i = varargin{1};%camara "izquierda" o de origen
%cam_d = varargin{2};%camara "derecha" o de destino 
%n_frame = varargin{3}; %numero de frame 
%index_xi -->vector con indices de marcadores de cam_i en frame n_frame a proyectar sobre cam_d 
%n_min ----->indica la cantidad de puntos a devolver de la camara derecha ordenados por cercania a la recta ld. Otra manera de decirlo nro de puntos mas cercanos a devolver.
%% Salida
% xi   ----------->vector cuyas columnas son coordenadas de marcadores en el frame n_frame de camara cam_i 
% xd   ----------->cell array cuyos elementos son los mejores "n_min" puntos asociados a un coorespondiente xi
%                   EJEMPLO: xd{1} devuelve una matriz cuyas columnas son los "n_min" puntos de cam_d asociados al punto xi(:,1) de cam_i. 
%                   Ordenados de mejor a peor, esto quiere decir que la primer columna de x{1} es el punto mas cercano a la recta epipolar de xi. 
% d_min  --------->matriz ordenada con las distancias entre rectas epipolares y puntos
%                   d_min(i, j) indica la distancia entre la recta epipolar del punto index_table(i, 1) de cam_i con el punto index_table(i, j+1)
% index_table ---->matriz con las correspondencias entre indices. 
%                   index_table(i, 1) indica el indice del punto xi(:,i), el resto de la fila i son los indices de los puntos xd ordenados por
%                   cercania a la recta ld asociada al punto xi(:,i)
%                   O sea index_table(i, j) indica el indice del punto xd{i}(:,j)
% Para ver estos detalles claramente correr los ejemplos y ver las salidas.
            
%% EJEMPLOS
%       n_frame = 1;
%       index_xi = [1 2];
%       [xi, xd, index_table, d_min]= cam2cam(cam(1), cam(2), n_frame, 'indice', index_xi)%devuelve todos los puntos de cam(1) del frame n_frame con indice en index_xi y sus correspondientes contrapartes xd de cam(2)
%       [xi, xd, index_table, d_min]= cam2cam(cam(1), cam(2), n_frame) %devuelve todos los puntos xi de cam1 y sus correspondientes contrapartes xd de cam2
%       [xi, xd, index_table, d_min]= cam2cam(cam(1), cam(2), n_frame, 'indice', index_xi, 'n_min', 2)%devuelve todos los puntos de cam(1) del
%       frame n_frame con indice en index_xi y sus correspondientes 2 mejores contrapartes xd's de cam(2), ordenadas de mejor a peor.
%       [xi, xd, index_table, d_min]= cam2cam(cam(1), cam(2), n_frame, 'n_min', 2) %devuelve todos los puntos xi de cam1 y sus
%       correspondientes 2 mejores contrapartes xd's de cam2. O sea que para un xi devuelve los 2 puntos mas cercanos a la recta ld=F*xi de la camara cam2 
 
%% CUERPO DE LA FUNCION

    %proceso la entrada
    cam_i = varargin{1};%camara "izquierda" o de origen
    cam_d = varargin{2};%camara "derecha" o de destino 
    n_frame = varargin{3};%numero de frame  
    location_indice = find(strcmp(varargin, 'indice'));
    location_n_min = find(strcmp(varargin, 'n_min')); 
    
    if isempty(location_indice)
        index_xi = [1:get_info(cam_i,'frame', n_frame, 'n_markers')];%genero un indice para cada marcadores de cam_i en el frame n_frame
    else
        index_xi=varargin{ location_indice + 1};%la entrada que le sigue a string 'indice' es el indice    
    end
    
    if isempty( location_n_min +1)
        n_min = 1;%solo se devuelve el primer minimo
    else
        n_min= varargin{ find(strcmp(varargin, 'n_min'))+1};%la entrada que le sigue a string 'umbral' es el valor de umbral        
    end
                
    %encuentro cuantos puntos xi quiero proyectar en cam_d
    n_xi = size(index_xi, 2);
    
    %genero salidas    
    xi = get_info(cam_i,'frame', n_frame,'marker', index_xi, 'coord');%vector con los puntos de cam_i en frame n_frame a proyectar sobre cam_d     
    
    if (n_xi == 1) %tengo un solo punto xi para proyectar
        [xd, index_table, d_min] = xd_from_xi(cam_i, cam_d, n_frame, 'punto', xi, 'n_min', n_min);
    else %tengo mas de un punto
        %inicializo salidas
        xd=cell(1, n_xi);
        index_table=ones(n_xi, n_min+1);%la cantidad de filas viene dado por la cantidad de puntos a proyectar, mientras que las columnas se corresponden con la cantidad de minimos a mostrar
        d_min=ones(n_xi, n_min);
        for j=1:n_xi%para todos los puntos xi a proyectar
            [xd{j}, index_table(j, :), d_min(j,:)] = xd_from_xi(cam_i, cam_d, n_frame, 'punto', xi(:,j), index_xi(j), 'n_min', n_min);    
            %[~, ~] = xd_from_xi(cam_i, cam_d, n_frame, 'punto', xi(:,j), index_xi(j), 'n_min', 1);    
        end
    end
    
end
          

 function [xd, index_table, d_min] = xd_from_xi(varargin)
% Funcion que devuelve los n_min puntos xd de la camara cam_d que minimizan
% |xd'*(F*xi)|, donde xi pertenece a la camara cam_i.
% Se logra un estimativo de la correspondencia de puntos entre
% dos vistas
%% Entrada
% 
% cam_i ---->camara "izquierda" o de origen
% cam_d ---->camara "derecha" o de destino
% n_frame -->numero de frame
% t_var -->string que indica el tipo de variable que se introduce a continuacion
%       t_var = {'punto' 'umbral'}
% xi -->punto de la camara cam_i
% index_xi(j) -->indice del punto xi (se decide ingresarlo junto al punto para ahorrar tiempo preguntando alguno de los dos en este nivel del programa)
% n_min ---->escalar que indica el numero de marcadores mas cercanos a
%           devolver
%% Salida
% xd   ---->n_min puntos de la camara cam_d asociados a xi en orden de
%           importancia
% d_min  -->minimo de |xd'*(F*xi)|
% index_table   -->vector donde la primer columna es el indice de xi y la segunda del xd asociado
%% EJEMPLOS
%   [xd, index_table, d_min] = cam2cam2(cam(1), cam(2), 100, 'punto', xi, 'n_min', 1)
%   [xd, index_table, d_min] = cam2cam2(cam(1), cam(2), 100, 'punto', xi, 'n_min', 10)
%% CUERPO DE LA FUNCION
%     proceso la entrada
    cam_i=varargin{1}; 
    cam_d=varargin{2};
    n_frame = varargin{3};
    xi=varargin{ find(strcmp(varargin, 'punto'))+1};%la entrada que le sigue a string 'indice' es el indice
    index_xi = varargin{ find(strcmp(varargin, 'punto'))+2};%la entrada que le sigue a string 'indice' es el indice
    if isempty(find(strcmp(varargin, 'n_min'))+1)
        n_min = 1;%solo se devuelve el primer minimo
    else
        n_min= varargin{ find(strcmp(varargin, 'n_min'))+1};%la entrada que le sigue a string 'umbral' es el valor de umbral        
    end
   

    %obtengo las matrices de proyeccion
    Pi = get_info(cam_i, 'projection_matrix');
    Pd = get_info(cam_d, 'projection_matrix');       
    %obtengo las rectas epipolares y los puntos de cam_d
    ld = recta_epipolar(Pi, Pd, xi);
    xd = get_info(cam_d,'frame', n_frame, 'marker', 'coord'); %obtengo todos las coordenadas de los marcadores en el frame n_frame de la camara derecha (destino)
        
    %encuentro las correspondencias y genero salida    
    if (n_min==1) %encuentro el primer punto mas cercano
        index_table = ones(1, 2); %inicializo la tabla de indices
        [d_min, index_table(2)]=min(abs(xd'*ld));%encuentro el punto xd que minimice la metrica |xd'*ld| (o sea que el punto que mejor verifique la ecuacion de la recta, un valor grande con esta metrica indica una mayor distancia del punto a la recta)
        %igual a encontrar el valor de (xd'*ld) mas cercano al cero (agradecer simplicidad a que utilizamos coordenadas homogeneas ;) )
    else %de lo contrario encuentro todos los primeros n puntos minimos que indique umbral
        %inicializo la salida
        index_table = ones(1, n_min+1);
        d_min = ones(1, n_min);
        [d_min, index_table]=minimos(xd, ld, n_min);%encuentro los puntos xd que minimice la metrica |xd'*ld| (o sea que el punto que mejor verifique la ecuacion de la recta, un valor grande con esta metrica indica una mayor distancia del punto a la recta)
        %igual a encontrar el valor de (xd'*ld) mas cercano al cero (agradecer simplicidad a que utilizamos coordenadas homogeneas ;) )
    end  
    xd=xd(:,index_table(2:length(index_table))); %devuelvo solo los m�nimos encontrados
    index_table(1)=index_xi; %agrego en la primera columna de tabla de indices el indice de xi
end

function [d_min, index_table] = minimos(xd, ld, n_min)
%Funcion que devuelve los primeros n minimos de abs(xd'*ld)
%% Entrada
%xd -->conjunto de puntos de camara derecha
%ld -->recta en coordenadas homogeneas
%n_min --->nro de puntos mas cercanos a devolver

%% Salida
%d_min -->distancia minima de los n puntos encontrados 
%index_table -->indice de los n puntos de xd encontrados 

%% Cuerpo de la funcion
    %metrica a encontrar minimos
    d = abs(xd'*ld);    
    
    %manera 1 de hacerlo    
    [d index_origin] = sort(d);%ordeno los valores de menor a mayor y conservo los indices iniciales
    d_min = d(1:n_min);
    index_table = ones(1, n_min+1);
    index_table(2: n_min+1) = index_origin(1:n_min);
    
    %manera 2 de hacerlo
%    %inicializo la salida   
%     index_table = ones(1, n_min+1);
%     d_min = ones(1, n_min);
%     for i=1:n_min %repetir n_min veces, para encontrar los n_min primeros minimos
%         [d_min(i), index_table(i+1)]= min(abs(d));%guardo la minima distancia
%         d(index_table(i+1))=inf;%lo saco de la busqueda
%     end
%     
end