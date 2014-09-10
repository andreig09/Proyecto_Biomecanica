function [X, validation, d]=validation3D_fast(cam, n_cam1, n_cam2, n_frame, varargin)
tic
%gestiono las entradas
 cam1=cam(n_cam1);
 cam2=cam(n_cam2);
 location_index = find(strcmp(varargin, 'index'), 1);
 
 location_umbral = find(strcmp(varargin, 'umbral'), 1);
 location_debug = find(strcmp(varargin, 'debug'), 1); 
 
 location_replace = find(strcmp(varargin, 'replace'), 1); %en este caso no se quitan los puntos que validaron alguna vez, y por lo tanto no se ingresa la matriz
                                                           %invalid_points
 
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
    
n_cams=size(cam, 2);


%reconstruyo los puntos 3D X
X = reconstruccion3D(cam1, cam2, n_frame, index_x1, index_x2);
%se efectua procedimiento para cam3, cam3 es toda camara distinta de cam1 y cam2

vec_cam3 = find( ((1:n_cams)~=n_cam1)&((1:n_cams)~=n_cam2) )';%devuelve un vector con todas los numeros de camaras que no sean cam1 o cam2
n_cam3 = length(vec_cam3);
%Obtengo todos los x3 de las posibles camaras cam3
n_x3 = ones(1,n_cam3);
for i=1:(n_cam3)
    %n_x3 = get_info(cam(i), 'frame', n_frame, 'n_markers'); %marcadores de la cam(i) en el frame n_frame
    %devuelve las coordenadas de los marcadores del frame n_frame de cam(i)
    %junto con el numero de camara correspondiente en la tercer coordenada
    %x3{i}=get_info(cam(i),'frame', n_frame, 'marker', 'coord');  
    %x3{i} = [x3{i}(1:2, :); i*ones(1, n_x3) ];
    n_x3(i)= get_info(cam(i), 'frame', n_frame, 'n_markers'); %marcadores de la cam(i) en el frame n_frame
end 
 
 %X = X*ones(1, sum(n_x3))
 X3 =cell(1, n_cam3); %inicializo X3
 
 for i=1:n_cam3 
     index_x3 = 1:n_x3(i);%vector con los indices de los vectores x3 de la camara i     
     X3{i}=reconstruccion3D(cam1, cam2, n_frame, index_x1*ones(1, n_x3(i)), index_x3);
 end
 X3 = cell2mat(X3);
 d=pdist2(X', X3'); %distancia de todos los puntos X3 reconstruidos al punto X
 validation = d>umbral;
 toc
end