clc
close all
clear all

load 'saved_vars/cam_andrei.mat';
load 'saved_vars/skeleton.mat';
n_cams = get_info(skeleton, 'n_cams');

%%
p = 0.50; 
aux_cam = dirty_cam(cam,p);
cam = aux_cam;

%%


v_cams = [1:n_cams]; % vector de cámaras
lv_cams = length(v_cams); 
frame_i = 1;

%%
for ci = v_cams
    
    if ci < lv_cams
        

    [~, ~, ix_table1, ~]= cam2cam(  cam(v_cams(ci)), cam(v_cams(ci+1)), frame_i,'show');
    [~, ~, ix_table2, ~]= cam2cam(  cam(v_cams(ci+1)) , cam(v_cams(ci)), frame_i,'show');
    
    else
        

            [~, ~, ix_table1, ~]= cam2cam(  cam(v_cams(ci)), cam(v_cams(1)), frame_i,'show');
            [~, ~, ix_table2, ~]= cam2cam(  cam(v_cams(1)) , cam(v_cams(ci)), frame_i,'show');
    end

  
    match_cam{ci} = [];
    aux_ix_table2 = ix_table2(:,[2,1]);
    for i = 1:size(ix_table1,1)
        for j= 1:size(ix_table2,1)
                
            
            if ix_table1(i,:) == aux_ix_table2(j,:)
   
                match_cam{ci} = [match_cam{ci};ix_table1(i,:)];
               
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
    cant_cam =  [cant_cam, size(match_cam{ci},1)];
end

[~,ind] = sort(cant_cam);
v_cams_ord = v_cams(ind);


% valido los puntos previamente matcheados
for ci = v_cams_ord
    
    suma = 0;
    for i =  v_cams
        suma = suma + sum(valid_points{i});
    end
    
    if suma == 0
        break
    end
    
    n_cam1 = ci;
    if ci < lv_cams
        n_cam2 = ci+1;
    else
        n_cam2 = 1;
    end
    
    index1 = match_cam{n_cam1}(:,1);
    index2 = match_cam{n_cam1}(:,2);
    
    [X, validation, n_cam3, index_x3, ~, valid_points] = validation3D(cam, n_cam1, n_cam2, frame_i, 'index', index1', index2', 'umbral', 10, valid_points);
    
    %[X, validation, n_cam3, index_x3, ~, valid_points] = validation3D(cam, 1, 2, frame_i, 'index', [1:10], [1:10], 'umbral', 10, valid_points);
    
    rec_cam(ci).X = X; 
    rec_cam(ci).validation = validation;
    rec_cam(ci).n_cam3 = n_cam3;
    rec_cam(ci).index_x3 = index_x3;
    
end
pause
%%
[X, validation, n_cam3, index_x3, ~, valid_points]=validation3D(cam, 1, 2, frame_i, 'index', [1:10], [1:10], 'umbral',  10, valid_points)
%%
[X, validation, n_cam3, index_x3, ~, valid_points]=validation3D(cam, 1, 2, frame_i, 'index', [1:10], [1:10], valid_points)
%%
 plot3(X(1,:),X(2,:),X(3,:) ,'*')
 axis equal