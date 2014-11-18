function plot_skeleton_rec(skeleton_rec)
%Funcion que permite efectuar mostrar skeleton_rec

init_frame = get_info(skeleton_rec, 'init_frame');
end_frame =  get_info(skeleton_rec, 'end_frame');

for frame=init_frame:end_frame %graficar todos los frames
    plot_one_frame(skeleton_rec, frame);
    pause
end
end