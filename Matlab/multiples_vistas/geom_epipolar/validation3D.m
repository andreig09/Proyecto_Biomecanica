function [X, validation, n_cam3, index_x3, dist, valid_points]=validation3D(cam, n_cam1, n_cam2, n_frame, varargin )
% Funcion que permite reconstruir y validar las reconstrucciones 3D
% Se reconstruye un punto 3D X a partir de dos puntos x1 y x2, que se corresponden con un mismo marcador. x1 pertenece a cam1 y x2 a cam2.
% Luego se reproyecta el punto X sobre una tercer camara cam3 generando el punto x3_1.
% Por otro lado se trazan las rectas epipolares l3_x1 y l3_x2 correspondientes a los puntos x1 de cam1 y x2 de cam2, sobre la retina de cam3.
% Y se encuentra la interseccion de ambas rectas epipolares a traves del producto vectorial x3_2 = (l3_x1 ^ l3_x2). (Se asumen coordenadas homogeneas) 
% Se buscan los puntos de la retina cam3 que satisfagan simultaneamente dos criterios. 
%   1) pertenecer al interior de la conica cc1, generalmente una circunferencia de centro x3_1 y radio en funcion del parametro umbral
%   2) pertenecer al interior de la conica cc2, generalmente una circunferencia de centro x3_2 y radio en funcion del parametro umbral
% cc1 es la conica generada por la proyeccion sobre cam3 del contorno de una esfera  de radio umbral y centro X.
% cc2 es la misma conica que cc1 pero "centrada" en x3_2.
% Un punto X es considerado un marcador correctamente reconstruido si en al menos una retina se encuentran puntos x3 que satisfagan simultaneamente 
% los dos criterios anteriores.
% Se definen dos distancias d3_1 = (x3^2 - (x3_1)^2 ) y d3_2 = (x3^2 - (x3_2)^2).
% Si se encuentra solo un punto que satisface ambos criterio sobre cam3 se detiene el proceso y se devuelve la salida.
% En el caso que se tenga mas de un punto en cam3 que satisfaga los dos criterios antedichos se asocia al marcador X el punto que minimice la
% siguiente funcion de costo d = alpha*d3_1 + beta*d3_2. Para algun alpha y beta. 
% En el caso que no se encuentren puntos para validar X en ninguna retina, se considera X como marcador invalido 
% y se devuelve dentro del conjunto de los que no lograron validarlo la mejor opcion camara-punto2D.

%% ENTRADA
% cam ------------->estructura cam que contiene todas las camaras del laboratorio.
% n_cam1 ---------->vector que indica los numeros de la camara 1. n_cam1(j) indica la camara del punto cuyo indice es index_x1(j)
% n_cam2 ---------->vector que indica los numeros de la camara 2. n_cam2(j) indica la camara del punto cuyo indice es index_x2(j)
% n_frame --------->numero de frame.
% index_x1 -------->se coloca a continuacion del string 'index'. Indices de los puntos de cam1 que se quieren reconstruir y validar
%                   index_x1(j) pertenece a la camara n_cam1(j)
% index_x2 -------->se coloca a continuacion del string 'index'. Indices de los puntos de cam2 que se quieren reconstruir y validar
%                   index_x2(j) pertenece a la camara n_cam2(j)
% [alpha, beta] --->se coloca a continuacion del string 'cost'. Este vector modifica la funcion de costo.
%                   d = alpha*(x^2 - (x3_1)^2 ) + beta*(x^2 - (x3_2)^2).  Si no se encuentra este parametro se asume [1, 1].  
% umbral ---------->se coloca a continuacion del string 'umbral'. Entorno de busqueda para validacion, 
%                   radio de la esfera con centro en los puntos reconstruidos X a validar, dentro de la cual se buscan proyecciones de puntos 3D para efectuar 
%                   validacion, unidades en metros. 1e-5 es ellimite inferior del umbral para un funcionamiento correcto.

%% SALIDA
% X ----------->matriz cuyas columnas son puntos 3D reconstruidos.
% n_cam3 ------>matriz, n_cam3(i,j) indica la camara a la cual pertenece el punto de indice index_x3(i, j).
% index_x3----->matriz cuyas componentes son indices de puntos de cam3 que minimiza d. 
%               index_x3(i, j) pertenece a la camara n_cam3(i,j) y se corresponde con X(:,j). 
%               index_x3(i, j)=-1 indica que no se encontro ningun punto en la camara n_cam3(i, j)                  
% dist -------->matriz de distancias (costos), dist(i,j) es la funcion de costo asociada al punto index_x3(i,j) 
%               funcion de costo -->d = alpha*d3_1 + beta*d3_2
%               dist(i, j)= -1 indica que no se encontro ningun punto en la camara n_cam3(i, j)    
% validation -->matriz  de validacion, 
%                        validation(i, j)=1 indica que el punto de indice index_x3(i,j) VALIDA al punto X(:,j).
%                        validation(i, j)=0 indica que el punto de indice index_x3(i,j) NO VALIDA al punto X(:,j), pero es la mejor opcion que se encontro.
% valid_points --> cell array valid_points que guarda informacion sobre que puntos ya fueron utilizados para validar algun marcador. 
%                  %valid_points{i}(j)=1  indica que el marcador j de la camara i esta disponible para futuras validaciones.
%                  %valid_points{i}(j)=0  indica que el marcador j de la camara i ya fue utilizado para validar algun marcador.

