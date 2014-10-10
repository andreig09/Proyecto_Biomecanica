%F = F_from_P(P)  Compute fundamental matrix from two camera matrices.
%   C1 es el centro de la camara con matriz de proyeccion P1, es vector columna. 
%   P is cell (2), P = {P1 P2}. F has size (3,3). It is x2'*F*x1 = 0
%
%   Overall scale of F is unique and such that, for any X, P1, P2, it is
%   F*x1 = vgg_contreps(e2)*x2, where
%   x1 = P1*X, x2 = P2*X, e2 = P2*C1, C1 = vgg_wedge(P1).

function F = F_from_P(P, P2)

if nargin == 1 %si nro de argumentos igual a dos significa que pusieron P como cell
  P1 = P{1};
  P2 = P{2};
else
  P1 = P;
end

if ~all(size(P1) == [3 4]) | ~all(size(P2) == [3 4]) 
    error('Las matrices de las camaras deben ser 3x4');
  end

C1 = null(P1);  % Camera centre 1 is the null space of P1

e2=P2*C1; %C1 se mapea en el epipolo del plano 2
e2_x=[0      -e2(3)   e2(2)
      e2(3)   0        -e2(1)
      -e2(2)  e2(1)     0    ];
P1_plus = pinv(P1); %inversa generalizada de P1 la cual es igual a la inversa de Moore-Penrose
F = (e2_x)*(P2*P1_plus); 
end
