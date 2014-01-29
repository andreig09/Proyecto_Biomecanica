function M_=differ(M,thr)
%% Dada una matriz, hago la diferencia entre bordes opuestos de cada submatriz
M_=zeros(size(M,1),size(M,2));
for i=2:(size(M,1)-1)
    for j=2:(size(M,2)-1)
        subM=M(i-1:i+1,j-1:j+1);
        M_(i,j)=max(max(abs(subM-subM(3:-1:1,3:-1:1))));
    end;
end;
if(nargin>1)
    M_=255*(M_>thr);
end;
end