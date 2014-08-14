function [C, r_retina] = esfera2cam(X_0, r, P, varargin)
%Esta funcion permite proyectar esferas 3D sobre la retina de una camara, devolviendo un cell array con las matrices de coeficientes de cada conica 2D
% (Ver Zisserman seccion 2.2.3 p30-31 sobre conicas)
% Se aprovecha la idea de que sin importar la retina sobre la que se proyecta la imagen va a ser una circunferencia, lo importante es encontrar
% la distancia r proyectada la retina.
% La idea es encontrar rectas que pasen por 'X_0' que sean paralelas al plano de la retina de la camara con matriz P, sobre dichas rectas se
% encuentran puntos X tales que |X-X_0| = r . Estos X se mapean sobre la retina obteniendo x=P*X, y dichos x pasan sobre una conica que debería
% ser una circunferencia.


%% ENTRADA
%X_0 -->matriz donde X_0(:,j) vector columna centro de la esfera j
%r    -->vector fila con los radios de las esferas, si se coloca un escalar todas las esferas tendran el mismo radio
%P    -->matriz de proyeccion de la camara sobre la cual se van a proyectar las esferas
%varargin -->si se ingresa un 1 se efectuan dibujos de verificacion. 

%% SALIDA
%C --->cell array, C{j} es la matriz de coeficientes de la conica 2D asociada a la esfera de centro X_0(:,j) y radio r(j) 

%      Si (x1, x2, 1) es un punto generico "normalizado" en coordenadas homogeneas 2D, las conicas "normalizadas" 
%      quedan definidas por los coeficientes cc=(a, b, c, d, e, 1).
%      La ecuacion de la conica "normalizada" es x'*C*x = a*x1^2 +b*x1*x2 +cx2^2 +d*x1*1 +e*x1*1 +1*1 = 0  , donde  
%      C = [a  ,  b/2 , d/2;  
%           b/2,  c   , e/2; 
%           d/2,  e/2 , 1  ]
%r_retina -->vector donde la componente r_retina(j) indica el radio medio
%           de la conica C{j} asociado a la camara de matriz P

