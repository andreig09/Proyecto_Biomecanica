if ~exist('cam_segmentacion', 'var')
    load saved_vars/cam13_segmentacion.mat
end
clc
cam_in =cam_segmentacion;
s=[];
frame=[];
marker = [];
n_cams = 2;
cam = cell(1, n_cams);
for i = 1:n_cams
    n_frames =cam_in(i).n_frames;
    n_paths = cam_in(i).n_paths;
    frame = cell(1, n_frames);
    for k = 1:n_frames %para cada frame
        frame_in = cam_in(i).frame(k);
        n_markers = frame_in.n_markers;
        marker = cell(1,n_markers);
        for j=1:n_markers %para cada marcador
            marker{j}.Attributes.id = j; %agrego el nro de marcador
            marker{j}.Attributes.name = frame_in.marker(j).name;
            marker{j}.Attributes.state = frame_in.marker(j).state;
            marker{j}.Attributes.x = frame_in.marker(j).coord(1);
            marker{j}.Attributes.y = frame_in.marker(j).coord(2);
        end
        %Atributos de frame
        frame{k}.Attributes.id = k;
        frame{k}.Attributes.time = frame_in.time;
        frame{k}.Attributes.n_markers =   frame_in.n_markers;
        %Elementos marker de frame
        frame{k}.marker = marker(:);%coloco todos los marcadores en el frame
    end
    
    path = cell(1,n_paths);
    for k=1:n_paths
        path_in = cam_in(i).path(k);
        path{k}.Attributes.id = k;
        path{k}.Attributes.name = path_in.name;
        path{k}.Attributes.state = path_in.state;
        path{k}.Attributes.n_markers = path_in.n_markers;
        path{k}.Attributes.init_frame = path_in.init_frame;
        path{k}.Attributes.end_frame = path_in.end_frame;
        path{k}.Attributes.members = path_in.members;
        
    end
    %Atributos de camara
    cam{i}.Attributes.id = i;
    cam{i}.Attributes.name = cam_in(i).name;
    cam{i}.Attributes.n_frames = cam_in(i).n_frames;
    cam{i}.Attributes.n_paths = cam_in(i).n_paths;
    cam{i}.Attributes.frame_rate = cam_in(i).frame_rate;
    cam{i}.Attributes.Rc = cam_in(i).info.Rc;
    cam{i}.Attributes.Tc = cam_in(i).info.Tc;
    cam{i}.Attributes.focal_dist = cam_in(i).info.f;
    cam{i}.Attributes.resolution = cam_in(i).info.resolution;
    cam{i}.Attributes.t_vista = cam_in(i).info.t_vista{:};
    cam{i}.Attributes.shift = cam_in(i).info.shift';
    cam{i}.Attributes.sensor = cam_in(i).info.sensor;
    cam{i}.Attributes.sensor_fit = cam_in(i).info.sensor_fit{:};
    cam{i}.Attributes.pixel_aspect =  cam_in(i).info.pixel_aspect;
    cam{i}.Attributes.projection_matrix = cam_in(i).info.projection_matrix;
    
    
    %Elementos frame de cam
    cam{i}.frame = frame(:);
    %Elementos path de cam
    cam{i}.path = path(:);
end
s.Lab.cam = cam(:);


file = 'prueba.xml';
%ida
struct2xml( s, file )
%vuelta
[ a ] = xml2struct( file );