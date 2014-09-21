function list_XML = segmentacion(path_vid, type_vid, path_program, path_XML)
%Funcion que gestiona los procedimientos de segmentacion y obtencion de parametros de las camaras Blender
%Devuelve toda la informacion realtiva a las estructuras cam.mat

%% ENTRADA
%path_vid -->string ubicacion de los videos
%type_vid -->string extension de los videos. Ejemplo '*.dvd', siempre escribir '*.' y la extension.
%           Se asume que los nombres de los videos se diferencian
%           unicamente en un numero antes de la extension.
%path_program -->string ubicacion del programa que efectua la segmentacion
%path_XML -->string ubicacion de los xml de salida

%% SALIDA
%list_XML -->cell array de strings con los nombres de los xml generados en la carpeta path_XML
            

%% EJEMPLO%  
%  path_vid =[pwd '/Seccion_segmentacion/Videos']; %ubicacion de los videos
%  type_vid = '*.dvd';%extension de los videos
%  path_program = [pwd '/Seccion_segmentacion/ProgramC']; %path donde se encuentran los ejecutables 'Source_*' que efectuan la segmentacion
%  path_XML = [pwd '/Seccion_segmentacion/XML']; %ubicacion de los XML
%  list_XML=segmentacion(path_vid, type_vid, path_program, path_XML)

%% ---------
% Author: M.R.
% created the 01/09/2014.

%% CUERPO DE LA FUNCION
% %Guardar el path que tiene por defecto matlab
MatlabPath = path; %POR AHORA NO LO USO
% Guardar ld_library_paths que tiene por defecto matlab
MatlabLibraryPath = getenv('LD_LIBRARY_PATH');
%Modificar ld_library_path para que Matlab use las librerias del sistema?
setenv('LD_LIBRARY_PATH','')

%Generar string con el sistema operativo donde se esta ejecutando el matlab 
os = computer; 
%Generar el nombre del ejecutable que efectua la segmentacion.
name_program = ['Source_' os];
%Generar una lista con los nombres de los videos en path_vid
list_vid = get_list_files(path_vid, type_vid);
n_cams = length(list_vid);

%Por algun motivo no puedo correr el programa de segmentacion desde la carpeta path_XML, aparentemente por lo largo de los parametros que
%introduzco para llegar hasta los videos de entrada. 
%La solucion que encontre es VUELTERA pero funciona, moverme a la carpeta de los videos path_vid, efectuo la segmentacion (ahora los parametros de entrada al programa de segmentacion 
%consisten solo en el nombre del video), y luego muevo los archivos XML generados en path_vid a su carpeta correspondiente path_XML.
current_dir = pwd; %guardo el directorio actual
cd(path_vid);%permite ir a la carpeta path_vid

parfor k=1:n_cams %hacer con cada elemento en list_vid
    name_vid = list_vid{k};%nombre del video actual    
    %command2 = sprintf('%s/%s %s/%s', path_program, name_program, path_vid, name_vid);%command2 permite segmentar el video name_vid %POR ALGUN
    %MOTIVO NO FUNCIONA CUANDO EL PARAMETRO A LA ENTRADA DE LA SEGMENTACION ES GRANDE    
    command = sprintf('%s/%s %s', path_program, name_program, name_vid);%command permite segmentar el video name_vid
    [status, cmdout]=execute_command(command); %ejecutar command desde terminal    
    %el .xml de salida de command se van generando en el directorio desde donde se ejecuta la funcion, actualmente la carpeta path_vid.
    %luego con movefile se gestiona el llevar los  .xml hasta path_XML
    
    %Se gestiona la salida segun command 
    if status~=0 %en este caso se obtuvo un error en command 
        restore(MatlabPath, MatlabLibraryPath, current_dir) %restablece las variables de entorno 'ld_library_path' y 'path'           
        disp(cmdout)%devuelvo el mensaje de error de command
        error('system:ComandoFallido','El comando ''%s'' ha devuelto una señal de error', command)         
    else %command se ejecuto normalmente    
