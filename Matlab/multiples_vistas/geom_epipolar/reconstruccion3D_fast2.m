function X = reconstruccion3D_fast2(xi, Pi, xd, Pd)
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
% created the 20/09/2014.

X = dlt(xi,xd,Pi,Pd); %efectuo la triangulacion con dlt 
X = homog_norm(X); % normalizo el vector homogeneo 3D
X = X(1:3, :); %me quedo solo con las coordenadas euclideas
return






