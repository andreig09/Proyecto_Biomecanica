clc
clear all
close all

%%
v_cams =[ 1 2 3]; n_cams = length(v_cams);
calibrar = 0;
segmentar = 0;
carpeta = './videos/'; % carpeta donde se encuantran los videos a segmentar
umbral = .05; % umbral reconstruccion
tot_markers = 18;   % numero de marcadores colocados

% resolucion videos
res_xp = 720;
res_yp = 576;

%%
addpath ../Proyecto_Biomecanica/SISTEMA/ -end;
addpath ../Proyecto_Biomecanica/SISTEMA/Manejo_Estructura/ -end;
addpath ../Proyecto_Biomecanica/SISTEMA/InfoCamaras/ -end;
addpath ../Proyecto_Biomecanica/SISTEMA/Reconstruccion/ -end;
addpath ../Proyecto_Biomecanica/SISTEMA/Utiles/ -end;



 %% calibración de las cámaras
 
 % lectura de imagenes del objeto de calibración tomada de cada cámara
 
 if calibrar
     
     calibrador = [    0   0   0;
                            45  0   0;
                            45  45  0;
                            0   45  0;
                            0   0   90;
                            45  0   90;
                            45  45  90;
                            0   45  90];
     for i= v_cams

        img = imread(['calibracion/calib_' num2str(i) '.jpg']);

        P_i = calibracion(img, calibrador);
        pause
        P{i} = P_i;

    end

    save('calibracion.mat','P');
    
 else
     load('calibracion.mat','P');
 end
  
 
 %% segmentación de los videos
 
 
 if segmentar
 
 setenv('LD_LIBRARY_PATH','')
 cont = 0;
 for i=v_cams
 
     cont = cont + 1;
   
     video = ['cam' num2str(i)];
     ext = '.avi';
     gauss([carpeta video ext]);
     system(['./Source ' video '_gauss_gray' ext ' t 10'])
     
     list_XML{cont} = [video '_gauss_gray.xml'];
     
     save('list_XML.mat','list_XML');
 end
 
 else
    load('list_XML.mat','list_XML');
 end
%% Pasar XML a estructura cam
%
names = {'1' '2' '3' '4' '5' '6' '7' '8' '9' '10' '11' '12' '13' '14' '15' '16' '17' '18'};

path_XML = pwd;
cam = markersXML2mat(names, path_XML, list_XML);




%% corrección datos de cam

for i=v_cams
    cam_aux{i} = cam{i};
end
cam = cam_aux;

%%
res = get_info(cam{v_cams(1)}, 'resolution');
res_y = res(2);
 
 for c=v_cams

     
         cam{c} = set_info(cam{c}, 'resolution', [res_xp;res_yp]); 
         cam{c} = set_info(cam{c}, 'projection_matrix', P{c});
   
         for f=1:get_info(cam{c}, 'n_frames') 

             for m=1: get_info(cam{c}, 'frame', f, 'n_markers')
 
                 old_coord =  get_info(cam{c}, 'frame', f, 'marker', m);
                 old_coord_y = old_coord(2) ;
                 new_y = res_yp - res_y + old_coord_y;
                 new_coord = [old_coord(1); new_y; 1];
                 cam{c} = set_info(cam{c}, 'frame', f, 'marker', m, 'coord', new_coord);
                 
             end
         end
    
 end 
 
 
 %save('cam_clinicas.mat','cam');
 




%%

   % P = cell(1, n_cams);
    invP = cell(1, n_cams);
    C = cell(1, n_cams);
    
    
    
%    flag1 = 0;
    for i=v_cams 
        
 %       P{i} = get_info(cam{i}, 'projection_matrix'); %matrix de proyeccion de la camara 
        invP{i}=pinv(P{i});%inversa generalizada de P 
        C{i} = homog2euclid(null(P{i})); %punto centro de la camara, o vector director perpendicular a la retina    
        
%         if ~isempty(cam{i}) && flag1 == 0
%             n_frames = get_info(cam{i},'n_frames');
%             flag1=1;
%         end
    end

%%

%rango_frames = [100 150];

vid_cam1 = VideoReader([carpeta 'cam' num2str(v_cams(1)) '.avi']);
vidFrames_cam1 = read(vid_cam1);

vid_cam2 = VideoReader([carpeta 'cam' num2str(v_cams(2)) '.avi']);
vidFrames_cam2 = read(vid_cam2);  

vid_cam3 = VideoReader([carpeta 'cam' num2str(v_cams(3)) '.avi']);
vidFrames_cam3 = read(vid_cam3); 



%%
n_frames = get_info(cam{v_cams(1)}, 'n_frames');
    
distancias_tot=[];

umbral_dist=inf;
tot_markers=inf;

for frame=1:n_frames
    
    
    
    Xrec=reconstruccion1frame_fast_dist4(cam, v_cams, P,  invP, C, frame, umbral, tot_markers, umbral_dist);


   

