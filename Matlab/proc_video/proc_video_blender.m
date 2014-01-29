clc;
clear all;
close all;

for i=1:200
    if i <10
        imagen = sprintf('blender/test/image_00%d.tif',i);
    elseif i<100
        imagen = sprintf('blender/test/image_0%d.tif',i);
    else
       imagen = sprintf('blender/test/image_%d.tif',i); 
    end;
    
    I=imread(imagen);
    M=double(I(:,:,1));
    imshow(uint8(M));
    %imshow(uint8(255*(M>190)));
    pause(1/180)
end;