function animar_tracking(X_out,marker,sombra)
    if nargin==1
        if size(X_out,1)>4
            marker=min(X_out(5,:));
        end
        sombra = 1;
    end
    close all
    figure
    for n_frame=min(X_out(4,:)):max(X_out(4,:))
        if size(X_out,1)>4
            plot3(X_out(1,X_out(4,:)<=n_frame&X_out(4,:)>max([min(X_out(4,:)),n_frame-sombra])),X_out(2,X_out(4,:)<=n_frame&X_out(4,:)>max([min(X_out(4,:)),n_frame-sombra])),X_out(3,X_out(4,:)<=n_frame&X_out(4,:)>max([min(X_out(4,:)),n_frame-sombra])),'o',...
            X_out(1,X_out(4,:)<=n_frame&X_out(4,:)>max([min(X_out(4,:)),n_frame-sombra])&X_out(5,:)==marker),X_out(2,X_out(4,:)<=n_frame&X_out(4,:)>max([min(X_out(4,:)),n_frame-sombra])&X_out(5,:)==marker),X_out(3,X_out(4,:)<=n_frame&X_out(4,:)>max([min(X_out(4,:)),n_frame-sombra])&X_out(5,:)==marker),'rs');
            axis equal;
        axis([...
        min(X_out(1,X_out(4,:)<=max(X_out(4,X_out(5,:)~=0)))),...
        max(X_out(1,X_out(4,:)<=max(X_out(4,X_out(5,:)~=0)))),...
        min(X_out(2,X_out(4,:)<=max(X_out(4,X_out(5,:)~=0)))),...
        max(X_out(2,X_out(4,:)<=max(X_out(4,X_out(5,:)~=0)))),...
        min(X_out(3,X_out(4,:)<=max(X_out(4,X_out(5,:)~=0)))),...
        max(X_out(3,X_out(4,:)<=max(X_out(4,X_out(5,:)~=0)))) ]);
        else
            plot3(X_out(1,X_out(4,:)<=n_frame&X_out(4,:)>max([min(X_out(4,:)),n_frame-sombra])),X_out(2,X_out(4,:)<=n_frame&X_out(4,:)>max([min(X_out(4,:)),n_frame-sombra])),X_out(3,X_out(4,:)<=n_frame&X_out(4,:)>max([min(X_out(4,:)),n_frame-sombra])),'o');
            axis equal;
        end
        
    pause(0.01);
    end
end