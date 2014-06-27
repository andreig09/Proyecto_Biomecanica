function plotear(E, arg2, arg3, arg4, arg5, arg6, arg7)
%Funcion general de ploteo para secuencias 2D y 3D  
%% ENTRADA
%E --> estructura cámara o estructura skeleton
%argi -->depende lo que se quiera obtener 

%POSIBILIDADES:
%   plotear(skeleton)                                   --> plot_secuencia_3D(E, 0);%se plotea secuencia 3D con etiquetas nombres
%   plotear(skeleton, t_label)                         -->  plot_secuencia_3D(E, 1);%se plotea secuencia 3D con etiquetas t_label
%   plotear(skeleton, list_marker, last_frame, n_prev, t_label) --> plot_trayectoria_3D(E, arg2, arg3, arg4, arg5)
%   plotear(cam, n_cam )                                  --> plot_secuencia_2D(E, arg2, 0); %se plotea 2D con etiquetas nombres 
%   plotear(cam, n_cam, t_label)                        --> plot_secuencia_2D(E, arg2, 1);%se plotea 2D con etiquetas t_label
%   plotear(cam, n_cam, list_marker, last_frame, n_prev, t_label, radio) --> plot_trayectoria_2D(E, arg2, arg3, arg4, arg5, arg6, arg7)

%SUB_FUNCIONES
           
    %plot_secuencia_3D(skeleton, t_label)
     % ENTRADA
        %skeleton --> estructura skeleton que contiene la informacion 3D de los marcadores 
        %t_label --> indica el tipo de etiquetado
            %t_label = 0; se etiqueta con nombres
            %t_label = 1; se etiqueta con numeros

    %plot_trayectoria_3D(skeleton, list_marker, last_frame, n_prev, t_label)
     %ENTRADA
        % skeleton    --> estructura skeleton que contiene la informacion 3D de los marcadores 
        % list_marker --> vector que contiene los indices respectivos de cada marcador a graficar %skeleton.marker("indice_respectivo")
        % last_frame  --> indica el ultimo frame de la trayectoria
        % n_prev      --> es el nro de elementos previos a last_frame que se quiere visualizar
        % t_label     --> indica el tipo de etiquetado
                        %t_label = 0; se etiqueta con nombres
                        %t_label = 1; se etiqueta con numeros

    %plot_secuencia_2D(cam, n_cam, t_label)
     % ENTRADA
        %cam --> estructura cámara 
        %n_cam -->indica el numero de la camara a graficar
        %t_label --> indica el tipo de etiquetado
            %t_label = 0; se etiqueta con nombres
            %t_label = 1; se etiqueta con numeros

    %plot_trayectoria_2D(cam, n_cam, list_marker, last_frame, t_label, radio)
     % ENTRADA
        % skeleton    --> estructura skeleton que contiene la informacion 3D de los marcadores
        %n_cam        -->indica el numero de la camara a graficar
        % list_marker --> vector que contiene los indices respectivos de cada marcador a graficar %skeleton.marker("indice_respectivo")
        % last_frame  --> indica el ultimo frame de la trayectoria
        % n_prev      --> es el nro de elementos previos a last_frame que se quiere visualizar
        % t_label     --> indica el tipo de etiquetado
                        %t_label = 0; se etiqueta con nombres
                        %t_label = 1; se etiqueta con numeros
        % radio      --> radio de los circulos ubicados en los ultimos frames, su dimension DEBE SER EN PIXELES

%% Cuerpo de la funcion

if size(E, 2)==1 %en caso afirmativo es una estructura skeleton
    switch nargin
        case 1
            plot_secuencia_3D(E, 0);%se plotea secuencia 3D con etiquetas nombre
        case 2
            plot_secuencia_3D(E, arg2);%se plotea secuencia 3D con etiquetas nombre (arg1=0) o numero (arg1=1)
        case 5
            plot_trayectoria_3D(E, arg2, arg3, arg4, arg5)
        otherwise
            disp('Numero de argumentos invalidos para estructura skeleton')
            return
    end  %(del switch)          
