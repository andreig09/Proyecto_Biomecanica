function [X, validation, n_cam3, x3, dist]=validation3D(cam, n_cam_i, n_cam_d, n_frame, varargin )

% Se reconstruye un punto 3D X a partir de dos puntos xi y xd, que se corresponden con un mismo marcador. xi pertenece a cam_i y xd a cam_d.
% Luego se reproyecta el punto X sobre una tercer camara cam_3 generando el punto x3_1.
% Por otro lado se trazan las rectas epipolares l3_xi y l3_xd correspondientes a los puntos xi de cam_i y xd de cam_d, sobre la retina de cam3.
% Y se encuentra la interseccion de ambas rectas epipolares a traves del producto vectorial x3_2 = (l3_xi ^ l3_xd). (Se asumen coordenadas homogeneas) 
% Se buscan los puntos de la retina cam_3 que satisfagan simultaneamente dos criterios
%   1) pertenecer al disco de centro x3_1 y radio umbral1
%   2) pertenecer al disco de centro xe_2 y radio umbral2
% Un punto X es considerado un marcador correctamente reconstruido si en al menos una retina se encuentran puntos x3 que satisfagan simultaneamente 
% los dos criterios anteriores.
% Se definen dos distancias d3_1 = (x3^2 - (x3_1)^2 ) y d3_2 = (x3^2 - (x3_2)^2).
% Si se encuentra solo un punto que satisface ambos criterio sobre cam3 se detiene el proceso y se devuelve la salida.
% En el caso que se tenga mas de un punto en cam3 que satisfaga los dos criterios antedichos se asocia al marcador X el punto que minimice la
% siguiente funcion de costo d = alpha*d3_1 + beta*d3_2. Para algun alpha y beta. 
% En el caso que no se encuentren puntos para validar X en ninguna retina se considera X como marcador invalido.

%% ENTRADA
% cam ----------------->estructura cam que contiene todas las camaras del laboratorio.
% n_cam_i ------------->numero de la camara izquierda.
% n_cam_d ------------->numero de la camara derecha.
% n_frame ------------->numero de frame.
% index_xi ------------>se coloca a continuacion del string 'index'. Indices de los marcadores de cam_i que se quieren reconstruir y validar, si este parametro no se encuentra se reconstruyen todo los puntos. 
% [alpha, beta] ------->se coloca a continuacion del string 'cost'. Este vector modifica la funcion de costo.
%                         d = alpha*(x^2 - (x3_1)^2 ) + beta*(x^2 - (x3_2)^2).  Si no se encuentra este parametro se asume [1, 1].  
% [umbral1, umbral2] -->se coloca a continuacion del string 'umbral'. Umbrales de busqueda asociados a los criterios 1 y 2 enunciados en la intro

%% SALIDA
% X ------>matriz cuyas columnas son puntos 3D reconstruidos
% n_cam3 --->vector con los numeros de las camaras de la estructura cam que contienen a los respectivos x3
% x3------>matriz cuyas columnas son puntos de cam3 que minimiza d
% dist ------>matriz cuya fila j son tres componentes de distancia [d3_1, d3_2, d] asociadas a x3(:,j). 
%             d3_1 = (x3^2 - (x3_1)^2 ) 
%             d3_2 = (x3^2 - (x3_2)^2) 
%             d = alpha*d3_1 + beta*d3_2
% validation -->vector cuya columna j es un booleano que indica si el punto X(:,j) es un marcador correctamente reconstruido o no.



%% IDEA DE IMPLEMENTACION
% 1) hago la funcion para un unico punto xi validation3D_one(cam, n_cam_i, n_cam_d, n_frame, varargin )
% 2) obtengo la matriz xi de dimension 3xn cuyas columnas son los n puntos de entrada de cam_i dados por index_xi
% 3) genero un cell array xi_cell donde cada componente sea una columna de xi -->xi_cell = mat2cell(xi, 3, ones(1, size(xi, 2)))
% 4) luego utilizo la funcion cellfunc la cual efectua una misma funcion cambiando un parametro determinado por componentes de un cell array
%  EJEMPLO: hacer la media de todos los vectores de xi_cell --->media = cellfun(@(x) mean(x), xi_cell), la salida cumple media{j}=mean(xi_cell{j})
% 5) luego modifico el cell de salida para devolver el formato correcto en la funcion validation3D 


location_index = find(strcmp(varargin, 'index'), 1);




load saved_vars/cam.mat
n_cam_i=1;
n_cam_d=2;
n_frame=100;


[xi, xd, index_table, d_min]= cam2cam(cam(n_cam_i), cam(n_cam_d), n_frame); %devuelve todos los puntos xi de camara izquierda y sus correspondientes contrapartes xd de camara derecha

Pi = get_info(cam(n_cam_i), 'projection_matrix'); %matrix de proyeccion de la camara izquierda
Pd = get_info(cam(n_cam_d), 'projection_matrix'); %matrix de proyeccion de la camara derecha

%ordeno los vectores xi, xd, para que se correspondan los puntos que
%identifican el mismo marcador

X = dlt(xi,xd,Pi,Pd); %efectuo dlt para triangulacion
X = homog_norm(X); % normalizo el vector homogeneo 3D
X = X([1:3], :); %me quedo solo con las coordenadas euclideas


%proyecto sobre una tercer camara
n_cam3 = 4; %numero que indica el indice de la tercer camara
P3 = get_info(cam(n_cam3), 'projection_matrix'); %matrix de proyeccion de la tercer camara

x3= obtain_coord_retina(X, P3);% proyecto los puntos 3D sobre la camara3

[~, x3_i, index_table_3i, d_min_3i] = cam2cam(cam(n_cam_i), cam(n_cam3), n_frame); %devuelve todos los puntos x3_i contrapartes de xi en camara 3
[~, x3_d, index_table_3d, d_min_3d] = cam2cam(cam(n_cam_d), cam(n_cam3), n_frame); %devuelve todos los puntos x3_d contrapartes de xd en camara 3


%Ahora voy a obtener para cada xi la correspondiente rectas proyectada sobre la camara 3 (li3= F*xi)
Fi3 = F_from_P(Pi, P3);
li3 = Fi3*xi; %obtengo rectas homogeneas en camara 3
li3 = homog_norm(li3);%normalizo vector de recta homogenea 

%Ahora voy a obtener para cada xd la correspondiente rectas proyectada sobre la camara 3 (li3= F*xi)
Fd3 = F_from_P(Pd, P3);
ld3 = Fd3*xd; %obtengo rectas homogeneas en camara 3
ld3 = homog_norm(ld3);%normalizo vector de recta homogenea 




