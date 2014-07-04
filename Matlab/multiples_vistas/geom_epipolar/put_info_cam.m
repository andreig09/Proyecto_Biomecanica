function cam_out = put_info_cam(varargin)
% Funcion que actualiza la información de una camara
%% Entrada
% cam --> una estructura camara
% t_data -->string que indica el tipo de dato a actualizar del campo info de la camara, t_data = 'info' es un string valido y actualiza la estructura info integramente.
% data ---->dato a actualizar
%
%info = struct(...
%     'Rc',               nan(3, 3), ...%matriz de rotación
%     'Tc',               nan(3, 1), ...%vector de traslación
%     'f' ,               0.0, ...%distancia focal en metros
%     'resolution',       nan(1, 2), ...%=[resolución_x, resolution_y] unidades en pixeles
%     't_vista',          blanks(15), ...%tipo de vista utilizada en la camara (PERSPECTIVA, ORTOGRAFICA, PANORAMICA)
%     'shift',            nan(1, 2), ...%[shift_x, shidt_y] corrimiento del centro de la camara en pixeles
%     'sensor',           nan(1, 2), ...%[sensor_x, sensor_y] largo y ancho del sensor en milimetros
%     'sensor_fit',       blanks(15), ...%tipo de ajuste utilizado para el sensor (AUTO, HORIZONTAL, VERTICAL)
%     'pixels_aspect',    1, ...%(pixel_aspect_x)/(pixel_aspect_y) valor 1 indica pixel cuadrado
%     'Pcam',              nan(3, 3) ...%matrix de proyección de la camara
%     );
%% Salida
% cam -->estructura camara con el campo indicado por 'data' actualizado
%% EJEMPLO
%  cam(1) = put_info_cam(cam(1), 'Rc', Rc); %actualiza la matriz Rc de la camara 1

%% ---------
% Author: M.R.
% created the 02/07/2014.
% Copyright T.R.U.C.H.A.

%% Cuerpo de la funcion

    %proceso la entrada
    cam_in = varargin{1};
    t_data = varargin{2};
    data = varargin{3};
    
    % el segundo argumento define todo el procedimiento
    if (strcmp(t_data, 'info')) %en este caso seguro se quiere actualizar el campo cam.info    
        cam_out = setfield(cam_in, 'info', data);     
    else %seguro se va a actualizar un campo dentro de info     
        cam_in.info = setfield( cam_in.info, t_data, data); %seteo el campo cam_in.info.'t_data' con el valor de data
        cam_out = cam_in;    
    end
end