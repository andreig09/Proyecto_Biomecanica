function info_out = get_info_cam(varargin)
% Funcion que recupera la información de una camara
%% Entrada
% cam --> una estructura camara
% t_data -->string que indica el tipo de dato a recuperar del campo info de la camara, t_data = 'info' es un string valido y regresa la estructura info integramente.

%% Salida
% info_out -->informacion de salida, su tipo depende del string data
%% EJEMPLO
%  info_out = get_info_cam(cam(1), 'Rc') %devuelve la matriz Rc
%  info_out = get_info_cam(cam(1), 'Tc') %devuelve vector de traslacion Tc
%  info_out = get_info_cam(cam(1), 'f') %devuelve distancia focal en metros f 
%  info_out = get_info_cam(cam(1), 'resolution') %devuelve [resolución_x, resolution_y] unidades en pixeles
%  info_out = get_info_cam(cam(1), 't_vista') %devuelve tipo de vista utilizada en la camara (PERSPECTIVA, ORTOGRAFICA, PANORAMICA)
%  info_out = get_info_cam(cam(1), 'shift') %devuelve [shift_x, shidt_y] corrimiento del centro de la camara en pixeles
%  info_out = get_info_cam(cam(1), 'sensor') %devuelve [sensor_x, sensor_y] largo y ancho del sensor en milimetros
%  info_out = get_info_cam(cam(1), 'sensor_fit') %devuelve tipo de ajuste utilizado para el sensor (AUTO, HORIZONTAL, VERTICAL)
%  info_out = get_info_cam(cam(1), 'pixel_aspect') %devuelve (pixel_aspect_x)/(pixel_aspect_y) valor 1 indica pixel cuadrado
%  info_out = get_info_cam(cam(1), 'projection_matrix') %matrix de proyección de la camara

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