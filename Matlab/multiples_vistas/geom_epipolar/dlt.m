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
      
       
        % X en coordenadas homogeneas
        % X(1,j,i)/X(4,j,i) coordenada x del frame j del marcador i
        % X(2,j,i)/X(4,j,i) coordenada y del frame j del marcador i
        % X(3,j,i)/X(4,j,i) coordenada z del frame j del marcador i
      
          
  
end

N3D = X;
