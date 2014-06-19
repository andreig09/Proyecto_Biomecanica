function Pcam= MatrixProyection(f, M, N, sensor, Tc, Rc)
% Construye las matrices de parametros intrinsecos y extrinsecos a partir de
% los datos en Blender y devuelve tanto la matriz de proyeccion. 

%% ENTRADA
% f -->dist. focal en mm
% M -->resolucion horizontal en pixeles
% N --> resolucion vertical en pixeles
% sensor --> tamaño en mm del sensor (se considera el lado más largo, en este caso el horizontal)
% Tc -->  Tc=(Cx, Cy, Cz) vector de traslacion que indica la posicion del origen de la
    % camara. Tc= C - O_world
%Rc --> matriz de rotacion  de la camara respecto al sistema del mundo. 

%% SALIDA
% Pcam --> matriz de proyeccion

%% Parametros intrinsecos

%Se asumen dos cosas en los calculos que siguen:
%                   1) que la variable de Blender,  Properties/Object Data/Lens/Shift, indicado por los
%                       parametros (X, Y) es (0, 0)
%                   2) que la variable relacion de forma en Properties/Render/Dimensions/Aspect Radio, indicado por 
%                       los parametros (X, Y) es (1, 1)
% Ox = M/2+0.5;   % coordenada en x (pixeles) del punto principal
% Oy = N/2+0.5;   % coordenada en y (pixeles) del punto principal
Ox = M/2;   % coordenada en x (pixeles) del punto principal
Oy = N/2;   % coordenada en y (pixeles) del punto principal

Sx = sensor/M;  % tamaño en mm de un pixel en la direccion horizontal
Sy = Sx;        % tamaño en mm de un pixel en la direccion vertical (en este caso como los píxeles son cuadrados Sy = Sx)

 
%% Matriz de parámetros intrínsecos

M_int = [ -f/Sx     0        Ox 
             0     -f/Sy      Oy 
             0       0        1  ];

%% Parametros extrínsecos

M_ext = [Rc , - Rc*Tc']; %se genera una matriz que permite hacer Pc = Rc*(Pworld-Tc) como Pc = M_ext*Pworld

%% Matriz de proyección

Pcam=M_int * M_ext; 

end




         