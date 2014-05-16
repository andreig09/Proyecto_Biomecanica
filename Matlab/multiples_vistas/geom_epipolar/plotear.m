function plotear(skeleton, P_blender, res_x, res_y)
%Funcion que muestra la salida frame a frame de la secuencia guardada en skeleton a traves de la matriz M 

%% Entrada
%P_blender --> matriz que mapea los datos de skeleton sobre una retina o bien sobre otra base. 
    %En el caso de que se quiera ver unicamente la nube 3D original poner
    %M= eye(3) matriz identidad 3x3
%skeleton --> estructura que guarda la información de las junturas.
    %skeleton(j) -->accede a la información de la juntura j
    %skeleton(j).name --> devuelve el nombre de la juntura j
    %skeleton(j).t_xyz --> matriz cuyas filas son las coordenadas 3D y las
    %columnas los correspondientes frames de la juntura j
    %EJEMPLO: skeleton(j).t_xyz(:, k) --> devuelve las coordenadas 3D de la juntura j en el
    %frame k
%res_x y res_y son la resolución de la pantalla de salida en pixeles.
    %en el caso que valgan (0, 0) no se utilizan

%% 
[filas, colum] = size(P_blender); %las filas de la matriz M determinan la dimensión del espacio de salida y las columnas del espacio de partida


n_frames = size(skeleton(1).t_xyz, 2);  
n_marcadores = size(skeleton,2);


if ( (filas==3)&&(colum==4) ) %entonces estamos proyectando sobre una retina
        for k=1:n_frames % para cada frame se plotean las posiciones 3D de los marcadores
            for j=1:n_marcadores
                P = skeleton(j).t_xyz(:, k); %vector columna con coordenadas 3D
                P = [P;1]; %vector columna proyectivo 3D
                p = P_blender*P; %coordenadas proyectivas en 2D
                plot(p(1)/p(3), p(2)/p(3), '*')%solo plotea el frame k de juntura j
                xlabel('x (pixeles)')
                ylabel('y (pixeles)')
                str = sprintf('Proyeccion sobre retina - frame %f',floor(k));
                title(str)
                %axis equal
                axis([0 res_x 0 res_y])
                grid on
                if j ==1  %solo se activa en el primer marcador graficado
                    hold on 
                end
            end
            pause(0.01)
            hold off 
        end
else
    if (colum==3) %entonces solo estamos graficando datos 3D
        for k=1:n_frames % para cada frame se plotean las posiciones 3D de los marcadores
            for j=1:n_marcadores
                P = skeleton(j).t_xyz(:, k); %vector columna con coordenadas 3D
                P_new = P_blender*P; %aqui P_blender es la identidad 3x3
                plot3(P_new(1), P_new(2), P_new(3), '*')%solo plotea el frame k de juntura j
                xlabel('x (metros)')
                ylabel('y (metros)')
                zlabel('z (metros)')
                str = sprintf('Secuencia 3D - frame %f', floor(k));
                title(str)
                axis equal
                grid on
                if j ==1  %solo se activa en el primer marcador graficado
                    hold on 
                end
            end
            pause(0.01)
            hold off 
        end        
    else
        if ( (filas==4)&&(colum==4) ) %cambio de base en 3D proyectivo
            for k=1:n_frames % para cada frame se plotean las posiciones 3D de los marcadores
            for j=1:n_marcadores
                P = skeleton(j).t_xyz(:, k); %vector columna con coordenadas 3D
                P = [P;1]; %vector columna proyectivo 3D
                P_new = P_blender*P; %coordenadas proyectivas 3D en sistema distinto al del mundo
                plot3(P_new(1), P_new(2), P_new(3), '*')%solo plotea el frame k de juntura j
                xlabel('x (metros)')
                ylabel('y (metros)')
                zlabel('z (metros)')
                str = sprintf('Secuencia desde camara - frame %f', floor(k));
                title(str)
                %axis equal
                axis([0 res_x 0 res_y])
                grid on
                if j ==1  %solo se activa en el primer marcador graficado
                    hold on 
                end
            end
            pause(0.01)
            hold off 
            end  
        end
    end
end