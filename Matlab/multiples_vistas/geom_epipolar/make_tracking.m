function [X_out]=make_tracking(X)

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

X_out=X;

f_ini=min(X_in(4,:));
f_fin=max(X_in(4,:));

%f_fin=f_ini+10;


if(X(3,:)==ones(1,size(X_in,2)))
    dim_max=2;
else
    dim_max=3;
end;

for frame=f_ini:f_fin-1
    
    if frame>f_ini
        X_fprev=X_in(1:dim_max,X_in(size(X_in,1),:)==frame-1);
    end;
    
    X_f0=X_in(1:dim_max,X_in(size(X_in,1),:)==frame);
    X_f1=X_in(1:dim_max,X_in(size(X_in,1),:)==frame+1);
    X_f2=X_in(1:dim_max,X_in(size(X_in,1),:)==frame+2);
    
    if exist('link_next')
        link_old = link_prev;
    end;
    
    if frame==f_ini
        
        link_next=enfrentar_marcadores_inicial(X_f0,X_f1,X_f2);
        link_prev=link_next(:,1:2);
        
    elseif frame==f_fin-1
        link_next=enfrentar_marcadores_inicial(X_fprev,X_f0,X_f1);
        link_prev=link_next(:,2:3);
    else
        link_next = enfrentar_marcadores_multiples(X_fprev,X_f0,X_f1,X_f2,link_prev);
        if ~isempty(link_next)
            link_prev = link_next(:,2:3);
        end;
    end;
    
    % Busco los marcadores en (f) y (f+1) que no fueron identificados
    
    res_0 = setdiff(1:size(X_f0,2),link_prev(:,1)');
    res_1 = setdiff(1:size(X_f1,2),link_prev(:,2)');
    
    if (~isempty(res_0)) && (~isempty(res_1))
        %res_0,res_1,link_old
        link_next=[link_next;enfrentar_marcadores_restantes(X_fprev,X_f0,X_f1,X_f2,link_old,res_0,res_1)];
        link_prev = link_next(:,2:3);
    end
    
    link_next=sortrows(link_next,size(link_next,2))
    
    %% Actualizo los indices en la matriz de salida
    
    elementos_marcadores_actuales = X_in(4,:)==frame;
    elementos_marcadores_proximos = X_in(4,:)==frame+1;
    
    X_0=X_out(:,elementos_marcadores_actuales);
    X_1=X_out(:,elementos_marcadores_proximos);
    
    if frame==f_ini
        % Para el primer frame, reviso si existe una 5ta fila con numeros
        % inicializados
        if size(X_0,1)<5
            % Si no existe 5ta fila, la creo numerando marcadores desde 1 hasta la cantidad
            X_out(5,elementos_marcadores_actuales)=1:size(X_0,2);
        end
        
        indices_actuales_old = X_out(5,elementos_marcadores_actuales);
        
        indices_proximos_old = X_out(5,elementos_marcadores_proximos);
        indices_proximos_new = zeros(size(indices_proximos_old));
        
        link_new = link_next(:,1:2);% dos columnas, primera indice marcador en frame (f), segunda indice marcador en frame (f+1)
        acc_new = link_next(:,4);
        dst_new = link_next(:,5);
        
    elseif frame==f_fin-1
        
        indices_actuales_old = X_out(5,elementos_marcadores_actuales);
        
        indices_proximos_old = X_out(5,elementos_marcadores_proximos);
        indices_proximos_new = zeros(size(indices_proximos_old));
        
        link_new = link_next(:,2:3);% dos columnas, primera indice marcador en frame (f), segunda indice marcador en frame (f+1)
        acc_new = link_next(:,4);
        dst_new = link_next(:,5);
        
    else
        
        indices_actuales_old = X_out(5,elementos_marcadores_actuales);
        
        indices_proximos_old = X_out(5,elementos_marcadores_proximos);
        indices_proximos_new = zeros(size(indices_proximos_old));
        
        link_new = link_next(:,2:3);% dos columnas, primera indice marcador en frame (f), segunda indice marcador en frame (f+1)
        acc_new = link_next(:,5);
        dst_new = link_next(:,6);
    end
    
    acc_resultante = (-Inf)*ones(size(indices_proximos_old));
    dst_resultante = (-Inf)*ones(size(indices_proximos_old));
    
    for n_link=1:size(link_new,1)
        
        index_f0 =link_new(n_link,1);
        index_f1 =link_new(n_link,2);
        acc_resultante(index_f1) = acc_new(n_link);
        dst_resultante(index_f1) = dst_new(n_link);
        
        if indices_proximos_old(index_f1) == 0
            % Si antes no estaba definido, debo heredarlo de (f) hacia
            % (f+1) segun la relacion establecida en tracking
            indices_proximos_new(index_f1)=indices_actuales_old(index_f0);
        else
            % Si antes ya estaba definido, lo mantengo
            indices_proximos_new(index_f1)=indices_proximos_old(index_f1);
        end
        
    end;
    
    X_out(5,elementos_marcadores_proximos)=indices_proximos_new;
    X_out(6,elementos_marcadores_proximos)=acc_resultante;
    X_out(7,elementos_marcadores_proximos)=dst_resultante;
    
    %%
    
    disp(['(f)(f+1) = (' num2str(frame) ')(' num2str(frame+1) '), enlaces = ' num2str(size(link_next,1)) ]);
    %disp(num2str(link_next));
    disp(['---------------------------------------------------------------------------------------------']);
    
    
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function link_next = enfrentar_marcadores_multiples(X_fprev,X_f0,X_f1,X_f2,link_prev)

trayectorias = [];

for n_marker=1:length(X_f0)
    
    n_prev = link_prev(link_prev(:,2)==n_marker,1);
    % el indice del enlace al marcador actual, en el frame anterior
    
    if ~isempty(n_prev)
        
        d3 = norm(X_fprev(:,n_prev)-X_f0(:,n_marker));
        % distancia entre frames, de un mismo marcador
        X_f1_aux = (2*X_f0(:,n_marker)-X_fprev(:,n_prev));
        % estimacion del punto en frame (f+1), que verifica (x0-xprev)-(X1-x0)=0, aceleracion nula
        I3=vecinos_intraframe(X_f1',X_f1_aux',d3);
        % puntos en (f+1) que se encuentran a distancia d3 de la
        % estimacion
        
        if ~isempty(I3)
            
            for m_marker=1:length(I3)
                
                d4 = norm(X_f1(:,I3(m_marker))-X_f0(:,n_marker));
                
                X_f2_aux = 2*X_f1(:,I3(m_marker))-X_f0(:,n_marker);
                
                I4=vecinos_intraframe(X_f2',X_f2_aux',d4);
                
                if ~isempty(I4)
                    
                    tray_aux=[n_prev*ones(length(I4),1),...
                        n_marker*ones(length(I4),1),...
                        I3(m_marker)*ones(length(I4),1),...
                        I4];
                    
                    for n_tray=1:size(tray_aux,1)
                        tray_aux(n_tray,5) = norm(X_f2(:,tray_aux(n_tray,4))...
                            -3*X_f1(:,tray_aux(n_tray,3))...
                            +3*X_f0(:,tray_aux(n_tray,2))...
                            -X_fprev(:,tray_aux(n_tray,1)));
                        % calculo la variacion de aceleracion para cada
                        % distancia
                        tray_aux(n_tray,6) = norm(X_f1(:,tray_aux(n_tray,3))-X_f0(:,tray_aux(n_tray,2)));
                        % calculo la distancia (f)(f+1)
                    end
                    trayectorias = [trayectorias;tray_aux];
                else
                    % Si no se encontraron marcadores en (f+2), pero si en
                    % (f+1), ingreso todas las posibilidades para el 4to
                    % frame
                    %disp(['marcador ' num2str(n_prev) ' @(f-1), marcador ' num2str(n_marker) ' @(f), marcador ' num2str(I3(m_marker)) ' @(f+1), sin candidatos @(f+2)']);
                    tray_aux = [n_prev*ones(size(X_f2,2),1),n_marker*ones(size(X_f2,2),1),I3(m_marker)*ones(size(X_f2,2),1),(1:size(X_f2,2))'];
                    for n_tray=1:size(tray_aux,1)
                        tray_aux(n_tray,5) = norm(X_f2(:,tray_aux(n_tray,4))...
                            -3*X_f1(:,tray_aux(n_tray,3))...
                            +3*X_f0(:,tray_aux(n_tray,2))...
                            -X_fprev(:,tray_aux(n_tray,1)));
                        % calculo la variacion de aceleracion para cada
                        % distancia
                        tray_aux(n_tray,6) = norm(X_f1(:,tray_aux(n_tray,3))-X_f0(:,tray_aux(n_tray,2)));
                        % calculo la distancia (f)(f+1)
                    end
                    trayectorias = [trayectorias;tray_aux];
                end;
            end
        else
            % Si no se encontraron marcadores en (f+1)
            %disp(['marcador ' num2str(n_prev) ' @(f-1), marcador ' num2str(n_marker) ' @(f), sin candidatos @(f+1)']);
        end;
    end;
end;

aux = trayectorias;

link_next = [];

if ~isempty(aux)
    
    [I,J]=find(aux(:,5)==min(aux(:,5)),1);
    
    while ~isempty(I)
        
        link_next = [link_next;aux(I,:)];
        
        aux = aux(aux(:,2)~=aux(I,2)&aux(:,3)~=aux(I,3),:);
        
        [I,J]=find(aux(:,5)==min(aux(:,5)),1);
        
    end
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function link_next = enfrentar_marcadores_restantes(X_fprev,X_f0,X_f1,X_f2,link_prev,res_0,res_1)

trayectorias = [];

for n_marker=1:size(X_f0,2)
    
    n_prev = link_prev(link_prev(:,2)==n_marker,1);
    % el indice del enlace al marcador actual, en el frame anterior
    
    if ~isempty(n_prev)
        if ~isempty(intersect(n_marker,res_0))
            
            for m_marker=1:length(res_1)
                
                tray_aux = [n_prev*ones(size(X_f2,2),1),n_marker*ones(size(X_f2,2),1),res_1(m_marker)*ones(size(X_f2,2),1),(1:size(X_f2,2))'];
                for n_tray=1:size(tray_aux,1)
                    tray_aux(n_tray,5) = norm(X_f2(:,tray_aux(n_tray,4))...
                        -3*X_f1(:,tray_aux(n_tray,3))...
                        +3*X_f0(:,tray_aux(n_tray,2))...
                        -X_fprev(:,tray_aux(n_tray,1)));
                    % calculo la variacion de aceleracion para cada
                    % distancia
                    tray_aux(n_tray,6) = norm(X_f1(:,tray_aux(n_tray,3))-X_f0(:,tray_aux(n_tray,2)));
                    % calculo la distancia (f)(f+1)
                end
                trayectorias = [trayectorias;tray_aux];
            end;
        end
    end;
    
end

aux = trayectorias;

link_next = [];

if ~isempty(aux)
    
    [I,J]=find(aux(:,5)==min(aux(:,5)),1);
    
    while ~isempty(I)
        
        link_next = [link_next;aux(I,:)];
        
        aux = aux(aux(:,2)~=aux(I,2)&aux(:,3)~=aux(I,3),:);
        
        [I,J]=find(aux(:,5)==min(aux(:,5)),1);
        
    end
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%