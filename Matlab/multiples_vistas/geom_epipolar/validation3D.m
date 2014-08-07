function [X, validation, n_cam3, index_x3, dist]=validation3D(cam, n_cam1, n_cam2, n_frame, varargin )

% Se reconstruye un punto 3D X a partir de dos puntos x1 y x2, que se corresponden con un mismo marcador. x1 pertenece a cam1 y x2 a cam2.
% Luego se reproyecta el punto X sobre una tercer camara cam_3 generando el punto x3_1.
% Por otro lado se trazan las rectas epipolares l3_x1 y l3_x2 correspondientes a los puntos x1 de cam1 y x2 de cam2, sobre la retina de cam3.
% Y se encuentra la interseccion de ambas rectas epipolares a traves del producto vectorial x3_2 = (l3_x1 ^ l3_x2). (Se asumen coordenadas homogeneas) 
% Se buscan los puntos de la retina cam_3 que satisfagan simultaneamente dos criterios
%   1) pertenecer al disco de centro x3_1 y radio umbral1
%   2) pertenecer al disco de centro x3_2 y radio umbral2
% Un punto X es considerado un marcador correctamente reconstruido si en al menos una retina se encuentran puntos x3 que satisfagan simultaneamente 
% los dos criterios anteriores.
% Se definen dos distancias d3_1 = (x3^2 - (x3_1)^2 ) y d3_2 = (x3^2 - (x3_2)^2).
% Si se encuentra solo un punto que satisface ambos criterio sobre cam3 se detiene el proceso y se devuelve la salida.
% En el caso que se tenga mas de un punto en cam3 que satisfaga los dos criterios antedichos se asocia al marcador X el punto que minimice la
% siguiente funcion de costo d = alpha*d3_1 + beta*d3_2. Para algun alpha y beta. 
% En el caso que no se encuentren puntos para validar X en ninguna retina se considera X como marcador invalido.

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
%           radio de la esfera con centro en los puntos a validar, dentro de la cual se buscan puntos 3D para efectuar validacion, unidades en metros.
% 'debug' -->si se quiere ver graficamente las conicas y los marcadores sobre la retina

%% SALIDA
% X ------>matriz cuyas columnas son puntos 3D reconstruidos
% n_cam3 --->vector con los numeros de las camaras de la estructura cam que contienen a los respectivos x3
% index_x3------>vector cuyas componentes son indices de puntos de cam3 que minimiza d
%                 EJEMPLO index_x3(j) es el indice de un punto x3 de la camara n_cam3(j)
% dist ------>matriz cuya fila j son tres componentes de distancia en pixeles [d3_1, d3_2, d] asociadas a x3(:,j). 
%             d3_1 = (x3^2 - (x3_1)^2 ) 
%             d3_2 = (x3^2 - (x3_2)^2) 
%             d = alpha*d3_1 + beta*d3_2
% validation -->vector cuya columna j es un booleano que indica si el punto X(:,j) es un marcador correctamente reconstruido o no.


%% EJEMPLOS
% clc
% close all
% n_frame = 100;
% n_cam1=1;
% n_cam2=2; 
% tic 
% %en este caso busca validar las respectivas reconstrucciones hechas por  los puntos de indice [1, 2, 3] de cam1 y sus correspondientes en cam2,
% %utilizando un umbral y los pesos para la funcion de costo.                    
% % [X, validation, n_cam3, index_x3, dist]=validation3D(cam, n_cam1, n_cam2, n_frame, 'index', [1, 2, 3],[1, 2, 3], 'cost', [1 1], 'umbral',  0.0001)
% %limite inferior del umbral para funcionamiento correcto
% %[X, validation, n_cam3, index_x3, dist]=validation3D(cam, n_cam1, n_cam2, n_frame, 'index', [1:26],[1:26], 'cost', [1 1], 'umbral', 1e-5 ) 
% %si se agrega el string 'debug' se puede hacer una comprobacion grafica con las conicas frontera y los puntos
% %[X, validation, n_cam3, index_x3, dist]=validation3D(cam, n_cam1, n_cam2, n_frame, 'index', [1:26],[1:26], 'cost', [1 1], 'umbral', 1e-5, 'debug' ) 
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

%incializo las salidas
n_points = size(index_x1, 2);
validation=zeros(1, n_points);
n_cam3 = -ones(1, n_points);
index_x3 = -ones(1, n_points);
dist = -ones(1, n_points);


%reconstruyo los puntos 3D X
X = reconstruccion3D(cam1, cam2, n_frame, index_x1, index_x2);

%obtengo matrices de proyeccion de cam1 y cam2 y puntos correspondientes
P1 = get_info(cam1, 'projection_matrix'); %matrix de proyeccion de cam1
P2 = get_info(cam2, 'projection_matrix'); %matrix de proyeccion de cam2
x1 = get_info(cam1,'frame', n_frame, 'marker', index_x1, 'coord'); %devuelve las coordenadas de los marcadores en index_x1 del frame n_frame de cam1
x2 = get_info(cam2,'frame', n_frame, 'marker', index_x2, 'coord'); %devuelve las coordenadas de los marcadores en index_x2 del frame n_frame de cam2


