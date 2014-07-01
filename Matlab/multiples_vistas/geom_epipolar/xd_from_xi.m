function [xd, pos, d_min] = xd_from_xi(xi, cam_i, cam_d, n_frame)
% Funcion que devuelve el punto xd de la camara cam_d que genera
% el minimo de  |xd'*(F*xi)|, donde xi pertenece a la camara cam_i
% con lo cual se logra un estimativo de la correspondencia de puntos entre
% dos vistas
%% Entrada
% xi   -->punto de la camara cam_i
%cam_i -->camara "izquierda" o de origen
%cam_d -->camara "derecha" o de destino
%% Salida
% xd   ---->punto de la camara cam_d
% d_min  -->minimo de |xd'*(F*xi)|
% pos    -->posicion asociada al marcador xd en la estructura cam_d en el
% frame n_frame

Pi = get_Pcam(cam_i);
Pd = get_Pcam(cam_d);
F= F_from_P(Pi, Pd);
ld = F*xi; %recta en cam_d
ld = homog_norm(ld);%normalizo vector de la recta
xd = get_nube_markers(n_frame, cam_d); %obtengo todos las coordenadas de los marcadores en el frame n_frame de la camara derecha
[d_min, pos]=min(abs(xd'*ld));%encuentro la minima distancia a la recta
%igual a encontrar el valor de (xd'*ld) más cercano al cero (gracias a que utilizamos coordenadas homogeneas ;) )
xd=xd(:,pos);
end