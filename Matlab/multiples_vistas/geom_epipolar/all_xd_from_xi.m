function [xi, xd, pos, d_min]= all_xd_from_xi(cam_i, cam_d, n_frame)
%Funcion que devuelve en el frame "n_frame"
%todos los coorespondientes puntos xd de la camara cam_d que generan
% el minimo de  |xd'*(F*xi)|, para cada xi perteneciente a la camara cam_i.
% Por lo tanto se logra un estimativo de la correspondencia de puntos entre
% dos vistas
%% Entrada
%cam_i -->camara "izquierda" o de origen
%cam_d -->camara "derecha" o de destino
%% Salida
% xi   ---->vector cuyas columnas son coordenadas de marcadores en el frame n_frame de camara cam_i 
% xd   ---->coorespondiente vector cuyas columnas son coordenadas de marcadores en el frame n_frame de camara cam_d
% d_min  -->vector con los minimos de |xd'*(F*xi)|
% pos    -->vector con las posiciones asociada a los marcadores de xd en la estructura cam_d en el frame n_frame
            %Ejemplo: pos(2)=3, indica que 
            %el punto xi que ocupa la posición 2 en cam_i 
            %se corresponde con 
            %el punto xd que ocupa la posición 3 en cam_d

xi = get_nube_markers(n_frame, cam_i);%todos los puntos del fram n_frame de camara cam_i
xd=xi;%inicializo salida
pos=xi(1,:);
d_min=xi(1,:);
for j=1:size(xi, 2)%para todos los puntos xi
    [xd(:,j), pos(j), d_min(j)] = xd_from_xi(xi(:,j), cam_i, cam_d, n_frame);    
end
end



