function plotear(E, arg2, arg3)
%Funcion que muestra la salida frame a frame de la secuencia 2D o 3D en la estructura E 
%% ENTRADA
%E --> estructura cámara o estructura skeleton
%arg2 -->indica el numero de la camara en el caso de grafica 2D o un string para etiquetas en el caso de grafica 3D
%arg3 -->indica un string para etiquetas y existe solo en el caso de grafica 2D
%       El string de etiquetas puede tener dos valores:
%           'name' si se quiere imprimir los nombres de los marcadores
%           'number' en el caso de imprimir numero de los marcadores

%% Cuerpo de la funcion

switch nargin
    case 1
        plotear3D(E, 0);%se plotea 3D con etiquetas nombres
    case 2
        switch arg2 %miro el argumento 2
            case 'number'
                plotear3D(E, 1);%se plotea 3D con etiquetas numeros
            case 'name'
                plotear3D(E, 0);%se plotea 3D con etiquetas nombres
            otherwise 
                plotear2D(E, arg2, 0); %se plotea 2D con etiquetas nombres
        end
    case 3
        switch arg3 %miro el argumento 3
            case 'number'
                plotear2D(E, arg2, 1);%se plotea 2D con etiquetas numeros
            case 'name'
                plotear2D(E, arg2, 0);%se plotea 2D con etiquetas nombres
            otherwise
                disp('el argumento 3 es invalido')
                return;
        end
    otherwise
        disp('el nro de argumentos es invalido')
        return;
end  
            
end %de la funcion plotear


function plotear2D(cam, n_cam, t_label)
%% ENTRADA
%cam --> estructura cámara 
%n_cam -->indica el numero de la camara a graficar
%t_label --> indica el tipo de etiquetado
%            t_label = 0; se etiqueta con nombres
%            t_label = 1; se etiqueta con numeros
%% Cuerpo de la funcion
%NOTACION: cam(i).marker(j).x(:, k) para acceder a las coordenadas del marcador j en el frame k de la camara i.
%          cam(i).frame(k).x(:, j)  para acceder a las coordenadas del marcador j en el frame k de la camara i

n_frames = size(cam(1).frame, 2); %nro de frames
res_x = cam(n_cam).M; %resolucion horizontal
res_y = cam(n_cam).N; %resolucion vertical

for k=1:n_frames % para cada frame se plotean las posiciones 2D de los marcadores con sus respectivas etiquetas
    plot(...
        cam(n_cam).frame(k).x(1, :), ... %coordenada x
        cam(n_cam).frame(k).x(2, :), ... %coordenada y
        '*');
    %%%De aquí para abajo son chirimbolos
    if t_label == 0
        labels = cellstr(... 
            cam(n_cam).frame(k).name...
            ); %genero las etiquetas con los nombres de cada marcador
    else
        labels = labels_num( cam(n_cam).frame(k).n ); %genero las etiquetas con los nros de cada marcador
    end
    text(cam(n_cam).frame(k).x(1, :), ...%coordenada x
        cam(n_cam).frame(k).x(2, :), ... %coordenada y
        labels,...
        'VerticalAlignment','bottom', ...
        'HorizontalAlignment','right');
    xlabel('x (pixeles)');
    ylabel('y (pixeles)');
    str = sprintf('Proyeccion sobre retina de Camara %d  \n frame %d / %d',n_cam, k, n_frames);
    title(str);
    axis([0 res_x 0 res_y])
    grid on
    pause(0.01);
end
end % de la funcion plotear2D


function plotear3D(skeleton, t_label)
%% ENTRADA
%skeleton --> estructura skeleton que contiene la informacion 3D de los marcadores 
%t_label --> indica el tipo de etiquetado
%            t_label = 0; se etiqueta con nombres
%            t_label = 1; se etiqueta con numeros
%% Cuerpo de la funcion
%NOTACION: 
    %        skeleton.marker(j).x(:, k) para acceder a las coordenadas del marcador j en el frame k de la camara i.
    %        skeleton.frame(k).x(:, j)  para acceder a las coordenadas del marcador j en el frame k de la camara i
    %        skeleton.frame(k).name(j)  para acceder al nombre del marcador j en el frame k de la camara i

n_frames = size(skeleton.frame, 2); %nro de frames

for k=1:n_frames % para cada frame se plotean las posiciones 3D de los marcadores con sus respectivas etiquetas
    plot3(...
        skeleton.frame(k).X(1, :), ... %coordenada x
        skeleton.frame(k).X(2, :), ... %coordenada y
        skeleton.frame(k).X(3, :), ... %coordenada z
        '*');
    %%%De aquí para abajo son chirimbolos
    if t_label == 0
        labels = cellstr(... 
            skeleton.frame(k).name...
            ); %genero las etiquetas con los nombres de cada marcador
    else
        labels = labels_num( skeleton.frame(k).n ); %genero las etiquetas con los nros de cada marcador
    end
    text(skeleton.frame(k).X(1, :), ...%coordenada x
         skeleton.frame(k).X(2, :), ... %coordenada y
         skeleton.frame(k).X(3, :), ... %coordenada y
        labels,...
        'VerticalAlignment','bottom', ...
        'HorizontalAlignment','right');
    xlabel('x (metros)')
    ylabel('y (metros)')
    zlabel('z (metros)')
    str = sprintf('Secuencia 3D del esqueleto %s \n frame %d / %d',skeleton.name_bvh, k, n_frames);
    title(str)
    axis equal
    grid on
    pause(0.01);
end 
end %de la funcion plotear3D

function n_str =labels_num(n)
%La siguiente función es útil si se quiere la variable labels con los nros de
%marcadores en lugar del nombre del marcador
%% ENTRADA
%n = cam(n_cam).frame(k).n -->matriz fila, cada columna j asocia un nro al marcador j del frame k;
%k --> nro de frame
%% Cuerpo de la funcion    
    n_str = {}; %n_str es un cell array de string
    for j=1:length(n) %para todas los marcadores
        n_str=[n_str, num2str(n(j))]; %paso de una fila de numeros a un cell array de string
    end
end %de la funcion n_str

