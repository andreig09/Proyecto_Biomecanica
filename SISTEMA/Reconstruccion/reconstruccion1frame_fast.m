

%ACTUALMENTE EJEMPLO DE UN CODIGO SIN COMENTARIOS; PRONTO PARA CAER EN EL OLVIDO DENTRO DE UNAS SEMANAS
%function Xrec = reconstruccion1frame(cam, v_cams, frame, umbral, tot_markers)
function Xrec = reconstruccion1frame_fast(cam, v_cams, P, inv_P, C, frame, umbral, tot_markers)
% PONER ACA QUE HACE LA FUNCION Y COMO LO HACE
%% ENTRADA
% cam -->
% v_cams -->
% frame -->
% umbral -->
% tot_markers -->
%% SALIDA
% Xrec -->
%% CUERPO DE LA FUNCION
n_cams = length(v_cams);
x_cam = cell(1, n_cams);
n_markers_cam = ones(1, n_cams);
%Obtengo informacion de las camaras
for i=v_cams
x_cam{i} = get_info(cam{i}, 'frame', frame, 'marker', 'coord'); %devuelve las coordenadas de todos los marcadores de la camara en el frame
%pixel_error = 2 ;x_cam{i} = [x_cam{i}(1:2,:)+pixel_error*randn(size(x_cam{i}(1:2,:)));x_cam{i}(3,:)]; % linea q agrega pixeles aleatorios a las camaras
n_markers_cam(i) = size(x_cam{i}, 2); %numero de marcadores
end
%matches = matchear1(cam, v_cams, frame);
matches = matchear1(x_cam, n_markers_cam, P, v_cams);
%valid_matches = matches;
valid_points=cell(n_cams, 1);
for i=v_cams
%n_markers = get_info(cam(i), 'frame', frame, 'n_markers');
%valid_points{i} = ones(1, n_markers);
valid_points{i} = ones(1, n_markers_cam(i));
end
%Xrec = [];
Xrec = zeros(3,tot_markers);
%pasadas = 0;
%p_validos = inf;
for k = 1:tot_markers
%while (p_validos > 0 && size(Xrec,2) < tot_markers)
valid_matches = actualizar_matches(matches, valid_points, v_cams);
%[res, cam_i, ind_i, cam_d, ind_d] = best_match(valid_matches, cam, frame, v_cams);
[res, cam_i, ind_i, cam_d, ind_d] = best_match(valid_matches, v_cams, x_cam, inv_P, C );
if res == 0
break
end
%[X, validation, n_cam3, index_x3, ~, valid_points] = validation3D(cam, cam_i,cam_d, frame, 'index', ind_i, ind_d, 'umbral', umbral, valid_points);
%[X, ~, ~, ~, ~, valid_points] = validation3D(cam, cam_i,cam_d, frame, 'index', ind_i, ind_d, 'umbral', umbral, valid_points);
[X, ~, ~, ~, valid_points]=validation3D_fast2(cam, cam_i, cam_d, x_cam, P, valid_points, 'index', ind_i, ind_d, 'umbral', umbral );
valid_points{cam_i}(ind_i) = 0; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
valid_points{cam_d}(ind_d) = 0;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%Xrec = [Xrec,X];
Xrec(:,k) = X;
%pasadas = pasadas+1;
%disp(pasadas)
p_validos = 0;
for h = 1:n_cams
p_validos = p_validos + sum(valid_points{h});
end
if (p_validos < 0 || sum(Xrec(:,tot_markers)))
return
end
end
end
%%
%function matches = matchear1(cam, v_cams, frame)
function matches = matchear1(x_cam, n_markers_cam, P, v_cams)
%Funcion que devuelve las parejas que lograron emparejarse tras hacer cam2cam de cam_izq a cam_der y luego cam2cam de cam_der a cam_izq
%% ENTRADAS
% cam -->estructura con camaras
% v_cam -->
% frame -->
%% SALIDAS
% matches -->
%% CUERPO DE LA FUNCION
n_cams = length(v_cams);%numero de camaras
matches = cell(n_cams);%un cell para cada camara
%La idea es generar una matriz con dos filas, y que cada columna contenga
%una combinacion de camaras para hacer cam2cam
%n_markers_cam = zeros(1, n_cams);%inicializo la variable
%n_markers_i = ones(n_cams, n_cams); %la idea es poner aqui n_cams veces el numero de cada marcador para luego generar las parejas
n_cam_i = ones(n_cams, n_cams); %la idea es poner aqui el numero de camara de cada indice contenido en aux1
aux1 = ones(n_cams, n_cams);
for i = v_cams %hacer para cada camara de v_cams
%n_markers_cam(i) = get_info(cam(i), 'frame', frame, 'n_markers'); %vector con el numero de marcadores de cada camara
aux1(:,i) = n_markers_cam(i)*ones(n_cams, 1);
n_cam_i(:,i) = i*ones(n_cams, 1);
end
%matriz que contiene los pares de camaras asi como los indices necesarios para hacer los cam2cam en ambas direcciones
% pairs = [n_cam_i(:);...
% n_cam_d(:);...
% n_markers_i(:);...
% n_markers_d(:)];
pairs =[n_cam_i(:)'; repmat(v_cams, 1, n_cams); aux1(:)' ; repmat(n_markers_cam, 1, n_cams) ];
%n_pairs = size(pairs, 2); %indica cuantos pares se tienen formados
k=0;
for i = v_cams %hacer para cada camara en v_cams

