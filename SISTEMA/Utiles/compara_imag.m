%Este script permite comparar visualmente la informacion proveniente de la segmentacion con el video
%original.
%Se pueden comparar dos segmentaciones y el video original al mismo tiempo.



close all
clc


%% REQUISITOS______________________________________
%cam1 debe ser una estructura cam a probar
%cam2 debe ser una estructura diferente a cam1, puede estar vacia, en ese caso solo se muestra la segmentacion de cam1
        %Poder visualizar dos segmentaciones sobre las imagenes permite tener una comparacion visual de las mismas
%Se debe tener los fotogramas del video que se quiere observar en el formato cam<nro_camara>-<nro_frame>.png
%Por ejemplo con ffmpeg se pueden obtener de: ffmpeg -i cam01.dvd cam01-%d.png


%% PARAMETROS DE ENTRADA
n_cam = 6;%nro de camara a observar
frames_path = '/home/sun/Documentos/Fing/Base_de_datos/Sujeto_CMU_08/08_07/Datos_Imagen/400_150-100-200/6';%direccion donde se tienen los fotogramas de video
init_frame=1;
last_frame=121;%si se coloca el valor -1 se plotean todos los frames del video
save_on=1;%si vale 1 salva las imagenes
time_pause=0.2;%si vale -1 se generan pausas entre frames del ploteo

 

%% CUERPO DE LA FUNCION
%% Cargo las imagenes
im = cell(1, last_frame);
for k=1:last_frame %guardo el nombre de cada frame en la matriz im   
    im{k}= [frames_path '/cam0' num2str(n_cam) '-' num2str(k), '.png'];
end


%% Ploteos

%esto es para que la pantalla salga maximizada
screen_size=get(0,'ScreenSize'); % averiguo el tamaño de la pantalla
f1=figure(1);

i=1;
for k=init_frame:last_frame %desde el frame inicial al final
    image(imread(im{k}));
    set(f1,'Position',screen_size-[0 0 0 70] );% Ajusta la ventana activa al tamaño de la pantalla 
    axis([1, vidWidth, 1, vidHeight]);
    hold on
    
    marker = get_info(cam1{n_cam},'frame', k, 'marker', 'coord');%obtengo las coordenadas de los marcadores en el frame k
    x = marker(1,:);%coordenada x
    y = marker(2,:);%coordenada y     
    x=x+(0.5)*ones(1, length(x));
    y=-y+(vidHeight+1)*ones(1, length(y));%por algun motivo (vidHeight-0.5) no se ajusta bien pero si (vidHeight+1)
    plot(x, y, 'rs', 'LineWidth', 2)    
    
    if exist('cam2') %en este caso se debe plotear dos segmentaciones sobre la imagen original
        marker = get_info(cam2{n_cam},'frame', k, 'marker', 'coord');%obtengo las coordenadas de los marcadores en el frame k
        x = marker(1,:);%coordenada x
        y = marker(2,:);%coordenada y     
        x=x+(0.5)*ones(1, length(x));
        y=-y+(vidHeight+1)*ones(1, length(y));%por algun motivo (vidHeight-0.5) no se ajusta bien pero si (vidHeight+1)
        plot(x, y, 'bx', 'LineWidth', 2)    
    end
    
    grid on
    grid minor
    str = sprintf('Comparacion de segmentacion vs. imagenes de video fuente. \n Frame %d.', k);
    t=title(str);
    set(t, 'FontSize', 20);
    hold off
    
    
    if (time_pause==-1)
        pause
    else
        pause(time_pause)
    end
    % Save output images
    if save_on==1
        if i==1 %crear el directorio una vez
            mkdir([frames_path, '/out'])
            i=2;
        end
        saveas(f1, [frames_path '/out/' num2str(n_cam) '-' num2str(k) '.png' ], 'png');%guarda una foto de la ventana en un archivo png
    end     
end