%salida = clinicas_reconstruccion1frame(cam, v_cams, frame, umbral, tot_markers);
%salida = reconstruccion1frame_fast_prueba1(cam, v_cams, P,  invP, C, frame, umbral, tot_markers);


%{
Xrec = salida{1};   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
indices_i = salida{2};%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
indices_d = salida{3};%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
distancias = salida{4};%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
%}

disp(['frame: ' num2str(frame)])

 %ploteo

 
seg_cam1 = get_info(cam{v_cams(1)}, 'frame', frame, 'marker', 'coord');
seg_cam2 = get_info(cam{v_cams(2)}, 'frame', frame, 'marker', 'coord');
seg_cam3 = get_info(cam{v_cams(3)}, 'frame', frame, 'marker', 'coord');



 
f1=figure(1);

 %vidFrames_cam1 = read(vid_cam1,frame);
 subplot(2,2,1);imshow(vidFrames_cam1(:,:,:,frame));
hold on


n_markers1 = get_info(cam{v_cams(1)}, 'frame', frame, 'n_markers');
texto = cellstr(int2str([1:n_markers1]'));
for n1 = 1:n_markers1
    hold on
    text(seg_cam1(1,n1),res_yp - seg_cam1(2,n1),texto(n1),'HorizontalAlignment','right', 'BackgroundColor',[.7 .9 .7], 'FontSize',5, 'FontWeight', 'bold');
end

plot(seg_cam1(1,:),res_yp - seg_cam1(2,:),'*');axis([0 res_xp 0 res_yp]);



%  if size(Xrec,2) > 0
%       rec_cam1 = get_info(cam{v_cams(1)}, 'frame', frame, 'marker', 'coord');
% 
%       subplot(2,2,1);plot(rec_cam1(1,:),res_yp - rec_cam1(2,:),'or')
%  end

hold off






%vidFrames_cam2 = read(vid_cam2,frame+desfase);
    subplot(2,2,3); imshow(vidFrames_cam2(:,:,:,frame));
hold on


n_markers2 = get_info(cam{v_cams(2)}, 'frame', frame , 'n_markers');
texto = cellstr(int2str([1:n_markers2]'));
for n2 = 1:n_markers2
    hold on
    text(seg_cam2(1,n2),res_yp - seg_cam2(2,n2),texto(n2),'HorizontalAlignment','right', 'BackgroundColor',[.7 .9 .7], 'FontSize',5, 'FontWeight', 'bold');
end




plot(seg_cam2(1,:),res_yp - seg_cam2(2,:),'*');axis([0 res_xp 0 res_yp]);



%  if size(Xrec,2) > 0
% 
%       rec_cam2 = get_info(cam{v_cams(2)}, 'frame', frame, 'marker', 'coord');
%       subplot(2,2,3);plot(rec_cam2(1,:),res_yp - rec_cam2(2,:),'or')
%  end

hold off


    subplot(2,2,4); imshow(vidFrames_cam3(:,:,:,frame));
hold on


n_markers3 = get_info(cam{v_cams(3)}, 'frame', frame , 'n_markers');
texto = cellstr(int2str([1:n_markers3]'));
for n3 = 1:n_markers3
    hold on
    text(seg_cam3(1,n3),res_yp - seg_cam3(2,n3),texto(n3),'HorizontalAlignment','right', 'BackgroundColor',[.7 .9 .7], 'FontSize',5, 'FontWeight', 'bold');
end




plot(seg_cam3(1,:),res_yp - seg_cam3(2,:),'*');axis([0 res_xp 0 res_yp]);




%title(['frame' num2str(frame)])

%{

 for n = 1:size(Xrec,2)
    hold on
    %disp( [num2str(indices_i(n)) '.' num2str(indices_d(n)) '.' num2str(distancias(n))]);
    
    subplot(2,2,2);text(Xrec(1,n),Xrec(2,n),Xrec(3,n),[num2str(indices_i(n)) '.' num2str(indices_d(n))],'HorizontalAlignment','right', 'BackgroundColor',[.7 .9 .7], 'FontSize',18, 'FontWeight', 'bold');
  end
% plot 3D
%}
  if size(Xrec,2) > 0
      
      %indexes = 1:size(Xrec,2);
      
      
     subplot(2,2,2);plot3(Xrec(1,:),Xrec(2,:),Xrec(3,:) ,'*')
     

  else
      subplot(2,2,2);plot3([],[],[])
  end
  
 
 

 
   axis([-.5 .5 -4 1 -.5 2])
  %axis square
  grid on


  xlabel('x')
  ylabel('y')
  zlabel('z')
 
   

  %figure(2) 
 % plot(distancias)
  %saveas(f1,num2str(frame),'png')
 pause(0.1)
  
 % distancias_tot=[distancias_tot,distancias];

  %close all
% saveas(figura,num2str(frame),'fig')

end