%se efectua procedimiento para cam3, cam3 es toda camara distinta de cam1 y cam2
n_cams = size(cam, 2); %numero total de camaras en el laboratorio
temp_n_cam3 = find( ([1:n_cams]~=n_cam1)&([1:n_cams]~=n_cam2) );%devuelve un vector con todas los numeros de camaras que no sean cam1 o cam2
current_index = index_x1; %esta variable es utilizada para mantener los indices de los puntos para los cuales no se tiene una reconstruccion valida
                       %en principio para todo punto en index_x1 se debe asociar un marcador reconstruido que sea valido,
                       %a medida que se vayan validando los puntos de index_x1, la lista de puntos current_index se va actualizando y reduciendo, 
                       %quedandose solo con aquellos que aun no se pudieron validar en las camaras buscadas hasta el momento
                       
for i = 1:(n_cams-2) %para todas las camaras en n_cam3     
    
    cam3 = cam(temp_n_cam3(i)); %el indice de la camara 3 actual viene dado por n_cam3(i)
    
    %actualizo puntos a validar, solo busco validar los puntos que aun no se encuentren validados
    current_X = X(:,current_index);
    current_x1 = x1(:,current_index);
    current_x2 = x2(:,current_index);
    
    %obtengo todos los puntos de cam3 y su matriz de proyeccion
    x3 = get_info(cam3, 'frame', n_frame, 'marker', 'coord'); %devuelve las coordenadas de todos los marcadores en el frame n_frame de cam3(i)
    P3 = get_info(cam3, 'projection_matrix'); %matrix de proyeccion de cam3
    
    %obtengo los puntos x3_1 y x3_2
    [x3_1, x3_2, ~,  ~] =  reprojection(P1, P2, P3, current_x1, current_x2, current_X); 
    
    %encuentro la matriz de la conica resultado de proyectar la esfera de radio umbral y centro X, sobre la retina de cam3
    C = esfera2cam(X, umbral, P3, debug_on);    
    
    %se encuentran puntos de cam3 que satisfacen simultaneamente los dos criterios, con el fin de validar cada punto de current_X
    [flag, d] = check_both_criteria(x3, x3_1, x3_2, C, cost);    
    
    %de los puntos encontrados para cada marcador se selecciona el mejor, o sea el que minimiza la funcion de costo d
    %[index_current_x3, index_X, d_min, current_index ] = choice_best_x3(flag, d, current_index);
    
    %de los puntos que satisfacen los criterios encontrados para cada marcador se selecciona el mejor, o sea el que minimiza la funcion de costo d
    [index_current_x3, index_X, d_min, current_index ] = choice_best_x3(flag, d, current_index);
    
     %actualizo la salida con estos resultados 
     validation(index_X)=1; 
     n_cam3(index_X) = temp_n_cam3(i);
     index_x3(index_X) = index_current_x3;%en cada X(j) se guarda su correspondiente x3 que lo valida
     dist(index_X) = d_min;
     
     if debug_on
         hold on; plot(x3(1,:), x3(2,:), 'k*'); hold off %solo para DEBUGG, ploteo todos los puntos x, si en esfera2cam ploteo la conica 
         %puedo comprobar visualmente que todo ok para esta camara                        
     end
     
     if isempty(current_index) %ya se validaron las reconstrucciones de todos los puntos de cam1 solicitados
         return %salgo de la funcion
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

function [flag, d] = check_both_criteria(x3, x3_1, x3_2, C, cost)
% Funcion que indica que puntos x3 verifican simultaneamente los dos criterios explicados en la introduccion

%% ENTRADA 
%x3 ------> matriz de puntos cuyas columnas son los puntos de camara 3
%x3_1 ----> matriz cuyas columnas son los centros a aplicar con criterio 1
%x3_2 ----> matriz cuyas columnas son los centros a aplicar con criterio 2
%C   -----> matriz de la conica que genera intervalo alrededor de x3_1
%cost ----> vector [alpha, beta] que contiene los costos a aplicar a cada criterio en particular


