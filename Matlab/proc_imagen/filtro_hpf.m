function M_=filtro_hpf(M)
%% Dada una matriz, calculo la homogeinedad de un pixel , como el maximo del valor absoluto de las restas de los pixeles vecinos
M_=M;
nivel =1;
%% Mascaras de Filtro HPF;
N=[0,-1,0;-1,5,-1;0,-1,0];
N(:,:,2)=[-1,-1,-1;-1,9,-1;-1,-1,-1];
N(:,:,3)=[1,-2,1;-2,5,-2;1,-2,1];
for i=(1+nivel):(size(M,1)-nivel)
    for j=(1+nivel):(size(M,2)-nivel)
        subM=M(i-nivel:i+nivel,j-nivel:j+nivel);
        M_(i,j)=sum(sum(subM.*N(:,:,2)));
    end;
end;
end