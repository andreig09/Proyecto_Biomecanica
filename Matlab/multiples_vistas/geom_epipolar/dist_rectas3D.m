
function [i,j] = dist_rectas3D (C,u)

% dado un vector de rectas donde C son puntos que le pertenecen y u sus vectores
% directores definidos en columnas, devulve los 2 indices (i,j) de estos
% vectores del par de rectas que tiene menor distancia entre ellas.

num_rectas = size(C,2);
matriz_distancias = zeros(num_rectas);
for i = 1:num_rectas
    for j = 1:num_rectas
        
        if i ~= j
            dist = dist_2rectas(C(:,i),u(:,i),C(:,j),u(:,j));
            matriz_distancias(i,j) = dist;
            
        end
    end
    
end

[Y,J] = min(matriz_distancias,[],1);
[~,i] = min(Y);

j = J(I);



function dist = dist_2rectas(C1, u1, C2, u2)

% dadas 2 rectas con sus respectivos puntos y vectores directores (C1 y u1,
% para la recta 1 y C2, u2 para la recta 2) devulve la distancia que hay
% entre ellas.


s = cross (u1,u2);

dist = abs( dot(s,  (C2 - C1))) / norm(s);

end

end