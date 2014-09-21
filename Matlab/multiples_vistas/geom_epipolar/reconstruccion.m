function skeleton = reconstruccion(cam, skeleton, umbral, init_frame, end_frame)
%Funcion que efectua la reconstruccion.
%% ENTRADA
%cam -->estructura cam
%skeleton -->estructura skeleton
%umbral -->radio de la esfera dentro de la cual se tienen puntos validos en la reconstruccion

%% SALIDA

%skeleton -->estructura skeleton actualizada

%% CUERPO DE LA FUNCION

n_cams = length(cam);
n_markers = get_info(skeleton, 'frame', 1, 'n_markers');

disp('__________________________________________________')
disp('Se inicia el proceso de Reconstruccion')

vec_cams = 1:n_cams;
Xrec = cell(1, 300);

%obtengo datos que no dependen del frame con el que se este trabajando
P = cell(1, n_cams);
invP = cell(1, n_cams);
C = cell(1, n_cams);

for i=vec_cams    
    P{i} = get_info(cam(i), 'projection_matrix'); %matrix de proyeccion de la camara 
    invP{i}=pinv(P{i});%inversa generalizada de P 
    C{i} = homog2euclid(null(P{i})); %punto centro de la camara, o vector director perpendicular a la retina    
end

global contador
contador =0;
log_operation('reset'); %funcion que permite generar un contador de ciclos dentro del ciclo parfor
parfor frame=init_frame:end_frame %hacer para cada frame (Se efectua en paralelo)
%for frame=init_frame:end_frame %hacer para cada frame (Se efectua en paralelo)
    %efectuo la reconstruccion de un frame     
    Xrec{frame} = reconstruccion1frame_fast(cam, vec_cams, P,  invP, C, frame, umbral, n_markers);
    %genero aviso     
    num = log_operation(end_frame); %incremento contador que lleva numeros del ciclos
    str=sprintf('Se ha reconstruido el frame %d, actualmente se han reconstruideo %d de %d ', frame, num, (end_frame-init_frame+1));
    %str=sprintf('Se ha reconstruido el frame %d', frame);
    disp(str)      
end

%for  frame=1:n_frames %hacer para cada frame (Se efectua secuencialmente)     
for  frame=init_frame:end_frame %hacer para cada frame (Se efectua secuencialmente)     
    n_Xrec= size(Xrec{frame}, 2); %numero de marcadores reconstruidos en el frame 'frame'
    n_markers = get_info(skeleton, 'frame', frame, 'n_markers'); % devuelve el numero de marcadores del frame 'frame' de la estructura structure
    Xrec{frame} = [Xrec{frame}, zeros(3, (n_markers - n_Xrec) )];%Si faltan marcadores para rellenar la estructura los lleno con ceros    
    skeleton = set_info(skeleton, 'frame', frame, 'marker', 'coord', Xrec{frame}); %ingreso los marcadores en el frame correspondiente de estructura_salida
    skeleton = set_info(skeleton, 'frame', frame, 'n_markers', n_Xrec);% actualizo el numero de frame correspondiente
end

