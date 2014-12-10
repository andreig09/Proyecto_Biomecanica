% se diferencia de la verion anterior en que incluye el valid_points para
% los puntos recontruidos de menor distancia entre rectas.



function Xrec = reconstruccion1frame_fast_dist2(cam, v_cams, P, inv_P, foco, frame, umbral, tot_markers)



n_cams = length(v_cams);    %num de cámaras
x_cam = cell(1, n_cams);    % coordenadas 2D de las cámaras (inicializa)
n_markers_cam = cell(1, n_cams);    % num. de marcadores detectado por cámara (inicializa)
valid_points=cell(n_cams, 1);   % puntos 2D que se tienen en cuenta para c/ cámara

%Obtengo informacion de las camaras
%h=1;
for i=v_cams
    

    x_cam{i} = get_info(cam{i}, 'frame', frame, 'marker', 'coord'); %devuelve las coordenadas de todos los marcadores de la camara en el frame
    n_markers_cam{i} = size(x_cam{i}, 2); %numero de marcadores    
    %h = h+1;
    
   % [C{i}, u{i}] = recta3D(x_cam{i}, inv_P{i},  foco{i} );
   valid_points{i} = ones(1, n_markers_cam{i});

end








%m_dist = zeros(3,)

m_markers = cell2mat(n_markers_cam);    %vector numero de marcadores por cámara

