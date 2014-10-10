function structure = fill_paths(structure, frame)
%Funcion que permite rellenar la informacion de la estructura path dentro de la estructura structure para un cierto frame
%Lo primero que se debe hacer es definir en el primer frame correctamente los nombres de cada trayectoria (path), 
%pues esta funcion busca los marcadores en cada frame cuyo nombre coincida con el nombre de alguna trayectoria y actualiza la estructura en consecuencia.
%Tambien se asume que se corrio previamente clear_paths(structure, frame), para dejar en blanco las trayectorias de structure en el frame 'frame'

%% ENTRADA
%structure -->estructura skeleton o cam(i)
%frame -->escalar que indica el frame donde se actualiza el path
%% SALIDA
%structure -->structure de entrada paro con la sub-estructura path actualizada
%% EJEMPLOS


%% ---------
% Author: M.R.
% created the 26/08/2014.

%% CUERPO DE LA FUNCION

name = get_info(structure, 'frame', frame, 'marker', 'name'); %devuelve un cell string con los nombres de todos los marcadores en 'frame' de structure

%Obtengo los numeros de path asociados a los marcadores con nombre en 'name'
num_path = find_path_by_name(structure, name);%num_path(i) indica el numero de trayectoria con el nombre name(i), en el caso que no exista un trayectoria para name(j), num_path(j)=-1  
condition = num_path ~=-1; %busco los elementos de name_path distintos de -1
num_path = num_path(condition); %me quedo solo con los elementos que cumplen la condicion anterior, o sea aquellos paths que tengo actualizar
index = find(condition); %index(i) es el indice del marcador a poner en el path de nombre name_path(i)


for k = 1:length(num_path) %hacer para cada valor de num_path
    structure = set_info(structure, 'path', num_path(k), 'members', frame, index_(k));% setea la trayectoria en el frame adecuado    
    %se asume que se esta agregando el ultimo elemento de la trayectoria
    structure = set_info(structure, 'path', num_path(k), 'n_markers', frame); % setea el numero de marcadores totales en la trayectoria 
    structure = set_info(structure, 'path', num_path(k), 'end_frame', frame); %setea  el frame final de la trayectoria
end
 


end


 



