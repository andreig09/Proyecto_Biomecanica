function aux_cam = dirty_cam(cam,p)

%% genera estructura cam con  puntos que faltan, 
% si p = 0.7 la estructura de salida tiene el 70% de los puntos de la
% estructura de entrada.

n_cams = length(cam);

for f = 1:cam(1).n_frames
for i = 1:n_cams
    aux_cam(i).name = cam(i).name;
    aux_cam(i).info = cam(i).info;

    
    m = 0;
    for j=1:cam(i).frame(f).n_markers;
        if rand < p
            
            m=m+1;
            aux_cam(i).frame(f).marker(m) = cam(i).frame(f).marker(j);
            aux_cam(i).frame(f).like = cam(i).frame(f).like;
            aux_cam(i).frame(f).time = cam(i).frame(f).time;
            
        end
        aux_cam(i).frame(f).n_markers = m;
        aux_cam(i).frame(f).n_marker = m;
    end
    
    
    aux_cam(i).path = cam(i).path;
    
    aux_cam(i).n_frames = cam(i).n_frames;
    aux_cam(i).n_paths = cam(i).n_paths;
    aux_cam(i).frame_rate = cam(i).frame_rate;

end
end