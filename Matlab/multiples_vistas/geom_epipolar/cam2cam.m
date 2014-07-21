function [xi, xd, index_table, d_min]= cam2cam(varargin)
%Funcion que devuelve en el frame "n_frame"
%todos los coorespondientes puntos xd de la camara cam_d que generan
% el minimo de  |xd'*(F*xi)|, para los xi de entrada pertenecientes a la camara cam_i.
% Por lo tanto se logra un estimativo de la correspondencia de puntos entre
% dos vistas
%% Entrada
%cam_i = varargin{1};%camara "izquierda" o de origen
%cam_d = varargin{2};%camara "derecha" o de destino 
%n_frame = varargin{3}; %numero de frame 
%index_xi = varargin{4};%vector con indices de marcadores de cam_i en frame n_frame a proyectar sobre cam_d 
%% Salida
% xi   ---->vector cuyas columnas son coordenadas de marcadores en el frame n_frame de camara cam_i 
% xd   ---->coorespondiente vector cuyas columnas son coordenadas de marcadores en el frame n_frame de camara cam_d
% d_min  -->vector con los minimos de |xd'*(F*xi)|
% index_table    -->matriz con las correspondencias entre indices. La primer columna son indices de xi y la segunda de xd 
            
%% EJEMPLOS
%       n_frame = 1;
%       index_xi = [1 2];
%       [xi, xd, index_table, d_min]= cam2cam(cam(1), cam(2), n_frame, index_xi)%devuelve todos los puntos de cam(1) del frame n_frame con indice en index_xi y sus correspondientes contrapartes xd de cam(2)
%       [xi, xd, index_table, d_min]= cam2cam(cam(1), cam(2), n_frame) %devuelve todos los puntos xi de cam1 y sus correspondientes contrapartes xd de cam2
            
    %proceso la entrada
    cam_i = varargin{1};%camara "izquierda" o de origen
    cam_d = varargin{2};%camara "derecha" o de destino 
    n_frame = varargin{3};%numero de frame  
    if (nargin < 4) %se quiere proyectar todos los puntos de cam_i a cam_d
        index_xi = [1:get_info(cam_i,'frame', n_frame, 'n_markers')];%genero un indice para cada marcadores de cam_i en el frame n_frame
    else         
        index_xi = varargin{4}; %vector que contiene los indices de los puntos a proyectar
        
    end            
            
    %encuentro cuantos puntos xi quiero proyectar en cam_d
    n_xi = size(index_xi, 2);
    
    %genero salidas
    xi = get_info(cam_i,'frame', n_frame,'marker', index_xi, 'coord');%vector con los puntos de cam_i en frame n_frame a proyectar sobre cam_d     
    if (n_xi == 1) %tengo un solo punto xi para proyectar
        [xd, index_table, d_min] = xd_from_xi(cam_i, cam_d, n_frame, index_xi);
    else %tengo mas de un punto
        xd=ones(3, n_xi);%inicializo salidas
        index_table=ones(n_xi, 2);
        d_min=ones(n_xi, 1);
        for j=1:n_xi%para todos los puntos xi
            [xd(:,j), index_table(j, :), d_min(j)] = xd_from_xi(cam_i, cam_d, n_frame, index_xi(j));    
        end        
    end
end
          

function [xd, index_table, d_min] = xd_from_xi(cam_i, cam_d, n_frame, index_xi)
% Funcion que devuelve el punto xd de la camara cam_d que genera
% el minimo de  |xd'*(F*xi)|, donde xi pertenece a la camara cam_i
% con lo cual se logra un estimativo de la correspondencia de puntos entre
% dos vistas
%% Entrada

%cam_i ---->camara "izquierda" o de origen
%cam_d ---->camara "derecha" o de destino
%n_frame -->numero de frame
%index_xi -->indice de punto de la camara cam_i
%% Salida
% xd   ---->punto de la camara cam_d asociado a xi
% d_min  -->minimo de |xd'*(F*xi)|
% index_table   -->vector donde la primer columna es el indice de xi y la segunda del xd asociado
    
    %obtengo la matriz fundamental 
    Pi = get_info(cam_i, 'projection_matrix');
    Pd = get_info(cam_d, 'projection_matrix');
    F= F_from_P(Pi, Pd); 
    
    %efectuo las proyecciones
    xi = get_info(cam_i, 'frame', n_frame, 'marker', index_xi, 'coord');% tomo el punto xi de la camara cam_i a proyectar
    ld = F*xi; %recta en cam_d correspondiente al punto xi de cam_i
    ld = homog_norm(ld);%normalizo vector de la recta
    xd = get_info(cam_d,'frame', n_frame, 'marker', 'coord'); %obtengo todos las coordenadas de los marcadores en el frame n_frame de la camara derecha (destino)
    
    index_table = ones(1, 2); %inicializo la tabla de indices
    
    %encuentro las correspondencias y genero salida
    [d_min, index_table(2)]=min(abs(xd'*ld));%VER ESTO  --->encuentro el punto xd que posee la minima distancia a la recta ld
    %igual a encontrar el valor de (xd'*ld) más cercano al cero (agradecer simplicidad a que utilizamos coordenadas homogeneas ;) )
    xd=xd(:,index_table(2)); %devuelvo solo el que genero el minimo
    index_table(1)=index_xi; %agrego en la primera columna de tabla de indices el indice de xi
end

