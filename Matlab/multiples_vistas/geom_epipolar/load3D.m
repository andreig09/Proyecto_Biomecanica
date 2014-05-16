function [skeleton, n_marcadores, n_frames, time] = load3D(name_bvh)


%Esta función devuelve parámetros básicos para trabajar con el ground truth 
%así como para visualizar la secuencia .bvh
%% ENTRADA
%name.bvh --> string que indica el nombre de la secuencia .bvh
%% SALIDA
%time --> matriz cuyas columnas son los tiempos en segundos de cada frame
%n_marcadores --> indica el nro de marcadores de la armadura (esqueleto)
%n_frames --> indica nro de frames de la secuencia
%skeleton --> estructura que guarda la información de las junturas.
    %skeleton(j) -->accede a la información de la juntura j
    %skeleton(j).name --> devuelve el nombre de la juntura j
    %skeleton(j).t_xyz --> matriz cuyas filas son las coordenadas 3D y las
    %columnas los correspondientes frames de la juntura j
    %EJEMPLO: skeleton(j).t_xyz(:, k) --> devuelve las coordenadas 3D de la juntura j en el
    %frame k
%% Limpieza
    close all
    clc

%% Cargo  ground truth
    name_bvh = sprintf(name_bvh); %fuerzo transformación a string
    [skeleton,time]=loadbvh(name_bvh);
    %load('ground_truth.mat');%BORRAR SI NO SE ESTA PROBANDO
    n_frames = length(time);  
    n_marcadores = size(skeleton,2);

%% Generar gráfica de secuencia
   
%   if (ploter == 1)
%         for k=1:n_frames % para cada frame se plotean las posiciones 3D de los POI
%             for j=1:n_marcadores
%                 P = skeleton(j).t_xyz(:, k);            
%                 plot3(P(1), P(2), P(3), '*')%solo plotea el frame k de juntura j
%                 xlabel('x')
%                 ylabel('y')
%                 zlabel('z')
%                 axis equal
%                 grid on
%                 if j ==1  %solo se activa en el primer marcador graficado
%                     hold on 
%                 end
%             end
%             pause(0.01)
%             hold off 
%         end
%     end
end
