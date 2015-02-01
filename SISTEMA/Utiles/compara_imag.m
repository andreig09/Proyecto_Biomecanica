%clear all
close all
clc
% correccion=0;
% if correccion==0
%     dX=0;
%     dY=0;
% else
%     dX=0.3;%correccion de X en pixeles
%     dY=-0.5;%correccion de Y en pixeles
% end
 
 n_cam = 6;
 vid_path = '/home/sun/Documentos/Fing/Base_de_datos/Sujeto_CMU_08/08_07/Datos_Imagen/1600_600-100-100';
 vid_name = sprintf('cam0%d.dvd', n_cam);
 frames_path = [vid_path '/' num2str(n_cam)];
 ground_path = '/home/sun/Documentos/Fing/Proyecto_Biomecanica/Archivos_mat/CMU_9_07_hack/1600_600-100-100/Ground_Truth';
 %if ~exist('cam.mat', 'var')
 %cam=   load([ground_path '/cam.mat']);
 %end
 %cam=cam.cam;

 %Construyo un objeto de video
 if ~exist('xyloObj')
  xyloObj = VideoReader([vid_path '/' vid_name]);
 end
 nFrames = xyloObj.NumberOfFrames;
  
  init_frame = 1;
  last_frame = nFrames;
  vidWidth = xyloObj.Width;
  vidHeight = xyloObj.Height;
% 
% %Genero una estructura para alojar los frame del objeto de video
% mov(1:nFrames) = ...
%     struct('cdata', zeros(vidHeight, vidWidth, 3, 'uint8'),...
%            'colormap', []);
% 
%        %NO FUNCIONA POR ALGUN MOTIVO 
% % %Leo el objeto de video frame a frame hasta alcanzar el final del mismo
% % for k = 1 : nFrames
% %     mov(k).cdata = read(xyloObj, k);
% %     k
% % end

%Genero los frames del video utilizando ffmpeg(TAMPOCO FUNCIONA DENTRO DEL MATLAB EL ffmpeg QUE PEDAZO DE 1@~~#@ ESTE MATLAB)
% mkdir(frames_path)
% oldFolder = cd(frames_path);
% str=sprintf('ffmpeg -i %s cam%d.png', [vid_path '/' vid_name], n_cam);
% eval(str)
% cd(oldFolder)
% 


%% Cargo las imagenes
im = cell(1, last_frame);

for k=1:last_frame %guardo el nombre de cada frame en la matriz im   
%     if k<10
%         im{k+1}= [frames_path '/cam' num2str(n_cam) '-000' num2str(k), '.png'];
%     else 
%         im{k+1}= [frames_path '/cam' num2str(n_cam) '-00' num2str(k), '.png'];
%     end
    im{k}= [frames_path '/cam0' num2str(n_cam) '-' num2str(k), '.png'];
end


%% Ploteos

%esto es para que la pantalla me salga maximizada
screen_size=get(0,'ScreenSize'); % averiguo el tamaño de mi pantalla
f1=figure(1);

% init_frame=1
% last_frame=63

for k=3:13%init_frame:last_frame %desde el frame inicial al final
     
        image(imread(im{k+1}));
        set(f1,'Position',screen_size-[0 0 0 70] );% Ajusta la ventana activa al tamaño de la pantalla 
       axis([1, vidWidth, 1, vidHeight]);
       hold on
     
     
     marker = get_info(cam{n_cam},'frame', k+1, 'marker', 'coord');%obtengo las coordenadas de los marcadores en el frame k
     x = marker(1,:);%coordenada x
     y = marker(2,:);%coordenada y     
     x=x+(0.5)*ones(1, length(x));
     y=-y+(vidHeight+0.5)*ones(1, length(y));
     plot(x, y, 'rs', 'LineWidth', 2)
     %plot(x, y, 'rx')
     
     %marker = get_info(cam2{n_cam},'frame', k, 'marker', 'coord');%obtengo las coordenadas de los marcadores en el frame k
     %x = marker(1,:);%coordenada x
     %y = marker(2,:);%coordenada y     
     %x=x+(0.5)*ones(1, length(x));
     %y=-y+(vidHeight+0.5)*ones(1, length(y));
     %plot(x, y, 'rx', 'LineWidth', 2)
     
     %plot_one_frame(cam{n_cam}, k)
     %axis xy
      % Save output images
   %saveas(f1, [ground_path '/cam' num2str(n_cam) '-' num2str(k) '.png' ], 'png');
     %axis square
     grid on
     grid minor
     hold off
     pause
     
     
end




