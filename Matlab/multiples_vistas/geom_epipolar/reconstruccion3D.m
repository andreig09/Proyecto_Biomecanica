function X = reconstruccion3D(varargin)
% Funcion que efectua la reconstruccion de un punto 3D a partir de 
% puntos en dos camaras

%% ENTRADA
% cam_i -->camara izquierda 
% cam_d -->camara derecha
% n_frame -->numero de frame
% index_xi -->lista que contiene los indices de puntos de la camara izquierda que
% se quieren reconstruir. Si no se especifica se reconstruyen todos los
% puntos.
% index_xd -->lista que contiene los indices de puntos de la camara derecha correspondientes a la camara izquierda
%           Si no se especifica se encuentran los correspondientes a index_xi.
%% SALIDA
% X -->coordenadas euclideas 3D del punto reconstruido

%% EJEMPLOS
% cam_i = cam(1);
% cam_d = cam(2);
% n_frame = 100;
% index_xi = [1, 10]; 
% [~, ~, index_table,  ~]= cam2cam(cam_i, cam_d, n_frame, 'index', index_xi, 'show');%devuelve todos los puntos de cam(1) del frame n_frame con indice en index_xi y sus correspondientes contrapartes xd de cam(2)
% index_xd = index_table(:,2); %indices de los marcadores correspondientes a los indices de index_xi
% 
% % X1 = reconstruccion3D(cam_i, cam_d, n_frame)%de esta manera la busqueda de todos los index_xi y los correspondientes en cam_d es automatica
% % X2 = reconstruccion3D(cam_i, cam_d, n_frame, index_xi) %de esta manera la busqueda de los correspondientes en cam_d es automatica
% % X3 = reconstruccion3D(cam_i, cam_d, n_frame, index_xi, index_xd)%de esta manera la busqueda de los correspondientes en cam_d corre por cuenta del usuario

%% ---------
% Author: M.R.
% created the 28/07/2014.

cam_i = varargin{1};
cam_d = varargin{2};
n_frame = varargin{3};


%encuentro las matrices de proyecccion
Pi = get_info(cam_i, 'projection_matrix'); %matrix de proyeccion de la camara izquierda
Pd = get_info(cam_d, 'projection_matrix'); %matrix de proyeccion de la camara derecha

if (nargin < 5) %estamos en el caso de salida X1 o X2 de los ejemplos
    [xi, xd, index_table, ~]= cam2cam(cam_i, cam_d, n_frame, 'show'); %devuelve todos los puntos xi de camara izquierda y sus correspondientes contrapartes xd de camara derecha
    
    if iscell(xd)%si xd es un cell lo llevo a matriz
        xd=[xd{:}];
    end
        
    %ordeno los elementos del vector xd, para que se correspondan con los elementos que
    %identifican el mismo marcador en xi
    xd=xd(:, index_table(:,2));
    
    if (nargin>3) %se agrego una lista de puntos
        index_xi =varargin{4};
        xi = xi(:,index_xi); %me quedo solo con los vectores de la lista
        xd = xd(:,index_xi); %como xd ordenado puedo hacer lo mismo que en linea anterior
    end
    
elseif (nargin == 5) %estamos en el caso de la salida X3
    index_xi = varargin{4};
    index_xd = varargin{5};
    xi = get_info(cam_i,'frame', n_frame, 'marker', index_xi, 'coord'); %devuelve las coordenadas de los marcadores en index_x1 del frame n_frame de cam1
    xd = get_info(cam_d,'frame', n_frame, 'marker', index_xd, 'coord'); %devuelve las coordenadas de los marcadores en index_x2 del frame n_frame de cam2 
    
else %tengo un numero de argumentos invalidos
    str = ['Se deben ingresar los indices de los marcadores de cam1 y cam2 a reconstruir. '];
    error('nargin:ValorInvalido',str)
end

X = dlt(xi,xd,Pi,Pd); %efectuo la triangulacion con dlt 
X = homog_norm(X); % normalizo el vector homogeneo 3D
X = X([1:3], :); %me quedo solo con las coordenadas euclideas
return






