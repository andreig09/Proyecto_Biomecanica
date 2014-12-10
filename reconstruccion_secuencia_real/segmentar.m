clear all
close all
clc

setenv('LD_LIBRARY_PATH','')
num_cam = [1 3];

for i=num_cam

    carpeta = './videos/';
    video = ['cam' num2str(i) 'pte1_r'];
    ext = '.avi';
    gauss([carpeta video ext],100);
    system(['./Source_GLNX86 ' video '_gauss_gray' ext])
end