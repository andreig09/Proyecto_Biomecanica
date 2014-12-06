%% Tracking en camara 7 de 8_07_100_200, resaltando marcadores con tracking valido

X_out = make_tracking(Xi,Inf)

clc
close all

markers=unique(X_out(5,X_out(5,:)~=0));

X_valid = [];

total_frames = max(X_out(4,:))-min(X_out(4,:))+1

for n_marker=1:size(markers,2)
    if (size(X_out(:,X_out(5,:)==markers(n_marker)),2)/total_frames)>0.9
        X_valid = [X_valid,X_out(:,X_out(5,:)==markers(n_marker))];
    end
end

plot(X_out(1,:),X_out(2,:),'b.',X_valid(1,:)',X_valid(2,:)','go')
xlabel('X (pixels)');
ylabel('Y (pixels)');
title('Tracking 2D - Camara 7');
legend('Segmentacion','Trayectorias Trackeadas');

axis equal