else %en caso negativo es una estructura cam    camara = 1;
    switch nargin
        case 1
            disp('Faltan argumentos para visualizar una estructura cam')
        case 2
            plot_secuencia_2D(E, arg2, 0) %se plotea secuencia 2D con etiquetas nombre             
        case 3
            plot_secuencia_2D(E, arg2, arg3);%se plotea secuencia 2D con etiquetas nombre(arg3=0) o numero (arg3=1)
       case 7
            plot_trayectoria_2D(E, arg2, arg3, arg4, arg5, arg6, arg7) %se plotean trayectorias 2D con etiquetas nombre (arg5=0) o numero(arg5=1)            
        otherwise
            disp('Numero de argumentos invalidos para estructura cam')
            return            
    end %(del switch)
end %(del if)
            
end %(de la funcion plotear)


function plot_secuencia_2D(cam, n_cam, t_label)
%% ENTRADA
%cam     --> estructura cámara 
%n_cam   -->indica el numero de la camara a graficar
%t_label --> indica el tipo de etiquetado
%            t_label = 0; se etiqueta con nombres
%            t_label = 1; se etiqueta con numeros
%% Cuerpo de la funcion
%NOTACION: cam(i).marker(j).x(:, k) para acceder a las coordenadas del marcador j en el frame k de la camara i.
%          cam(i).frame(k).x(:, j)  para acceder a las coordenadas del marcador j en el frame k de la camara i

n_frames = size(cam(1).frame, 2); %nro de frames
res_x = cam(n_cam).resolution(1,:); %resolucion horizontal
res_y = cam(n_cam).resolution(2,:); %resolucion vertical

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
        'HorizontalAlignment','right', 'FontSize',10, 'fontweight','b');
    xlabel('\fontsize{13}{x (pixeles)}', 'fontweight','b' );
    ylabel('\fontsize{13}{y (pixeles)}', 'fontweight','b');
    str = sprintf('Proyeccion sobre retina de Camara %d  \n frame %d / %d',n_cam, k, n_frames);
    title(['\fontsize{14}{',str, '}'], 'fontweight','b');
    axis equal
    axis([0 res_x 0 res_y])
    
    grid on
    pause(0.01);
end
end % (de la funcion plotear2D)


function plot_secuencia_3D(skeleton, t_label)
%% ENTRADA
%skeleton --> estructura skeleton que contiene la informacion 3D de los marcadores 
%t_label  --> indica el tipo de etiquetado
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
        'HorizontalAlignment','right', 'FontSize',10, 'fontweight','b');
    xlabel('\fontsize{11}{x (metros)}', 'fontweight','b');
    ylabel('\fontsize{11}{y (metros)}', 'fontweight','b');
    zlabel('\fontsize{11}{z (metros)}', 'fontweight','b');
    str = sprintf('Secuencia 3D del esqueleto %s \n frame %d / %d',skeleton.name_bvh, k, n_frames);
    title(['\fontsize{14}{',str, '}'],'fontweight','b');
    axis equal
    axis([-0.5 0.5 -5 1 0 2]) %esto se debe ajustar a mano si no se ve la figura
    grid on
    pause(0.01);
end 
end %(de la funcion plotear3D)


function plot_trayectoria_3D(skeleton, list_marker, last_frame, n_prev, t_label)
%Función que permite graficar segmentos de trayectorias 3D a partir del
%frame last_frame y los n_prev frames anteriores de 
%los marcadores incluidos en el vector list_marker

%% ENTRADA
% skeleton    --> estructura skeleton que contiene la informacion 3D de los marcadores 
% list_marker --> vector que contiene los indices respectivos de cada marcador a graficar %skeleton.marker("indice_respectivo")
% last_frame  --> indica el ultimo frame de la trayectoria
% n_prev      --> es el nro de elementos previos a last_frame que se quiere visualizar
% t_label     --> indica el tipo de etiquetado
                %t_label = 0; se etiqueta con nombres
                %t_label = 1; se etiqueta con numeros

%% Cuerpo de la función

