function restore_path()
%load MatlabPath.mat
rmpath([pwd, '/Graficas'], [pwd, '/GUI'], [pwd, '/InfoCamaras'], [pwd, '/Manejo_Estructura'],...
    [pwd, '/Reconstruccion'], [pwd, '/Segmentacion'], [pwd, '/Tracking'], [pwd, '/Utiles'], [pwd, '/ProgramaC'], [pwd, '/Testeo']  );
%path(MatlabPath);
%delete MatlabPath.mat
end