clear all
close all
clc



addpath('./videos/');
vid_cam1 = VideoReader('cam1pte1.avi');
vid_cam2 = VideoReader('cam3pte1.avi');

%%

rango_frames = 1:5000;
desfase = 0;%104;

pausa = .01;







for frame=rango_frames

disp(frame)





vidFrames_cam1 = read(vid_cam1,frame);
subplot(1,2,1);imshow(vidFrames_cam1(:,:,:,1));title(['frame' num2str(frame)])

vidFrames_cam2 = read(vid_cam2,frame+desfase);
subplot(1,2,2);imshow(vidFrames_cam2(:,:,:,1));title(['frame' num2str(frame+desfase)])


  pause(pausa);

end