function skeleton = main_reconstruccion(cam_segmentacion, n_markers, names, reconsThr_on, reconsThr, init_frame, end_frame, path_XML, save_reconstruction_mat, path_mat)


n_frames = get_info(cam_segmentacion(1), 'n_frames');%obtengo el numero de frames de la primera camara, todas las camaras deberian tener igual nro de frame
frame_rate = get_info(cam_segmentacion(1), 'frame_rate');%obtengo el frame rate de la camara 1. %estoy asumiendo que todos los frame rate son iguales
n_cams = length(cam_segmentacion);
%inicializo una estructura skeleton
Lab=init_structs(n_markers, n_frames, frame_rate, n_cams, 'skeleton'); %solo genero una estructura skeleton
skeleton = Lab.skeleton;
skeleton=set_info(skeleton, 'name', 'skeleton_reconstruccion');
skeleton=set_info(skeleton, 'n_frames', n_frames);%ingreso la cantidad de frames que se van a tener

skeleton = reconstruccion(cam_segmentacion, skeleton, reconsThr, init_frame, end_frame);

if save_reconstruction_mat
    save([path_mat '/skeleton'], 'skeleton')
    str = ['Se a guardado el resultado de la reconstruccion del esqueleto a partir de las camaras en ', path_mat, '/skeleton.mat'];
    disp(str)
end
end


