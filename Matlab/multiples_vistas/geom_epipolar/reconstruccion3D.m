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
%% SALIDA
% X -->coordenadas euclideas 3D del punto reconstruido

%% EJEMPLOS
% cam_i = cam(1);
% cam_d = cam(2);
% n_frame = 100;
% X1 = reconstruccion3D(cam_i, cam_d, n_frame)
% index_xi = [1, 10];
% X2 = reconstruccion3D(cam_i, cam_d, n_frame, index_xi)

%% ---------
% Author: M.R.
% created the 28/07/2014.

cam_i = varargin{1};
cam_d = varargin{2};
n_frame = varargin{3};


[xi, xd, index_table, ~]= cam2cam(cam_i, cam_d, n_frame); %devuelve todos los puntos xi de camara izquierda y sus correspondientes contrapartes xd de camara derecha

Pi = get_info(cam_i, 'projection_matrix'); %matrix de proyeccion de la camara izquierda
Pd = get_info(cam_d, 'projection_matrix'); %matrix de proyeccion de la camara derecha

%ordeno los elementos del vector xd, para que se correspondan con los elementos que
%identifican el mismo marcador en xi
xd=xd(:, index_table(:,2));

if (nargin>3) %se agrego una lista de puntos
    index_xi =varargin{4};
    xi = xi(:,index_xi); %me quedo solo con los vectores de la lista
    xd = xd(:,index_xi); %como xd ordenado puedo hacer lo mismo que en linea anterior
end

X = dlt(xi,xd,Pi,Pd); %efectuo la triangulacion con dlt 
X = homog_norm(X); % normalizo el vector homogeneo 3D
X = X([1:3], :); %me quedo solo con las coordenadas euclideas
return






