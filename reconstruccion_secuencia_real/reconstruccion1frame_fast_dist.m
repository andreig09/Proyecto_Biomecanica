 function Xrec = reconstruccion1frame_fast_dist(cam, v_cams, P, inv_P, foco, frame, umbral, tot_markers)



n_cams = length(v_cams);
x_cam = cell(1, n_cams);
n_markers_cam = cell(1, n_cams);

%Obtengo informacion de las camaras
%h=1;
for i=v_cams
    
    x_cam{i} = get_info(cam{i}, 'frame', frame, 'marker', 'coord'); %devuelve las coordenadas de todos los marcadores de la camara en el frame
    n_markers_cam{i} = size(x_cam{i}, 2); %numero de marcadores    
    %h = h+1;
    
   % [C{i}, u{i}] = recta3D(x_cam{i}, inv_P{i},  foco{i} );

end



valid_points=cell(n_cams, 1);

for i=v_cams
    %n_markers = get_info(cam(i), 'frame', frame, 'n_markers');
    %valid_points{i} = ones(1, n_markers);
    valid_points{i} = ones(1, n_markers_cam{i});
end



%m_dist = zeros(3,)

m_markers = cell2mat(n_markers_cam);
m_dist_s2 = sum(tril(repmat(m_markers, length(m_markers),1)')*m_markers') - m_markers*m_markers';
m_dist = zeros(5,m_dist_s2);
n_tot_sum = 1;

for i=v_cams
    for j=v_cams
        if i < j
           
            [C_i, u_i] = recta3D(x_cam{i}, inv_P{i},  foco{i} );
            [C_j, u_j] = recta3D(x_cam{j}, inv_P{j},  foco{j} );
            n_i = n_markers_cam{i};
            n_j = n_markers_cam{j};
            
            n_tot = n_i * n_j;
            u2_i = reshape(repmat(u_i',1,n_j)',3,n_tot);
            u2_j = reshape(repmat(u_j',1,n_i)',3,n_tot);
            
            o_i = reshape(repmat(1:n_i,1,n_j),1,n_tot);
            o_j = reshape(repmat((1:n_j)',1,n_i)',1,n_tot);
            
            C2_i = reshape(repmat(C_i',1,n_j)',3,n_tot);
            C2_j = reshape(repmat(C_j',1,n_i)',3,n_tot);

         
            dist = dist_2rectas(C2_i, u2_i, C2_j, u2_j);

       
           m_dist(:, n_tot_sum: n_tot_sum + n_tot -1 ) = [i * ones(1, n_tot); o_i; j * ones(1, n_tot); o_j; dist];
           
           n_tot_sum = n_tot_sum + n_tot;

        end
    end
end



[~, ind_m] = sort(m_dist(5,:));
m_dist = m_dist(:,ind_m);

Xrec = [];

for k = 1:tot_markers
    
    
    cam_i = m_dist(1,k);
    cam_d = m_dist(3,k);
    ind_i = m_dist(2,k);
    ind_d = m_dist(4,k);

[X, ~, ~, ~, valid_points]=validation3D_fast2(cam, cam_i, cam_d, x_cam, P, valid_points, 'index', ind_i, ind_d, 'umbral', umbral );

Xrec = [Xrec,X];

end

%{
figure(1)
plot(m_dist(5,:))
figure(2)
hist(m_dist(5,:))
%}










%m_dist = [m_dist; cell2mat(valid_points)]























%dist_2rectas(C1, u1, C2, u2)


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
dist = abs( dot(s,  (C2 - C1))) / norm(s);
end


end