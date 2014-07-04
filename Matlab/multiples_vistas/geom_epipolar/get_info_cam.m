function info_out = get_info_cam(varargin)
% Funcion que recupera la información de una camara
%% Entrada
% cam --> una estructura camara
% t_data -->string que indica el tipo de dato a recuperar del campo info de la camara, t_data = 'info' es un string valido y regresa la estructura info integramente.
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
% info_out -->informacion de salida, su tipo depende del string data
%% EJEMPLO
%  info_out = get_info_cam(cam(1), 'Rc'); %devuelve la matriz Rc

%% ---------
% Author: M.R.
% created the 02/07/2014.
% Copyright T.R.U.C.H.A.

%% Cuerpo de la funcion

%proceso la entrada
cam = varargin{1};
if (length(varargin)==1)
    comando = 'cam.info';
elseif (length(varargin)==2)
    comando = sprintf('cam.info.%s', varargin{2});      
end
%obtengo la salida
info_out = eval(comando);
end