function validation3D_fast(cam, n_cam1, n_cam2, n_frame, varargin)

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

vec_cam3 = find( ((1:n_cams)~=n_cam1)&((1:n_cams)~=n_cam2) )';%devuelve un vector con todas los numeros de camaras que no sean cam1 o cam2
n_cam3 = length(vec_cam3);
index = index_x1; %esta variable es utilizada para mantener los indices de los puntos para los cuales no se tiene una reconstruccion valida
                       %Vector que indica cuyos elementos son los indices de los X que aun no fueron validados                        
%Obtengo todos los x3 de las posibles camaras cam3
x3 = cell(1,n_cam3);
for i=1:(n_cam3)
    n_x3 = get_info(cam(i), 'frame', n_frame, 'n_markers'); %marcadores de la cam(i) en el frame n_frame
    %devuelve las coordenadas de los marcadores del frame n_frame de cam(i)
    %junto con el numero de camara correspondiente en la tercer coordenada
    x3{i}=get_info(cam(i),'frame', n_frame, 'marker', 'coord');  
    x3{i} = [x3{i}(1:2, :); i*ones(1, n_x3) ];
    
end
 x3=cell2mat(x3);  
 
 x1 = x1*ones(1, n_frame*n_cam3)
 X = X*ones(1, n_frame*n_cam3)
                       
end