%% EJEMPLOS
%clc
%n_frame = 100;
%n_cam1=1;
%n_cam2=4;
%%genero el cell array valid_points que guarda informacion sobre que puntos ya fueron utilizados para validar algun marcador. 
%%valid_points{i}(j)=1  indica que el marcador j de la camara i esta disponidble para validar.
% valid_points=cell(n_cams, 1);
% for i=1:n_cams
%     n_markers = get_info(cam(i), 'frame', n_frame, 'n_markers');
%     valid_points{i} = ones(1, n_markers);
% end

%%en este caso se agrega la lista de puntos validos para efectuar la busqueda de validacion
%[X, validation, n_cam3, index_x3, dist, valid_points]=validation3D(cam, n_cam1, n_cam2, n_frame, 'index', [1:26], [1:26], 'cost', [1 1], 'umbral',  0.0001, valid_points)

%%El string 'replace' al final de cada entrada significa que se efectua reposicion de marcadores, o sea que NO se quitan los puntos que ya
%%validaron algun marcador.
%%en este caso busca validar las respectivas reconstrucciones hechas por  los puntos de indice [2, 5] de cam1 y sus correspondientes en cam2,
%%utilizando un umbral y los pesos para la funcion de costo. Las camaras se ingresan fuera de orden a proposito para ver si funciona. 
% [X, validation, n_cam3, index_x3, dist]=validation3D(cam, [1 2], [2 1], n_frame, 'index', [2, 5],[2, 5], 'cost', [1 1], 'umbral',  0.0001, 'replace');
% 
% n_cam1 = [1 3 4]; index_x1 = [2 5 1]; n_cam2 = [2, 4, 5]; index_x2=[2 5 1]; 
% [X, validation, n_cam3, index_x3, dist]=validation3D(cam, n_cam1, n_cam2, n_frame, 'index', index_x1, index_x2, 'cost', [1 1], 'umbral',  0.0001, 'replace')

%%temporalmente uno de los peores casos
%n_cam1 = [1*ones(1, 6) 2*ones(1, 6) 3*ones(1, 6) 4*ones(1, 6) 5 4]; index_x1 = [1:26];
%n_cam2 = [2*ones(1, 6) 3*ones(1, 6) 4*ones(1, 6) 5*ones(1, 6) 1 3]; index_x2 = [1:26];
%[X, validation, n_cam3, index_x3, dist]=validation3D(cam, n_cam1, n_cam2, n_frame, 'index', index_x1, index_x2, 'cost', [1 1], 'umbral',  0.0001, 'replace')

%%1e-5 es el limite inferior del umbral para funcionamiento correcto.
%%si se ingresan escalares en n_cam1 y n_cam2 se asume que todos los puntos en index_x1 son de cam1 al igual que los de index_x2 son de cam2
% n_cam1=1; n_cam2=2; 
% [X, validation, n_cam3, index_x3, dist]=validation3D(cam, n_cam1, n_cam2, n_frame, 'index', [1:26],[1:26], 'cost', [1 1], 'umbral', 1e-5 , 'replace') ;
%%voy a generar a proposito unos puntos X que no deberian encontrar una reconstruccion valida siempre
% [X, validation, n_cam3, index_x3, dist]=validation3D(cam, n_cam1, n_cam2, n_frame, 'index', [2, 5],[2, 21], 'cost', [1 1], 'umbral',  0.0001, 'replace')
%   x2 = get_info(cam(2), 'frame', n_frame, 'marker', 'coord');
%   x2(:,[2, 4, 6, 8, 10]) = [ones(1, 4) 400;2*ones(1, 4) 150; zeros(1, 4), +100];
%   cam_aux=cam;
%   cam_aux(2) = set_info(cam(2), 'frame', n_frame, 'marker', 'coord', x2); %setea con las columnas de "x2" las coordenadas de todos los marcadores en el frame 1 de structure
% 
% [X, validation, n_cam3, index_x3, dist]=validation3D(cam_aux, n_cam1, n_cam2, n_frame, 'index', [2],[2], 'cost', [1 1], 'umbral',  0.0001, 'replace')
% [X, validation, n_cam3, index_x3, dist]=validation3D(cam_aux, n_cam1, n_cam2, n_frame, 'index', [1:26],[1:26], 'cost', [1 1], 'umbral',  0.0001, 'replace')
% [X, validation, n_cam3, index_x3, dist]=validation3D(cam_aux, n_cam1, n_cam2, n_frame, 'index', [1:2],[1:2], 'cost', [1 1], 'umbral', 1e-5, 'replace' ) 



%% ---------
% Author: M.R.
% created the 11/08/2014.

%% CUERPO DE LA FUNCION

%gestiono las entradas
location_index = find(strcmp(varargin, 'index'), 1);
location_cost = find(strcmp(varargin, 'cost'), 1);
location_umbral = find(strcmp(varargin, 'umbral'), 1);
location_replace = find(strcmp(varargin, 'replace'), 1); %en este caso no se quitan los puntos que validaron alguna vez, y por lo tanto no se ingresa la matriz
                                                           %invalid_points

