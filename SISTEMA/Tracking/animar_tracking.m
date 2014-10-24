function animar_tracking(X_out,marker,skeleton)
    if nargin==1
        if size(X_out,1)>4
            marker=min(X_out(5,:));
        end
    end
    close all
    figure
    for n_frame=min(X_out(4,:)):max(X_out(4,:))
        X_frame = X_out(:,X_out(4,:)==n_frame);
        if size(X_out,1)>4
            plot3(X_frame(1,:),X_frame(2,:),X_frame(3,:),'o',...
                X_out(1,X_out(4,:)==n_frame&X_out(5,:)==marker),X_out(2,X_out(4,:)==n_frame&X_out(5,:)==marker),X_out(3,X_out(4,:)==n_frame&X_out(5,:)==marker),'rs',...
                X_out(1,X_out(4,:)<=n_frame&X_out(5,:)==marker),X_out(2,X_out(4,:)<=n_frame&X_out(5,:)==marker),X_out(3,X_out(4,:)<=n_frame&X_out(5,:)==marker),'r.');
            if nargin==3
                skeleton_x=[];skeleton_y=[];skeleton_z=[];
                for bone=1:size(skeleton,1)
                    
                    skeleton_x=[skeleton_x;X_frame(1,X_frame(5,:)==skeleton(bone,1)),X_frame(1,X_frame(5,:)==skeleton(bone,2))];
                    skeleton_y=[skeleton_y;X_frame(2,X_frame(5,:)==skeleton(bone,1)),X_frame(2,X_frame(5,:)==skeleton(bone,2))];
                    skeleton_z=[skeleton_z;X_frame(3,X_frame(5,:)==skeleton(bone,1)),X_frame(3,X_frame(5,:)==skeleton(bone,2))];
                    
                end
                hold on
                plot3(skeleton_x',skeleton_y',skeleton_z','-r');
            else
            end
            labels = cellstr(num2str(X_frame(5,:)'));
            text(X_out(1,X_out(4,:)==n_frame),X_out(2,X_out(4,:)==n_frame),X_out(3,X_out(4,:)==n_frame),labels,'VerticalAlignment','bottom','HorizontalAlignment','right');
            axis equal;
        axis([...
        min(X_out(1,X_out(4,:)<=max(X_out(4,X_out(5,:)~=0)))),...
        max(X_out(1,X_out(4,:)<=max(X_out(4,X_out(5,:)~=0)))),...
        min(X_out(2,X_out(4,:)<=max(X_out(4,X_out(5,:)~=0)))),...
        max(X_out(2,X_out(4,:)<=max(X_out(4,X_out(5,:)~=0)))),...
        min(X_out(3,X_out(4,:)<=max(X_out(4,X_out(5,:)~=0)))),...
        max(X_out(3,X_out(4,:)<=max(X_out(4,X_out(5,:)~=0)))) ]);
        else
            plot3(X_out(1,X_out(4,:)==n_frame),X_out(2,X_out(4,:)==n_frame),X_out(3,X_out(4,:)==n_frame),'o');
            axis equal;
        end
    hold off;    
    pause(0.01);
    end
end