%% SALIDA
%flag ---> matriz donde flag(i,j) vale 1 si x3(:,i)  
%        verifica el primer criterio con centro x3_1(j) y el segundo criterio con centro x3_2(j), en caso contrario vale 0 
%        Por lo tanto permite validar el marcador current_X(:,j)=X(:,current_index(j))
%d ----->matriz que contiene el valor de la funcion de costo asociadas a cada componente de flag. d = alpha*d1 + beta*d2
%% CUERPO DE LA FUNCION

    %criterio 1: d3_1 = (x3^2 - (x3_1)^2 ) < umbral(1) 
    [flag1, d1 ]= criterio(x3, x3_1, C); %flag1(i,j) indica con 1 si el punto x3(:,i) verifica el criterio 1 del punto x3_1(:,j)
    
    %mapeo a partir de una traslacion todos los puntos de cam3 de manera que x3_2 se corrresponda con x3_1
    %de esta manera puedo utilizar la misma conica para ver que puntos x3_tras caen dentro (basicamente en lugar de trasladar la conica hasta x3_2, traslado
    %todos los puntos de entrada, x3_tras = (x3 - (x3_1-x3_2)) ).
    T = (x3_1-x3_2); %vectores que efectuan la traslacion
        
    flag2 = zeros(size(flag1)); %inicializo variable flag2
    for j = 1:size(T, 2) %hacer para cada traslacion, o sea para cada x3_2
        TT =  T(:,j)*ones(1, size(x3, 2));%repito el vector solo para poder hacer corrimiento de todos los puntos x3
    %ahora puedo aplicar el criterio a los puntos trasladados con la misma conica que en el criterio anterior
    %criterio 2: d3_1 = (x3^2 - (x3_2)^2 ) < umbral(2) 
        [flag2_aux, d2 ] = criterio(x3+TT, x3_2+T , C); %flag2_aux(i,j) indica con 1 si el punto x3(:,i) verifica el criterio 2 del punto x3_2(:,j)
        flag2(:,j)=flag2_aux(:,j); %me quedo solo con la columna que me intereza
    end
    %veo cuales cumplen ambos criterios 
    flag = flag1.*flag2;% flag(i,j) indica con 1 si el punto x3(:,i) verifica ambos criterios, validando de esta manera 
                        %al marcador current_X(:,j) que corresponde al marcador X(:,current_index(j))
   
    %calculo la matriz funcion de costo 
    d = cost(1).*d1 + cost(2).*d2; %funcion de costo, d(i, j) es la funcion de costo del punto x3(:,i) 
                                    %con respecto al marcador current_X(:,j) que corresponde  
                                    %al marcador X(:,current_index(j))  
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
function  [flag, d_out]  = criterio(x, y, C)
%% Funcion que verifica que puntos de 'x' se encuentran en el interior de la conica C de "centro" los puntos 'y' 

%% SALIDA
% flag -->matriz cuyo elemento flag(i, j) vale 1 si x(:,i) se encuentra dentro de disco con centro y(:,j) y radio umbral
% d_out --> distancia del punto x al y 
%% CUERPO DE LA FUNCION
    n_y = size(y, 2);%numero de elementos de y
    n_x = size(x, 2);%numero de elementos de x 
    flag = zeros(n_x, n_y); %inicializo la salida
    d_out = zeros(n_x, n_y); %inicializo la salida    
    
    for j=1:n_y %para todos los puntos 'y'
        %centros =repmat(y(:,j), 1, size(x, 2)); %genero una matriz equivalente a x donde cada columna es el centro y(:,j)
        centro = y(:,j);
        d = pdist2(centro', x', 'euclidean');%calculo las distancias de cada punto al centro 
        %inside = find(d<umbral);%encuentro cuales puntos x3 caen dentro del disco
        
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



function [index_current_x3, index_X, d_min, current_index] = choice_best_x3(flag, d, current_index)
% Funcion que devuelve los indices de los puntos x3 que minimizan la funcion de costo d para cada marcador en current_X
% EN REALIDAD AUN NO HACE ESTO PUES FALTARIA UNA FUNCION QUE LLEVE DISTANCIAS DE DOS PUNTOS PERO ENTRE CAMARAS

    %necesito un solo punto por marcador no validado, el que minimice la funcion de costo 'd'
    d_aux = d.*flag; %dejo prendidas solo las distancias que verificaron el umbral
    d_aux(d_aux==0)=inf; %pongo en infinito las distancias que estaban en cero 
    [d_min, index_current_x3] = min(d_aux, [], 1); %busco los minimos por columna y me devuelve un vector de minimos min_d y la fila donde se encontraba el minimo 
                                            %indica el indice del punto x3
    
                                                                                        
    %necesito saber que marcador tiene al menos un punto x3 que verifique ambos criterios de validacion
    flag=sum(flag, 1); %acumulo las banderas prendidas con 1 de cada columna (o sea cada marcador).
                        %flag deja de ser una matriz y pasa a ser un vector donde flag(j) es mayor a cero si existe al menos un x3 
                        %que valida current_X(j)=X(:,current_index(j)) 
                        
     %me quedo solo con los puntos x3 de marcadores validados con distancia minima 
     d_min = d_min(flag>0);
     index_current_x3=index_current_x3(flag>0);       
     index_X = current_index(flag>0); %me quedo con los indices de current_X que tienen al menos un x3 para validarlo
     
    current_index = find(flag==0); %actualizo los indices de X que aun no pueden ser validados    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
