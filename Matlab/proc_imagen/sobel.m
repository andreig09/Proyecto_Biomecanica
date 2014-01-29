function M_=sobel(M,thr)
%Dado una matriz, le aplico la mascara de sobel de 3x3 a cada parche de
%la matriz
%% Mascaras de Sobel;
N=[-1,-2,-1;0,0,0;1,2,1];%arriba->abajo
N(:,:,2)=[-1,0,1;-2,0,2;-1,0,1];%izquierda->derecha
%N(:,:,3)=[1,2,1;0,0,0;-1,-2,-1];%abajo->arriba
%N(:,:,4)=[1,0,-1;2,0,-2;1,0,-1];%derecha->izquierda
%N(:,:,5)=[2,1,0;1,0,-1;0,-2,2];%inferior_derecha->superior_izquierda
%N(:,:,6)=[0,-1,-2;1,0,-1;2,1,0];%superior_derecha->inferior_izquierda
%N(:,:,7)=[-2,-1,0;-1,0,1;0,1,2];%superior_derecha->inferior_izquierda
%N(:,:,8)=[0,1,2;-1,0,1;-2,-1,0];%inferior_izquierda->superior_derecha
M_0=zeros(size(M,1),size(M,2),size(N,3));
for i=2:(size(M,1)-1)
    for j=2:(size(M,2)-1)
        %%sub-matriz a la cual aplicar la mascara
        subM=M(i-1:i+1,j-1:j+1);
        %%
        %Aplico cada una de las mascaras a la submatriz
        for k=1:size(N,3)
            subN=N(:,:,k);
            %aplico mascara, haciendo la suma de la diagonal del producto
            for l=1:size(subN,1)
                 M_0(i,j,k)=M_0(i,j,k)+subM(l,:)*subN(l,:)';
            end;
        end;
    end;
end;
%% El resultado es la norma cuadratica, de la mascara horizontal y vertical
M_=floor((M_0(:,:,1).^2+M_0(:,:,2).^2).^(1/2));
%% El resultado es la suma de los absolutos de la mascara horizontal y vertical
%M_=floor(abs(M_0(:,:,1))+abs(M_0(:,:,2)));
%% Si la cantidad de argumentos es 1, el umbral es nulo
if(nargin>1)
    M_=255*(M_>thr);
end;
end
