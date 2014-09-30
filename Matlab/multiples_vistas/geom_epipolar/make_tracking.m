function [X_out,datos,X]=make_tracking(X,limit_distancia)

%{

Toma como entrada una matriz cuyas columnas son marcadores, de la forma

x1  x2 ... x1  x2  ...
y1  y2 ... y1  y2  ...
z1  z2 ... z1  z2  ...
f   f      f+1 f+1

Las primeras tres filas corresponden a coordenadas x,y,z (para el caso 2D, la coordenada z es constante 1)

La cuarta fila corresponde al frame al que pertenece cada marcador anonimo
detectado

La salida es la misma matriz con filas adicionales, y un struct con los
enlaces entre frames sucesivos y las variaciones de aceleracion resultantes

x1
y1
z1
f
n1
da1
d1

n1 corresponde al marcador que se realizo el tracking. En el primer frame
que se trackea, se inicializa desde 1 hasta la cantidad de frames
detectados, luego marcadores en sucesivos frames respetan esa misma
notacion

da1, es la variacion de aceleracion resultante en el enlace en el enlace
que se eligio

d1 es la distancia entre marcadores enlazados

%}

X_in=X;

X_in = [X_in;zeros(7-size(X_in,1),size(X_in,2))];

X_out=[];

f_ini=min(X_in(4,:));
f_fin=max(X_in(4,:));

%f_fin=f_ini+10;

datos.enlaces = [];

if(X_in(3,:)==ones(1,size(X_in,2)))
    dim_max=2;
else
    dim_max=3;
end;

trayectorias_truncas = [];
inicializaciones_truncas = [];

