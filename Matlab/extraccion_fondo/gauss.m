function [] = gauss(video,umbral, calidad, min_area, risk)

% Descripción:
% Se asume que cada pixel puede modelarse como una distribución gaussiana,
% por tanto para cada pixel de la imagen se calcula su media y su varianza a lo largo de
% toda la secuencia. Luego cada píxel de un determinado cuadro es
% discriminado como pertenciente al fondo o no comparando su distribución
% gaussiana con una distribución normal, esto es, un píxel (pix) pertenece
% al fondo si se cumple:
%      N(pix, mean, sigma) > ( 1/256 )
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


if (nargin == 1)
    umbral = 0;
    calidad = 75;
    min_area = 15;
    risk     = 1; 
    
end

if (nargin == 2)
    calidad = 75;
    min_area = 15;
    risk     = 1; 
end

if (nargin == 3)
    min_area = 15;
    risk     = 1; 
end
if (nargin == 4)
    risk     = 1; 
end


% se carga el video
xyloObj = VideoReader(video);
vid = read(xyloObj);

% numero de frames y framerate
nFrames = xyloObj.NumberOfFrames;
framerate = xyloObj.FrameRate;


% se calcula media y varianza para cada pixel a lo largo de la secuencia
disp('Extrayendo estadísticas del video:')

    for frame_num = 1 : nFrames

           img = double(rgb2gray(vid(:,:,:,frame_num)));

                if (frame_num == 1)
                    sum_of_values  = img;
                    sum_of_squares = img.^2;
                    total_frames   = 1;
                else
                    sum_of_values  = sum_of_values + img;
                    sum_of_squares = sum_of_squares + img.^2;
                    total_frames   = total_frames + 1;
                end
              
                if rem(frame_num,10) == 0
                disp(['frame ' num2str(frame_num) ' de ' num2str(nFrames)])
                end
     end
            

            % compute statistics
            bg_means = sum_of_values / total_frames;
            bg_vars  = sum_of_squares / total_frames - (sum_of_values / total_frames).^2;    

            % if pixel has no variance (e.g. saturated in all frames) then
            % assign a reasonable variance.
            ind = find(bg_vars == 0.0);
            bg_vars(ind) = 1.0000e-003;        


%% Video de salida, sin el fondo
            

[~,name,~] = fileparts(video);
writerObj = VideoWriter([name '_gauss_gray.avi']);
writerObj.FrameRate = framerate;
writerObj.Quality = calidad;
open(writerObj);

           
     
disp('Extrayendo el fondo del video:')
            

    for FRAME = 1:nFrames

       
                image = double(rgb2gray(vid(:,:,:,FRAME)));

                % probabilidad por píxel de pertenecer al background
                    bg_prob = normpdf(image, bg_means, sqrt(bg_vars));     
            
                % Classify pixel based on the assumption that foreground
                % is distributed according to uniform distribution.
                bg_img = double(bg_prob < 1/(256*risk));
                         
                
                bg_img = imfill(bg_img,'holes');%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%linaa agregada al codigo original
                

      
                
                if umbral > 0
                    im = image.*bg_img;
                    bin = im>umbral;
                    
                else
                    bin = bg_img;
                end

                              
                
                                % se eliminan conjuntos de pixeles de area < min_area
                if (min_area > 0)
                    [L] = bwlabel(bin, 4);
                    reg = regionprops (L,'Area');
                    L_selected = find([reg.Area] < min_area);
                    bin(find(ismember(L, L_selected))) = 0;
                end
                
                im = uint8(image.*bin);

                writeVideo(writerObj,im);

                
                if rem(FRAME,10) == 0
                    disp(['frame ' num2str(FRAME) ' de ' num2str(nFrames)])
                end

    end              

   close(writerObj);




