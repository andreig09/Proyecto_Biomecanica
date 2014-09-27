% %SE CARGAN LAS ENTRADAS PARA PROBAR LA FUNCION
% if ~exist('cam_segmentacion', 'var')
%     load saved_vars/cam13_segmentacion.mat
% end
% clc
% structure=a.Lab.cam{1};
% %structure = skeleton;
% %DATOS DE LA CAMARA
% info1 = get_info(structure, 'Rc'); %devuelve la matriz Rc
% info2 = get_info(structure, 'Tc'); %devuelve vector de traslacion Tc
% info3 = get_info(structure, 'focal_dist'); %devuelve distancia focal en metros f
% info4 = get_info(structure, 'resolution'); %devuelve [resolución_x, resolution_y] unidades en pixeles
% info5 = get_info(structure, 't_vista'); %devuelve tipo de vista utilizada en la camara (PERSPECTIVA, ORTOGRAFICA, PANORAMICA)
% info6 = get_info(structure, 'shift'); %devuelve [shift_x, shidt_y] corrimiento del centro de la camara en pixeles
% info7 = get_info(structure, 'sensor'); %devuelve [sensor_x, sensor_y] largo y ancho del sensor en milimetros
% info8 = get_info(structure, 'sensor_fit'); %devuelve tipo de ajuste utilizado para el sensor (AUTO, HORIZONTAL, VERTICAL)
% info9 = get_info(structure, 'pixel_aspect'); %devuelve (pixel_aspect_x)/(pixel_aspect_y) valor 1 indica pixel cuadrado
% info10 = get_info(structure, 'projection_matrix'); %matrix de proyección de la camara
% %DATOS DE LA ESTRUCTURA
% info11 = get_info(structure, 'name'); %string nombre de la estructura
% %info12 = get_info(structure, 'name_bvh'); %nombre del archivo.bvh asociado al esqueleto structure (VALIDO SOLO SI STRUCTURE ES UN SKELETON)
% info13 = get_info(structure, 'n_frames'); %numero de frames de la estructura
% info14 = get_info(structure, 'n_paths'); %numero de paths de la estructura
% %info15 = get_info(structure, 'n_cams'); %numero de camaras de la estructura (VALIDO SOLO SI STRUCTURE ES UN SKELETON)
% info16 = get_info(structure, 'frame_rate'); %frame rate de los frames en la estructura
% %DATOS DE UN FRAME
% info17 = get_info(structure, 'frame', 1, 'marker', 'coord'); %devuelve las coordenadas de todos los marcadores en el frame 1 de structure
% info18 = get_info(structure, 'frame', 1, 'marker', 'name'); %devuelve un cell string con los nombres de todos los marcadores en el frame 1 de structure
% info19 = get_info(structure, 'frame', 1, 'marker', 'state'); %devuelve un vector con los estados de  todos los marcadores en el frame 1 de structure
% %info20 = get_info(structure, 'frame', 1, 'marker', 'source_cam'); %devuelve un vector con las camaras fuente de todos los marcadores
% %                                                                 en el frame 1 de structure (VALIDO SOLO SI STRUCTURE ES UN SKELETON)
% info21 = get_info(structure, 'frame', 1, 'marker', [2, 3], 'coord'); %devuelve las coordenadas de los marcadores 2 y 3 del frame 1 de structure
% info22 = get_info(structure, 'frame', 1, 'marker', [2, 3], 'name'); %devuelve un cell string con los nombres de los marcadores 2 y 3 del frame 1 de structure
% info23= get_info(structure, 'frame', 1, 'marker', [2, 3], 'state'); %devuelve un vector con los estados de los marcadores 2 y 3 del frame 1 de structure
% %info24 = get_info(structure, 'frame', 1, 'marker', [2, 3],  'source_cam'); %devuelve un vector con las camaras fuente de los marcadores
% %                                                                            2 y 3 del frame 1 de structure (VALIDO SOLO SI STRUCTURE ES UN SKELETON)
% info25 = get_info(structure, 'frame', 1, 'time'); % devuelve el tiempo asociado al frame 1 de la estructura structure
% info26 = get_info(structure, 'frame', 1, 'n_markers'); % devuelve el numero de marcadores del frame 1 de la estructura structure
% 
% %DATOS DE UN PATH
% info30 = get_info(structure, 'path', 1, 'name'); % devuelve el nombre asociado a la trayectoria 1 de structure
% info31 = get_info(structure, 'path', 1, 'members'); % devuelve una matriz 2xn_markers. la primer fila son los indices de los marcadores
% %                                                        miembros de la trayectoria 1 de la estructura structure y la fila 2 son
% %                                                        los correspondientes frames.
% info32 = get_info(structure, 'path', 1, 'state') ;% devuelve una medida de calidad para la trayectoria 1 de la estructura structure
% info33 = get_info(structure, 'path', 1, 'n_markers') ;% devuelve el numero de marcadores totales en la trayectoria 1 de structure
% info34 = get_info(structure, 'path', 1, 'init_frame'); %devuelve el frame inicial de la trayectoria 1 de structure
% info35 = get_info(structure, 'path', 1, 'end_frame'); %devuelve  el frame final de la trayectoria 1 de structure
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % %EJEMPLOS PARA USOS DE FUNCION
% % %DATOS DE LA CAMARA
% structure1 = set_info(structure, 'Rc', info1); %setea la matriz Rc
% structure2 = set_info(structure1, 'Tc', info2); %setea vector de traslacion Tc
% structure3 = set_info(structure2, 'focal_dist', info3); %setea distancia focal en metros f
% structure4 = set_info(structure3, 'resolution', info4); %setea [resolución_x, resolution_y] unidades en pixeles
% structure5 = set_info(structure4, 't_vista', info5); %setea tipo de vista utilizada en la camara (PERSPECTIVA, ORTOGRAFICA, PANORAMICA)
% structure6 = set_info(structure5, 'shift', info6); %setea [shift_x, shidt_y] corrimiento del centro de la camara en pixeles
% structure7 = set_info(structure6, 'sensor', info7); %setea [sensor_x, sensor_y] largo y ancho del sensor en milimetros
% structure8 = set_info(structure7, 'sensor_fit', info8); %setea tipo de ajuste utilizado para el sensor (AUTO, HORIZONTAL, VERTICAL)
% structure9 = set_info(structure8, 'pixel_aspect', info9); %setea (pixel_aspect_x)/(pixel_aspect_y) valor 1 indica pixel cuadrado
% structure10 = set_info(structure9, 'projection_matrix', info10); %setea matrix de proyección de la camara
% % %DATOS DE LA ESTRUCTURA
% structure11 = set_info(structure10, 'name', info11); %setea string nombre de la estructura
% %structure12 = set_info(structure, 'name_bvh', info12); %setea nombre del archivo.bvh asociado al esqueleto structure (VALIDO SOLO SI STRUCTURE ES UN SKELETON)
% structure13 = set_info(structure11, 'n_frames', info13); %setea numero de frames de la estructura
% structure14 = set_info(structure13, 'n_paths', info14); %setea numero de paths de la estructura
% %structure15 = set_info(structure, 'n_cams', info15); %setea numero de camaras de la estructura (VALIDO SOLO SI STRUCTURE ES UN SKELETON)
% structure16 = set_info(structure14, 'frame_rate', info16); %setea frame rate de los frames en la estructura
% % %DATOS DE FRAME
% structure17 = set_info(structure16, 'frame', 1, 'marker', 'coord', info17); %setea con las columnas de "info17" las coordenadas de todos los marcadores en el frame 1 de structure
% structure18 = set_info(structure17, 'frame', 1, 'marker', 'name', info18); %setea con las columnas del cell string "info18" los nombres de todos los marcadores en el frame 1 de structure
% structure19 = set_info(structure18, 'frame', 1, 'marker', 'state', info19); %setea con las columnas de "info19" un vector con los estados de  todos los marcadores en el frame 1 de structure
% % structure20 = set_info(structure, 'frame', 1, 'marker', 'source_cam', info20);  %setea con las columnas de "info20" un vector con las camaras fuente de todos los marcadores en el frame 1 de structure
% structure21 = set_info(structure19, 'frame', 1, 'marker', [2, 3], 'coord', info21); %setea con las columnas de "info21" las coordenadas de los marcadores 2 y 3 del frame 1 de structure
% structure22 = set_info(structure21, 'frame', 1, 'marker', [2, 3], 'name', info22); %setea con las columnas del cell string "info22" los nombres de los marcadores 2 y 3 del frame 1 de structure
% structure23 = set_info(structure22, 'frame', 1, 'marker', [2, 3], 'state', info23); %setea con las columnas de "info23"  los estados de los marcadores 2 y 3 del frame 1 de structure
% % structure24 = set_info(structure, 'frame', 1, 'marker', [2, 3], 'source_cam', info24); %setea con las columnas de "info24"  un vector con las camaras fuente de los marcadores 2 y 3 del frame 1 de structure
% structure25 = set_info(structure23, 'frame', 1, 'time', info25); % setea con el valor de "info25" el tiempo asociado al frame 1 de la estructura structure
% structure26 = set_info(structure25, 'frame', 1, 'n_markers', info26); % setea con el valor de "info26" devuelve el numero de marcadores del frame 1 de la estructura structure
% 
% %DATOS DE PATH
% structure33 = set_info(structure26, 'path', 1, 'name', info30); % setea el nombre asociado a la trayectoria 1 de structure
% structure34 = set_info(structure33, 'path', 1, 'members', info31); % setea con una matriz 2xn_markers. la primer fila son los indices de los marcadores
% % %                                                        miembros de la trayectoria 1 de la estructura structure y la fila 2 son
% % %                                                        los correspondientes frames.
% structure35 = set_info(structure34, 'path', 1, 'state', info32); % setea una medida de calidad para la trayectoria 1 de la estructura structure
% structure36 = set_info(structure35, 'path', 1, 'n_markers', info33); % setea el numero de marcadores totales en la trayectoria 1 de structure
% structure37 = set_info(structure36, 'path', 1, 'init_frame', info34); %setea el frame inicial de la trayectoria 1 de structure
% structure38 = set_info(structure37, 'path', 1, 'end_frame', info35); %setea  el frame final de la trayectoria 1 de structure
% structure39 = set_info(structure38, 'path', 1, 'members', 2, info31(:,2));% setea la columna 2 de la matriz con miembros de la trayectoria 1 de la estructura structure y la fila 2 son
% % %                                                        los correspondientes frames.
% %
% % %EVALUACION
% %Para ello lo mejor es pasar todo por el xml y regresar cosa de tener todo
% %en el mismo formato
% s1.structure39 = structure39;
% struct2xml( s1, file )
% [s1]=xml2struct(file);
% structure_out=s1.structure39;
%Luego es ir viendo las difentes partes de las estructuras para ver donde
%se encuentra la diferencia y estudiarla en el codigo
% disp('----------------------------------')
% disp('structure.Attributes')
% if isequal(structure_out.Attributes, structure.Attributes)
%     disp('No se encontraron diferencias')
% else
%     disp('Se encontraron diferencias')
% end
% 
% disp('----------------------------------')
% disp('structure.frame')
% if isequal(structure_out.frame, structure.frame)
%     disp('No se encontraron diferencias')
% else
%     disp('----------------------------------')
%     disp('structure.frame.Attributes')
%     ok=1;
%     for i=1:info13 %hacer para todos los frames
%         if ~isequal(structure_out.frame{i}.Attributes, structure.frame{i}.Attributes)
%             fprintf('structure.frame{%d}.Attributes -->fallo.\n', i)
%             ok = 0;
%         end
%     end
%     if ok
%         disp('No se encontraron diferencias')
%     end
%     
%     disp('----------------------------------')
%     disp('structure.frame.marker')
%     for i=1:info13 %hacer para todos los frames
%         if ~isequal(structure_out.frame{i}.marker, structure.frame{i}.marker)
%             fprintf('structure.frame{%d}.marker -->fallo.\n', i)
%             ok = 0;
%         end
%     end
%     if ok
%         disp('No se encontraron diferencias')
%     end
%     
%     disp('----------------------------------')
%     disp('structure.frame.marker.Attributes')
%     for i=1:info13 %hacer para todos los frames        
%         for j=1:get_info(structure, 'frame', i, 'n_markers')
%             if ~isequal(structure_out.frame{i}.marker{j}.Attributes, structure.frame{i}.marker{j}.Attributes)
%                 fprintf('structure.frame{%d}.marker{%d}.Attributes -->fallo.\n', i, j)
%                 ok = 0;
%             end
%         end
%     end
%     if ok
%         disp('No se encontraron diferencias')
%     end
% end
% 
% disp('----------------------------------')
% disp('structure.path')
% if isequal(structure_out.path, structure.path)
%     disp('No se encontraron diferencias')
% else
%     for i=1:info14 %hacer para todos los paths
%         if ~isequal(structure_out.path{i}.Attributes, structure.path{i}.Attributes)
%             fprintf('structure.path{%d}.Attributes -->fallo.\n', i)
%             ok = 0;
%         end
%     end
%     if ok
%         disp('No se encontraron diferencias')
%     end
% end
