%function index_table = cam2cam_fast(cam_i, cam_d, n_frame, n_points)
function index_table = cam2cam_fast(xi, n_markers_i, Pi, xd, n_points, Pd )
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

%% Salida
% index_table ---->matriz con las correspondencias entre indices.
%                   index_table(i, 1) indica el indice del punto xi(:,i), el resto de la fila i son los indices de los puntos xd ordenados por
%                   cercania a la recta ld asociada al punto xi(:,i)
%

%% CUERPO DE LA FUNCION

% %obtengo todos las coordenadas de los marcadores en el frame n_frame de la camara derecha (destino)
% xd = get_info(cam_d,'frame', n_frame, 'marker', 'coord');
% %numero de marcadores en la camara izquierda
% n_markers_i = get_info(cam_i,'frame', n_frame, 'n_markers');
%genero un indice para cada marcadores de cam_i en el frame n_frame
index_xi = 1:n_markers_i;
% %obtengo las matrices de proyeccion
% Pi = get_info(cam_i, 'projection_matrix');
% Pd = get_info(cam_d, 'projection_matrix');
% %encuentro cuantos puntos xi quiero proyectar en cam_d
n_xi = size(index_xi, 2);
% %vector con los puntos de cam_i en frame n_frame a proyectar sobre cam_d
% xi = get_info(cam_i,'frame', n_frame,'marker', index_xi, 'coord');
%rectas epipolares correspondientes a los puntos xi
ld = recta_epipolar(Pi, Pd, xi);

%inicializo salidas
index_table=ones(n_xi, n_points+1);%la cantidad de filas viene dado por la cantidad de puntos a proyectar, mientras que las columnas se corresponden con la cantidad de minimos a mostrar
for j=1:n_xi%para todos los puntos xi a proyectar        
    index_table(j, :) = xd_from_xi(xd, ld(:,j), index_xi(j), n_points);        
end

end



function index_table = xd_from_xi(xd, ld, index_xi, n_points)
% Funcion que devuelve los n_points puntos xd de la camara cam_d que minimizan
% |xd'*(F*xi)|, donde xi pertenece a la camara cam_i.
% Se logra un estimativo de la correspondencia de puntos entre
% dos vistas
%% Entrada
% xd ---->todos los marcadores de la camara derecha
% Pi ---->camara "izquierda" o de origen
% Pd ---->camara "derecha" o de destino
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

%encuentro las correspondencias y genero salida
if (n_points==1) %encuentro el primer punto mas cercano
    index_table = ones(1, 2); %inicializo la tabla de indices
    [~, index_table(2)]=min(abs(xd'*ld));%encuentro el punto xd que minimice la metrica |xd'*ld| (o sea que el punto que mejor verifique la ecuacion de la recta, un valor grande con esta metrica indica una mayor distancia del punto a la recta)
    %igual a encontrar el valor de (xd'*ld) mas cercano al cero (agradecer simplicidad a que utilizamos coordenadas homogeneas ;) )
    %esta distancia d_min es igual a la distancia euclidea entre el punto y la recta a menos de una constante
    %d_min_euclidea = d_min_homogenea/sqrt((b/c)^2+(a/c)^2), donde la recta ld:ax+by+c=0, o sea ld=(a/c, b/c, 1) en homogeneas normalizadas    
else %de lo contrario encuentro todos los primeros n puntos minimos que indique umbral    
    index_table = minimos(xd, ld, n_points);%encuentro los puntos xd que minimice la metrica |xd'*ld| (o sea que el punto que mejor verifique la ecuacion de la recta, un valor grande con esta metrica indica una mayor distancia del punto a la recta)
    %igual a encontrar el valor de (xd'*ld) mas cercano al cero (agradecer simplicidad a que utilizamos coordenadas homogeneas ;) )
end
index_table(1)=index_xi; %agrego en la primera columna de tabla de indices el indice de xi

end

function index_table = minimos(xd, ld, n_points)
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
[~, index_origin] = sort(d);%ordeno los valores de menor a mayor y conservo los indices iniciales
index_table = ones(1, n_points+1);
index_table(2: n_points+1) = index_origin(1:n_points);

end