n_frames = size(skeleton.frame, 2); %nro de frames
n_marker = length(list_marker);% cantidad de marcadores a plotear
mantener_trayectoria = true; % mantiene o no la trayectoria
%Inicializo variables
X=[];
Y=[];
Z=[];
labels=cellstr(num2str(zeros(n_marker,1)));
n=zeros(n_marker,1);%esta variable solo se utiliza en el caso de etiquetas numero
%Acumulo los marcadores en vectores
%skeleton.marker(j).x(:, k) para acceder a las coordenadas del marcador j en el frame k de la camara i.
for i=1:n_marker
    X=[X; skeleton.marker(list_marker(i)).X(1, (last_frame-n_prev):last_frame)];%solo cargo el ultimo frame y los n_prev anteriores
    Y=[Y; skeleton.marker(list_marker(i)).X(2, (last_frame-n_prev):last_frame)];%solo cargo el ultimo frame y los n_prev anteriores
    Z=[Z; skeleton.marker(list_marker(i)).X(3, (last_frame-n_prev):last_frame)];%solo cargo el ultimo frame y los n_prev anteriores
    if t_label==0
        labels(i) = cellstr(skeleton.marker(list_marker(i)).name);
    else 
        n(i) = skeleton.marker(list_marker(i)).n;
    end
end
if t_label ==1 %si las etiquetas son numeros entonces labels = vector n transformado a un cell array de string
    labels = labels_num( n );
end

