

clc

close all
clear all

load 'saved_vars/cam.mat';
%load 'saved_vars/cam_andrei.mat';
load 'saved_vars/skeleton.mat';
n_cams = get_info(skeleton, 'n_cams');

%%
p = 0.80; 
aux_cam = dirty_cam(cam,p);
cam = aux_cam;

%%


v_cams = [1:n_cams]; % vector de cámaras
lv_cams = length(v_cams); 
frame_i = 1;
max_frames = 100;
umbral = .000001;

for frame_i =1:max_frames
%%
for ci = v_cams
    
    if ci < lv_cams
        

    [~, ~, ix_table1, ~]= cam2cam(  cam(v_cams(ci)), cam(v_cams(ci+1)), frame_i,'show');
    [~, ~, ix_table2, ~]= cam2cam(  cam(v_cams(ci+1)) , cam(v_cams(ci)), frame_i,'show');
    
    else
        

            [~, ~, ix_table1, ~]= cam2cam(  cam(v_cams(ci)), cam(v_cams(1)), frame_i,'show');
            [~, ~, ix_table2, ~]= cam2cam(  cam(v_cams(1)) , cam(v_cams(ci)), frame_i,'show');
    end

  
    match_cam{ci} = ix_table1;
    match_pares{ci} = [];
    aux_ix_table2 = ix_table2(:,[2,1]);
    for i = 1:size(ix_table1,1)
        for j= 1:size(ix_table2,1)
                
            
            if ix_table1(i,:) == aux_ix_table2(j,:)
   
                match_pares{ci} = [match_pares{ci},i];
            end

        end
    end
    
end


%[xi, xd, index_table, d_min]= cam2cam(cam(1), cam(2), 1, 'index', [1 2 3], 'show');
%%
%n_frame = 100;
%n_cam1=3;
%n_cam2=4;
%genero el cell array valid_points que guarda informacion sobre que puntos ya fueron utilizados para validar algun marcador. 
%valid_points{i}(j)=1  indica que el marcador j de la camara i esta disponidble para validar.

% inicalizo una matriz de puntos que aun no han sido validados
%%
valid_points=cell(n_cams, 1);
for i=1:n_cams
    n_markers = get_info(cam(i), 'frame', frame_i, 'n_markers');
    valid_points{i} = ones(1, n_markers);
end
%%
% ordeno las cámaras segun la cantidad de puntos correctamente matcheados
cant_cam = [];
for ci = v_cams
    cant_cam =  [cant_cam, sum(match_pares{ci})];
end

[~,ind] = sort(cant_cam);
v_cams_ord = v_cams(ind);

Xrec = [];
% valido los puntos previamente matcheados
for ci = v_cams_ord
    
    if isempty(valid_points)
        break;
    end
    
    n_cam1 = ci;
    if ci < lv_cams
        n_cam2 = ci+1;
    else
        n_cam2 = 1;
    end
    
    index1 = match_cam{ci}([match_pares{ci}],1);
    index2 = match_cam{ci}([match_pares{ci}],2);
    
    [X, validation, n_cam3, index_x3, ~, valid_points] = validation3D(cam, n_cam1, n_cam2, frame_i, 'index', index1', index2', 'umbral', umbral, valid_points);
    
    %[X, validation, n_cam3, index_x3, ~, valid_points] = validation3D(cam, 1, 2, frame_i, 'index', [1:10], [1:10], 'umbral', 10, valid_points);
    
    for j = 1:size(X,2)
        if sum(validation(:,j))>=1
 
            Xrec = [Xrec,X];
        end
    end
   % rec_cam(ci).X = X; 
   % rec_cam(ci).validation = validation;
   % rec_cam(ci).n_cam3 = n_cam3;
   % rec_cam(ci).index_x3 = index_x3;
   
    
end

plot3(Xrec(1,:),Xrec(2,:),Xrec(3,:) ,'*')
 axis equal
 grid on
 pause(0.01)
%reconstruccion{frame_i} = Xrec;
%frame_i
end


%%

for i=1:max_frames
Xrec = reconstruccion{i};
 plot3(Xrec(1,:),Xrec(2,:),Xrec(3,:) ,'*')
 axis equal
 grid on
 pause(0.1)
end

function matches = actualizar_matches1 (matches, valid_points)

    num_matches = length(A);
    for i=1:num_matches
        for j=1:num_matches
            if i~=j
                l2_matches = size(matches{i,j},2);
                matches{i,j} = matches{i,j}.*(valid_points{i}'*ones(1,l2_matches));
                
                ind = find(valid_points{i}==1);
                valid_matches{i,j} = matches{i,j}(ind,:);
            end
        end
    end
end


function matches = actualizar_matches2(matches, valid_points)

    num_matches = length(matches);
    for i=1:num_matches
        for j=1:num_matches
            if i~=j

                
                ind = find(valid_points{i}==1);
                valid_matches_i{i,j} = matches{i,j}(ind,:);
                
                [~,ind_ord] = sort(valid_matches_i{i,j}(:,2:end),2);
                l1_matches = size(matches{i,j},1);
                rep_ones = ones(l1_matches,1);
                
                valid_ind_ord = (rep_ones * valid_points{j}) .*  ind_ord;
                
                best_ind = min(valid_ind_ord(valid_ind_ord>0),2);
                
                for k = 1:l1_matches
                    valid_matches{i,j}(k,:) = [valid_matches_i{i,j}(k,1), valid_matches_i{i,j}(k,best_ind(k))];
                end
                %best_valid_matches = [valid_matches{i,j}(:,1), valid_matches{i,j}(:,)
                
                
            end
        end
    end
end

function matches = actualizar_matches (matches, valid_points)

    num_matches = size(matches);
    
    for i=1:num_matches(1)

        ind_nulos = find(valid_points{i}==0);
                
        for j=1:num_matches(2)
                
            matches{i,j}{ind_nulos} = [];
        end

    end
end


function matcheos_nz = eliminar_filas_nulas(matcheos)

    matches{:,:} = 

end

function valid_matches = mejores_parejas(valid_matches)


end

