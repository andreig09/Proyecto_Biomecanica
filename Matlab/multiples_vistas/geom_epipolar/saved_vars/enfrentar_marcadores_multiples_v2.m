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
        I3 = (1:size(N3,2))';
    end;
    
    for j=1:length(I3)
        if nargin > 7
            I4 = vecinos_intraframe(N4', (2*N3(:,I3(j))-N2(:,marker(i)))', d4);
        else
            I4 = (1:size(N4,2))';
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
    
    a1 = N2(:,trayectorias(i,2))-N1(:,trayectorias(i,1));
    a2 = N3(:,trayectorias(i,3))-N2(:,trayectorias(i,2));
    trayectorias(i,6) = acos(dot(a2,a1)/(norm(a1)*norm(a2)))*180/pi;
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