if isempty(location_cost) %no se agrego vector de costos
    cost = [1, 1]; 
else % se agrego vector de costos
    cost = varargin{ location_cost +1 };    
end

if isempty(location_umbral)%no se agrego umbral
    umbral = [inf, inf];
else %se agrego vector con umbrales
    umbral = varargin{ location_umbral +1 };
end

if isempty(location_index) %no se agrego tabla de indices
    str = ['Se deben ingresar los indices de los marcadores de cam1 y cam2 a reconstruir. '];
    error('nargin:ValorInvalido',str)
else %si se agrego tabla de indice
    index_x1 = varargin{ location_index + 1};%la entrada que le sigue a string 'index' es el vector de indices de cam1
    index_x2 = varargin{  location_index + 2};%la entrada que le sigue a index_x1 es el vector de indices de cam2 correspondiente.
end


%incializo las salidas
n_cams = size(cam, 2); %numero total de camaras del experimento
n_points = size(index_x1, 2);
validation=zeros(n_cams-2, n_points);
index_x3 = -ones(n_cams-2, n_points);
dist = -ones(n_cams-2, n_points);
n_cam3 = -ones(n_cams-2, n_points);
X = -ones(3, n_points);


n= length(n_cam1);
if n==1 %solo se tiene un par de camaras
    %[X, validation, n_cam3, index_x3, dist]=validation3D_two_cams(cam, n_cam1, n_cam2, n_frame, 'index', index_x1, index_x2, 'cost', cost, 'umbral', umbral);
    [X, validation, n_cam3, index_x3, dist, valid_points]=validation3D_two_cams(cam, n_cam1, n_cam2, n_frame, varargin{:});
else
    %ordeno las entradas para tener la camara con menor numeracion del par en n_cam1
    [n_cam1, n_cam2, index_x1, index_x2]=ordenar(n_cam1, n_cam2, index_x1, index_x2);
    for i=1:(n_cams-1) %como estas las camaras ordenadas puedo terminar en n_cams-1
        index1 = (n_cam1 == i);
        if sum(index1)>0 %si se encontro alguna n_cam1=i
            for j= (i+1):n_cams %como estas las camaras ordenadas puedo empezar en i+1
                index2 = (n_cam2 == j);        
                index = find( index1.*index2==1); %index indica los lugares donde se tiene  n_cam1(index)=i y n_cam2(index)=k
                if ~isempty(index) %existe la pareja de camaras
                    if isempty(location_replace)
                        [X_aux, validation_aux, n_cam3_aux, index_x3_aux, dist_aux, valid_points]=...                        
                            validation3D_two_cams(cam, i, j, n_frame, 'index', index_x1(index), index_x2(index),  varargin{4:size(varargin, 2)});
                    else 
                        [X_aux, validation_aux, n_cam3_aux, index_x3_aux, dist_aux]=...                        
                            validation3D_two_cams(cam, i, j, n_frame, 'index', index_x1(index), index_x2(index),  varargin{4:size(varargin, 2)});
                    end
                    X(:,index)=X_aux;
                    validation(:,index) = validation_aux;
                    n_cam3(:,index) = n_cam3_aux*ones(1, length(index));
                    index_x3(:,index) = index_x3_aux;
                    dist(:,index)=dist_aux;
                end
            end
        end
    end
end


%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [n_cam1, n_cam2, index_x1, index_x2]=ordenar(n_cam1, n_cam2, index_x1, index_x2)
%funcion que ordena dejando la camara con menor numeracion del par en n_cam1

%% CUERPO DE LA FUNCION

index=n_cam1>n_cam2;
aux_cam = n_cam1(index);
n_cam1(index) = n_cam2(index);
n_cam2(index) = aux_cam;
aux_point = index_x1(index);
index_x1(index) = index_x2(index);
index_x2(index) = aux_point;


end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [X, validation, n_cam3, index_x3, dist, valid_points]=validation3D_two_cams(cam, n_cam1, n_cam2, n_frame, varargin )


%% ENTRADA
% cam ----------------->estructura cam que contiene todas las camaras del laboratorio.
% n_cam1 ------------->numero de la camara 1.
% n_cam2 ------------->numero de la camara 2.
% n_frame ------------->numero de frame.
% index_x1 ------------>se coloca a continuacion del string 'index'. Indices de los marcadores de cam1 que se quieren reconstruir y validar, 
% index_x2 ------------>se coloca a continuacion de index_x1. Indices de los marcadores de cam2 correspondientes a los marcadores de cam1 en index_x1.
% [alpha, beta] ------->se coloca a continuacion del string 'cost'. Este vector modifica la funcion de costo.
%                         d = alpha*(x^2 - (x3_1)^2 ) + beta*(x^2 - (x3_2)^2).  Si no se encuentra este parametro se asume [1, 1].  
% umbral -->se coloca a continuacion del string 'umbral'. Entorno de busqueda para validacion, 
%           radio de la esfera con centro en los puntos reconstruidos X a validar, dentro de la cual se buscan proyecciones de puntos 3D para efectuar 
%           validacion, unidades en metros.
% 'debug' -->permite visualizar graficamente las conicas y todos los marcadores sobre la retina. 