for frame=f_ini:f_fin-1
    
    if frame>f_ini
        X_fprev=X_in(1:dim_max,X_in(4,:)==(frame-1));
        datos(frame).X_fprev = X_in(:,X_in(4,:)==(frame-1));
    end;
    
    if frame>(f_ini+1)
        X_fprev2=X_in(1:dim_max,X_in(4,:)==(frame-2));
    end;
    
    X_f0=X_in(1:dim_max,X_in(4,:)==frame);
    X_f1=X_in(1:dim_max,X_in(4,:)==(frame+1));
    X_f2=X_in(1:dim_max,X_in(4,:)==(frame+2));
    
    if frame==f_ini
        link_next=enfrentar_marcadores_inicial(X_f0,X_f1,X_f2);
    elseif frame==f_fin-1
        link_next=enfrentar_marcadores_final(X_fprev,X_f0,X_f1,link_prev);
    else
        [link_next,X_f1_estimado] = enfrentar_marcadores_herda(X_fprev,X_f0,X_f1,X_f2,link_prev);
        %X_f1_estimado
    end;
    
    if isempty(link_next)
        disp('*******************************************************************************');
        disp(['TRACKING TERMINADO PREMATURAMENTE @(' num2str(frame) ')(' num2str(frame+1) ')']);
        disp('*******************************************************************************');
        return;
    end
    
    link_next=sortrows(link_next,size(link_next,2));
    
    %disp(num2str(link_next,2));
    
    %num2str(link_next,2)
    
    
    %limit_distancia = 3*median(link_next(:,size(link_next,2)));
    
    %limit_distancia = 3*0.0336;
    
    %limit_distancia;
    
    % Controlo que ningun enlace se vaya mas alla de cierto multiplo de
    % la mayor distancia de enlace registrada hasta el momento
    
	[link_next,sobran_0,sobran_1] = validar_enlaces(X_out,X_in,link_next,'externo',limit_distancia);

    if size(X_out,1)==7
        max_step_global = max(X_out(7,:));
    end
        
    disp('-----------------------------------------');
    
    disp([ '@(f+1) sobran: ' num2str(sobran_1) ]);
    
    
    
    if ~isempty(trayectorias_truncas)
        posibles_rescates = [] ;% path - index_marker@(f+1) -  distancia
        for n_rescate = 1:size(sobran_1,2)
            for n_tray=1:size(trayectorias_truncas,1)
                
                n_path_perdido = trayectorias_truncas(n_tray,1);
                n_frame_perdido = trayectorias_truncas(n_tray,2);
                n_index_f1 = sobran_1(n_rescate);
                
                X_path = X_out(:,X_out(5,:)==n_path_perdido);
                
                if size(X_path,2)==1
                    distancia_perdido = norm(X_path(1:3,:)-X_f1(1:3,n_index_f1));
                    diff_frames = frame+1-n_frame_perdido;
                    ratio_radial = distancia_perdido/max_step_global;
                    if ratio_radial<(diff_frames+1)
                        disp(['      ---> marker: ' num2str(n_index_f1) ' @(' num2str(frame+1) ') - path: ' num2str(n_path_perdido) ' @(' num2str(n_frame_perdido) ')' ]);
                        posibles_rescates = [posibles_rescates;n_path_perdido,n_index_f1,distancia_perdido];
                    end
                else
                    back_frame = 3;
                    step_path = mean(X_path(1:3,max([2,size(X_path,2)-back_frame]):size(X_path,2))-X_path(1:3,max([1,size(X_path,2)-back_frame-1]):size(X_path,2)-1),2);
                    
                    paso_distancia = max(X_path(7,max([1,size(X_path,2)-2]):size(X_path,2)));
                    
                    X_perdido = X_path(1:3,X_path(4,:)==n_frame_perdido);
                    
                    distancia_perdido = norm(X_f1(1:3,n_index_f1)-X_perdido);
                    
                    diff_frames = frame+1-n_frame_perdido;
                    
                    estimacion_lineal = X_perdido+diff_frames*step_path;
                    
                    ratio_direccional = norm(X_f1(1:3,n_index_f1)-estimacion_lineal)/paso_distancia;
                    ratio_radial = norm(X_f1(1:3,n_index_f1)-X_perdido)/paso_distancia;
                    
                    if ratio_direccional<10
                        disp([ 'trayectoria: ' num2str(n_path_perdido) ' ,punto: [' num2str(X_f1(1:3,n_index_f1)',3) '] ,dist: ' num2str(norm(X_f1(1:3,n_index_f1)-estimacion_lineal),3) ' ,step: ' num2str(paso_distancia,3) ' ,ratio_direccional: ' num2str(ratio_direccional,3)])
                        
                    end
                    
                    if ratio_direccional<10
                        disp([ 'trayectoria: ' num2str(n_path_perdido) ' ,punto: [' num2str(X_f1(1:3,n_index_f1)',3) '] ,dist: ' num2str(norm(X_f1(1:3,n_index_f1)-estimacion_lineal),3) ' ,step: ' num2str(paso_distancia,3) ' ,ratio_radial: ' num2str(ratio_radial,3)])
                    end
                    
                    
                    %[distancia_perdido/paso_distancia,diff_frames+2]
                    
                    %if (distancia_perdido/paso_distancia) < (diff_frames+2)
                    
                    max_ratio = 4;
                    
                    if ratio_direccional<max_ratio || ratio_radial<max_ratio
                        posibles_rescates = [posibles_rescates;n_path_perdido,n_index_f1,distancia_perdido]
                    end
                end
            end
            
        end
        
        aux = posibles_rescates;
        
        % Busco las distancia minimas, para cada path recuperado
        posibles_rescates = [];
        
        if~isempty(aux)
            
            [I,J]=find(aux(:,3)==min(aux(:,3)),1);
            
            while ~isempty(I)
                posibles_rescates = [posibles_rescates;aux(I,:)];
                aux = aux(aux(:,1)~=aux(I,1)&aux(:,2)~=aux(I,2),:);
                [I,J]=find(aux(:,3)==min(aux(:,3)),1);
            end
            
            posibles_rescates;
            % Fin Minimos
            
            for n_rescate=1:size(posibles_rescates,1)
                
                X_path = X_out(:,X_out(5,:)==posibles_rescates(n_rescate,1));
                if (frame+1-posibles_rescates(n_rescate,2))>1
                    X_estimado = estimar_marcadores(X_out,X_in,posibles_rescates(n_rescate,1),frame+1,posibles_rescates(n_rescate,2));
                    
                    X_out = [X_out,X_estimado(1:size(X_out,1),:)];
                    X_in = [X_in,X_estimado(1:size(X_in,1),:)];
                    
                    n_prev = get_index_from_tracking(X_out,frame-1,posibles_rescates(n_rescate,1));
                    n_0 = get_index_from_tracking(X_out,frame,posibles_rescates(n_rescate,1));
                    n_1 = posibles_rescates(n_rescate,2);
                    
                    X_fprev = X_in(:,X_in(4,:)==(frame-1));
                    X_f0 = X_in(:,X_in(4,:)==(frame));
                    X_f1 = X_in(:,X_in(4,:)==(frame+1));
                    
                    if norm(X_estimado(1:3,size(X_estimado,2))-X_f1(1:3,n_1))<limit_distancia
                        
                        if frame<f_fin-1
                            link_next = [link_next;n_prev,...
                                n_0,...
                                n_1,...
                                0,...
                                norm(X_fprev(1:3,n_prev)-2*X_f0(1:3,n_0)+X_f1(1:3,n_1)),...
                                norm(X_estimado(1:3,size(X_estimado,2))-X_f1(1:3,n_1))...
                                ];
                        else
                            link_next = [link_next;n_prev,...
                                n_0,...
                                n_1,...
                                NaN,...
                                norm(X_estimado(1:3,size(X_estimado,2))-X_f1(1:3,n_1))...
                                ];
                        end
                        
                        trayectorias_truncas = trayectorias_truncas(trayectorias_truncas(:,1)~=posibles_rescates(n_rescate,1),:);
                        
                    end
                end
            end
        end
    end;
   
    disp([ '@(f) sobran: ' num2str(sobran_0)]);
    
    for n_sobran=1:size(sobran_0,2)
        path_perdido = get_path_from_tracking(X_out,frame,sobran_0(n_sobran));
        if path_perdido~=0
            disp(['   ---> Perdi marker: ' num2str(sobran_0(n_sobran)) ' @(' num2str(frame) '), path: '  num2str(path_perdido)]);
            trayectorias_truncas = [trayectorias_truncas;path_perdido,frame];
        end
    end
    
    
    disp('-----------------------------------------');
    
    link_prev=link_next(:,(size(link_next,2)-4):(size(link_next,2)-3));
    
    datos(frame).enlaces = link_next;
    datos(frame).trayectorias_truncas = trayectorias_truncas;
    datos(frame).X_f0 = X_in(:,X_in(4,:)==frame);
    datos(frame).X_f1 = X_in(:,X_in(4,:)==(frame+1));
    if frame==f_ini
        datos(frame).X_f2 = X_in(:,X_in(4,:)==(frame+2));
    elseif frame==f_fin-1
        datos(frame).X_fprev = X_in(:,X_in(4,:)==(frame-1));
    else
        datos(frame).X_fprev = X_in(:,X_in(4,:)==(frame-1));
        datos(frame).X_f2 = X_in(:,X_in(4,:)==(frame+2));
    end;
    
    
    %% Actualizo los indices en la matriz de salida

    X_out = actualizar_tracking(X_out,X_in,frame,link_next);
    
    %%
    
    disp(['(f)(f+1) = (' num2str(frame) ')(' num2str(frame+1) '), enlaces = ' num2str(size(link_next,1)) ]);
    %disp(num2str(link_next));
    disp('****************************************************');
    
    if isempty(link_next)
        disp('****************************************************');
        disp(['TRACKING TERMINADO PREMATURAMENTE @(' num2str(frame) ')(' num2str(frame+1) ')']);
        disp('****************************************************');
        return;
    end
    
end

end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [link_next,sobran_0,sobran_1] = validar_enlaces(X_out,X_in,link_next,modo,parametro)
if size(X_out,2)==0
    frame = min(X_in(4,:));
else
    frame = max(X_out(4,:));
end

if strcmp(modo,'global')
    if nargin<5
        parametro = 1;
    end
    link_next = link_next(link_next(:,size(link_next,2))< parametro*max(X_out(7,:)),:);
    if frame==min(X_in(4,:))
        sobran_0 = setdiff(1:size(X_in(:,X_in(4,:)==frame),2),link_next(:,1));
        sobran_1 = setdiff(1:size(X_in(:,X_in(4,:)==frame+1),2),link_next(:,2));
    else
        sobran_0 = setdiff(1:size(X_in(:,X_in(4,:)==frame),2),link_next(:,2));
        sobran_1 = setdiff(1:size(X_in(:,X_in(4,:)==frame+1),2),link_next(:,3));
    end
elseif strcmp(modo,'local')
    
elseif strcmp(modo,'externo')
    if nargin<5
        parametro = Inf;
    end
    link_next = link_next(link_next(:,size(link_next,2))< parametro,:);
    if frame==min(X_in(4,:))
        sobran_0 = setdiff(1:size(X_in(:,X_in(4,:)==frame),2),link_next(:,1));
        sobran_1 = setdiff(1:size(X_in(:,X_in(4,:)==frame+1),2),link_next(:,2));
    else
        sobran_0 = setdiff(1:size(X_in(:,X_in(4,:)==frame),2),link_next(:,2));
        sobran_1 = setdiff(1:size(X_in(:,X_in(4,:)==frame+1),2),link_next(:,3));
    end
end
    
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function index_path = get_path_from_tracking(X_out,frame,index_frame)
if isempty(X_out)
    index_path = index_frame;
else
    elementos_frame = X_out(4,:)==frame;
    marker_frame = X_out(:,elementos_frame);
    index_path = marker_frame(5,index_frame);    
end
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function index_frame = get_index_from_tracking(X_out,frame,index_path)
elementos_frame = X_out(4,:)==frame;
marker_frame = X_out(:,elementos_frame);
[I,J] = find(marker_frame(5,:)==index_path);
index_frame = J;
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function marker = get_marker_from_tracking(X_out,frame,index_frame)
elementos_frame = X_out(4,:)==frame;
marker_frame = X_out(:,elementos_frame);
marker = marker_frame(1:3,index_frame);
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function X_estimado = estimar_marcadores(X_out,X_in,path,frame,index_marker)

X_path = X_out(:,X_out(5,:)==path);
frame_path = X_path(4,size(X_path,2));
X_f1 = X_in(:,X_in(4,:)==frame);
diff_frames = frame - frame_path;
X_f1_aux= X_f1(:,index_marker);

% Genero las ecucaciones de variacion de aceleracion nulas

M1 = zeros(diff_frames,diff_frames-1+1+min([3,size(X_path,2)]));

if size(X_path,2)==1
    for i=1:size(M1,1)
        M1(i,i) = -1;
        M1(i,i+1) = 1;
    end
elseif size(X_path,2)==2
    for i=1:size(M1,1)
        M1(i,i) = 1;
        M1(i,i+1) = -2;
        M1(i,i+2) = 1;
    end
elseif size(X_path,2)>=3
    for i=1:size(M1,1)
        M1(i,i) = -1;
        M1(i,i+1) = 3;
        M1(i,i+2) = -3;
        M1(i,i+3) = 1;
    end
end
   

%{
M1 = zeros(diff_frames,diff_frames+3);


M2 = zeros(diff_frames+1,diff_frames+3);

for i=1:size(M2,1)
    M2(i,i) = 1;
    M2(i,i+1) = -2;
    M2(i,i+2) = 1;
end

M3 = zeros(diff_frames+2,diff_frames+3);

for i=1:size(M3,1)
    M3(i,i) = -1;
    M3(i,i+1) = 1;
end
%}
M = [M1];

A=M(:,size(M,2)-diff_frames+1:size(M,2)-1);
B=-M(:,size(M,2))*X_f1_aux(1:3,:)'-M(:,1:size(M,2)-diff_frames)*X_path(1:3,max([size(X_path,2)-2,1]):size(X_path,2))';

% Viejo y Querido Minimos Cuadrados
X_estimado = [((A'*A)^-1*A'*B)';frame_path+1:frame-1;path*ones(1,diff_frames-1);NaN*ones(1,diff_frames-1);zeros(1,diff_frames-1)];

X_aux = [X_path,X_estimado];

for i=1:size(X_estimado,2)
    X_estimado(7,i) = norm(X_aux(1:3,X_aux(4,:)==X_estimado(4,i))-X_aux(1:3,X_aux(4,:)==X_estimado(4,i)-1));
end

end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function X_out = actualizar_tracking(X_out,X_in,frame,link_next)

f_ini = min(X_in(4,:));
f_fin = max(X_in(4,:));

if frame==f_ini
    elementos_marcadores_actuales = X_in(4,:)==frame;
else
    elementos_marcadores_actuales = X_out(4,:)==frame;
end
elementos_marcadores_proximos = X_in(4,:)==frame+1;

X_1 = X_in(:,elementos_marcadores_proximos);X_1 = X_in(:,elementos_marcadores_proximos);

if frame==f_ini
    X_0 = X_in(:,elementos_marcadores_actuales);
    if X_0(5,:)==zeros(1,size(X_0,2))
        X_0(5,:) = 1:size(X_0,2);
    end
    for n_enlace=1:size(link_next,1)
        enlaces = link_next(n_enlace,1:2);
        X_1(5,enlaces(2)) = X_0(5,enlaces(1));
        X_1(6,enlaces(2)) = link_next(n_enlace,4);
        X_1(7,enlaces(2)) = link_next(n_enlace,5);
    end;
    X_out = [X_0,X_1];
else
    X_0 = X_out(:,elementos_marcadores_actuales);
    %link_next(:,2:3)
    %X_0
    %X_1
    for n_enlace=1:size(link_next,1)
        enlaces = link_next(n_enlace,2:3);
        X_1(5,enlaces(2)) = X_0(5,enlaces(1));
        if frame<(f_fin-1)
            X_1(6,enlaces(2)) = link_next(n_enlace,5);
            X_1(7,enlaces(2)) = link_next(n_enlace,6);
        else
            X_1(6,enlaces(2)) = link_next(n_enlace,4);
            X_1(7,enlaces(2)) = link_next(n_enlace,5);
        end;
    end;
    X_out = [X_out,X_1];
end

end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function I = vecinos_intraframe(N, p, d)


% Dada una nube de puntos N correspondiente a un frame, devuelve un vector
% de indices de los puntos de N de aquellos que se encuentran a una distancia
% menor a d respecto al punto p.

% N(j,1), posición x del marcador j
% N(j,2), posición y del marcador j
% N(j,3), posición z del marcador j (si son puntos 3D)
% p(1), posición x del punto p
% p(2), posicion y del punto p
% p(3), posicion z del punto p (si son puntos 3D)

dimN = size(N);   % dimension de N
dimp = size(p);   % dimension de p

if dimN(2) ~= dimp(2)
    error('dimension de p y N distintas')
end

% si los puntos son 2D se agrega una columna de ceros y se resuelve
% genericamente para puntos 3D
if dimN(2) == 2
    N = [N,zeros(dimN(1),1)];
    p = [p,0];
end

dx = N(:,1) - p(1);
dy = N(:,2) - p(2);
dz = N(:,3) - p(3);

% condicion de distancia que deben cumplir los puntos buscados
condicion = sqrt(sum([dx, dy, dz].^2,2)) < d;
I = find(condicion);
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function link_next = enfrentar_marcadores_inicial(N0,N1,N2)
%{
ENTRADA

Ni - matriz DIM 2 o 3 filas, N[#marcadores@(frame)] columnas

N0 - Marcadores del frame (f)
N1 - Marcadores del frame (f+1)
N2 - Marcadores del frame (f+2)

SALIDA

link_next - Matriz,
    1era columna es el indice de marcador en (f)
    2nda columna es el indice de marcador en (f+1)
    3era columna es el indice de marcador en (f+1)
    4rta columna es la aceleracion resultante
    5ta columna es la distancia (f)(f+1)
%}
%% Genenro las posibles combinaciones de trayectorias, calculando la aceleracion, y la distancias resultantes

%num2str(N0,2)

%num2str(N1,2)

trayectorias = [];

for i=1:size(N0,2)
    for j=1:size(N1,2)
        tray_aux=[i*ones(size(N2,2),1),j*ones(size(N2,2),1),(1:size(N2,2))'];
        for k=1:size(tray_aux,1)
            tray_aux(k,4)=norm(N0(:,tray_aux(k,1))-2*N1(:,tray_aux(k,2))+N2(:,tray_aux(k,3)));
            tray_aux(k,5)=norm(N0(:,tray_aux(k,1))-N1(:,tray_aux(k,2)));
        end
        trayectorias=[trayectorias;tray_aux];
    end;
end;

aux=trayectorias;

link_next = [];

[I,J]=find(aux(:,4)==min(aux(:,4)),1);

while ~isempty(I)
    
    link_next = [link_next;aux(I,:)];
    
    aux = aux(aux(:,1)~=aux(I,1)&aux(:,2)~=aux(I,2),:);
    
    [I,J]=find(aux(:,4)==min(aux(:,4)),1);
    
end

%disp(num2str(link_next,2));
%disp(['SOBRAN @(f) ' num2str(setdiff(1:size(N0,2),link_next(:,1)'))]);
%disp(['SOBRAN @(f+1) ' num2str(setdiff(1:size(N1,2),link_next(:,1)'))]);
%median(link_next(:,5))

end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function link_next = enfrentar_marcadores_final(N0,N1,N2,link_prev)
%{
ENTRADA

Ni - matriz DIM 2 o 3 filas, N[#marcadores@(frame)] columnas

N0 - Marcadores del frame (f)
N1 - Marcadores del frame (f+1)
N2 - Marcadores del frame (f+2)

SALIDA

link_next - Matriz,
    1era columna es el indice de marcador en (f)
    2nda columna es el indice de marcador en (f+1)
    3era columna es el indice de marcador en (f+1)
    4rta columna es la aceleracion resultante
    5ta columna es la distancia (f)(f+1)
%}
%% Genenro las posibles combinaciones de trayectorias, calculando la aceleracion, y la distancias resultantes

%num2str(N0,2)

%num2str(N1,2)

%N0,N1,N2,link_prev

trayectorias = [];

for n_marker=1:size(N1,2)
    
    n_prev = link_prev(link_prev(:,2)==n_marker,1);
    
    if ~isempty(n_prev)
        d3 = norm(N0(:,n_prev)-N1(:,n_marker));
        
        if d3 == 0
            d3 = d3+0.01;
        end
        
        N2_aux = (2*N1(:,n_marker)-N0(:,n_prev));
        
        I3 = [];
        
        n_dist = 1;
        
        while isempty(I3)
            I3=vecinos_intraframe(N2',N2_aux',(2^n_dist)*d3);
            % puntos en (f+1) que se encuentran a distancia d3 de la
            % estimacion, si no se encuentra nada, se incrementa la distancia
            if isempty(I3)
                %disp(['marcador (' num2str(n_marker) ') @(f)- No se encontraron candidatos en (f+1), se duplica la distancia - ' num2str((2^(n_dist+1))*d3) ]);
                n_dist = n_dist+1;
            else
                %disp(['marcador (' num2str(n_marker) ') - Se encontraron ' num2str(length(I3)) ' marcadores en (f+1) ' ]);
            end
        end;
        
        if length(I3)==1
            tray_aux_3 = [n_prev,n_marker,I3];
            tray_aux_3(4) = norm(...
                N2(:,tray_aux_3(3))...
                -2*N1(:,tray_aux_3(2))...
                +N0(:,tray_aux_3(1))...
                );
            % calculo la aceleracion para la trayectoria
            tray_aux_3(5) = norm(N2(:,tray_aux_3(3))-N1(:,tray_aux_3(2)));
            % calculo la distancia (f)(f+1)
            %disp(num2str(tray_aux_3));
            trayectorias = [trayectorias;tray_aux_3];
        else
            tray_aux_3 = [n_prev*ones(length(I3),1),n_marker*ones(length(I3),1),I3];
            for n_tray=1:size(tray_aux_3,1)
                tray_aux_3(n_tray,4) = norm(...
                    N2(:,tray_aux_3(n_tray,3))...
                    -2*N1(:,tray_aux_3(n_tray,2))...
                    +N0(:,tray_aux_3(n_tray,1))...
                    );
                % calculo la aceleracion para la trayectoria
                tray_aux_3(n_tray,5) = norm(N2(:,tray_aux_3(n_tray,3))-N1(:,tray_aux_3(n_tray,2)));
                % calculo la distancia (f)(f+1)
                %disp(num2str(tray_aux_3));
            end;
            trayectorias = [trayectorias;tray_aux_3];
        end
        
    end;
    
end


aux=trayectorias;

link_next = [];

[I,J]=find(aux(:,4)==min(aux(:,4)),1);

while ~isempty(I)
    
    link_next = [link_next;aux(I,:)];
    
    aux = aux(aux(:,1)~=aux(I,1)&aux(:,2)~=aux(I,2),:);
    
    [I,J]=find(aux(:,4)==min(aux(:,4)),1);
    
end

end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [link_next,X_f1_estimado] = enfrentar_marcadores_herda(X_fprev,X_f0,X_f1,X_f2,link_prev)

%X_fprev,X_f0,X_f1,X_f2,link_prev

%num2str(X_f0,2)

%num2str(X_f1,2)

trayectorias = [];

X_f1_estimado = zeros(size(X_f0));

for n_marker=1:length(X_f0)
    
    n_prev = link_prev(link_prev(:,2)==n_marker,1);
    % el indice del enlace al marcador actual, en el frame anterior
    
    if ~isempty(n_prev)
        
        d3 = norm(X_fprev(:,n_prev)-X_f0(:,n_marker));
        
        if d3 == 0
            d3 = d3+0.01;
        end
        
        % distancia entre frames, de un mismo marcador
        X_f1_aux = (2*X_f0(:,n_marker)-X_fprev(:,n_prev));
        X_f1_estimado(:,n_marker) = X_f1_aux;
        % estimacion del punto en frame (f+1), que verifica (x0-xprev)-(X1-x0)=0, aceleracion nula
        
        I3 = [];
        
        n_dist = 1;
        
        while isempty(I3)
            I3=vecinos_intraframe(X_f1',X_f1_aux',(2^n_dist)*d3);
            % puntos en (f+1) que se encuentran a distancia d3 de la
            % estimacion, si no se encuentra nada, se incrementa la distancia
            if isempty(I3)
                %disp(['marcador (' num2str(n_marker) ') @(f)- No se encontraron candidatos en (f+1), se duplica la distancia - ' num2str((2^(n_dist+1))*d3) ]);
                n_dist = n_dist+1;
            else
                %disp(['marcador (' num2str(n_marker) ') - Se encontraron ' num2str(length(I3)) ' marcadores en (f+1) ' ]);
            end
        end;
        
        %disp([ '[' num2str(n_prev) '] @(f-1) , [' num2str(n_marker) '] @(f) , [' num2str(I3') '] @(f+1)']);
        
        if length(I3)==1
            tray_aux_3 = [n_prev,n_marker,I3,0];
            tray_aux_3(5) = norm(...
                X_f1(:,tray_aux_3(3))...
                -2*X_f0(:,tray_aux_3(2))...
                +X_fprev(:,tray_aux_3(1))...
                );
            % calculo la aceleracion para la trayectoria
            tray_aux_3(6) = norm(X_f1(:,tray_aux_3(3))-X_f0(:,tray_aux_3(2)));
            % calculo la distancia (f)(f+1)
            %disp(num2str(tray_aux_3));
            trayectorias = [trayectorias;tray_aux_3];
        else
            
            tray_aux_3 = [];
            
            for m_marker=1:length(I3)
                
                if ~isempty(X_f2)
                    
                    d4 = norm(X_f1(:,I3(m_marker))-X_f0(:,n_marker));
                    
                    if d4 == 0
                        d4 = d4+0.01;
                    end
                    
                    % distancia entre frames, de un mismo marcador
                    X_f2_aux = 2*X_f1(:,I3(m_marker))-X_f0(:,n_marker);
                    % estimacion del punto en frame (f+2), que verifica (x1-x0)-(X2-x1)=0, aceleracion nula
                    
                    I4 = [];
                    
                    n_dist = 1;
                    
                    while isempty(I4)
                        I4=vecinos_intraframe(X_f2',X_f2_aux',(2^n_dist)*d4);
                        % puntos en (f+1) que se encuentran a distancia d3 de la
                        % estimacion, si no se encuentra nada, se incrementa la distancia
                        if isempty(I4)
                            %disp(['marcador (' num2str(I3(m_marker)) ') @(f+1)- No se encontraron candidatos en (f+2), se duplica la distancia - ' num2str((2^(n_dist+1))*d4) ]);
                            n_dist = n_dist+1;
                        else
                            %disp(['marcador (' num2str(I3(m_marker)) ') - Se encontraron ' num2str(length(I4)) ' marcadores en (f+2) ' ]);
                        end
                    end;
                    
                    %disp([ '[' num2str(n_prev) '] @(f-1) , [' num2str(n_marker) '] @(f) , [' num2str(I3(m_marker)') '] @(f+1) , [' num2str(I4') '] @(f+2)']);
                    
                    
                    if length(I4)==1
                        tray_aux_4 = [n_prev,n_marker,I3(m_marker),I4];
                        tray_aux_4(5) = norm(...
                            X_f2(:,tray_aux_4(4))...
                            -3*X_f1(:,tray_aux_4(3))...
                            +3*X_f0(:,tray_aux_4(2))...
                            -X_fprev(:,tray_aux_4(1))...
                            );
                        % calculo la variacion de aceleracion la
                        % trayectoria
                        tray_aux_4(6) = norm(X_f1(:,tray_aux_4(3))-X_f0(:,tray_aux_4(2)));
                        % calculo la distancia (f)(f+1)
                    else
                        tray_aux_4=[n_prev*ones(length(I4),1),...
                            n_marker*ones(length(I4),1),...
                            I3(m_marker)*ones(length(I4),1),...
                            I4];
                        
                        for n_tray=1:size(tray_aux_4,1)
                            tray_aux_4(n_tray,5) = norm(X_f2(:,tray_aux_4(n_tray,4))...
                                -3*X_f1(:,tray_aux_4(n_tray,3))...
                                +3*X_f0(:,tray_aux_4(n_tray,2))...
                                -X_fprev(:,tray_aux_4(n_tray,1)));
                            % calculo la variacion de aceleracion para cada
                            % trayectoria
                            tray_aux_4(n_tray,6) = norm(X_f1(:,tray_aux_4(n_tray,3))-X_f0(:,tray_aux_4(n_tray,2)));
                            % calculo la distancia (f)(f+1)
                        end
                    end
                    [I,J]=find(tray_aux_4(:,5)==min(tray_aux_4(:,5)),1);
                    tray_aux_4 = tray_aux_4(I,:);
                    % Cambio el calculo de la 5ta columna a aceleracion, en
                    % vez de variacion, para comparacion final
                    tray_aux_4(1,5) = norm(...
                        X_f1(:,tray_aux_4(3))...
                        -2*X_f0(:,tray_aux_4(2))...
                        +X_fprev(:,tray_aux_4(1))...
                        );
                    tray_aux_3 = [tray_aux_3;tray_aux_4];
                end
            end
            tray_aux_3;
            %[I,J]=find(tray_aux_3(:,5)==min(tray_aux_3(:,5)),1);
            %tray_aux_3 = tray_aux_3(I,:);
            trayectorias = [trayectorias;tray_aux_3];
            
        end
        
    end;
end;

trayectorias = sortrows(trayectorias,size(trayectorias,2));

aux = trayectorias;

%disp(num2str(aux,2));

link_next = [];

if ~isempty(aux)
    
    [I,J]=find(aux(:,5)==min(aux(:,5)),1);
    
    while ~isempty(I)
        
        link_next = [link_next;aux(I,:)];
        
        aux = aux(aux(:,2)~=aux(I,2)&aux(:,3)~=aux(I,3),:);
        
        [I,J]=find(aux(:,5)==min(aux(:,5)),1);
        
    end
end
%disp('////////////////////////////////////');
%disp(num2str(link_next,2));
%disp(['SOBRAN @(f-1) ' num2str(setdiff(1:size(X_fprev,2),link_next(:,1)'))]);
%disp(['SOBRAN @(f) ' num2str(setdiff(1:size(X_f0,2),link_next(:,2)'))]);
%disp(['SOBRAN @(f+1) ' num2str(setdiff(1:size(X_f1,2),link_next(:,3)'))]);

end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
