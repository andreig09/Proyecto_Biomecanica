%function choose_cam(vec_cam)
%Funcion que permite seleccionar un conjunto de camaras para trabajar,
%la informacion proviene del archivco InfoCamBlender.m obtenido a partir del
%codigo phyton desde Blender.
%Las variables de salida quedan guardadas en el workspace
%% Entrada
%vec_cam -->vector con el numero de camaras a mantener del archivo
%InfoCamBlender

%% Cuerpo de la funcion
%cargo los datos de las camaras
InfoCamBlender;%este archivo .m fue generado con Python desde Blender y contienen todos los parametros de las camaras de interes
n_cams = length(vec_cam); %numero de camaras de entrada

%inicializo las variables de salida
T_out = zeros(3, n_cams);
%q_out = zeros(1,n_cams);
q_out =quaternion.zeros(1, n_cams);
t_vista_out = cell(1, n_cams);
f_out = zeros(1,n_cams);
shift_x_out = zeros(1, n_cams);
shift_y_out = zeros(1, n_cams);
sensor_out = zeros(2, n_cams);
sensor_fit_out = cell(1, n_cams);
index = 1; %indice auxiliar que permite mantener ordenada la nueva informacion
for k = vec_cam %para cada elemento dentro de vec_cam
    T_out(:,index) = T(:,k);
    q_out(index) = q(k);
    t_vista_out{index} = t_vista{k};
    f_out(index) = f(k);
    shift_x_out(index)=shift_x(k);
    shift_y_out(index)=shift_y(k);
    sensor_out(:,index)=sensor(:,k);
    sensor_fit_out{index} = sensor_fit{k};    
    index = index +1;
end
T = T_out;
Rq = RotationMatrix(q_out);
t_vista = t_vista_out;
f=f_out;
shift_x = shift_x_out;
shift_y = shift_y_out;
sensor = sensor_out;
sensor_fit = sensor_fit_out;