% numero de combinaciones posibles entre puntos de diferentes cámaras
m_dist_s2 = sum(tril(repmat(m_markers, length(m_markers),1)')*m_markers') - m_markers*m_markers';

%inicializa matriz de distancias entre dos rectas 3D cualquiera y tomando en cuenta
%todas las combinaciones posibles. Las rectas 3D son las que se conforman con los focos
% de las cámaras y los puntos 2D de las retinas. Cada columna es una combinacion posible
% de dos de esas rectas (considerando todas las cámaras). Cada fila se
% compone:
% 1: camara a
% 2: punto 2D camara a
% 3: camara b
% 4: punto 2D camara b
% 5: distancia entre las rectas 3D de los puntos considerados en las filas
% anteriores
% 6: variable booleana que indica si esa combinacion de rectas es válida para
% reconstruir un punto 3D.
m_dist = inf*ones(6,m_dist_s2);

n_tot_sum = 1;

for i=v_cams
    for j=v_cams
        if i < j
           
            [C_i, u_i] = recta3D(x_cam{i}, inv_P{i},  foco{i} );
            [C_j, u_j] = recta3D(x_cam{j}, inv_P{j},  foco{j} );
            n_i = n_markers_cam{i};
            n_j = n_markers_cam{j};
            
            n_tot = n_i * n_j;
            %u2_i =reshape(repmat(u_i',1,n_j)',3,n_tot);%-----------------------
            u2_i = reshape(repmat(u_i,1,n_j),3,n_tot);
            
            u2_j = reshape(repmat(u_j',1,n_i)',3,n_tot);
            
            o_i = reshape(repmat(1:n_i,1,n_j),1,n_tot);
            o_j = reshape(repmat((1:n_j)',1,n_i)',1,n_tot);
            
            %C2_i = reshape(repmat(C_i',1,n_j)',3,n_tot);%--------------------
            C2_i = reshape(repmat(C_i,1,n_j),3,n_tot);
            
            C2_j = reshape(repmat(C_j',1,n_i)',3,n_tot);

         
            dist = dist_2rectas(C2_i, u2_i, C2_j, u2_j);
            
           
            


       
           m_dist(:, n_tot_sum: n_tot_sum + n_tot -1 ) = [i * ones(1, n_tot); o_i; j * ones(1, n_tot); o_j; dist; ones(1,n_tot)];
           
           n_tot_sum = n_tot_sum + n_tot;

        end
    end
end

%m_dist
[~, ind_m] = sort(m_dist(5,:));
m_dist_ord = m_dist(:,ind_m);

%figure(10)
%plot(m_dist_ord(5,:),'*')

%{
[C_i, u_i] = recta3D(x_cam{3}(:,1:4), inv_P{3},  foco{3} );
[C_j, u_j] = recta3D(x_cam{4}(:,1:4), inv_P{4},  foco{4} );
dist1 = dist_2rectas(C_i, u_i, C_j, u_j)

[C_i, u_i] = recta3D(x_cam{3}(:,4), inv_P{3},  foco{3} );
[C_j, u_j] = recta3D(x_cam{4}(:,4), inv_P{4},  foco{4} );
dist2 = dist_2rectas(C_i, u_i, C_j, u_j)
%}


Xrec = [];
k = 1;

m_dist_valid = m_dist_ord;

m_dist_valid(:,1:13)

flag=0;

while k <= tot_markers && sum(m_dist(6,:)) ~= 0 && flag == 0
    
    
    %disp([num2str(m_dist_valid(2,1)) ' - ' num2str(m_dist_valid(4,1)) ' - ' num2str(m_dist_valid(5,1))])
    
 

    
    cam_i = m_dist_valid(1,1);
    cam_d = m_dist_valid(3,1);
    ind_i = m_dist_valid(2,1);
    ind_d = m_dist_valid(4,1);
    
    if m_dist_valid(5,1) < inf

        [X, ~, ~, ~, valid_points]=validation3D_fast2(cam, cam_i, cam_d, x_cam, P, valid_points, 'index', ind_i, ind_d, 'umbral', umbral );

        valid_points{cam_i}(ind_i) = 0;
        valid_points{cam_d}(ind_d) = 0;

        valid = m_dist(6,:);
        valid = actualizar_valid(valid, valid_points, v_cams, n_markers_cam);
        m_dist(6,:) = valid;

        m_dist_ord = m_dist(:,ind_m);
        m_dist_valid = m_dist_ord(:,m_dist_ord(6,:)==1);

        Xrec = [Xrec,X];
    else
        flag=1;
        
        
    end
   

k=k+1;




end

%{
figure(1)
plot(m_dist(5,:))
figure(2)
hist(m_dist(5,:))
%}










%m_dist = [m_dist; cell2mat(valid_points)]


















end






%m_valid_i = ones(1,m_dist_s2);

%dist_2rectas(C1, u1, C2, u2)

function valid = actualizar_valid(valid, valid_points, v_cams, n_markers_cam)
    
n_tot_sum = 1;   
    
for i=v_cams
    for j=v_cams
        if i < j
            
            n_i = n_markers_cam{i};
            n_j = n_markers_cam{j};
            
            n_tot = n_i * n_j;
            
            valid_points_i = valid_points{i};
            valid_points_j = valid_points{j};
            
            valid_i = reshape(repmat(valid_points_i,1,n_j),1,n_tot);
            valid_j = reshape(repmat(valid_points_j',1,n_i)',1,n_tot);
            
            valid_it = valid_i .* valid_j;

       
           valid(:, n_tot_sum: n_tot_sum + n_tot -1 ) = valid_it;
           
           n_tot_sum = n_tot_sum + n_tot;

        end
    end
end

    
end



function [C, u] = recta3D(p_retina, inv_P,  foco_h )
% Dada una cámara y un punto en su retina, devuelve la recta en el espacio
% que pasa por dicho punto y el foco de la cámara. La recta 3D es de la
% forma (x,y,z) = C + lambda*u, donde C es un punto de la recta
% (en particular el foco de la cámara), u es el
% vector dirección y lambda un escalar.

% entrada:
%   cam: una de las camaras de la estructura cam
%   p_retina: punto de la retina de la cámara en píxeles (coord. homogeneas)

% salida:
%    P: un punto de la recta
%    u: vector director 'u'

% p_retina puede ser una matriz de puntos p_retina(i,j) siendo las filas,
% las 3 coordenas y las columnas los distintos puntos. En ese caso u tiene
% la forma u(i,j) donde se devuelve un vector director para cada punto
% ingresado.

%P_matrix= get_info(cam, 'projection_matrix') ; % matriz de proyeccion de la cámara

%foco_h = null(P_matrix);  % foco de la cámara en coord homg.
%invP = pinv(P_matrix);
punto3D_h = inv_P*p_retina; % punto 3D cualquiera tal que si se proyecta en la cámara se obtiene p_retina (coord. homog)

punto3D = homog2euclid(punto3D_h); % pasa a coord. euclideas
%foco = homog2euclid(foco_h);    % pasa a coord. euclideas

num_puntos = size(p_retina,2);

C =foco_h*ones (1,num_puntos);

u = punto3D - C;  % vector director de la recta

% normalizo vector director
normas = sqrt(u(1,:).^2 + u(2,:).^2 + u(3,:).^2);
normas = [normas; normas; normas];
u=u./normas;
% u(1,:) = u(1,:)./normas;
% u(2,:) = u(2,:)./normas;
% u(3,:) = u(3,:)./normas;
% 
% 
%C = foco;
end

%%
function dist = dist_2rectas(C1, u1, C2, u2)
% dadas 2 rectas con sus respectivos puntos y vectores directores (C1 y u1,
% para la recta 1 y C2, u2 para la recta 2) devulve la distancia que hay
% entre ellas.

s = cross (u1,u2);
%dist = abs( dot(s,  (C2 - C1))) /norm(s);%./
%sqrt(sum(s.^2,1));-----------------------------------------------------
dist = abs( dot(s,  (C2 - C1)))./ sqrt(sum(s.^2,1));
end


