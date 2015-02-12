function skeleton_rec = main_reconstruccion(cam_segmentacion, n_markers, names, reconsThr_on, reconsThr, init_frame, end_frame, vec_cams, path_XML, save_reconstruction_mat, path_mat)

if vec_cams(1)~=-1%solo reconstruyo con las camaras indicadas en vec_cams
    cam_segmentacion = cam_segmentacion(vec_cams);
end

%arreglar el numero de la camara a la cual preguntar
n_frames = get_info(cam_segmentacion(1), 'n_frames');%obtengo el numero de frames de la primera camara, todas las camaras deberian tener igual nro de frame
frame_rate = get_info(cam_segmentacion(1), 'frame_rate');%obtengo el frame rate de la camara 1. %estoy asumiendo que todos los frame rate son iguales
n_cams = length(cam_segmentacion);
%inicializo una estructura skeleton
Lab=init_structs(n_markers, n_frames, frame_rate, n_cams, 'skeleton'); %solo genero una estructura skeleton
skeleton_rec = Lab.skeleton;
skeleton_rec=set_info(skeleton_rec, 'name', 'skeleton_rec');
skeleton_rec=set_info(skeleton_rec, 'n_frames', n_frames);%ingreso la cantidad de frames que se van a tener

    

skeleton_rec = reconstruccion(cam_segmentacion, skeleton_rec, reconsThr, init_frame, end_frame, n_markers);
disp('La reconstruccion a finalizado correctamente.')
disp(' ')


%Se actualiza path_XML y path_mat para que se guarde en la carpeta
%old_path_XML/Reconstruccion y old_path_mat/Reconstruccion
%Verifico que exista el nuevo path y en caso negativo lo creo
if ~isdir([path_XML, '/Reconstruccion'])
    mkdir(path_XML, '/Reconstruccion')
elseif ~isdir([path_mat, '/Reconstruccion'])
    mkdir(path_mat, '/Reconstruccion')
end
path_XML = [path_XML '/Reconstruccion'];
path_mat = [path_mat '/Reconstruccion'];

if save_reconstruction_mat
    save([path_mat '/skeleton'], 'skeleton_rec')
    str = ['Se a guardado el resultado de la reconstruccion del esqueleto a partir de las camaras en ', path_mat, '/skeleton.mat'];
    disp(str)
end
end


