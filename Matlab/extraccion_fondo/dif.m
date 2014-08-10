function [] = dif(video, fondo, umbral_mark, umbral_bs, calidad, min_area)

% Descripción:
% Dado un video y la imagen de su fondo se resta cuadro a cuadro el frame
% del video con la imagen del fondo. Luego se obtiene una imagen binaria
% con valor '1' para aquellos píxeles tales que la resta anterior superen el
% umbral 'umbral_bs'.
% A la imagen binaria resultante se le aplica la función imfill que rellena
% aquellos pixeles de valor '0' que estén rodeados de píxeles de valor '1'.
% Luego se eliminan los conjuntos de píxeles de valor '1' cuya área sea
% menor a min_area.
% El video de salida es el producto del video con la
% imagen binaria resultante.


%http://vision.cs.brown.edu/humaneva/download1.html

% Sintaxis: 
%       [] = BackgroundSubtraction(video);
%       [] = BackgroundSubtraction(video,umbral);
%       [] = BackgroundSubtraction(video,umbral, calidad);
%       [] = BackgroundSubtraction(video,umbral, calidad,min_area);
%       [] = BackgroundSubtraction(video,umbral, calidad,min_area, risk);

% Entrada:
%   video       - archivo de video (string)
%   umbral      - valor entre [0, 255] aplicado sobre el resultado de
%                 final de extraer el fondo al video.
%   calidad     - calidad de video de salida ('0 - 100'), siendo 100 
%                 calidad óptima. Por defecto calidad = 75.
%   min_area    - valor entero positivo que se utiliza para eliminar todo 
%                 conjunto unido de píxeles cuya área sea < min_area. Por
%                 defecto min_area = 15.
%   risk        - margen de ajuste del umbral de decision si un píxel 
%                 pertenece al background o no.

%Salida:
%   Si video es 'nombre.ext'devulve el video con extraccion de background
%   'nombre_sf.avi'.


if (nargin == 2)
    umbral_mark = 0;
    umbral_bs = 20;
    calidad = 75;
    min_area = 15;    
end

if (nargin == 3)
    umbral_bs = 20;
    calidad = 75;
    min_area = 15;
end

if (nargin == 4)
    
    calidad = 75;
    min_area = 15;
end
if (nargin == 5)
    
    min_area = 15;
end




%%
xyloObj = VideoReader(video);
nFrames = xyloObj.NumberOfFrames;
framerate = xyloObj.FrameRate;


fondo = double(rgb2gray(imread(fondo)));
vid = read(xyloObj);



            
[~,name,~] = fileparts(video);
writerObj = VideoWriter([name '_dif.avi']);
writerObj.FrameRate = framerate;
writerObj.Quality = calidad;
open(writerObj);


%%
  for frame_num = 1 : nFrames

           %img = read(xyloObj,frame_num);
           img = double(rgb2gray(vid(:,:,:,frame_num)));
           binario = abs(img - fondo)>umbral_bs;
           
           
                binario = imfill(binario,'holes');
           
 
                

                
                 
                
                if umbral_mark > 0
                    im = img.*binario;
                    bin = im>umbral_mark;
                    
                else
                    bin = binario;
                end
                
                 if (min_area > 0)
                    [L] = bwlabel(bin, 4);
                    reg = regionprops (L,'Area');
                    L_selected = find([reg.Area] < min_area);
                    bin(find(ismember(L, L_selected))) = 0;
                end
                 
                 imagen = uint8((img.*bin)); 
   
 
           writeVideo(writerObj,imagen);

  end
  
 close(writerObj);
            