function M_=filtro_mediana(M,nivel)
%% Dada una matriz, calculo la homogeinedad de un pixel , como el maximo del valor absoluto de las restas de los pixeles vecinos
M_=M;
if(nargin==1)
    nivel = 1;
end;
for i=(1+nivel):(size(M,1)-nivel)
    for j=(1+nivel):(size(M,2)-nivel)
        subM=M(i-nivel:i+nivel,j-nivel:j+nivel);
        M_(i,j)=median(reshape(subM,1,(2*nivel+1)^2));
    end;
end;
end