%% SALIDA
% X ----------->matriz cuyas columnas son puntos 3D reconstruidos
% n_cam3 ------>vector con los numeros de las camaras de la estructura cam que contienen a los respectivos x3. n_cam3(i) es la camara de la fila
%               i de index_x3
% index_x3----->matriz de indices, la componente index_x3(i, j) indica el indice del punto de cam3 que minimiza la funcion de costo d 
%               para el punto X(:,j) en la camara n_cam3(i) 
% dist -------->matriz de distancias (costos), dist(i,j) es la funcion de costo asociada al punto index_x3(i,j) 
%               funcion de costo -->d = alpha*d3_1 + beta*d3_2
% validation -->vector cuya columna j es un booleano que indica si el punto X(:,j) es un marcador correctamente reconstruido o no.
% valid_points --> cell array valid_points que guarda informacion sobre que puntos ya fueron utilizados para validar algun marcador. 
%                  %valid_points{i}(j)=1  indica que el marcador j de la camara i esta disponible para futuras validaciones.

%% EJEMPLOS
% clc
% close all
% n_frame = 100;
% n_cam1=1;
% n_cam2=2;
% n_cams=size(cam, 2);
%%genero el cell array valid_points que guarda informacion sobre que puntos ya fueron utilizados para validar algun marcador. 
%%valid_points{i}(j)=1  indica que el marcador j de la camara i esta disponidble para validar.
% valid_points=cell(n_cams, 1);
% for i=1:n_cams
%     n_markers = get_info(cam(i), 'frame', n_frame, 'n_markers');
%     valid_points{i} = ones(1, n_markers);
% end

%tic 
%%en este caso se agrega la lista de puntos validos para efectuar la busqueda de validacion
%[X, validation, n_cam3, index_x3, dist, valid_points]=validation3D(cam, n_cam1, n_cam2, n_frame, 'index', [1:26], [1:26], 'cost', [1 1], 'umbral',  0.0001, valid_points)

%%El string 'replace' al final de cada entrada significa que se efectua reposicion de marcadores, o sea que NO se quitan los puntos que ya
%%validaron algun marcador.
%%en este caso busca validar las respectivas reconstrucciones hechas por  los puntos de indice [2, 5] de cam1 y sus correspondientes en cam2,
%%utilizando un umbral y los pesos para la funcion de costo.  
%[X, validation, n_cam3, index_x3, dist]=validation3D_two_cams(cam, n_cam1, n_cam2, n_frame, 'index', [2, 5],[2, 5], 'cost', [1 1], 'umbral',  0.0001, 'replace')
%%limite inferior del umbral para funcionamiento correcto
%[X, validation, n_cam3, index_x3, dist]=validation3D_two_cams(cam, n_cam1, n_cam2, n_frame, 'index', [1:26],[1:26], 'cost', [1 1], 'umbral', 1e-5, 'replace' ) 
%%si se agrega el string 'debug' se puede hacer una comprobacion grafica con las conicas frontera y los puntos
%[X, validation, n_cam3, index_x3, dist]=validation3D_two_cams(cam, n_cam1, n_cam2, n_frame, 'index', [1:26],[1:26], 'cost', [1 1], 'umbral', 1e-5, 'debug', 'replace' ) 
%toc
%%voy a generar a proposito unos puntos X que no deberian encontrar una reconstruccion valida siempre
%[X, validation, n_cam3, index_x3, dist]=validation3D_two_cams(cam, n_cam1, n_cam2, n_frame, 'index', [2, 5],[2, 21], 'cost', [1 1], 'umbral',  0.0001, 'replace')
%   x2 = get_info(cam(2), 'frame', n_frame, 'marker', 'coord');
%   x2(:,[2, 4, 6, 8, 10]) = [ones(1, 4) 400;2*ones(1, 4) 150; zeros(1, 4), +100];
%   cam_aux=cam;
%   cam_aux(2) = set_info(cam(2), 'frame', n_frame, 'marker', 'coord', x2); %setea con las columnas de "x2" las coordenadas de todos los marcadores en el frame 1 de structure
% tic
% [X, validation, n_cam3, index_x3, dist]=validation3D_two_cams(cam_aux, n_cam1, n_cam2, n_frame, 'index', [2],[2], 'cost', [1 1], 'umbral',  0.0001, 'replace')
% [X, validation, n_cam3, index_x3, dist]=validation3D_two_cams(cam_aux, n_cam1, n_cam2, n_frame, 'index', [1:26],[1:26], 'cost', [1 1], 'umbral',  0.0001, 'replace')
% [X, validation, n_cam3, index_x3, dist]=validation3D_two_cams(cam_aux, n_cam1, n_cam2, n_frame, 'index', [1:2],[1:2], 'cost', [1 1], 'umbral', 1e-5 , 'replace') 
% [X, validation, n_cam3, index_x3, dist]=validation3D_two_cams(cam_aux, n_cam1, n_cam2, n_frame, 'index', [1:26],[1:26], 'cost', [1 1], 'umbral', 1e-5, 'debug', 'replace') 
% toc


%% ---------
% Author: M.R.
% created the 1/08/2014.

