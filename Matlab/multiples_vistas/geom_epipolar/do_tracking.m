function [X_,enlazado]=do_tracking(X)

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

if size(X,2)<size(X,1)
    X=X';
end

if size(X,1)==4
    if(X(3,:)==ones(1,size(X,2)))
        dim_max=2;
    else
        dim_max=3;
    end;
else
    dim_max=2;
end;

f_ini=min(X(size(X,1),:));
f_fin=max(X(size(X,1),:));

d3=Inf;d4=Inf;

for frame=f_ini:(f_fin-1)
    
    if mod(ceil(100*(frame-f_ini+1)/(f_fin-f_ini)),10)==0
        disp(['Trackeando...' num2str(100*(frame-f_ini+1)/(f_fin-f_ini)) '%']);
        clc
    end;
    
    X_f0=X(1:dim_max,X(size(X,1),:)==frame);
    X_f1=X(1:dim_max,X(size(X,1),:)==frame+1);
    X_f2=X(1:dim_max,X(size(X,1),:)==frame+2);
    
    if frame==f_ini
        
        %% Inicializacioon de Tracking, por cadena con menor aceleracion;
        link_next=enfrentar_marcadores_iniciales(X_f0,X_f1,X_f2);
    else
        X_f_prev=X(1:dim_max,X(size(X,1),:)==frame-1);
        % Cargo los marcadores a enfrentar del frame (f) a enlazar
        marker_versus = 1:size(X_f0,2);
        % Busco los enlaces previos de los marcadores a enfrentar
        link_prev = enlazado.frame(frame-f_ini+1).marcador(marker_versus);
        % Calculo los enlaces proximos
        link_next = enfrentar_marcadores_multiples_v2(X_f_prev,X_f0,X_f1,X_f2,marker_versus,link_prev,d3,d4);
        
        if size(link_next,1) ~= size(X_f0,2)
            
            % Si no se encontro ningun enlace, inicializo el vector
            % link_next
            
            if isempty(link_next)
                link_next=[0,0,0,0];
            end
            
            link_next = [link_next;...
                enfrentar_marcadores_restantes(X_f_prev,X_f0,X_f1,X_f2,...% Marcadores de X_f0 que no fueron enlazados
                setdiff((1:size(X_f0,2))',link_next(:,1)),...% Enlaces previos de los marcadores de X_f0 que no fueron encontrados
                enlazado.frame(frame-f_ini+1).marcador(setdiff((1:size(X_f0,2))',link_next(:,1))),...% Marcadores de X_f1 que no fueron enlazados
                setdiff((1:size(X_f1,2))',link_next(:,2)))];
            
            % Quito los marcadores cuya primer columna tengo enlaces nulos
            
            link_next=link_next(link_next(:,1)>0,:);
            
        end;
        
        N5=[enlazado.frame(frame-f_ini+1).marcador(link_next(:,1))',link_next];
        
        % Calculo las distancias entre  X_f1 y (2*X_f0-X_f_prev), d3
        %                               X_f2 y (2*X_f1-X_f0), d4
        % Usando los enlaces obtenidos, para la proxima iteracion
        
        d3 = mean(sqrt(sum(X_f1(:,N5(:,3))'-(2*X_f0(:,N5(:,2))-X_f_prev(:,N5(:,1)))').^2));
        d4 = mean(sqrt(sum(X_f2(:,N5(:,4))'-(2*X_f1(:,N5(:,2))-X_f0(:,N5(:,1)))').^2));
        
    end
    
    for i=1:size(link_next,1)
        enlazado.frame(frame-f_ini+1+1).marcador(link_next(i,2))=link_next(i,1);
        enlazado.frame(frame-f_ini+1+1).d_acc(link_next(i,2))=link_next(i,4);
    end;
    
    index_marcadores_actual=X(4,:)==frame;
    cantidad_actual = size(X(:,X(size(X,1),:)==frame),2);
    
    if frame==f_ini
        %inicializo los indices de marcadores
        %fila INDEX+1, indices de marcadores frame a frame
        %fila INDEX+2, indices de marcadores en frame original
        X_=X;
        X_(size(X,1)+1,index_marcadores_actual)=1:cantidad_actual;
        %X_(size(X,1)+2,index_marcadores_actual)=1:cantidad_actual;
    else
        
        index_marcadores_previo=(X(4,:)==frame-1);
        
        %X_(8,index_marcadores_actual)=1:cantidad_actual;
        
        track_previo = X_(size(X,1)+1,index_marcadores_previo);
        
        enlaces = enlazado.frame(frame-f_ini+1).marcador;
        d_acc = enlazado.frame(frame-f_ini+1).d_acc;
        
        X_(size(X,1)+1,index_marcadores_actual)=track_previo(enlaces(1:cantidad_actual));
        X_(size(X,1)+2,index_marcadores_actual)=d_acc(1:cantidad_actual);
        
        x_actual=X_(:,index_marcadores_actual);
        x_previo=X_(:,index_marcadores_previo);
        
        x_dim=size(X,1)+3;
        
        for marker=min(x_actual(5,:)):max(x_actual(5,:))
            x_actual(x_dim,x_actual(5,:)==marker)=norm(x_actual(1:3,x_actual(5,:)==marker)-x_previo(1:3,x_previo(5,:)==marker));
        end;
        
        X_(x_dim,index_marcadores_actual)=x_actual(size(x_actual,1)-1,:);
        X_(x_dim+1,index_marcadores_actual)=1:cantidad_actual;
        
    end;
end;


end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function delta_aceleracion = delta_aceleracion (p1,p2,p3,p4)



a1 = (p3 - p2) - (p2 - p1);

a2 = (p4 - p3) - (p3 - p2);

delta_aceleracion = norm(a2 - a1);

%delta_aceleracion = cross([a1;1],[a2;1]);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function link_next = enfrentar_marcadores_iniciales(N1,N2,N3)
%{
ENTRADA

Ni - matriz DIM[2,3] filas, N[#marcadores@(frame)] columnas

N1 - Marcadores del frame (f)
N2 - Marcadores del frame (f+1)
N3 - Marcadores del frame (f+2)

SALIDA

link_next - Matriz,
    1era columna es el marcador en (f)
    2nda columna es el marcador en (f+1)
    4rta columna es la aceleracion resultante
%}
%%

        trayectorias = [];
        
        for i=1:size(N1,2)
            for j=1:size(N2,2)
                trayectorias=[trayectorias;i*ones(size(N3,2),1),j*ones(size(N3,2),1),(1:size(N3,2))',zeros(size(N3,2),1)];
            end;
        end;
        
        for i=1:size(trayectorias,1)
            trayectorias(i,4)=norm(N1(:,trayectorias(i,1))-2*N2(:,trayectorias(i,2))+N3(:,trayectorias(i,3)));
        end;
        
        aux = trayectorias;
        
        link_next = [];
        
        i=1;
        
        while ~isempty(aux)
            
            [min_acc,min_acc_index] = min(aux(:,4));
            
            link_next = [link_next;aux(aux(:,4)==min_acc,:)];
            
            aux = aux(aux(:,2)~=link_next(i,1)&aux(:,3)~=link_next(i,2),:);
            
            i=i+1;
            
        end;


end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function link_next = enfrentar_marcadores_multiples_v2(N1,N2,N3,N4,marker,link_prev,d3,d4)
%{
ENTRADA

Ni - matriz DIM[2,3] filas, N[#marcadores@(frame)] columnas

N1 - Marcadores del frame (f-1)
N2 - Marcadores del frame (f)
N3 - Marcadores del frame (f+1)
N4 - Marcadores del frame (f+2)
marker - marcadores a enlazar entre (f) y (f+1)
link_prev - enlaces entre (f-1) y (f)
d3 - radio de busqueda entre estimacion y marcadores en N3,(f+1)
d4 - radio de busqueda entre estimacion y marcadores en N4,(f+2)

DESCRIPCION

Dado una lista de marcadores de (f), trato de encontrar sus enlaces en
(f+1), primero buscando los candidatos en (f+1) que se encuentran dentro de
un radio d3 con respecto a la aproximacion que verifica:

a1=v2-v1=(x3-x2)-(x2-x1)=x3-2*x2+x1=0   =>  x3=2*x2-x1

Luego, para cada uno de los candidatos de marcador, busco candidatos en
(f+2) dentro de radio d4 con respecto a aproximacion que verifica:

a2=v3-v2=(x4-x3)-(x3-x2)=x4-2*x3+x2=0   =>  x4=2*x3-x2

Una vez obtenidas las trayectorias candidatas, se calcula la variacion de
aceleracion de los 4 puntos para CADA trayectoria candidata

x1i,x2i,x3i,x4i     =>  d_a = |a2i - a1i|
 
En el conjunto de trayectorias candidatas, busco la minima variacion de aceleracion, a
que marcadores en (f) y (f+1) involucra, defino como enlace, y quito todas
las trayectorias que involucran los marcadores que tengan el minimo hallado
del conjunto de trayectorias. Repito hasta que no queden trayectorias
candidatas.

SALIDA

link_next - Matriz,
    1era columna es el marcador en (f)
    2nda columna es el marcador en (f+1)
    3era columna es el marcador en (f+2)
    4rta columna es la variacion de aceleracion resultante

%}
%%
marker = marker(link_prev>0);
link_prev = link_prev(link_prev>0);

trayectorias = [];

for i=1:length(marker)
    
    if nargin >6
        I3 = vecinos_intraframe(N3', (2*N2(:,marker(i))-N1(:,link_prev(i)))', d3);
    else
        I3 = (1:length(N3))';
    end;
    
    for j=1:length(I3)
        if nargin > 7
            I4 = vecinos_intraframe(N4', (2*N3(:,I3(j))-N2(:,marker(i)))', d4);
        else
            I4 = (1:length(N4))';
        end;
        trayectorias = [trayectorias;...
            link_prev(i)*ones(length(I4),1),...
            marker(i)*ones(length(I4),1),...
            I3(j)*ones(length(I4),1),...
            I4];
    end
end

for i=1:size(trayectorias,1)
    trayectorias(i,5)=delta_aceleracion(N1(:,trayectorias(i,1)),N2(:,trayectorias(i,2)),N3(:,trayectorias(i,3)),N4(:,trayectorias(i,4)));
end;

aux = trayectorias;

link_next = [];

i=1;

while ~isempty(aux)
    
    [min_acc,min_acc_index] = min(aux(:,5));
    
    link_next = [link_next;aux(aux(:,5)==min_acc,2:5)];
    
    aux = aux(aux(:,2)~=link_next(i,1)&aux(:,3)~=link_next(i,2),:);
    
    i=i+1;
    
end;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function link_next = enfrentar_marcadores_restantes(N1,N2,N3,N4,marker,link_prev,link_next)

marker = marker(link_prev>0);
link_prev = link_prev(link_prev>0);

trayectorias = [];

for i=1:length(marker)
    
    I3 = link_next;
    
    for j=1:length(I3)
        
        I4 = (1:length(N4))';
        trayectorias = [trayectorias;...
            link_prev(i)*ones(length(I4),1),...
            marker(i)*ones(length(I4),1),...
            I3(j)*ones(length(I4),1),...
            I4];
    end
end

for i=1:length(trayectorias)
    trayectorias(i,5)=delta_aceleracion(N1(:,trayectorias(i,1)),N2(:,trayectorias(i,2)),N3(:,trayectorias(i,3)),N4(:,trayectorias(i,4)));
end;

aux = trayectorias;

link_next = [];

i=1;

while ~isempty(aux)
    
    [min_acc,min_acc_index] = min(aux(:,5));
    
    link_next = [link_next;aux(aux(:,5)==min_acc,2:5)];
    
    aux = aux(aux(:,2)~=link_next(i,1)&aux(:,3)~=link_next(i,2),:);
    
    i=i+1;
    
end;
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