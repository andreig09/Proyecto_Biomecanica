%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% función que devuelve el valor absoluto de la 
% distancia 2D entre 2 puntos
% los puntos son arreglos donde el primer elemento
% es la coordenada x y el segundo la coordenada y
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function d = meanSquaredDistance2D(xi,xj)
x = xi(1) - xj(1);
y = xi(2) - xj(2);
d = sqrt(x*x + y*y);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% función que devuelve el valor absoluto de la 
% distancia 3D entre 2 puntos
% los puntos son arreglos donde el primer elemento
% es la coordenada x, el segundo la coordenada y y
% el tercero es la coordenada z
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function d = meanSquaredDistance3D(xi,xj)
x = xi(1) - xj(1);
y = xi(2) - xj(2);
z = xi(3) - xj(3);
l = sqrt(x*x + y*y);
d = sqrt(z*z + l*l);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% función que devuelve el error en 2D o en 3D en un frame con
% M marcadores comparando los puntos detectados con el
% ground truth
% Los marcadores tienen que estar emparejados con su 
% correspondiente en el ground truth
%
% deltas es un arreglo donde deltas(i) vale 1 si el marcador
% i se pudo reconstruir en ese frame o 0 si no se pudo reconstruir
%
% es3D: para error 3D vale 1 para error 2D 0.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function error = errorMSD(M,markers,gTruth,deltas,es3D)
D = 0;
sumDeltas = 0;
for i=1:M
    if es3D == 0
        e = meanSquaredDistance2D(markers(i),gTruth(i));
    else
        if es3D == 1
            meanSquaredDistance3D(markers(i),gTruth(i));
        end
    end
    D = D + e*deltas(i);
    sumDeltas = sumDeltas + deltas(i);
    e = 0;
end
error = D/sumDeltas;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Performance promedio
% T: frames
% Tmarkers: arreglos de marcadores en todos los frames
% TgTruth: arreglo del ground Truth en todos los frames
% Tdeltas: arreglo de las deltas en todos los frames
% M cantidad total de marcadores
% es3D: para error 3D vale 1 para error 2D 0.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function u = averagePerf(T,M,Tmarkers,TgTruth,Tdeltas,es3D)
sumD = 0;
for i=1:T
    error = errorMSD(M,Tmarkers(i),TgTruth(i),Tdeltas(i),es3D);
    sumD = sumD + error;
    error = 0;
end
u = SumD/T;
    
