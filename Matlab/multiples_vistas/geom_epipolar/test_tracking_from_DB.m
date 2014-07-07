    clc
clear all
close all

load saved_vars/cam.mat

%% Este codigo debe ser ejecutado con lo siguiente en carpeta
%{
cam.mat (debe hacerse un load cam.mat una sola vez, y despues no hacer clear)
get_marker_in_frame.m
    y sus funciones asociadas (?)
vecinos_intraframe.m
enfrentar_marcadores_multiples.m
enfrentar_marcadores_multiples_v2.m
delta_aceleracion

%}

camara = 5;

ini_frame=20;
n_frames=size(cam(camara).frame,2)-ini_frame;

d3=Inf;
d4=Inf;

N2 = get_info(cam(camara),'frame',ini_frame,'marker','coord');N2=N2(1:2,:);

enlazado.frame(ini_frame).marcador(1:size(N2,2))=1:size(N2,2);

t_start = tic;

for frame=ini_frame:(ini_frame+n_frames-2)
    
    N1 = get_info(cam(camara),'frame',frame-1,'marker','coord');N1=N1(1:2,:);
    N2 = get_info(cam(camara),'frame',frame,'marker','coord');N2=N2(1:2,:);
    N3 = get_info(cam(camara),'frame',frame+1,'marker','coord');N3=N3(1:2,:);
    N4 = get_info(cam(camara),'frame',frame+2,'marker','coord');N4=N4(1:2,:);
    
    % Cargo los marcadores a enfrentar del frame (f) a enlazar
    
    marker_versus = 1:size(N2,2);
    
    % Busco los enlaces previos de los marcadores a enfrentar
    
    link_prev_versus = enlazado.frame(frame).marcador(marker_versus);
    %link_prev_versus = marker_versus;
    
    % Calculo los enlaces proximos
    
    link_next_versus = enfrentar_marcadores_multiples_v2(N1,N2,N3,N4,marker_versus,link_prev_versus,d3,d4);
    
    % Si la cantidad de enlaces es menor a la cantidad de marcadores, debo
    % buscar los marcadores restantes
    
    if size(link_next_versus,1) ~= size(N2,2)
        
        % Si no se encontro ningun enlace, inicializo el vector
        % link_next_versus
        
        if isempty(link_next_versus)
            link_next_versus=[0,0,0,0];
        end
        
        link_next_versus = [link_next_versus;...
            enfrentar_marcadores_restantes(N1,N2,N3,N4,...% Marcadores de N2 que no fueron enlazados
            setdiff((1:length(N2))',link_next_versus(:,1)),...% Enlaces previos de los marcadores de N2 que no fueron encontrados
            enlazado.frame(frame).marcador(setdiff((1:length(N2))',link_next_versus(:,1))),...% Marcadores de N3 que no fueron enlazados
            setdiff((1:length(N3))',link_next_versus(:,2)))];
        
        % Quito los marcadores cuya primer columna tengo enlaces nulos
        
        link_next_versus=link_next_versus(link_next_versus(:,1)>0,:);
        
    end;
    
    % Genero matriz con marcadores en N1,N2,N3,N4, y aceleracion para poder
    % actualizar d3 y d4
    
    N5=[enlazado.frame(frame).marcador(link_next_versus(:,1))',link_next_versus];
    
    % Calculo las distancias entre  N3 y (2*N2-N1), d3
    %                               N4 y (2*N3-N2), d4
    % Usando los enlaces obtenidos, para la proxima iteracion
    
    d3 = mean(sqrt(sum(N3(:,N5(:,3))'-(2*N2(:,N5(:,2))-N1(:,N5(:,1)))').^2));
    d4 = mean(sqrt(sum(N4(:,N5(:,4))'-(2*N3(:,N5(:,2))-N2(:,N5(:,1)))').^2));
    
    for i=1:size(link_next_versus,1)
        enlazado.frame(frame+1).marcador(link_next_versus(i,2))=link_next_versus(i,1);
    end;
    
end;

%% Realizo el testeo de los resultados
test=[];
for frame=ini_frame:(ini_frame+n_frames-2)
    test(-ini_frame+frame+1,:)=(enlazado.frame(frame+1).marcador)-(1:size(enlazado.frame(frame).marcador,2));
end;
disp(['cam=' num2str(camara) ', d3=' num2str(d3) ', d4=' num2str(d4) ', err=' num2str(sum(sum(test~=0)*100/(size(test,1)*size(test,2))),3) '%, dt=' num2str(toc(t_start))]);
