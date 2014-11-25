clc
thr = [];
for marker=min(X_out(5,:)):max(X_out(5,:))
close all
aceleracion = X_out(1:3,X_out(5,:)==marker);
aceleracion = sum((-aceleracion(:,3:size(aceleracion,2))+2*aceleracion(:,2:size(aceleracion,2)-1)-aceleracion(:,1:size(aceleracion,2)-2)).^2).^(1/2);
test=[50:1:100;prctile(aceleracion,50:1:100)];
A=[ones(size(test(1,:)')),test(1,:)'];
B=[test(2,:)'];
M = inv(A'*A)*(A'*B);

plot(test(1,:),test(2,:),'.-',...
    test(1,:),M(1)+test(1,:)*M(2),'r',...
    test(1,:),M(1)+100*M(2),'r--');
title([ 'Marker: ' num2str(marker) ' , thr: ' num2str(M(1)+100*M(2)) ])
pause

thr = [thr;marker,M(1)+100*M(2)];
end

sortrows(thr,2)
