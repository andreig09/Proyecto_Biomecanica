function M_=homogen(M,thr)
%% Dada una matriz, calculo la homogeinedad de un pixel , como el maximo del valor absoluto de las restas de los pixeles vecinos
M_=zeros(size(M,1),size(M,2));
for i=2:(size(M,1)-1)
    for j=2:(size(M,2)-1)
        subM=M(i-1:i+1,j-1:j+1);
        M_(i,j)=max(max(abs(subM-subM(2,2))));
    end;
end;
if(nargin>1)
    M_=255*(M_>thr);
end;
end