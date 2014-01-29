clc;
clear all;
close all;
%% HECHO CON MATLAB 2011
%{
%Matriz Diagonal, para ensayar
dim=16;
M=255*not(eye(dim,dim));
%}
I=imread('image/house.tif');%Imagen de Casa, referencia del CIPS
%I=imread('image/walkbridge.tif');%Imagen de puente
%%
M=double(I(:,:,1));
imshow(uint8(M));
title('Imagen Original');
%%
figure
t_ini = tic;
M_=uint8(sobel(M));
disp('Sobel Sin Umbral');
toc(t_ini)
imshow(M_);
disp('---');
title('Sobel Sin Umbral');
imwrite(M_,'image/result_sobel_sin_thr.tif');
%%
figure
thr=150;
t_ini = tic;
M_=uint8(sobel(M,150));
disp('Sobel Con Umbral');
toc(t_ini)
imshow(M_);
disp('---');
title(['Sobel Con Umbral (',num2str(thr),')']);
imwrite(M_,'image/result_sobel_con_thr.tif');
%%
figure
t_ini = tic;
M_=uint8(homogen(M));
disp('Homogeinedad Sin Umbral');
toc(t_ini)
imshow(M_);
disp('---');
title('Homogeinedad Sin Umbral');
imwrite(M_,'image/result_homogen_sin_thr.tif');
%%
figure
thr=40;
t_ini = tic;
M_=uint8(homogen(M,thr));
disp('Homogeinedad Con Umbral');
toc(t_ini)
imshow(M_);
disp('---');
title(['Homogeinedad Con Umbral (',num2str(thr),')']);
imwrite(M_,'image/result_homogen_con_thr.tif');
%%
figure
t_ini = tic;
M_=uint8(differ(M));
disp('Diferencia Sin Umbral');
toc(t_ini)
imshow(M_);
disp('---');
title('Diferencia Sin Umbral');
imwrite(M_,'image/result_difer_sin_thr.tif');
%%
figure
thr=40;
t_ini = tic;
M_=uint8(differ(M,thr));
disp('Diferencia Con Umbral');
toc(t_ini)
imshow(M_);
disp('---');
title(['Diferencia Con Umbral(',num2str(thr),')']);
imwrite(M_,'image/result_difer_con_thr.tif');
%%
figure
t_ini = tic;
M_=uint8(diffgauss(M));
disp('Diferencia Gaussiana');
toc(t_ini)
imshow(M_);
disp('---');
title('Diferencia Gaussiana');
%%
figure
t_ini = tic;
M_=uint8(im_rng(M));
disp('Rango');
toc(t_ini)
imshow(M_);
disp('---');
title('Rango');
%%
figure
t_ini = tic;
M_=uint8(im_var(M));
disp('Varianza');
toc(t_ini)
imshow(M_);
disp('---');
title('Varianza');
%%
figure
t_ini = tic;
M_=uint8(filtro_mediana(M,2));
disp('Filtro Mediana');
toc(t_ini)
imshow(M_);
disp('---');
title('Filtro Mediana');
%%
figure
t_ini = tic;
M_=uint8(filtro_lpf(M));
disp('Filtro LPF');
toc(t_ini)
imshow(M_);
disp('---');
title('Filtro LPF');
%%
figure
t_ini = tic;
M_=uint8(filtro_hpf(M));
disp('Filtro HPF');
toc(t_ini)
imshow(M_);
disp('---');
title('Filtro HPF');