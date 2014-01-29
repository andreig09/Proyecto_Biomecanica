clc;
clear all;
close all;
imagen = 'image/image_01.tiff';
I=imread(imagen);
M=double(I(:,:,1));
imshow(uint8(M));

%{
El marcador 5, esta alrededor de X=249, Y=31
%}
%% uso dos input, para encerrar el punto de interes, y centrar segun el maximo
%primero marca la esquina superior izquierda, luego la inferior derecha
coord = floor(ginput(2));
N=M(coord(1,2):coord(2,2),coord(1,1):coord(2,1));

coord = double([coord(1,1)-1+find(sum(N)==max(sum(N)),1),coord(1,2)-1+find(sum(N')==max(sum(N')),1)]);

%% una vez centrado, trato de encontrar el radio u ancho

mat = @(i) M(coord(1,2)-i:coord(1,2)+i,coord(1,1)-i:coord(1,1)+i);
suma = @(i) sum(sum(mat(i)));
suma_i = 0;
i = 0;

while suma_i < suma(i)
    suma_i = suma(i);
    i = i+1;
end

%% obtengo el parche, con el centro y el ancho

parche = mat(i-1)

%% A ITERAR, A ITERAR!!!

for i=2:77
if i<10
    imagen = sprintf('image/image_0%d.tiff',i);
else
    imagen = sprintf('image/image_%d.tiff',i);
end

I=imread(imagen);
M=double(I(:,:,1));
imshow(uint8(M));

%centro la matriz en el punto relevante del cuadro anterior,e inicializo la
%busqueda de algun valor no nulo, no negro

largo =(length(parche)-1)/2;

%% 
%Dado el parche, y una segunda imagen, comparo todos los parches con el
%inical en un rectangulo con centro el marcador inicial (?)

N=[];

coord = floor(coord);

for m=largo+1+max([coord(i-1,2)-20,0]):min([coord(i-1,2)+20,size(M,1)])-1-largo
    for n=largo+1+max([coord(i-1,1)-20,0]):min([coord(i-1,1)+20,size(M,2)])-1-largo
        N(m,n)=sum(sum(M(m-largo:m+largo,n-largo:n+largo)*parche'));
    end
end

% busco los mas similares
[m_i,m_j] = find(N>0.95*max(max(N)));

% de esos puntos, busco el mas cercano al marcador del frame anterior
dist = abs(m_i-coord(i-1,2))+abs(m_j-coord(i-1,1));
n_i = find(dist == min(dist),1);
coord(i,2)=m_i(n_i);coord(i,1)=m_j(n_i);

%dibujo una cruz en el punto encontrado
M(coord(i,2),:) = 128;
M(:,coord(i,1)) = 128;

%escribo las imagenes
imshow(uint8(M));
if i<10
    imagen = sprintf('image/result/image_0%d.tiff',i);
else
    imagen = sprintf('image/result/image_%d.tiff',i);
end
imwrite(M,imagen);
pause(1/90)
end
figure
plot(coord(:,1),coord(:,2),'x-')
figure
subplot(2,1,1)
plot(coord(:,1));
subplot(2,1,2)
plot(coord(:,2));
