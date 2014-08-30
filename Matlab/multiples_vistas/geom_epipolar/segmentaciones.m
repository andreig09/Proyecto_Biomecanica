%comando 'computer' para saber el tipo de sistema operativo
%comando 'system' para coorer codigo externo a matlab

name_vid = 'cam'; %nombre comun a todos los videos
ext_vid = 'dvd';%extension de los videos
n_frames = 321;
n_cams = 17;



%Agrego informacion al path de Matlab, utilizo las funciones pertinentes y luego devuelvo el path original
p = path; %guardo el path original para restablecerlo una vez terminado el programa
path(p,'Seccion_segmentacion') %agrego al path el lugar donde se encuentra el ejecutable para efectuar las segmentaciones

os = computer; %devuelve un string con el sistema operativo donde se esta ejecutando el matlab 
name_program = ['Source_' os];%genero el nombre del ejecutable que efectua la segmentacion.

for k=1:n_cams %hacer para cada camara
    command = sprintf('./%s %s%d-0%d.%s', name_program, name_vid, k, n_frames, ext_vid);%genero el comando a ejecutar
    [status, cmdout]=system(command);
    if status~=0 %gestiono los posibles errores
        path(p) %Dejo el path de Matlab original antes de correr codigo        
        error('system:ComandoFallido','El comando ''%s'' a devuelto una señal de error', command)        
    else
        str = sprintf('El comando %s a finalizado satisfactoriamente', command);
        disp(str)
    end
end

path(p) %Dejo el path de Matlab original antes de correr codigo