k=k+1;

if i==v_cams(end)
	j = v_cams(1);
	
else
	j = v_cams(k+1);
end

%for j=v_cams
%if i < j
%index = find((pairs(1,:)==i)&(pairs(2,:)==j));
n_markers_i = n_markers_cam(i);
n_markers_d = n_markers_cam(j);
%ix_table1 = cam2cam_fast(cam(i), cam(j), frame, n_markers_d);
%ix_table2 = cam2cam_fast(cam(j), cam(i), frame, n_markers_i);
ix_table1 = cam2cam_fast(x_cam{i}, n_markers_i, P{i}, x_cam{j}, n_markers_d, P{j} );
ix_table2 = cam2cam_fast(x_cam{j}, n_markers_d, P{j}, x_cam{i}, n_markers_i, P{i} );
%n_markers_i = get_info(cam(i), 'frame', frame, 'n_markers');
%n_markers_d = get_info(cam(j), 'frame', frame, 'n_markers');
%[~, ~, ix_table1, ~]= cam2cam( cam(i), cam(j), frame, 'n_points',n_markers_d,'show');
%[~, ~, ix_table2, ~]= cam2cam( cam(j) , cam(i), frame,'n_points',n_markers_i,'show');
matches{i,j} = ix_table1;
matches{j,i} = ix_table2;
%end
%end
end
end
%%
function valid_matches = actualizar_matches(matches, valid_points, v_cams)
%Funcion que .....
%% ENTRADAS
% cam -->estructura con camaras
% valid_points -->
% v_cams -->
%% SALIDAS
% valid_matches -->
%% CUERPO DE LA FUNCION
n_cams = length(v_cams);
%inicializo variables
valid_matches = cell(n_cams, n_cams);
for i=v_cams
for j=v_cams
if ~isempty(matches{i,j})
%valid_matches{i,j} = [];
ind = valid_points{i}==1; %indices dee los puntos validos en la camara i
valid_matches_i = matches{i,j}(ind,:);%me quedo solo con las parejas conformadas a partir de puntos que aun pueden validar en camara i
%ordeno los marcadores de la camara j de menor a mayor, de manera de poder enmascarar con validation{j}
%de los puntos que "sobrevivieron" me quedo con el
%que se encuentra con menor indice de columna en cada fila de valid_matches_i
[~,index_sort_cam_j] = sort(valid_matches_i(:,2:end),2);%ordeno los indices de la camara j de menor a mayor, pero solo me preocupo de llevar los las columnas iniciales que ocupaban en cada fila de valid_matches_i
%l1_matches = size(valid_matches_i,1); %numero de indices validos en camara i
%rep_ones = ones(l1_matches,1); %es igual a ind(ind)'
%valid_ind_ord = (rep_ones * valid_points{j}) .* index_sort_cam_j;%apago en ind_ord los puntos que no juegan pues ya se usaron para validaciones anteriores
%ind(ind)' devuelve un vector de unos que tiene largo igual a la cantidad de unos que tenga ind
valid_ind_ord = (ind(ind)' * valid_points{j}) .* index_sort_cam_j; %utilizo la mascara de valid_points, para saber que indices puedo utilizar
valid_ind_ord(valid_ind_ord ==0)=inf; %pongo los indices que no puedo usar en infinito
[~, best_match] = min(valid_ind_ord,[],2);%encuentro el minimo de cada fila, o sea que se va a devolver en cada fila la primer columna de valid_matches_i que se puede utilizar
%[best_ind, ~] = min(valid_ind_ord,[],2);%encuentro el minimo de cada fila, o sea que se va a devolver en cada fila la primer columna de valid_matches_i que se puede utilizar
% for k = 1:l1_matches
% if best_ind(k) ~= inf
% valid_matches{i,j}= [valid_matches{i,j}; valid_matches_i(k,1), valid_matches_i(k,best_ind(k)+1)];
% end
% end
valid_matches{i, j} = [valid_matches_i(:,1), best_match];
end
end
end
end
%%
%function [res, cam_i, ind_i, cam_d, ind_d] = best_match(valid_matches, cam, frame, v_cams)
function [res, cam_i, ind_i, cam_d, ind_d] = best_match(valid_matches, v_cams, x_cam, inv_P, C )
%Funcion que .....
%% ENTRADAS
% valid_matches -->
% cam -->estructura con camaras
% frame -->
% v_cams -->
%% SALIDAS
% valid_matches -->
%% CUERPO DE LA FUNCION
n_cams = length(v_cams);
%num_matches = size(valid_matches);
matriz_distancias = cell((n_cams.^2-n_cams)/2, 1);
aux=1;
for i = v_cams
for j = v_cams
%if i~=j && ~isempty(valid_matches{i,j})
if i<j && ~isempty(valid_matches{i,j})
ind_i = valid_matches{i,j}(:,1);
ind_d = valid_matches{i,j}(:,2);
n_points = length(ind_i);
pcam_i = x_cam{i}(:,ind_i);
pcam_d = x_cam{j}(:,ind_d);
[Ci,ui] = recta3D(pcam_i, inv_P{i}, C{i} );
[Cd,ud] = recta3D(pcam_d, inv_P{j}, C{j} );
dist = dist_2rectas(Ci, ui, Cd, ud);
matriz_distancias{aux} = [dist', i*ones(n_points, 1), ind_i, j*ones(n_points, 1), ind_d]; %aqui inicializaria con zeros o ones a matriz_distancia con el tamaño maximo que puede tener y luego de llenado borro lo que no sirva
aux = aux+1;
% %match_pares{i,j} = [];
% s_vmatchesi = size(valid_matches{i,j},1);
% s_vmatchesd = size(valid_matches{j,i},1);
% %aux_ix_table2 = valid_matches{j,i}(:,[2,1]);
% for m = 1:s_vmatchesi
% for n= 1:s_vmatchesd
%
%
% if valid_matches{i,j}(m,:) == valid_matches{j,i}(n,[2, 1])
%
% %match_pares{i,j} = [match_pares{ci},i];
% % match_pares{i,j} = [match_pares{i,j}; valid_matches{i,j}(m,:)];
%
% ind_i = valid_matches{i,j}(m,1);
% ind_d = valid_matches{i,j}(m,2);
%
% %pcam_i = get_info(cam(i), 'frame', frame, 'marker', ind_i);
% pcam_i = x_cam{i}(:,ind_i);
% %pcam_d = get_info(cam(j), 'frame', frame, 'marker', ind_d);
% pcam_d = x_cam{j}(:,ind_d);
% %[Ci,ui] = recta3D(cam(i), pcam_i);
% %[Cd,ud] = recta3D(cam(j), pcam_d);
% [Ci,ui] = recta3D(pcam_i, P{i}, C{i} );
% [Cd,ud] = recta3D(pcam_d, P{j}, C{j} );
%
% dist = dist_2rectas(Ci, ui, Cd, ud);
%
% matriz_distancias = [matriz_distancias; dist, i, ind_i, j, ind_d]; %aqui inicializaria con zeros o ones a matriz_distancia con el tamaño maximo que puede tener y luego de llenado borro lo que no sirva
%
% end
%
% end
end
end
end
matriz_distancias = cell2mat(matriz_distancias);
if isempty(matriz_distancias)
res = 0;
cam_i = [];
ind_i = [];
cam_d = [];
ind_d = [];
else
res = 1;
[~,ind_min_dist] = min(matriz_distancias(:,1));
cam_i = matriz_distancias(ind_min_dist,2);
ind_i = matriz_distancias(ind_min_dist,3);
cam_d = matriz_distancias(ind_min_dist,4);
ind_d = matriz_distancias(ind_min_dist,5);
end
end
%%
%function [C,u] = recta3D(cam, p_retina)
function [C, u] = recta3D(p_retina, inv_P, foco_h )
% Dada una cámara y un punto en su retina, devuelve la recta en el espacio
% que pasa por dicho punto y el foco de la cámara. La recta 3D es de la
% forma (x,y,z) = C + lambda*u, donde C es un punto de la recta
% (en particular el foco de la cámara), u es el
% vector dirección y lambda un escalar.
% entrada:
% cam: una de las camaras de la estructura cam
% p_retina: punto de la retina de la cámara en píxeles (coord. homogeneas)
% salida:
% P: un punto de la recta
% u: vector director 'u'
% p_retina puede ser una matriz de puntos p_retina(i,j) siendo las filas,
% las 3 coordenas y las columnas los distintos puntos. En ese caso u tiene
% la forma u(i,j) donde se devuelve un vector director para cada punto
% ingresado.
%P_matrix= get_info(cam, 'projection_matrix') ; % matriz de proyeccion de la cámara
%foco_h = null(P_matrix); % foco de la cámara en coord homg.
%invP = pinv(P_matrix);
punto3D_h = inv_P*p_retina; % punto 3D cualquiera tal que si se proyecta en la cámara se obtiene p_retina (coord. homog)
punto3D = homog2euclid(punto3D_h); % pasa a coord. euclideas
%foco = homog2euclid(foco_h); % pasa a coord. euclideas
num_puntos = size(p_retina,2);
C =foco_h*ones (1,num_puntos);
u = punto3D - C; % vector director de la recta
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
dist = abs( dot(s, (C2 - C1))) / norm(s);
end
%
%
%
%
%
%
%
%
% for frame_i =1:max_frames
%
% for ci = v_cams
%
% if ci < lv_cams
%
%
% [~, ~, ix_table1, ~]= cam2cam( cam(v_cams(ci)), cam(v_cams(ci+1)), frame_i,'show');
% [~, ~, ix_table2, ~]= cam2cam( cam(v_cams(ci+1)) , cam(v_cams(ci)), frame_i,'show');
%
% else
%
%
% [~, ~, ix_table1, ~]= cam2cam( cam(v_cams(ci)), cam(v_cams(1)), frame_i,'show');
% [~, ~, ix_table2, ~]= cam2cam( cam(v_cams(1)) , cam(v_cams(ci)), frame_i,'show');
% end
%
%
% match_cam{ci} = ix_table1;
% match_pares{ci} = [];
% aux_ix_table2 = ix_table2(:,[2,1]);
% for i = 1:size(ix_table1,1)
% for j= 1:size(ix_table2,1)
%
%
% if ix_table1(i,:) == aux_ix_table2(j,:)
%
% match_pares{ci} = [match_pares{ci},i];
% end
%
% end
% end
%
% end
%
%
% %[xi, xd, index_table, d_min]= cam2cam(cam(1), cam(2), 1, 'index', [1 2 3], 'show');
% %%
% %n_frame = 100;
% %n_cam1=3;
% %n_cam2=4;
% %genero el cell array valid_points que guarda informacion sobre que puntos ya fueron utilizados para validar algun marcador.
% %valid_points{i}(j)=1 indica que el marcador j de la camara i esta disponidble para validar.
%
% % inicalizo una matriz de puntos que aun no han sido validados
% %%
% valid_points=cell(n_cams, 1);
% for i=1:n_cams
% n_markers = get_info(cam(i), 'frame', frame_i, 'n_markers');
% valid_points{i} = ones(1, n_markers);
% end
% %%
% % ordeno las cámaras segun la cantidad de puntos correctamente matcheados
% cant_cam = [];
% for ci = v_cams
% cant_cam = [cant_cam, sum(match_pares{ci})];
% end
%
% [~,ind] = sort(cant_cam);
% v_cams_ord = v_cams(ind);
%
% Xrec = [];
% % valido los puntos previamente matcheados
% for ci = v_cams_ord
%
% if isempty(valid_points)
% break;
% end
%
% n_cam1 = ci;
% if ci < lv_cams
% n_cam2 = ci+1;
% else
% n_cam2 = 1;
% end
%
% index1 = match_cam{ci}([match_pares{ci}],1);
% index2 = match_cam{ci}([match_pares{ci}],2);
%
% [X, validation, n_cam3, index_x3, ~, valid_points] = validation3D(cam, n_cam1, n_cam2, frame_i, 'index', index1', index2', 'umbral', umbral, valid_points);
%
% %[X, validation, n_cam3, index_x3, ~, valid_points] = validation3D(cam, 1, 2, frame_i, 'index', [1:10], [1:10], 'umbral', 10, valid_points);
%
% for j = 1:size(X,2)
% if sum(validation(:,j))>=1
%
% Xrec = [Xrec,X];
% end
% end
% % rec_cam(ci).X = X;
% % rec_cam(ci).validation = validation;
% % rec_cam(ci).n_cam3 = n_cam3;
% % rec_cam(ci).index_x3 = index_x3;
%
%
% end
%
% plot3(Xrec(1,:),Xrec(2,:),Xrec(3,:) ,'*')
% axis equal
% grid on
% pause(0.01)
% %reconstruccion{frame_i} = Xrec;
% %frame_i
% end
%
%
% %%
%
%
%
%
%
%
%
%
%
%
%
%
%
%
%
% for i=1:max_frames
% Xrec = reconstruccion{i};
% plot3(Xrec(1,:),Xrec(2,:),Xrec(3,:) ,'*')
% axis equal
% grid on
% pause(0.1)
% end
%
%
%
%
%
%
%
%
%
%
%
%
%
%
%
%
%
% function matches = actualizar_matches1 (matches, valid_points)
%
% num_matches = length(A);
% for i=1:num_matches
% for j=1:num_matches
% if i~=j
% l2_matches = size(matches{i,j},2);
% matches{i,j} = matches{i,j}.*(valid_points{i}'*ones(1,l2_matches));
%
% ind = find(valid_points{i}==1);
% valid_matches{i,j} = matches{i,j}(ind,:);
% end
% end
% end
% end
%
%
% function matches = actualizar_matches2(matches, valid_points)
%
% num_matches = length(matches);
% for i=1:num_matches
% for j=1:num_matches
% if i~=j
%
%
% ind = find(valid_points{i}==1);
% valid_matches_i{i,j} = matches{i,j}(ind,:);
%
% [~,ind_ord] = sort(valid_matches_i{i,j}(:,2:end),2);
% l1_matches = size(matches{i,j},1);
% rep_ones = ones(l1_matches,1);
%
% valid_ind_ord = (rep_ones * valid_points{j}) .* ind_ord;
%
% best_ind = min(valid_ind_ord(valid_ind_ord>0),2);
%
% for k = 1:l1_matches
% valid_matches{i,j}(k,:) = [valid_matches_i{i,j}(k,1), valid_matches_i{i,j}(k,best_ind(k))];
% end
% %best_valid_matches = [valid_matches{i,j}(:,1), valid_matches{i,j}(:,)
%
%
% end
% end
% end
% end
%
% function matches = actualizar_matches (matches, valid_points)
%
% num_matches = size(matches);
%
% for i=1:num_matches(1)
%
% ind_nulos = find(valid_points{i}==0);
%
% for j=1:num_matches(2)
%
% matches{i,j}{ind_nulos} = [];
% end
%
% end
% end
%
%
% function matcheos_nz = eliminar_filas_nulas(matcheos)
%
% matches{:,:} =
%
% end
%
% function valid_matches = mejores_parejas(valid_matches)
%
%
% end
%



