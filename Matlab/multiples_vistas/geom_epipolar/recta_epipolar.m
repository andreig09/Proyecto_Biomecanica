function ld = recta_epipolar(Pi, Pd, xi)
%Funcion que devuelve las rectas epipolares en camara derecha asociados a 
%los puntos xi de camara izquierda

%% Entrada
%Pi = varargin{1};%matriz de proyección de camara "izquierda" o de origen
%Pd = varargin{2};%matriz de proyección de camara "derecha" o de destino 
%xi = varargin{3};%vector con marcadores de cam_i a proyectar sobre cam_d 
%% Salida
% ld   ---->vector cuyas columnas son rectas epipolares en camara 
%           derecha correspondientes a los puntos xi de camara izquierda
            
%% EJEMPLOS
%       cam_i = cam(1);
%       cam_d = cam(2);
%       n_frame = 100;
%       index_xi = [2, 10];
%       xi = get_info(cam_i, 'frame', n_frame, 'marker', index_xi, 'coord');% tomo el punto xi de la camara cam_i a proyectar
%       Pi = get_info(cam_i, 'projection_matrix');
%       Pd = get_info(cam_d, 'projection_matrix');
%       ld = recta_epipolar(Pi, Pd, xi)
%% ---------
% Author: M.R.
% created the 28/07/2014.

if (nargin~=3)
    str = ['Se tiene un numero de argumentos invalido. '];
        error('nargin:ValorInvalido',str)
end
    
    %encuentro matriz fundamental
    F= F_from_P(Pi, Pd); 
    
    %efectuo las proyecciones
    ld = F*xi; %recta en cam_d correspondiente al punto xi de cam_i
    ld = homog_norm(ld);%normalizo vector de la recta
end