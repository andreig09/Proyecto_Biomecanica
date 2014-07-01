function cam = put_info_cam(info, cam)
% Funcion que actualiza "cam.info" con los valores de estructura "info"
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

cam.info = info;
end

