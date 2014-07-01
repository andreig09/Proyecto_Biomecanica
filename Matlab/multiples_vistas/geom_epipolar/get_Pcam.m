function Pcam = get_Pcam(cam)
% Función que devuelve la matriz de proyeccion asociada a una camara

%% Entrada
%cam --> estructura de una camara 

%% Salida
%Pcam --> matriz de proyeccion asociada a la camara cam

%% Ejemplo
%Pcam = get_Pcam(cam(1)) %Retorna la matriz de proyeccion de la camara 1

Pcam = cam.info.Pcam;
end