%function [X, validation, index_x3_mat, d, valid_points]=validation3D_fast(cam, n_cam1, n_cam2, n_frame, valid_points, varargin)
function [X, validation, index_x3_mat, d, valid_points]=validation3D_fast2(cam, n_cam1, n_cam2, x, P, valid_points, varargin)
% Funcion que permite reconstruir y validar las reconstrucciones 3D
% Se reconstruye un punto 3D X a partir de dos puntos x1 y x2, que se corresponden con un mismo marcador. x1 pertenece a cam1 y x2 a cam2.
% Luego se toman todos los puntos x3 de las camaras cam3 disponibles distintas a cam1 y cam2, y se reconstruye para cada x3 un punto 3D X3.
% Cada punto X3 se genera al reconstruir con la pareja (x1, x3), para cada x3.
% Se buscan los puntos x3 de la retina cam3 que satisfagan el siguiente criterio. 
%   1) Que el punto X3 reconstruido con la pareja (x1, x3) pertenezca al interior de la esfera de centro X y radio umbral
% Un punto X es considerado un marcador correctamente reconstruido si en al menos una retina se encuentran puntos x3 que satisfagan el criterio
% anterior.

%% ENTRADA
% cam ------------->estructura cam que contiene todas las camaras del laboratorio.
% n_cam1 ---------->vector que indica los numeros de la camara 1. n_cam1(j) indica la camara del punto cuyo indice es index_x1(j)
% n_cam2 ---------->vector que indica los numeros de la camara 2. n_cam2(j) indica la camara del punto cuyo indice es index_x2(j)
% x --------------->cell array con todos los puntos de las camaras de cam en el frame donde se desea efectuar la validacion. x{i} corresponde a cam(i)
% P --------------->cell array conteniendo todas las matrices de proyeccion. P{i} matriz de proyeccion de la camara cam(i)
% valid_points --> cell array valid_points que guarda informacion sobre que puntos ya fueron utilizados para validar algun marcador. 
%                  %valid_points{i}(j)=1  indica que el marcador j de la camara i esta disponible para futuras validaciones.
%                  %valid_points{i}(j)=0  indica que el marcador j de la camara i ya fue utilizado para validar algun marcador.
% index_x1 -------->se coloca a continuacion del string 'index'. Indices de los puntos de cam1 que se quieren reconstruir y validar
%                   index_x1(j) pertenece a la camara n_cam1(j)
% index_x2 -------->se coloca a continuacion del string 'index'. Indices de los puntos de cam2 que se quieren reconstruir y validar
% umbral ---------->se coloca a continuacion del string 'umbral'. Entorno de busqueda para validacion, 
%                   radio de la esfera con centro en los puntos reconstruidos X a validar, dentro de la cual se buscan proyecciones de puntos 3D para efectuar 
%                   validacion, unidades en metros. 1e-5 es ellimite inferior del umbral para un funcionamiento correcto.


%% SALIDA
% X ----------->matriz cuyas columnas son puntos 3D reconstruidos. 
% d -------->matriz de distancias, FALTA EXPLICAR 
% valid_points --> cell array valid_points que guarda informacion sobre que puntos ya fueron utilizados para validar algun marcador. 
%                  %valid_points{i}(:,j)=1  indica que el marcador j de la camara i esta disponible para futuras validaciones.
%                  %valid_points{i}(:,j)=0  indica que el marcador j de la camara i ya fue utilizado para validar algun marcador.
%validation -->vector cuya columna j indica con 1 si el punto
%               index_x3_mat(1,j) valido la reconstruccion X
%index_x3_mat -->matriz, cuya primera fila son indice de puntos y la
%               segunda fila camara correspondiente.

%% ---------
% Author: M.R.
% created the 11/09/2014.
%% CUERPO DE LA FUNCION

%gestiono las entradas
location_index = find(strcmp(varargin, 'index'), 1);
location_umbral = find(strcmp(varargin, 'umbral'), 1);

if isempty(location_umbral)%no se agrego umbral
    umbral = [inf, inf];
else %se agrego vector con umbrales
    umbral = varargin{ location_umbral +1 };