%% METODO
% Se encuentra el centro de la camara Ocam = ker(P), las tres primeras coordenadas de este punto tambien puede ser vistas 
% como un vector director n=[Ocam(1), Ocam(2), Ocam(3)] perpendicular al plano de la retina. 
% Encontrando el nucleo de 'n' tenemos dos direcciones pn=null(n') que son perpendiculares a 'n' y forman una base para los planos paralelos a la retina. 
% Se trazan al menos 3 rectas que pasen por 'X_0' y tengan cualquier vector director combinacion lineal de [pn(1), pn(2)], por recta se toman los 2 puntos X
% que cumplen |X -X_0|=r y luego se proyectan sobre la retina x=P*X.
% Se encuentra la mejor conica que pase por los puntos x y se devuelve su matriz de coeficientes de la conica.

%      Si (x1, x2, 1) es un punto generico "normalizado" en coordenadas homogeneas 2D, las conicas "normalizadas" 
%      quedan definidas por los coeficientes cc=(a, b, c, d, e, 1).
%      La ecuacion de la conica "normalizada" es x'*C*x = a*x1^2 +b*x1*x2 +cx2^2 +d*x1*1 +e*x1*1 +1*1 = 0  , donde  
%      C = [a  ,  b/2 , d/2;  
%           b/2,  c   , e/2; 
%           d/2,  e/2 , 1  ].
%      Los puntos interiores de la conica cumplen x'*C*x>0 y los exteriores x'*C*x<0
% Si tenemos m>5 (pues 5 son las incognitas de cc) puntos 2D, una matriz A donde cada fila es A(m,:)=[xm(1).^2,  xm(1).*xm2,   xm(2).^2, xm(1),  xm(2),  1];
%y queremos encontrar la conica que mejor ajuste a los m puntos. (Ver Zisserman seccion 2.2.3 p30-31 sobre conicas)
% Se debe encontrar la mejor solucion para A*cc=0 (con cc=(a, b, c, d, e, 1)), por lo tanto se debe encontrar el vector conica que minimice ||A*cc||
% con la restriccion ||cc||=1 para obtener los vectores cc~=0. 
% SOLUCION (ver Zisserman A5.3 p592-593)
% cc es la ultima columna de V, donde A=UDV' es la SVD de A 

%% ---------
% Author: M.R.
% created the 01/08/2014.

%% CUERPO DE LA FUNCION

  %proceso la entrada
  n_sph=size(X_0, 2);%numero total de esferas a proyectar
  if size(r, 2)==1 % si r es un escalar, lo transformo en un vector      
      r = r*ones(1, n_sph);
  end
  
  
  if nargin<4 %no se quiere debug
      debug_on=0;
  elseif nargin>4 %se tienen muchos argumentos
      str = ['Se ingresaron un numero erroneo de parametros'];
        error('nargin:FueraDeRango',str)  
  else
      debug_on=varargin{1};
  end
      
  %inicializo la salida
  C = cell(1, n_sph);
  r_retina=zeros(1, n_sph);
  
  %se obtiene el centro de la camara Ocam y el vector normal a la retina
  Ocam = null(P);
  n = homog2euclid(Ocam);%este es el vector director normal al plano de la retina  en R^3(tambien se puede ver como un punto)
  %genero dos direcciones en R^3 que sean perpendiculares al vector n
  pn = null(n');
  %con las dos direcciones anteriores genero otras tres direcciones combinacion lineal de las restante, de manera de seguir con direcciones
  %perpendiculares a n
  pn = [pn, (pn(:, 1)-pn(:,2)), (pn(:, 1)+pn(:,2)), (pn(:, 1)-2*pn(:,2))];
  %normalizo dichas direcciones para generar versores
  pn = [pn(:,1)/norm(pn(:,1)),    pn(:,2)/norm(pn(:,2)),      pn(:,3)/norm(pn(:,3)),  pn(:,4)/norm(pn(:,4)), pn(:,5)/norm(pn(:,5))   ];
  
  for j=1:n_sph %hacer para cada esfera
      %genero rectas que pasen por X_0(:,j) y encuentro puntos a distancia r(j)
      X1= [ (X_0(:,j) + r(j)*pn(:,1)), (X_0(:,j) - r(j)*pn(:,1)) ];
      X2= [ (X_0(:,j) + r(j)*pn(:,2)), (X_0(:,j) - r(j)*pn(:,2)) ];
      X3= [ (X_0(:,j)+  r(j)*pn(:,3)), (X_0(:,j) - r(j)*pn(:,3)) ];
      X4= [ (X_0(:,j)+  r(j)*pn(:,4)), (X_0(:,j) - r(j)*pn(:,4)) ];
      X5= [ (X_0(:,j)+  r(j)*pn(:,5)), (X_0(:,j) - r(j)*pn(:,5)) ];
      
      %proyecto todos los puntos X sobre la camara con matriz de proyeccion P
      X = [X1, X2, X3, X4, X5]; %agrupo todos los puntos
      x = obtain_coord_retina(X, P); %proyecto sobre retina
      
      %% A continuacion encuentro los parametros de la conica que mejor se ajusta a los puntos utilizando el algoritmo explicado en Zisserman A5.3 p592-593
      
      %genero vectores columnas con las coordenadas
      x1 = x(1,:)';
      x2 = x(2,:)';
      %x3 = x(3,:)'; %la tercer coordenada se que son de 1's pues siempre estoy trabajando con coordenadas homogeneas normalizadas
      
      %genero la matriz A
      A = [x1.^2     x1.*x2     x2.^2    x1      x2      ones(length(x1), 1)]; 
      %aplico descomposicion SVD
      [~,~,V] = svd(A);
      %me quedo con la ultima columna de V
      last_column=size(V, 2);
      cc = V(:,last_column); %estos son los coeficientes de la conica
      cc = 100000.*V(:,last_column); %estos son los coeficientes de la conica
      %construyo la matriz con coeficientes de la conica asociada a la esfera j
      C{j} = [cc(1)     cc(2)/2     cc(4)/2 ;...
              cc(2)/2   cc(3)       cc(5)/2;...
              cc(4)/2   cc(5)/2     cc(6)   ]; 
      %calculo en radio medio de la conica (este parametro es util en el caso que la conica se aproxime a una circunferencia, lo cual deberia pasar si no hay distorcion en la camara)
       x0 = obtain_coord_retina(X_0(:,j), P);%centro de la conica
       r_aux = (x-x0*ones(1, size(x, 2)));
       r_aux = pdist2(r_aux', zeros(1, size(r_aux', 2)));
       r_aux = mean(r_aux); %distancia media de los puntos al "centro"   
       r_retina(j) = r_aux;%radio de la conica j
       
       
       if debug_on         
          x0 = obtain_coord_retina(X_0(:,j), P);%centro de la conica
