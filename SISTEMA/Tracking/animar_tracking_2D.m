function animar_tracking_2D(X_out,marker,skeleton)
    if nargin<2 && size(X_out,1)>4
        marker=min(unique(X_out(5,X_out(5,:)~=0)));
    end
    figure
    set(gcf,'units','normalized','outerposition',[0 0 1 1])
    pause
    for frame=min(X_out(4,:)):max(X_out(4,:))
        X_frame = X_out(:,X_out(4,:)==frame);
        plot(X_frame(1,:),X_frame(2,:),'b*');
        if size(X_out,1)>5
            labels = cellstr(num2str(X_frame(5,:)'));
            text(X_frame(1,:),X_frame(2,:),labels,'VerticalAlignment','bottom','HorizontalAlignment','right');
        end
        
        if nargin>2
            hold on
            skeleton_x=[];skeleton_y=[];skeleton_z=[];
            for bone=1:size(skeleton,1)
                skeleton_x=[skeleton_x;X_frame(1,X_frame(5,:)==skeleton(bone,1)),X_frame(1,X_frame(5,:)==skeleton(bone,2))];
                skeleton_y=[skeleton_y;X_frame(2,X_frame(5,:)==skeleton(bone,1)),X_frame(2,X_frame(5,:)==skeleton(bone,2))];                    
            end
            plot(skeleton_x',skeleton_y','-r');
            hold off
        end
        axis equal;
        axis([min(X_out(1,:)),max(X_out(1,:)),min(X_out(2,:)),max(X_out(2,:))]);        
        set(gcf,'units','normalized','outerposition',[0 0 1 1])
        title([ 'Frame ' num2str(frame) ]);
        pause(1/24)
    end
    
    
end