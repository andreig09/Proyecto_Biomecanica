function add_paths()
%Funcion que permite agregar en el path la direccion de todas las carpetas del sistema
dir_actual = pwd;
%MatlabPath = path;
%save('MatlabPath.mat', 'MatlabPath');
addpath([pwd, '/Graficas'], [pwd, '/GUI'], [pwd, '/InfoCamaras'], [pwd, '/Manejo_Estructura'],...
    [pwd, '/Reconstruccion'], [pwd, '/Segmentacion'], [pwd, '/Tracking'], [pwd, '/Utiles'], [pwd, '/ProgramaC']   );
end