%         name = name_vid(1:(length(name_vid)-4));%name_vid pero sin la extension de video
%         [status_mov, message, messageid]=movefile([name, '.xml'], path_XML); %gestiona el llevar los  .xml hasta path_XML
%         %se gestiona la salida segun status_mov
%         if status_mov==0 %en este caso se obtuvo un error al mover  *.xml (OBSERVAR QUE MATLAB DEVUELVE 0 EN CASO DE ERROR)
%             restore(MatlabPath, MatlabLibraryPath, current_dir) %restablece las variables de entorno 'ld_library_path' y 'path'           
%             %devuelvo el mensaje de error 
%             disp(message)
%             disp(messageid)
%             error('system:ComandoFallido','El comando para mover *.xml a su carpeta correspondiente ha devuelto una señal de error')   
%         else 
            str = ['La segmentacion del archivo ', name_vid, ' ha finalizado satisfactoriamente.'];
            disp(str)     
%         end
    end
end

%Llevar los .xml hasta path_XML
[status_mov, message, messageid]=movefile('*.xml', path_XML); %gestiona el llevar los  .xml hasta path_XML
%se gestiona la salida segun status_mov
if status_mov==0 %en este caso se obtuvo un error al mover  *.xml (OBSERVAR QUE MATLAB DEVUELVE CERO EN CASO DE ERROR)
    restore(MatlabPath, MatlabLibraryPath, current_dir) %restablece las variables de entorno 'ld_library_path' y 'path'           
    %devuelvo el mensaje de error 
    disp(message)
    disp(messageid)
    error('system:ComandoFallido','El comando para mover *.xml a su carpeta correspondiente ha devuelto una señal de error')      
end
%Obtener lista de salida con los nombres de los xml generados
list_XML = get_list_files(path_XML, '*.xml'); 
%Ordenar la lista de nombres
list_XML = sort_list(list_XML);
%Restablecer las variables de entorno 'ld_library_path', 'path' y el directorio de trabajo de matlab    
restore(MatlabPath, MatlabLibraryPath, current_dir);

end


function [status, cmdout]=execute_command(command)
%Funcion que permite ejecutar commandos del sistema operativo
[status, cmdout]=system(command);%ejecutar command desde terminal
end


function out=get_list_files(path,type)
%Funcion que genera una lista de un tipo especifico de archivos de un determinado directorio
%% ENTRADA:
% path= directorio de los archivos
% type=tipo de archivos, ejemplo *.doc % Siempre escribir “*.�? y la extension
%% SALIDA: 
% out=cell array de strings con los nombres de los archivos en el orden que los devuelve el OS [nx1] 
%% EJEMPLOS
% d='/Seccion_segmentacion'; %busca en esta carpeta
% tipo = '*.dvd' %archivos con extension .dvd
% out=get_list_files(d,tipo)

%% CUERPO DE LA FUNCION

list_dir=dir(fullfile(path,type));
list_dir={list_dir.name}';
%devuelvo la salida
out=list_dir;
end

function list_XML = sort_list(list_XML)
%Funcion que ordena los nombres de list_XML..
%Se supone que los nombres difieren solo en un numero al final
%La idea es pasar en cada nombre su numero a un vector y luego ordenarlo.
%Devolviendo la lista con los nombres ordenados de menor a mayor.

index1 = strfind(list_XML{1}, '1.'); %index-1 indica donde termina el nombre y empiezan los numeros
n_files = length(list_XML); % cantidad de archivos con extensi�n xml
num_in_name = zeros(1, n_files);
for k=1:n_files %la idea es pasar cada numero de un nombre a un vector y luego ordenarlo
    index2 = strfind(list_XML{k}, '.') -1; %indice que indica hasta donde van los numeros finales
    num_in_name(k)=str2double(list_XML{k}(index1:index2)); %guardo el numero de archivo
end
[~, sort_index] = sort(num_in_name);
list_XML = list_XML(sort_index);
end

function restore(MatlabPath, MatlabLibraryPath, current_dir)
%Funcion que restablece las variables de entorno 'ld_library_path' y 'path'    

%% CUERPO DE LA FUNCION

% Restablezco el ld_library_paths original de matlab
setenv('LD_LIBRARY_PATH',MatlabLibraryPath);
%Restablezco el path original de matlab
path(MatlabPath); 
%Retorno al directorio de trabajo
%eval(['cd ' current_dir])
cd(current_dir)
end