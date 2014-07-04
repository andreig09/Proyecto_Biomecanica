function [xi, xd, pos, d_min]= cam2cam(varargin)
%Funcion que devuelve en el frame "n_frame"
%todos los coorespondientes puntos xd de la camara cam_d que generan
% el minimo de  |xd'*(F*xi)|, para los xi de entrada pertenecientes a la camara cam_i.
% Por lo tanto se logra un estimativo de la correspondencia de puntos entre
% dos vistas
%% Entrada
%cam_i = varargin{1};%camara "izquierda" o de origen
%cam_d = varargin{2};%camara "derecha" o de destino 
%n_frame = varargin{3}; %numero de frame 
%xi = varargin{4};%vector con los puntos de cam_i en frame n_frame a proyectar sobre cam_d 
% EJEMPLOS:
%       n_frame = 1;
%       list_markers = [1 2]
%       xi = get_markers_of_frame(n_frame, cam(1), list_frames); %devuelve los marcadores 1 y 2 del frame 1
%       [xi, xd, pos, d_min]= cam2cam(cam(1), cam(2), n_frame, xi)%devuelve todos los puntos del vector xi de cam(1) del frame n_frame y sus
%       correspondientes contrapartes xd de cam(2)
%
%       
%       [xi, xd, pos, d_min]= cam2cam(cam1, cam2, n_frame) %devuelve todos los
%       puntos xi de cam1 y sus correspondientes contrapartes xd de cam2
%
%% Salida
% xi   ---->vector cuyas columnas son coordenadas de marcadores en el frame n_frame de camara cam_i 
% xd   ---->coorespondiente vector cuyas columnas son coordenadas de marcadores en el frame n_frame de camara cam_d
% d_min  -->vector con los minimos de |xd'*(F*xi)|
% pos    -->vector con las posiciones asociada a los marcadores de xd en la
% estructura cam_d en el frame n_frame 
            %Ejemplo: pos(2)=3, indica que 
            %el punto xi que ocupa la posición 2 en cam_i 
            %se corresponde con
            %el punto xd que ocupa la posición 3 en cam_d

            
    %proceso la entrada
    if length(varargin)==3 %se quiere proyectar todos los puntos de cam_i a cam_d
        cam_i = varargin{1};%camara "izquierda" o de origen
        cam_d = varargin{2};%camara "derecha" o de destino 
        n_frame = varargin{3};%numero de frame  
        xi = get_markers_of_frame(n_frame, cam_i);%todos los puntos del frame n_frame de camara cam_i  
    elseif length(varargin)== 4
        cam_i = varargin{1};%camara "izquierda" o de origen
        cam_d = varargin{2};%camara "derecha" o de destino 
        n_frame = varargin{3}; %numero de frame 
        xi = varargin{4};%vector con los puntos de cam_i en frame n_frame a proyectar sobre cam_d 
    end            
            
    %encuentro cuantos puntos xi quiero proyectar en cam_d
    n_xi = size(xi, 2);
    
    if (n_xi == 1) %tengo un solo punto xi
        [xd, pos, d_min] = xd_from_xi(xi, cam_i, cam_d, n_frame);
    else %tengo mas de un punto
        xd=ones(3, n_xi);%inicializo salidas
        pos=ones(1,n_xi);
        d_min=ones(1,n_xi);
        for j=1:size(xi, 2)%para todos los puntos xi
            [xd(:,j), pos(j), d_min(j)] = xd_from_xi(xi(:,j), cam_i, cam_d, n_frame);    
        end
    end
end
          

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
    xd = get_markers_of_frame(n_frame, cam_d); %obtengo todos las coordenadas de los marcadores en el frame n_frame de la camara derecha
    [d_min, pos]=min(abs(xd'*ld));%encuentro la minima distancia a la recta
    %igual a encontrar el valor de (xd'*ld) más cercano al cero (gracias a que utilizamos coordenadas homogeneas ;) )
    xd=xd(:,pos);
end

