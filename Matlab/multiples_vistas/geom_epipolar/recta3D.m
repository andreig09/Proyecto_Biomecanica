function [C,u] = recta3D(cam, p_retina)

    % Dada una cámara y un punto en su retina, devuelve la recta en el espacio
    % que pasa por dicho punto y el foco de la cámara. La recta 3D es de la
    % forma (x,y,z) = C + lambda*u, donde C es un punto de la recta 
    % (en particular el foco de la cámara), u es el
    % vector dirección y lambda un escalar.

    % entrada:
    %   cam: una de las camaras de la estructura cam
    %   p_retina: punto de la retina de la cámara en píxeles (coord. homogeneas)

    % salida:
    %    P: un punto de la recta
    %    u: vector director 'u'

    % p_retina puede ser una matriz de puntos p_retina(i,j) siendo las filas,
    % las 3 coordenas y las columnas los distintos puntos. En ese caso u tiene
    % la forma u(i,j) donde se devuelve un vector director para cada punto
    % ingresado.

    P_matrix= get_info(cam, 'projection_matrix') ; % matriz de proyeccion de la cámara

    foco_h = null(P_matrix);  % foco de la cámara en coord homg.

    punto3D_h = pinv(P_matrix)*p_retina; % punto 3D cualquiera tal que si se proyecta en la cámara se obtiene p_retina (coord. homog)

    punto3D = homog2euclid(punto3D_h); % pasa a coord. euclideas
    foco = homog2euclid(foco_h);    % pasa a coord. euclideas

    num_puntos = size(p_retina,2);
    u = punto3D - foco*ones (1,num_puntos);   % vector director dela recta

    % normalizo vector director
    normas = sqrt(u(1,:).^2 + u(2,:).^2 + u(3,:).^2);
    u(1,:) = u(1,:)./normas;
    u(2,:) = u(2,:)./normas;
    u(3,:) = u(3,:)./normas;


    C = foco;
end