%           r_retina = (x-x0*ones(1, size(x, 2)));
%           r_retina = pdist2(r_retina', zeros(size(r_retina')));
%           r_retina = mean(diag(r_retina)); %distancia media de los puntos al "centro"
          %genero puntos internos y externos a la conica para evaluar las variaciones de signo de la funcion de la conica (diag(x'*C{1}*x)) fuera y dentro
          %de la misma.
          %z1 = (x0*ones(1, size(x, 2)) + x)/2; %puntos a media distancia entre lospuntos de la conica y el centro
                    
          factor = 1;%multiplicar por algo mayor a 1 genera z2 y z3 puntos externos y con un factor menor a 1 puntos internos
          z2 = (x-x0*ones(1, size(x, 2)))*factor+x0*ones(1, size(x, 2));
          angle = pi/3;
          z3= [cos(angle) -sin(angle) 0; sin(angle) cos(angle) 0; 0 0 1]*(z2-x0*ones(1, size(z2, 2)))+x0*ones(1, size(z2, 2));
          
          hold on
          %intento de generar el dibujo de la conica, no funciona siempre
%           str=sprintf('(%0.10f)*x^2+ (%0.10f)*x*y +(%0.10f)*y^2 +(%0.10f)*x +(%0.10f)*y + (%0.10f)=0', cc(1), cc(2), cc(3), cc(4), cc(5), cc(6));
%           xmin=-500;
%           ymin=xmin;
%           xmax=1000;
%           ymax=xmax;
%           ezplot(str, [xmin,xmax,ymin,ymax])%los ejes van a recorrer los valores de x en [-2000, 2000]
%           colormap([0 1 0])   % Make the line green
         
          
          %puntos pertenecientes a la conica
          plot(x1, x2, 'go')%grafico las proyecciones de los puntos equidistantes de X_0 así como las rectas a las cuales pertenecen             
          plot(x1(1:2), x2(1:2), 'g--' )
          plot(x1(3:4), x2(3:4), 'g--' )
          plot(x1(5:6), x2(5:6), 'g--' )
          plot(x1(7:8), x2(7:8), 'g--' )          
          plot(x1(9:10), x2(9:10), 'g--' )          
          plot(x0(1), x0(2), 'go')
          
          %puntos interiores y exteriores
          %plot(z1(1,:), z1(2,:), 'r*')
          plot(z2(1,:), z2(2,:), 'k*')
          plot(z3(1,:), z3(2,:), 'm*')          
          axis equal 
          grid on          
          hold off
          
%           dz1=diag(z1'*C{j}*z1);
%           dz2=diag(z2'*C{j}*z2);
%           dz3=diag(z3'*C{j}*z3);
%           conica=diag(x'*C{j}*x);
%           signo = [dz1, conica, dz2, dz3] 
      end %del if
  end %del for
  
return







 %%%%PARA DEBUG Y VERIFICACION 3D (solo sirve para un solo punto)
%              %graficar vector perpendicular a la retina que pasa por X_0
%              lambda=[-100:1:100];
%              a=n(1)/norm(n);%son las coordenadas de n normalizado
%              b=n(2)/norm(n);
%              c=n(3)/norm(n);
%              x0=X_0(1);
%              y0=X_0(2);
%              z0=X_0(3);
%              xn= x0 + lambda.*a; 
%              yn= y0 + lambda.*b;
%              zn= z0 + lambda.*c;
%              plot3(xn, yn, zn, '-')
%              grid minor
%              hold on
%              %grafico el punto X_0
%              plot3(x0, y0, z0, 'bo')
%              %grafico el punto Ocam
%              plot3(a, b, c, 'bo')
%              %grafico el plano perpendicular a 'n' por el punto X_0
%              % ax +by +cz +d=0; o lo que es lo mismo <n,(X-X_0)>=0 para todo X perteneciente al plano
%              d=-dot([a;b;c], X_0);
%              % z = (-ax -by -d)/c
%              str=sprintf('(-%0.10f *x - %0.10f *y - %0.10f)/%0.10f', a, b, d, c)
%              ezsurf(str)   
%              %rectas perpendiculares a n por X_0
%              x1 =(x0 + lambda*pn(1,1));
%              y1 =(y0 + lambda*pn(2,1));
%              z1 =(z0 + lambda*pn(3,1));
%              plot3(x1, y1, z1, 'r-')
%              x2 =(x0 + lambda*pn(1,2));
%              y2 =(y0 + lambda*pn(2,2));
%              z2 =(z0 + lambda*pn(3,2));
%              plot3(x2, y2, z2, 'm-')
%              x3 =(x0 + lambda*pn(1,3));
%              y3 =(y0 + lambda*pn(2,3));
%              z3 =(z0 + lambda*pn(3,3));
%              plot3(x3, y3, z3, 'k-')
%              %ploteo los puntos que equidistan de X_0 una distancia r
%              plot3(X(1,:), X(2,:), X(3,:), 'b*')             
%              %verifico distancias
%              for i=1:6
%                  distancia = r-pdist2(X_0', X(:,i)');
%                  if (distancia)>(eps*100)                     
%                      str=sprintf('El punto %d no equidista de X_0.', i);
%                      disp(str)
%                  end                     
%              end
  
 