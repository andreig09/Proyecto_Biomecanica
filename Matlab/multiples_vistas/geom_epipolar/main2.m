%este script sirve para cargar los datos xml de la segmentacion en estructuras .mat dentro de la carpeta saved_vars
n_cams= 17
n_markers = 14
n_frames = 322
names = {'LeftFoot' 'LeftLeg' 'LeftUpLeg' 'RightFoot' 'RightLeg' 'RightUpLeg'...
    'RightShoulder' 'Head' 'LHand' 'LeftForeArm' 'LeftArm' 'RHand' 'RightForeArm' 'RightArm'}
archivo = 'saved_vars/cam'
name_bvh ='Mannaquin_con_Armadura_menos_pelotitas.bvh';

%cargo los archivos xml provenientes de la segmentacion asi como los datos de las camaras Blender
cam_segmentacion = markersXML2mat(n_cams, n_markers, n_frames, names, archivo)

%inicializo una estructura skeleton para completar a medida que se trabaje con los datos de cam_segmentacion
[~ , skeleton_segmentacion]=init_structs(n_markers, n_frames, names);
skeleton_segmentacion = set_info(skeleton_segmentacion, 'name_bvh', name_bvh); %setea string nombre de la estructura

%guardo la informacion
save('saved_vars/cam14_segmentacion', 'cam_segmentacion')
save('saved_vars/skeleton14_segmentacion', 'skeleton_segmentacion')

