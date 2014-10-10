% parametros de entrada
    % N1 - nube de puntos en 2D en camara 1 en formato euclideo (a,b)' o coord homogeneneas (a, b, 1)'
    % a - coordenada x (1) o y (2) del punto

    % N2 - nube de puntos en 2D en camara 2 en formato euclideo (a,b)' o coord homogeneneas (a, b, 1)'
    
    % P1 - matriz de proyeccion de la cámara 1  
    % P2 - matriz de proyeccion de la cámara 2
    
% parametro de salida

    % N3D - nube de puntos 3D en formato (a,b) en coordenadas homogeneas
    



function N3D = dlt(N1,N2,P1,P2)

    if size(N1,2)~=size(N2,2)
        error('Las nubes de puntos ingresadas tienen distinta cantidad de puntos')
    end
    
    X = [];
    for i=1:size(N1,2)%para cada punto
        
        
        A = [N1(1,i)*P1(3,:)-P1(1,:);
            N1(2,i)*P1(3,:)-P1(2,:);
            N2(1,i)*P2(3,:)-P2(1,:);
            N2(2,i)*P2(3,:)-P2(2,:)];
        %[U,D,V] = svd(A);
        [~,~,V] = svd(A);
        
        X(:,i) = reshape(V(:,4),1,4)';
        
        % JUSTIFICACION      
        % Un punto 3D X de coordenadas homogeneas (dimX =4×1) es proyectado sobre una retina en un punto 2D x de coordenadas homogeneas (dimx=3×1)
        % a traves de la matriz de proyeccion de dicha retina --> x = P.X, donde P (dimP=3×4). 
        % La ecuacion proyectiva es equivalente al producto vectorial (x ^ PX) = 0, donde x = [x_1, x_2, 1]' y PX = [P_1'.X, P_2'.X, P_3'.X]'.
        % Este producto genera dos ecuaciones independientes: x_2.(P_3'.X) – (P_2'.X) = 0 
        %                                                     x_1.(P_3'.X) – (P_1'.X) = 0.
        % Para cada camara las ecuaciones independientes  (x_2.P_3' – P_2').X = 0 
        %                                                 (x_1.P_'T – P_1').X = 0 
        % pueden ser combinadas en un sistema homogeneo de la forma A.X=0. 
        % Se UDV' es la descomposicion en valores singulares de A, se tiene que la ultima columna de V son las coordenadas del punto  X reconstruido.   
    end
    N3D = X;
return
    