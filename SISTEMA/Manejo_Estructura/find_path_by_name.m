function num_path = find_path_by_name(structure, name)
%Funcion que dado un cell array de string devuelve un vector con las correspondientes trayectorias de structure que tienen dicho nombre
%% ENTRADA
%structure -->estructura skeleton o cam(i)
%name  -->cell array de strings con los nombres de las trayecetorias a buscar
%% SALIDA
%num_path -->vector, num_path(i) indica el numero de trayectoria con el nombre name(i), en el caso que no exista un trayectoria para name(j), num_path(j)=-1

%% ---------
% Author: M.R.
% created the 24/08/2014.

%% CUERPO DE LA FUNCION

n_paths = get_info(structure, 'n_paths'); %numero de paths de la estructura
num_path = zeros(1, length(name)); %num_path(i) indica el nro de path con el nombre name(i), en caso de que no exista un path para un cierto 'name' la idea es que tome el valor -1
for k=1:n_paths %recorrer todos los paths de structure
    name_path = get_info(structure, 'path', k, 'name'); % devuelve el nombre asociado a la trayectoria k de structure
    aux = strcmp(name_path, name); %aux(i)=1 indica que el string 'name_path' cohincide con el string de name(i), cero en caso contrario
    num_path = k*aux + num_path; %actualizo num_path        
end
num_path(num_path==0)=-1; %cambio donde no se encontro nada por -1
end