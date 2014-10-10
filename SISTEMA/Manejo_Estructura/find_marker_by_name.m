function [index_x] = find_marker_by_name(structure, str, varargin)
%Funcion que retorna el indice del marcador con nombre igual al parametro 'str' en los frames que se indiquen de estructuras cam(i) o skeleton 
%% ENTRADA
%structure -->estructura cam(i) o skeleton
%str       -->cell con el string del nombre a buscar
%varargin -->opcionalmente se pueden ingresar los siguientes parametros
%               string "frame" y a continuacion un vector con los numeros de frame donde se desea encontrar el marcador con nombre str
%% SALIDA
%index_x  -->la primer fila contiene los indices de marcadores con el nombre str, la segunda fila el frame respectivo. 
%           En el caso que no se encuentre el nombre contenido en str en algun frame se devuelve el indice -1 para dicho frame.

%% EJEMPLOS
% clc
% structure = skeleton;
% %genero una estructura modificada
% cam_aux = set_info(cam(2), 'frame', 1, 'marker', [2, 3], 'name', {'lolo' 'lala'}); %setea con las columnas del cell string los nombres de los marcadores 2 y 3 del frame 1 de structure
% cam_aux = set_info(cam_aux, 'frame', 20, 'marker', [2, 3], 'name', {'lolo' 'lala'}); %setea con las columnas del cell string los nombres de los marcadores 2 y 3 del frame 1 de structure
% %empiezo las busquedas de prueba
% str={'LeftLeg'};
% [index_x1] = find_marker_by_name(structure, str)%busco en la estructura los marcadores con nombre 'LeftLeg'
% 
% structure = cam_aux;
% str={'lolo'};
% [index_x2] = find_marker_by_name(structure, str, 'frame', [1, 20]) %busco en los frames 1 y 20 de la estructura los marcadores con nombre 'lolo'
% str={'lala'};
% [index_x3] = find_marker_by_name(structure, str, 'frame', [1, 20]) %busco en los frames 1 y 20 de la estructura los marcadores con nombre 'lala'

%% ---------
% Author: M.R.
% created the 23/08/2014.
%% CUERPO DE LA FUNCION

    %gestiono la entrada
    location_frame = find(strcmp(varargin, 'frame'), 1);    
    if isempty(location_frame) %si no se introdujo el nro de frame a buscar
        n_frame = get_info(structure, 'n_frames'); %numero de frames de la estructura
        n_frame = 1:n_frame; %genero un vector con los numeros de frame
    else %se ingreso el frame donde se debe efectuar la busqueda
        n_frame = varargin{location_frame +1};
    end
    length_n_frame = length(n_frame);
    
    %inicializo la salida
    index_x = -ones(2,length_n_frame);
    
    %obtengo el indice de marcador con nombre 'str' en cada frame (el indice debería ser unico pues set_info se encarga que no pueda existir dos marcadores con igual nombre en un frame)
    for k= 1:length_n_frame %hacer con todos los elementos de n_frame         
        names = get_info(structure, 'frame', n_frame(k), 'marker', 'name');%devuelve un cell string con los nombres de todos los marcadores en el frame n_frame de structure
        index_aux=find(strcmp(str, names), 1); %devuelvo los indices de los marcadores que tienen el nombre contenido en str
        if isempty(index_aux) 
            index_x(1,k) = -1;%en el caso que no se encuentre un marcador con el nombre str en el frame k se devuelve -1
        else
            index_x(1,k) = index_aux;%en este caso se encontro un marcador con el nombre contenido en str
        end
        index_x(2,k) = n_frame(k);        
    end    
end



% % Al trabajar con 14 marcadores los mismos se encuentran en el .bvh con los siguientes nombres
% LeftFoot
% LeftLeg
% LeftUpLeg
% 
% RightFoot
% RightLeg
% RightUpLeg
% 
% RightShoulder
% Head
% 
% LHand
% LeftForeArm
% LeftArm
% 
% LHand
% RightForeArm
% RightArm