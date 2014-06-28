% Dada una nube de puntos N correspondiente a un frame, devuelve un vector
% de indices de los puntos de N de aquellos que se encuentran a una distancia
% menor a d respecto al punto p.

% N(j,1), posición x del marcador j
% N(j,2), posición y del marcador j
% N(j,3), posición z del marcador j (si son puntos 3D)
% p(1), posición x del punto p
% p(2), posicion y del punto p
% p(3), posicion z del punto p (si son puntos 3D)

function I = vecinos_intraframe(N, p, d)

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
