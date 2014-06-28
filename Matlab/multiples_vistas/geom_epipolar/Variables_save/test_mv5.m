close all;
clear all;
clc;

%% Carga de Archivos

load('cam.mat');

%% Parametros

limit_frames = 300;% cantidad de frames
limit_marker = 26;% cantidad de marcadores
mantener_trayectoria = true; % mantiene o no la trayectoria
time_step = 1/500;% tiempo entre entre frames

ini_frame = 20;

for camera = 3:3
    
    %% Inicializo radios de busqueda
    
    d3 =Inf;
    d4 =Inf;
    
    %% Inicializo variables
    
    x=[];
    y=[];
    name=cellstr(num2str(zeros(limit_marker,1)));
    
    
    %% inicializo estructura de enlazado
    
    enlazado.frame(ini_frame).marcador(1:limit_marker)=1:limit_marker;
    
    t_start = tic;
    %%
    for frame = ini_frame:limit_frames
        
        if rem(100*frame/limit_frames,10)==0
            %disp([num2str(100*frame/limit_frames) '% - ' num2str(toc(t_start))]);
        end
        
        N1 = cam(camera).frame(frame-1).x;
        % nube de puntos del frame f
        N2 = cam(camera).frame(frame).x;
        N3 = cam(camera).frame(frame+1).x;
        N4 = cam(camera).frame(frame+2).x;
        
        
        tamN2 = size(N2);
        
        % Cargo los marcadores a enfrentar del frame (f) a enlazar
        
        marker_versus = 1:tamN2(2);
        
        % Elimino los marcadores sin enlace
        
        marker_versus=unique(marker_versus);
        
        % Busco los enlaces previos de los marcadores a enfrentar
        
        link_prev_versus = enlazado.frame(frame).marcador(marker_versus);
        
        if mod(frame,10)==0
            %disp(['frame ' num2str(frame)]);
        end;
        
        % Enfrento los marcadores para obtener los enlaces en (f+1),
        % distintas versiones
        
        % Funcion de Gonzalo, no precisa los parametros, busca puntos en N3
        % con aceleracion nula, revisando todas las posibilidades
        %link_next_versus = enfrentar_marcadores_multiples(N1,N2,N3,marker_versus,link_prev_versus);d3='N/A';d4='N/A';
        
        % Funcion de Gonzalo, precisa d3, busca puntos en N3
        % con aceleracion nula, revisando los enlaces dentro de un radio d3
        %link_next_versus = enfrentar_marcadores_multiples(N1,N2,N3,marker_versus,link_prev_versus,d3);
        
        % Funcion Herda, no precisa los parametros, busca puntos en N3
        % y N4 , revisando todas las posibilidades (muy pesado)
        %link_next_versus = enfrentar_marcadores_multiples_v2(N1,N2,N3,N4,marker_versus,link_prev_versus);
        
        % Funcion Herda, precisa d3 y d4, busca puntos en N3
        % y N4 , con candidatos en N3 a distancia d3 de la estimacion, y candidatos en N4 a distancia d4 de la estimaciob
        link_next_versus = enfrentar_marcadores_multiples_v2(N1,N2,N3,N4,marker_versus,link_prev_versus,d3,d4);
        
        % Si la cantidad de enlaces encontrados, es menor a la cantidad de
        % marcadores, enfrento los marcadores en N3 y N4 que no fueron
        % enlazados, y los agrego a la matriz de enlaces
        
        if size(link_next_versus,1) ~= tamN2(2)
            
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
            
        end
        
        % Genero matriz con marcadores en N1,N2,N3,N4, y aceleracion
        
        N5=[enlazado.frame(frame).marcador(link_next_versus(:,1))',link_next_versus];
        
        % Calculo las distancias entre  N3 y (2*N2-N1), d3
        %                               N4 y (2*N3-N2), d4
        % Usando los enlaces obtenidos, para la proxima iteracion
        
        d3 = mean(sqrt(sum(N3(:,N5(:,3))'-(2*N2(:,N5(:,2))-N1(:,N5(:,1)))').^2));
        d4 = mean(sqrt(sum(N4(:,N5(:,4))'-(2*N3(:,N5(:,2))-N2(:,N5(:,1)))').^2));
        
        %disp([num2str(d3) ',' num2str(d4)]);
        
        % Para cada uno de los enlaces hallados, guardo en struct
        
        for i=1:size(link_next_versus,1)
            enlazado.frame(frame+1).marcador(link_next_versus(i,2))=link_next_versus(i,1);
            
        end;
        
    end
    
    test=[];
    for i=ini_frame:limit_frames
        test(i-1,:)=(enlazado.frame(i+1).marcador)-(1:26);
    end;
    disp(['cam=' num2str(camera) ', d3=' num2str(d3) ', d4=' num2str(d4) ', err=' num2str(sum(sum(test~=0)*100/(size(test,1)*size(test,2))),3) '%, dt=' num2str(toc(t_start))]);
    
end;

%return;

%% plots

for m = 1: limit_marker
    N = [];
    for f = ini_frame: limit_frames
        
        Naux = cam(camera).frame(f).x;
        N = [N,Naux];
    end
    
    hold off
    figure(2)
    plot(N(1,:),N(2,:),'.')
    
    
    
    x=cam(camera).marker(m).x(1,ini_frame:limit_frames);
    y=cam(camera).marker(m).x(2,ini_frame:limit_frames);
    hold on
    plot(x,y,'r.')
    
    
    for f = ini_frame:limit_frames-1
        indice = enlazado.frame(f+1).marcador(m);
        if indice ~= 0
            Naux = cam(camera).frame(f).x;
            hold on
            plot(Naux(1,indice),Naux(2,indice),'sg')
        end
    end
    pause
end
