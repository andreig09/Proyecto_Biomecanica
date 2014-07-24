%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% función que devuelve el valor absoluto de la 
% distancia 2D entre 2 puntos
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function d = meanSquaredDistance2D(xi,xj)
x = xi.x - xj.x;
y = xi.y - xj.y;
d = x*x + y*y;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% función que devuelve el error en 2D en un frame con
% M marcadores comparando los puntos detectados con el
% ground truth
% Los marcadores tienen que estar emparejados con su 
% correspondiente en el ground truth
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function error = error2Dmsd(M,markers,gTruth)
D = 0;
e = 0;
for i=1:M
    e = meanSquareDistance(markers(i),gTruth(i));
    D = D + e;
    e = 0;
end
error = D/M;