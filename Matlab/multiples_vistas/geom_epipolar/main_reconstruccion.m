function skeleton = main_reconstruccion(cam_segmentacion, n_markers, names, reconsThr_on, reconsThr, init_frame, end_frame, path_XML, save_reconstruction_mat, path_mat)


n_frames = get_info(cam_segmentacion(1), 'n_frames');%obtengo el numero de frames de la primera camara, todas las camaras deberian tener igual nro de frame
%inicializo una estructura skeleton
[~ , skeleton]=init_structs(n_markers, n_frames, names);
skeleton=set_info(skeleton, 'name', 'skeleton');

skeleton = reconstruccion(cam_segmentacion, skeleton, reconsThr, init_frame, end_frame);

if save_reconstruction_mat
    save([path_mat '/skeleton'], 'skeleton')
    str = ['Se a guardado el resultado de la reconstruccion del esqueleto a partir de las camaras en ', path_mat, '/skeleton.mat'];
    disp(str)
end
end