%% CUERPO DE LA FUNCION

%gestiono las entradas
 cam1=cam(n_cam1);
 cam2=cam(n_cam2);
 location_index = find(strcmp(varargin, 'index'), 1);
 location_cost = find(strcmp(varargin, 'cost'), 1);
 location_umbral = find(strcmp(varargin, 'umbral'), 1);
 location_debug = find(strcmp(varargin, 'debug'), 1); 
 
 location_replace = find(strcmp(varargin, 'replace'), 1); %en este caso no se quitan los puntos que validaron alguna vez, y por lo tanto no se ingresa la matriz
                                                           %invalid_points
 

if isempty(location_cost) %no se agrego vector de costos
    cost = [1, 1]; 
else % se agrego vector de costos
    cost = varargin{ location_cost +1 };    
end

if isempty(location_umbral)%no se agrego umbral
    umbral = [inf, inf];
else %se agrego vector con umbrales
    umbral = varargin{ location_umbral +1 };
end

if isempty(location_index) %no se agrego tabla de indices
    str = ['Se deben ingresar los indices de los marcadores de cam1 y cam2 a reconstruir. '];
    error('nargin:ValorInvalido',str)
else %si se agrego tabla de indice
    index_x1 = varargin{ location_index + 1};%la entrada que le sigue a string 'index' es el vector de indices de cam1
    index_x2 = varargin{  location_index + 2};%la entrada que le sigue a index_x1 es el vector de indices de cam2 correspondiente.
end

if isempty(location_debug) %no se quiere debug
    debug_on=0;
else
    debug_on=1;
end

if isempty(location_replace) %si no se va a reponer los puntos que ya validaron el ultimo parametro es invalid_points
    aux=size(varargin, 2); %indice del ultimo elemento de varargin
    valid_points=varargin{aux};
end
    

%incializo las salidas
n_cams = size(cam, 2); %numero total de camaras del experimento
n_points = size(index_x1, 2);
validation=zeros(n_cams-2, n_points);
index_x3 = -ones(n_cams-2, n_points);
if debug_on
    dist = cell(1, n_points);
    for  k=1:n_points
        dist{k}=-ones(3, n_cams-2);
    end
else
    dist = -ones(n_cams-2, n_points);
end


%reconstruyo los puntos 3D X
X = reconstruccion3D(cam1, cam2, n_frame, index_x1, index_x2);

%obtengo matrices de proyeccion de cam1 y cam2 y puntos correspondientes
P1 = get_info(cam1, 'projection_matrix'); %matrix de proyeccion de cam1
P2 = get_info(cam2, 'projection_matrix'); %matrix de proyeccion de cam2
x1 = get_info(cam1,'frame', n_frame, 'marker', index_x1, 'coord'); %devuelve las coordenadas de los marcadores en index_x1 del frame n_frame de cam1
x2 = get_info(cam2,'frame', n_frame, 'marker', index_x2, 'coord'); %devuelve las coordenadas de los marcadores en index_x2 del frame n_frame de cam2


%se efectua procedimiento para cam3, cam3 es toda camara distinta de cam1 y cam2

n_cam3 = find( ((1:n_cams)~=n_cam1)&((1:n_cams)~=n_cam2) )';%devuelve un vector con todas los numeros de camaras que no sean cam1 o cam2
index = index_x1; %esta variable es utilizada para mantener los indices de los puntos para los cuales no se tiene una reconstruccion valida
                       %Vector que indica cuyos elementos son los indices de los X que aun no fueron validados                        
                       