end

if isempty(location_index) %no se agrego tabla de indices
    str = 'Se deben ingresar los indices de los marcadores de cam1 y cam2 a reconstruir. ';
    error('nargin:ValorInvalido',str)
else %si se agrego tabla de indice
    index_x1 = varargin{ location_index + 1};%la entrada que le sigue a string 'index' es el vector de indices de cam1
    index_x2 = varargin{  location_index + 2};%la entrada que le sigue a index_x1 es el vector de indices de cam2 correspondiente.
end

n_cams=size(cam, 2);
%reconstruyo los puntos 3D X
P1 = P{n_cam1};
P2 = P{n_cam2};
x1 = x{n_cam1}(:, index_x1);
x2 = x{n_cam2}(:, index_x2);
X = reconstruccion3D_fast2(x1, P1, x2,  P2);
%se efectua procedimiento para cam3, cam3 es toda camara distinta de cam1 y cam2
vec_cam3 = find( ((1:n_cams)~=n_cam1)&((1:n_cams)~=n_cam2) )';%devuelve un vector con todas los numeros de camaras que no sean cam1 o cam2
n_vec_cam3 = length(vec_cam3); %numero de camaras cam3
%inicializo algunas variables 
n_x3 = ones(1,n_vec_cam3);
index_x3 = cell(1,n_vec_cam3);
X3 =cell(1, n_vec_cam3); %inicializo la salida  X3

for i=1:n_vec_cam3  %hacer para cada cam3 dentro de vec_cam3
    n_cam3 = vec_cam3(i);  %numero de camara en iteracion i
    index_x3{i} = find(valid_points{n_cam3});%encuentro los indices de los puntos x3 disponibles para validar
    P3 = P{n_cam3}; %matriz de proyeccion de la camara i
    x3 = x{n_cam3}(:, index_x3{i}); %coordenadas de los puntos validos en la camara i
    if ~isempty(index_x3{i}) %verifico que se tengan puntos para validar en esta cam3
        n_x3(i) = length(index_x3{i}); %guardo el numero de indices disponibles        
        index_x3{i} = [index_x3{i};...%vector conteniendo los indices de la camara i que se van a probar si validan
                       n_cam3*ones(1, n_x3(i))];%vector que indica el numero de camara de cada columna, la idea es no perder info de camara luego del cell2mat              
        X3{i}=reconstruccion3D_fast2(x1*ones(1, n_x3(i)), P1, x3, P3); %efetuo la reconstruccion 3D de x1 con todos los x3 disponibles        
    else
        index_x3{i}=[-1; n_cam3]; %dejo un valor que indique que no se encontraron indices en la camara
        X3{i}=inf*[1;1;1]; %dejo un valor infinito en la reconstruccion, para que nunca valide
    end
end
X3 = cell2mat(X3); %llevo la informacion de X3 a una matriz
d=pdist2(X', X3'); %distancia de todos los puntos X3 reconstruidos, al punto X
validation = d>umbral;%los ceros indican los puntos que verifican la condicion de umbral, por lo tanto validan al actual punto X
index_x3_mat = cell2mat(index_x3); %llevo index_x3 a una matriz

%se actualiza valid_points
for i=1:n_vec_cam3 %hacer con cada cam3    
    n_cam3 = vec_cam3(i); %numero de camara en iteracion i
    if (index_x3{i}(1,:)~=-1) %hacer solo si se tienen indices validos
        column=(index_x3_mat(2,:)==n_cam3); %indices de las columnas que pertenecen a la camara i
        valid_points{n_cam3}(index_x3{i}(1,:)) = validation(:,column); %solo modifico la informacion de los puntos con indice index_x3
    end
end
%apago los puntos que se usaron para reconstruir X, pues en futuras iteraciones no van a ser utilizados
%o sea que dejo no disponibles los indices de la pareja inicial x1 y x2
valid_points{n_cam1}(index_x1) = 0;
valid_points{n_cam2}(index_x2) = 0;
%hago que validation valga 1 cuando el punto verifica
validation = ~validation;
end