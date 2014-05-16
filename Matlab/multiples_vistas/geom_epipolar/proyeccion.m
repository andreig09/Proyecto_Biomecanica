function Pcam= proyeccion(f, M, N, sensor, Tc, Rc)
% Construye las matrices de parámetros intrínsecos y extrínsecos a partir de
% los datos en Blender y devuelve tanto la matriz de proyección como la matriz fundamental.

%% ENTRADA
% f -->dist. focal en mm
% M -->resolución horizontal en píxeles
% N --> resolución vertical en píxeles
% sensor --> tamaño en mm del sensor (se considera el lado más largo, en este caso el horizontal)
% Tc -->  Tc=(Cx, Cy, Cz) vector de traslación que indica la posición del origen de la
    % cámara. Tc= C - O_world
%Rc --> matriz de rotacion  de la camara respecto al sistema del mundo. 

%% SALIDA
% Pcam --> matriz de proyeccion

%% Parámetros intrínsecos

%Se asumen dos cosas en los calculos que siguen:
%                   1) que la variable de Blender,  Properties/Object Data/Lens/Shift, indicado por los
%                       parametros (X, Y) es (0, 0)
%                   2) que la variable relacion de forma en Properties/Render/Dimensions/Aspect Radio, indicado por 
%                       los parametros (X, Y) es (1, 1)
Ox = M/2;   % coordenada en x (pìxeles) del punto principal
Oy = N/2;   % coordenada en y (pìxeles) del punto principal
Sx = sensor/M;  % tamaño en mm de un píxel en la dirección horizontal
Sy = Sx;        % tamaño en mm de un píxel en la dirección vertical (en este caso como los píxeles son cuadrados Sy = Sx)

 
%% Matriz de parámetros intrínsecos

M_int = [ -f/Sx     0        Ox 
             0     -f/Sy      Oy 
             0       0        1  ];

%% Parametros extrínsecos

M_ext = [Rc , - Rc*Tc'];

%% Matriz de proyección

Pcam=M_int * M_ext; 

end




         