for i = 1:(n_cams-2) %para todas las camaras en n_cam3     
    
    cam3 = cam(n_cam3(i)); %el indice de la camara 3 actual viene dado por n_cam3(i)
    
    %obtengo todos los puntos de cam3 y su matriz de proyeccion
    if isempty(location_replace) %si no se quiere hacer reposicion de los marcadores que validaron anteriormente
        list_index_x3 = find(valid_points{n_cam3(i)});
        if isempty(list_index_x3) %si la camara no contiene ningun punto entonces reviso la camara que sigue. Esto puede pasar cuando los puntos de la 
            continue                %camara i ya fueron utilizados para validar en otras iteraciones. 
        end
    else 
        n_markers = get_info(cam3, 'frame', n_frame, 'n_markers');
        list_index_x3 = [1:n_markers];
    end   
    x3 = get_info(cam3, 'frame', n_frame, 'marker',list_index_x3,  'coord'); %devuelve las coordenadas de todos los marcadores en el frame n_frame de cam3(i)
    P3 = get_info(cam3, 'projection_matrix'); %matrix de proyeccion de cam3
    
    %obtengo los puntos x3_1 y x3_2
    [x3_1, x3_2, ~,  ~] =  reprojection(P1, P2, P3, x1, x2, X); 
    
    %encuentro la matriz de la conica resultado de proyectar la esfera de radio umbral y centro X, sobre la retina de cam3
    C = esfera2cam(X, umbral, P3, debug_on);    
    
    %se encuentran puntos de cam3 que satisfacen simultaneamente los dos criterios, con el fin de validar cada punto de index
    [flag, d] = check_both_criteria(x3, x3_1, x3_2, C, cost);    
        
    %de los puntos que satisfacen los criterios encontrados para cada marcador se selecciona el mejor, o sea el que minimiza la funcion de costo d
    [index_best_x3, index_val, d_min] = choice_best_x3(flag, d, index, debug_on);
    
     
    
    %actualizo la salida  
     for k=1:length(index_val) 
         validation(i, :) =or(validation(i, :), (index(:)==index_val(k))'); %voy prendiendo los elementos que fueron validados en la camara i
     end      
     if isempty(location_replace) %si no se quiere hacer reposicion de los marcadores que validaron anteriormente
         index_x3(i,:) = list_index_x3(index_best_x3);%en cada X(j) se guarda su correspondiente x3 que lo valida. flag_col(j) vale 1 en ese caso
         if sum(validation(i,:))>0 %si se valido algun punto
             validaron= find(validation(i,:)==1) ;
             valid_points{n_cam1}(index_x1(validaron))=0;
             valid_points{n_cam2}(index_x2(validaron))=0;%quito la pareja de entrada cuya reconstruccion encontro al menos una validacion
             validaron=index_x3(i, validaron);%devuelve los indices de los puntos que validaron algun marcador
             valid_points{n_cam3(i)}(validaron) = 0; %pongo en cero los puntos que ya validaron algun marcador
         end
     else %se efectua reposicion
         index_x3(i,:) = index_best_x3;%en cada X(j) se guarda su correspondiente x3 que lo valida. flag_col(j) vale 1 en ese caso
     end
     
     if debug_on
         for k=1:length(index) %para cada marcador
             dist{k}(:,i)=d_min(:,k); %coloco una columna igual a [d1;d2;d]
         end
         hold on; plot(x3(1,:), x3(2,:), 'k*'); hold off %solo para DEBUGG, ploteo todos los puntos x, si en esfera2cam ploteo la conica
         %puedo comprobar visualmente que todo ok para esta camara  
     else 
         dist(i,:)=d_min;
     end 
     
     
     
     
end 
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FUNCIONES AUXILIARES

function [x3_1, x3_2, l3_x1, l3_x2] =  reprojection(P1, P2, P3, x1, x2, X) 
% Funcion que dado 3 puntos, x1 en camara 1,  x2 en camara 2  que se corresponden y X en espacio 3D,
%devuelve las proyecciones de todos ellos sobre una tercer camara.
%Para los puntos 2D x1 y x2 devuelve rectas epipolares l3_x1 y l3_x2 respectivamente,
%para X en espacio 3D devuelve su proyeccion x3_1.
%Ademas devuelve la interseccion de las rectas epipolares en x3_2

    %obtengo los puntos x3_1 
    x3_1= obtain_coord_retina(X, P3); %se reproyecta los puntos de X sobre la retina de cam3 
    
    %obtengo las rectas l3_x1 y le_x2 junto con su interseccion x3_2
    l3_x1 = recta_epipolar(P1, P3, x1);%rectas epipolares sobre cam3 correspondientes a los puntos de cam1 
    l3_x2 = recta_epipolar(P2, P3, x2);%rectas epipolares sobre cam3 correspondientes a los puntos de cam2 
    x3_2 = cross(l3_x1, l3_x2, 1); % encuentro los puntos de interseccion de las rectas epipolares correspondientes al mismo punto x3_2 = (l3_x1 ^ l3_x2)
    x3_2 = homog_norm(x3_2);%normalizo los puntos encontrados
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [flag, d_out] = check_both_criteria(x3, x3_1, x3_2, C, cost)
% Funcion que indica que puntos x3 verifican simultaneamente los dos criterios explicados en la introduccion

%% ENTRADA 
%x3 ------> matriz de puntos cuyas columnas son los puntos de camara 3
%x3_1 ----> matriz cuyas columnas son los centros a aplicar con criterio 1
%x3_2 ----> matriz cuyas columnas son los centros a aplicar con criterio 2
%C   -----> matriz de la conica que genera intervalo alrededor de x3_1 y luego de una traslacion del plano tambien alrededor de x3_2
%cost ----> vector [alpha, beta] que contiene los costos a aplicar a cada criterio en particular

%% SALIDA
%flag ---> matriz donde flag(i,j) vale 1 si x3(:,i)  
%        verifica el primer criterio con centro x3_1(j) y el segundo criterio con centro x3_2(j), en caso contrario vale 0 
%        Por lo tanto permite validar el marcador X(:,index(j))
%d_out ----->cell array que contiene las matrices d1, d2, y d. LAs componentes (i, j) de dichas matrices son valores asociados a cada componente (i,j )de flag.

%% CUERPO DE LA FUNCION

    %criterio 1: d3_1 = (x3^2 - (x3_1)^2 ) < umbral(1)     
    [flag1, d1 ]= criterio1(x3, x3_1, C); %flag1(i,j) indica con 1 si el punto x3(:,i) verifica el criterio 1 del punto x3_1(:,j)

    %mapeo a partir de una traslacion todos los puntos de cam3 de manera que x3_2 se corrresponda con x3_1
    %de esta manera puedo utilizar la misma conica para ver que puntos x3_tras caen dentro (basicamente en lugar de trasladar la conica hasta x3_2, traslado
    %todos los puntos de entrada hasta la conica, x3_tras = (x3 + (x3_1-x3_2)) ).
    T = (x3_1-x3_2); %vectores que efectuan la traslacion 
    [flag2, d2 ] = criterio2(x3, x3_2 , C, T); %flag2_aux(i,j) indica con 1 si el punto x3(:,i) verifica el criterio 2 del punto x3_2(:,j)   
   
    %veo cuales cumplen ambos criterios 
    flag = flag1.*flag2;% flag(i,j) indica con 1 si el punto x3(:,i) verifica ambos criterios, validando de esta manera 
                        %al marcador X(:,index(j))
   
    %calculo la matriz funcion de costo 
    d = cost(1).*d1 + cost(2).*d2; %funcion de costo, d(i, j) es la funcion de costo del punto x3(:,i) 
                                    %con respecto al marcador X(:,index(j))                                
    d_out = {d1;d2;d};%genero la salida
                                    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
function  [flag, d_out]  = criterio1(x, y, C)
%% Funcion que verifica que puntos de 'x' se encuentran en el interior de la conica C de "centro" los puntos 'y' 


%% ENTRADA
% x --> vector de puntos que se deben verificar
% y --> vector con los "centros" de las conicas
% C --> cell array, C{j} es la conica asociada a y(:,j)

%% SALIDA
% flag -->matriz cuyo elemento flag(i, j) vale 1 si x(:,i) se encuentra dentro de disco con centro y(:,j) y radio umbral
% d_out --> distancia del punto x al y 
%% CUERPO DE LA FUNCION
    n_y = size(y, 2);%numero centros
    n_x = size(x, 2);%numero de puntos a verificar
    flag = zeros(n_x, n_y); %inicializo la salida
    d_out = zeros(n_x, n_y); %inicializo la salida    
    
    for j=1:n_y %para todos los centros 'y'        
        centro = y(:,j);
        d = pdist2(centro', x', 'euclidean');%calculo las distancias de cada punto al centro  
        
        %verifico que signo tengo dentro de la conica al evaluar (x'*C*x)
        signo = sign(centro'*C{j}*centro); 
        
        %encuentro cuales puntos x caen dentro de la conica cerrada(x'*C*x). 
        if signo>0 %el signo dentro de la conica es positivo
            inside = diag(x'*C{j}*x>=0);%Debido a que x es un conjunto de vectores columna solo la diagonal en la salida es importante por eso se utiliza diag.
                                         %El termino (j, j) de x'*C*x corresponde a verificar el punto x(:,j)
        else %el signo dentro de la conica es negativo
            inside = diag(x'*C{j}*x<=0);
        end
           
        flag(inside, j)=1; %prendo las banderas de los puntos que si caen dentro del umbral
        d_out(:,j) = d; %guardo las distancias generadas por todos los puntos x                    
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function  [flag, d_out]  = criterio2(x, y, C, T)
%% Funcion que verifica que puntos de 'x' se encuentran en el interior de la conica C de "centro" los puntos 'y' 

%% ENTRADA
% x --> vector de puntos que se deben verificar
% y --> vector con los "centros" de las conicas
% C --> cell array, C{j} es la conica asociada a y(:,j)
% T --> traslaciones a efectuar sobre cada conica
%% SALIDA
% flag -->matriz cuyo elemento flag(i, j) vale 1 si x(:,i) se encuentra dentro de disco con centro y(:,j) y radio umbral
% d_out --> distancia del punto x al y 
%% CUERPO DE LA FUNCION
    n_y = size(y, 2);%numero centros
    n_x = size(x, 2);%numero de puntos a verificar
    flag = zeros(n_x, n_y); %inicializo la salida
    d_out = zeros(n_x, n_y); %inicializo la salida    
    
    for j=1:n_y %para todos los centros 'y'        
        TT =  T(:,j)*ones(1, n_x);%repito el vector T(:,j) solo para poder hacer corrimiento de todos los puntos x3
                                  %ahora puedo aplicar el criterio a los puntos trasladados con la misma conica que en el criterio anterior
        centro = y(:,j) + T(:,j); %corrimiento de los centros
        x_tras = x + TT; %efectuo el corrimiento de todos los x
        d = pdist2(centro', x', 'euclidean');%calculo las distancias de cada punto al centro         
        
        %verifico que signo tengo dentro de la conica al evaluar (x_tras'*C*x_tras)
        signo = sign(centro'*C{j}*centro); 
        
        %encuentro cuales puntos x caen dentro de la conica cerrada(x_tras'*C*x_tras). 
        if signo>0 %el signo dentro de la conica es positivo
            inside = diag(x_tras'*C{j}*x_tras>=0);%Debido a que x es un conjunto de vectores columna solo la diagonal en la salida es importante por eso se utiliza diag.
                                         %El termino (j, j) de x'*C*x corresponde a verificar el punto x(:,j)
        else %el signo dentro de la conica es negativo
            inside = diag(x_tras'*C{j}*x_tras<=0);
        end
           
        flag(inside, j)=1; %prendo las banderas de los puntos que si caen dentro del umbral
        d_out(:,j) = d; %guardo las distancias generadas por todos los puntos x                    
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



function [index_best_x3, index_val, d_out] = choice_best_x3(flag, d_in, index, debug_on)
% Funcion que devuelve los indices de los puntos x3 que cumplen los criterios y minimizan la funcion de costo d para cada marcador en X
% En el caso que no se encuentren puntos x3 que cumplan los criterios para algun X se devuelve el que minimiza la funcion de costo d.
% Que un x3 cumpla los dos criterios para algun X,  implica que el punto puede validar a X.
%% ENTRADA
%flag  ---------->matriz donde el elemento flag(i, j)=1 indica que el punto x3(:,i) valida a X(:,j)
%d_in  ---------->cell array de tres elementos {d1;d2;d}. 
%                 d1 es una matriz cuyo elemento d1(i, j) indica la distancia del punto x3(:,i) a x3_1(:,j)
%                 d2 es una matriz cuyo elemento d2(i, j) indica la distancia del punto x3(:,i) a x3_2(:,j)
%                 d es una matriz cuyo elemento d(i, j) indica el valor de la funcion de costo del punto x3(:,i) con respecto a X(:,j)  
%index -->vector cuyos elementos son indices de X a validar
%% SALIDA
% index_best_x3--> vector que contiene los indices de los x3 que lograron validar los puntos X(:,index) respectivamente
% index_val ----> vector con los indices de los X validados
% d_out ---------> cell array de tres elementos {d1;d2;d}. 
%                 d1 es un vector cuyo elemento d1(j) indica la distancia minima encontrada para el punto x3_1(:,j)
%                 d2 es un vector cuyo elemento d2(j) indica la distancia minima encontrada para el punto x3_1(:,j)
%                 d es un vector cuyo elemento d(j) indica el minimo valor de la funcion de costo asociada a X(:,j)  
% index_no_val --> vector cuyos elementos son los indices de los X que aun no fueron validados. Se actualiza este vector con respecto
% a la entrada
% flag_col     -->%este parametro debe ser una salida pues tanto index_val como index_no_val guardan indices de X mientras que flag_colum 
%                 varia de tamaño entre llamadas de la funcion y direcciona correctamente a las columnas de la matriz d_out que
%                 sirven para validar algun X. 
%                 flag_col(j)=1 indica que el punto X(index_val(j)) se puede validar con funcion de costo asociada d_out(3,flag_col(j))
%% CUERPO DE LA FUNCION

    %gestiono entrada
    d1=d_in{1}; 
    d2=d_in{2};
    d =d_in{3};
    
    %inicializo salida
    n=size(d, 2); %numero total de punto de X
    d_min= ones(1, n);
    if debug_on
        d1_out=ones(1, n);
        d2_out= ones(1, n);
    end
    index_best_x3 = ones(1, n); 
    
    %todos los puntos X que se estan manejando se encuentran no validados
    %necesito un solo punto x3 por punto X, el que minimice la funcion de costo 'd' y en lo posible cumpla ambos criterios 
    
    %necesito saber que marcador tiene al menos un punto x3 que verifique ambos criterios de validacion
    flag_col=sum(flag, 1); %acumulo las banderas prendidas con 1 de cada columna (o sea cada marcador).
                        %flag deja de ser una matriz y pasa a ser un vector donde flag(j) es mayor a cero si existe al menos un x3 
                        %que valida X(j)=X(:,index_no_val(j)) 
    i_val = flag_col >0; %indices de puntos X que si se pueden validar
    i_noval = flag_col==0; %indices de puntos X que no se pueden validar
    
    %primero se encuentran los minimos de d para cada X donde se tengan puntos que cumplen ambos criterios 
    flag_aux=flag;
    flag_aux(flag==0)=inf; %pongo en infinito los que no validan (estos dos pasos evitan que a continuacion pueda suceder que seleccione
                         %algun minimo d que en realidad no cumpla los criterios)
    d_aux = d.*flag_aux; %dejo prendidas solo las distancias que verificaron los criterios    
    [d_min(i_val), index_best_x3(i_val)] = min(d_aux(:,i_val), [], 1); % d(i, j) indica el valor de la funcion de costo del punto x3(:,i) 
                                                %con respecto a X(:,j)
                                                %entonces busco los minimos solo en las columanas con puntos validos y me devuelve un vector de minimos min_d
                                                %donde el elemento min_d(k) corresponde X(:,k).
                                                %La fila donde se encontraba el minimo indica el indice del punto x3, este se guarda en index_best_x3
    
    %luego se encuentran minimos de d para los X que no tengan puntos que cumplan ambos criterios 
    [d_min(i_noval), index_best_x3(i_noval)] = min(d(:,i_noval), [], 1);
                        
     %gestiono la salida  
     if debug_on %con debug_on en 1 se devuelve d1 y d2 junto con d
         for j=1:n  %para cada columna de d1 y d2 me quedo con el valor de distancia del respectivo x3 que minimizo la funcion de costo d
             d1_out(j) = d1(index_best_x3(j), j); 
             d2_out(j) = d2(index_best_x3(j), j);
         end
         d_out = [d1_out; d2_out; d_min];
     else 
         d_out = d_min;
     end
     
     index_val = index(i_val); %me quedo con los indices de X que tienen al menos un x3 para validarlo     
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

