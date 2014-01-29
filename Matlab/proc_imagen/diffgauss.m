function M_=diffgauss(M,thr)
%% Dada una matriz, hago la convolucion con mascaras gaussianas
%N=[0,0,-1,-1,-1,0,0;0,-2,-3,-3,-3,-2,0;-1,-3,5,5,5,-3,-1;-1,-3,5,16,5,-3,-1;-1,-3,5,5,5,-3,-1;0,-2,-3,-3,-3,-2,0;0,0,-1,-1,-1,0,0];
N=[0 0 0 -1 -1 -1 0 0 0;0 -2 -3 -3 -3 -3 -3 -2 0;0 -3 -2 -1 -1 -1 -2 -3 0;-1 -3 -1 9 9 9 -1 -3 -1;-1 -3 -1 9 19 9 -1 -3 -1;-1 -3 -1 9 9 9 -1 -3 -1;0 -3 -2 -1 -1 -1 -2 -3 0;0 -2 -3 -3 -3 -3 -3 -2 0;0 0 0 -1 -1 -1 0 0 0];
M_=zeros(size(M,1),size(M,2));
for i=ceil(size(N,1)/2):(size(M,1)-ceil(size(N,1)/2))
    for j=ceil(size(N,1)/2):(size(M,2)-ceil(size(N,1)/2))
        subM=M(i-floor(size(N,1)/2):i+floor(size(N,1)/2),j-floor(size(N,1)/2):j+floor(size(N,1)/2));
        for k=1:size(N,1)
            M_(i,j)=M_(i,j)+subM(k,:)*N(k,:)';
        end;
    end;
end;
if(nargin>1)
    M_=255*(M_>thr);
end;
end