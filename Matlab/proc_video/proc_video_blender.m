clc;
clear all;
close all;

i_fin = 50;

centroide_total = [];

n = []

for i=1:i_fin
    if i <10
        imagen = sprintf('blender/test/image_00%d.tif',i);
    elseif i<100
        imagen = sprintf('blender/test/image_0%d.tif',i);
    else
       imagen = sprintf('blender/test/image_%d.tif',i); 
    end;
    
    I=imread(imagen);
    M=double(I(:,:,1));
    %figure(1)
    %subplot(2,1,1)
    %imshow(uint8(M));
    title(sprintf('Imagen Original %d',i));
    %M = M-imopen(M,strel('disk',15));
    figure(3)
    %subplot(2,1,2)
    %M_ = M;
    %% Por sigerencia/correcion de Juan, se hace la segmentacion/umbral, antes de dilacion
    M_=255*(M>(0.75*255)); % umbral al 75% de la escala de grises
    se4 = strel('disk',2);
    M_ = imdilate(M_,se4);
    %imshow(uint8(255*(M>190)));
    %imshow(uint8(homogen(M)));
    %hy = fspecial('sobel');
    %hx = hy';
    %Iy = imfilter(double(M), hy, 'replicate');
    %Ix = imfilter(double(M), hx, 'replicate');
    %m = sqrt(Ix.^2 + Iy.^2);
    %imshow(uint8());
    %M_=255*(M_>(0.75*255));
    L = bwlabel(M_>0);[x,y]=find(L==2);
    max(max(L))
    m = [];
    largo_m = 20;
    punteado_m = 3;
    for j=1:max(max(L))
        centroide = regionprops(L==j,'Centroid');
        m = [m;centroide.Centroid(1),centroide.Centroid(2)];
        M_(round(centroide.Centroid(2)),round(centroide.Centroid(1))-largo_m:punteado_m:round(centroide.Centroid(1))+largo_m) = 150;
        M_(round(centroide.Centroid(2))-largo_m:punteado_m:round(centroide.Centroid(2))+largo_m,round(centroide.Centroid(1))) = 150;
    end
    n = [n;round([i*ones(size(m,1),1),m])];
    imshow(uint8(M_));
    if i<10
        imagen = sprintf('image/result/image_0%d.tiff',i);
    else
        imagen = sprintf('image/result/image_%d.tiff',i);
    end
    imwrite(M_,imagen);
    %Lrgb = label2rgb(L, 'jet', 'w', 'shuffle');
    %imshow(Lrgb)
    title(sprintf('Imagen Procesada %d',i));
    pause(1/180)
end;