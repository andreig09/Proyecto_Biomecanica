clc
close all
marker=13;
limit = 0.3;
X_marker = X_out(:,X_out(5,:)==marker);
%X_marker = X_marker(:,X_marker(4,:)<=80&X_marker(4,:)>=60);

f_test = [];x_test=[];

for frame=(min(unique(X_marker(4,:)))+2):(max(unique(X_marker(4,:)))-1)
    x_estimado = X_marker(1:3,X_marker(4,:)>=(frame-2)&X_marker(4,:)<=frame)*[1,-3,3]';
    x_previo = X_marker(1:3,X_marker(4,:)==frame);
    f_test = [f_test,frame+1];
    x_test = [x_test,norm(x_estimado-x_previo)/X_marker(7,X_marker(4,:)==(frame))];
    %x_test = [x_test,X_marker(7,X_marker(4,:)==(frame+1))/X_marker(7,X_marker(4,:)==(frame))];
end
%{
plot3(X_marker(1,:),X_marker(2,:),X_marker(3,:),'b.',...
    X_marker(1,isnan(X_marker(6,:))),X_marker(2,isnan(X_marker(6,:))),X_marker(3,isnan(X_marker(6,:))),'rs')
axis equal;
%}
figure
plot(X_marker(4,:),X_marker(7,:),'.-')
figure
plot(f_test,x_test,'.-',...
    f_test,(1+limit)*ones(size(f_test)),'r--',...
    f_test,(1-limit)*ones(size(f_test)),'r--')
%plot(X_marker(7,2:length(X_marker))./X_marker(7,1:length(X_marker)-1),'.')