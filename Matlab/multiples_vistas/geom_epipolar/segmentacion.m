function list_XML = segmentacion(path_vid, type_vid, path_program, path_XML)
%Funcion que gestiona los procedimientos de segmentacion y obtencion de parametros de las camaras Blender
%Devuelve toda la informacion realtiva a las estructuras cam.mat

%% ENTRADA
%path_vid -->string ubicacion de los videos
%type_vid -->string extension de los videos. Ejemplo '*.dvd', siempre escribir “*.” y la extension
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
%Guardar el path que tiene por defecto matlab
MatlabPath = path; %POR AHORA NO LO USO
% Guardar ld_library_paths que tiene por defecto matlab
MatlabLibraryPath = getenv('LD_LIBRARY_PATH');
%Modificar ld_library_path para que Matlab use las librerias del sistema?
setenv('LD_LIBRARY_PATH',getenv('PATH'))

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
command1 = ['cd ', path_vid];%command1 permite ir a la carpeta path_vid
eval(command1)%ejecuto command1 
command3 = ['mv *.xml ', path_XML];%mueve los archivos XML de la carpeta path_vid a la carpeta path_XML

for k=1:n_cams %hacer con cada elemento en list_vid
    name_vid = list_vid{k};%nombre del video actual
    %command2 = sprintf('%s/%s %s/%s', path_program, name_program, path_vid, name_vid);%command2 permite segmentar el video name_vid %POR ALGUN
    %MOTIVO NO FUNCIONA CUANDO EL PARAMETRO A LA ENTRADA DE LA SEGMENTACION ES GRANDE
    command2 = sprintf('%s/%s %s', path_program, name_program, name_vid);%command2 permite segmentar el video name_vid
    str = sprintf('Comenzando el proceso de segmentacion del archivo %s', name_vid);         
    disp(str)
    [status2, cmdout2]=system(command2);%ejecutar command1 desde terminal
    %el .xml de salida de command2 se van generando en el directorio desde donde se ejecuta la funcion, actualmente la carpeta path_vid.
    %luego command3 se encarga de llevar los  .xml hasta path_XML
    
    %Se gestiona la salida segun command2 
    if status2~=0 %en este caso se obtuvo un error en command2
        restore(MatlabPath, MatlabLibraryPath, current_dir) %restablece las variables de entorno 'ld_library_path' y 'path'           
        disp(cmdout2)%devuelvo el mensaje de error de command2
        error('system:ComandoFallido','El comando ''%s'' ha devuelto una señal de error', command2)         
    else %command2 se ejecuto normalmente        
        [status3, cmdout3]=system(command3); %command3 se encarga de llevar los  .xml hasta path_XML
        %se gestiona la salida segun command3
        if status3~=0 %en este caso se obtuvo un error en command3
            restore(MatlabPath, MatlabLibraryPath, current_dir) %restablece las variables de entorno 'ld_library_path' y 'path'           
            disp(cmdout3)%devuelvo el mensaje de error de command3
            error('system:ComandoFallido','El comando ''%s'' ha devuelto una señal de error', command3)   
        else
            str = sprintf('La segmentacion del archivo %s ha finalizado satisfactoriamente.', name_vid);
            disp(str)     
        end
    end
end
%Obtener lista de salida con los nombres de los xml generados
list_XML = get_list_files(path_XML, '*.xml'); 
%Restablecer las variables de entorno 'ld_library_path', 'path' y el directorio de trabajo de matlab    
restore(MatlabPath, MatlabLibraryPath, current_dir);

end


function out=get_list_files(path,type)
%Funcion que genera una lista de un tipo especifico de archivos de un determinado directorio
%% ENTRADA:
% path= directorio de los archivos
% type=tipo de archivos, ejemplo *.doc % Siempre escribir “*.” y la extension
%% SALIDA: 
% out=cell array de strings con los nombres de los archivos en el orden que los devuelve el OS [nx1] 
%% EJEMPLOS
% d='/Seccion_segmentacion'; %busca en esta carpeta
% tipo = '*.dvd' %archivos con extension .dvd
% out=get_list_files(d,tipo)

%% CUERPO DE LA FUNCION

list_dir=dir(fullfile(path,type));
list_dir={list_dir.name}';
out=list_dir;
end

function restore(MatlabPath, MatlabLibraryPath, current_dir)
%Funcion que restablece las variables de entorno 'ld_library_path' y 'path'    

%% CUERPO DE LA FUNCION

% Restablezco el ld_library_paths original de matlab
setenv('LD_LIBRARY_PATH',MatlabLibraryPath);
%Restablezco el path original de matlab
path(MatlabPath); 
%Retorno al directorio de trabajo
eval(['cd ' current_dir])
end