%Ploteo
if mantener_trayectoria
        plot3(X(:,:)',Y(:,:)', Z(:,:)', '.-');%grafico ultimo frame y los n_prev anteriores
    else
        plot3(X(:,:)',Y(:,:)', Z(:,:)', '.');
end;

%%%De aquí para abajo son chirimbolos
text(X(:,(n_prev +1))'...%coordenada x -->notar que x, y, z solo tiene (n_prev+1) componentes
    ,Y(:,(n_prev +1))',...%coordenada y
    Z(:,(n_prev +1))',...%coordenada z
    labels, 'VerticalAlignment','bottom', ...
    'HorizontalAlignment','right', 'FontSize',10, 'fontweight','b')
xlabel('\fontsize{11}{x (metros)}','fontweight','b');
ylabel('\fontsize{11}{y (metros)}','fontweight','b');
zlabel('\fontsize{11}{z (metros)}','fontweight','b');
str = sprintf('Secuencia 3D del esqueleto %s \n último frame %d / %d',skeleton.name_bvh, last_frame, n_frames);
title(['\fontsize{14}{',str, '}'],'fontweight','b');
axis square;
grid on
    %correccion_zoom =0.005;% porcentaje de ventana de zoom
    %axis([(1-correccion_zoom)*min(min(X)),...
    %   (1+correccion_zoom)*max(max(X)),...
    % (1-correccion_zoom)*min(min(Y)),...
    % (1+correccion_zoom)*max(max(Y)), ... 
    % (1-correccion_zoom)*min(min(Z)),...
    % (1+correccion_zoom)*max(max(Z))]); %%Todo lo comentado funciona pero consume unos segundos extra en la función

end


function plot_trayectoria_2D(cam, n_cam, list_marker, last_frame, n_prev,  t_label, radio)
%Función que permite graficar las trayectorias 2D hasta el frame last_frame de
%los marcadores incluidos en el vector list_marker

%% ENTRADA
% skeleton    --> estructura skeleton que contiene la informacion 3D de los marcadores 
%n_cam        -->indica el numero de la camara a graficar
% list_marker --> vector que contiene los indices respectivos de cada marcador a graficar %skeleton.marker("indice_respectivo")
% last_frame  --> indica el ultimo frame de la trayectoria
% n_prev      --> es el nro de elementos previos a last_frame que se quiere visualizar
% t_label     --> indica el tipo de etiquetado
                %t_label = 0; se etiqueta con nombres
                %t_label = 1; se etiqueta con numeros
% radio      --> radio de los circulos ubicados en los ultimos frames, su dimension DEBE SER EN PIXELES
%% Cuerpo de la funcion

n_frames = size(cam(1).frame, 2); %nro de frames
n_marker = length(list_marker);% cantidad de marcadores a plotear
mantener_trayectoria = true; % mantiene o no la trayectoria
%Inicializo variables
x=[];
y=[];
labels=cellstr(num2str(zeros(n_marker,1)));
n=zeros(n_marker,1);%esta variable solo se utiliza en el caso de etiquetas numero
%Acumulo los marcadores en vectores
for i=1:n_marker
    x=[x; cam(n_cam).marker(list_marker(i)).x(1, (last_frame-n_prev):last_frame)];%solo cargo el ultimo frame y los n_prev anteriores
    y=[y; cam(n_cam).marker(list_marker(i)).x(2, (last_frame-n_prev):last_frame)];
    if t_label==0
        labels(i) = cellstr(cam(n_cam).marker(list_marker(i)).name); %labels nombre se van adjudicando
    else 
        n(i) = cam(n_cam).marker(list_marker(i)).n; %genero vector con numero asociado a cada marcador y fuera del for los paso a labels
    end
    
end

if t_label ==1 %si las etiquetas son numeros entonces labels = vector n transformado a un cell array de string
    labels = labels_num( n );
end
    
    
%Ploteo
if n_prev==0 %solo ploteo un frame, por lo tanto me intereza tenerlo resaltado
     plot(x(:,:)',y(:,:)','r+');%ploteo el último frame
else if mantener_trayectoria
        plot(x(:,:)',y(:,:)','.-');%ploteo el último frame y los n_prev anteriores
    else
        plot(x(:,:)',y(:,:)','.');
    end
end
    

if (radio~=0)%solo aplica circulos al ultimo frame si radio distinto de cero
    hold on
    circulo(x(:,(n_prev+1) ), y(:,(n_prev+1)), radio )
    hold off    
end



%%%De aquí para abajo son chirimbolos
text(x(:,(n_prev+1))',...%coordenada x --->notar que x e y solo tiene (n_prev+1) componentes
    y(:,(n_prev+1))',...%coordenada y
    labels, 'VerticalAlignment','bottom', 'HorizontalAlignment','right', 'FontSize',10, 'fontweight','b')
xlabel('\fontsize{11}{x (pixeles)}', 'fontweight','b');
ylabel('\fontsize{11}{y (pixeles)}','fontweight','b');
str = sprintf('Proyección sobre retina de Camara %d  \n último frame %d / %d',n_cam, last_frame, n_frames);
title(['\fontsize{14}{',str, '}'], 'fontweight','b');
%axis square;
res_x = cam(n_cam).resolution(1,:); %resolucion horizontal
res_y = cam(n_cam).resolution(2,:); %resolucion vertical
axis([0 res_x 0 res_y])
axis equal;
grid on
correccion_zoom =0.005;% porcentaje de ventana de zoom
% axis([(1-correccion_zoom)*min(min(x)),...
%     (1+correccion_zoom)*max(max(x)),...
%     (1-correccion_zoom)*min(min(y)),...
%     (1+correccion_zoom)*max(max(y))]);

end

function n_str =labels_num(n)
%Devuelve los elementos de un vector en un cell array de string 
%% ENTRADA
%n = cam(n_cam).frame(k).n -->matriz fila, cada columna j asocia un nro al marcador j del frame k;
%k --> nro de frame
%% Cuerpo de la funcion    
    n_str = {}; %n_str es un cell array de string
    for j=1:length(n) %para todas los marcadores
        n_str=[n_str, num2str(n(j))]; %paso de una fila de numeros a un cell array de string
    end
end %de la funcion n_str

function circulo(x_center, y_center, radius)
%Esta función plotea el contorno de una circunferencia de radio radius cuyo centro son las coordenadas por filas de los vectores 
%x_center, y_center  
theta = 0 : 0.1 : 2*pi*(11/10);%% se generan 70 elementos!!! el factor (11/10) se utiliza para cerrar el circulo dando apenas mas que una vuelta
x = radius * ( ones(length(x_center), 1) * cos(theta))  + x_center*ones(1, length(theta));
y = radius * ( ones(length(y_center), 1) * sin(theta) ) + y_center*ones(1, length(theta));
plot(x', y', 'r--');%ploteo todos los circulos
end

