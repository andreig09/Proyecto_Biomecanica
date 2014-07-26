%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% función que devuelve el valor absoluto de la 
% distancia 2D entre 2 puntos
% los puntos son arreglos donde el primer elemento
% es la coordenada x y el segundo la coordenada y
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function d = meanSquaredDistance2D(xi,xj)
x = xi(1) - xj(1);
y = xi(2) - xj(2);
d = x*x + y*y;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% función que devuelve el error en 2D en un frame con
% M marcadores comparando los puntos detectados con el
% ground truth
% Los marcadores tienen que estar emparejados con su 
% correspondiente en el ground truth
%
% deltas es un arreglo donde deltas(i) vale 1 si el marcador
% i se pudo reconstruir en ese frame o 0 si no se pudo reconstruir
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function error = error2Dmsd(M,markers,gTruth,deltas)
D = 0;
sumDeltas = 0;
for i=1:M
    e = meanSquareDistance(markers(i),gTruth(i));
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function u = averagePerf(T,M,Tmarkers,TgTruth,Tdeltas)
sumD = 0;
for i=1:T
    error = error2Dmsd(M,Tmarkers(i),TgTruth(i),Tdeltas(i));
    sumD = sumD + error;
    error = 0;
end
u = SumD/T;
    
