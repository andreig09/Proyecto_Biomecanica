function Pcam= MatrixProjection(f, resolution, sensor, sensor_fit, Tc, Rc)
% Construye las matrices de parametros intrinsecos y extrinsecos a partir de
% los datos en Blender, devuelve  la matriz de proyeccion. 

%% ENTRADA
% f -->dist. focal en mm
% resolution -->vector cuyas componentes indican la resolucion horizontal y vertical en pixeles de cada camara
% sensor -->vector cuyas componentes indican el tamaño horizontal y vertical  del sensor en mm.
%sensor_fit --> tipo de ajuste que efectúa Blender en la camara
                %'AUTO' indica que el tamaño de pixel depende del tamaño horizontal del sensor y la resolución horizontal de la imagen 
                %'HORIZONTAL' indica que el tamaño de pixel depende del tamaño horizontal del sensor y la resolución horizontal de la imagen 
                %'VERTICAL' indica que el tamaño de pixel depende del tamaño vertical del sensor y la resolución vertical de la imagen 
% Tc -->  Tc=(Cx; Cy; Cz) vector de traslacion que indica la posicion del origen de la
    % camara. Tc= C - O_world
%Rc --> matriz de rotacion  de la camara respecto al sistema del mundo. 

%% SALIDA
% Pcam --> matriz de proyeccion

%% Parametros intrinsecos

%Se asumen dos cosas en los calculos que siguen:
%                   1) que la variable de Blender,  Properties/Object Data/Lens/Shift, indicado por los
%                       parametros (X, Y) es (0, 0)
%                   2) que la variable relacion de forma en Properties/Render/Dimensions/Aspect Radio, indicado por 
%                       los parametros (X, Y) es (1, 1) con lo cual los
%                       pixeles son cuadrados
Ox = resolution(1)/2;   % coordenada en x (pixeles) del punto principal
Oy = resolution(2)/2;   % coordenada en y (pixeles) del punto principal

switch sensor_fit
   case 'VERTICAL'
      Sy = sensor(2)/resolution(2);  % tamaño en mm de un pixel en la direccion horizontal
      Sx = Sy;        % tamaño en mm de un pixel en la direccion vertical (en este caso como los píxeles son cuadrados Sy = Sx)
    otherwise %resulta que estamos en el caso AUTO o HORIZONTAL
      Sx = sensor(1)/resolution(1);  % tamaño en mm de un pixel en la direccion horizontal
      Sy = Sx;        % tamaño en mm de un pixel en la direccion vertical (en este caso como los píxeles son cuadrados Sy = Sx)
end

 
%% Matriz de parámetros intrínsecos

M_int = [ -f/Sx     0        Ox 
             0     -f/Sy      Oy 
             0       0        1  ];

%% Parametros extrínsecos

M_ext = [Rc , - Rc*Tc]; %se genera una matriz que permite hacer Pc = Rc*(Pworld-Tc) como Pc = M_ext*Pworld

%% Matriz de proyección

Pcam=M_int * M_ext; 

end




         