function structure = clear_paths(structure, frame)
%Funcion que permite remover las trayectorias de un cierto frame
%% ENTRADA
%structure -->estructura cam(i) o skeleton
%frame --> frame donde se desea remover todas las trayectorias

%% SALIDA
%structure --> estructura structure actualizada

%% ---------
% Author: M.R.
% created the 26/08/2014.

%% CUERPO DE LA FUNCION
num_path = get_info(structure, 'n_paths'); %numero de paths de la estructura
for k = 1:length(num_path) %hacer para cada valor de num_path    
    structure = set_info(structure, 'path', k, 'members', frame, -1);% setea la trayectoria en el frame adecuado    
    %se asume que se esta borrando el ultimo elemento de la trayectoria
    structure = set_info(structure, 'path', k, 'n_markers', (frame -1)); % setea el numero de marcadores totales en la trayectoria 
    structure = set_info(structure, 'path', k, 'end_frame', (frame-1)); %setea  el frame final de la trayectoria
end

end
