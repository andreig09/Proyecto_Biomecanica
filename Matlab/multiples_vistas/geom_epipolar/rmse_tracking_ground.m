function matcheo_tracking_ground = rmse_tracking_ground(tracking,ground)
    
    frame_ini = max([min(tracking(4,:)),min(ground(4,:))])
    frame_fin = min([max(tracking(4,:)),max(ground(4,:))])
    marker_tracking = unique(tracking(5,:));
    marker_ground = unique(ground(5,:));

    %% Matchear los marcadores en primer frame

    tracking(:,tracking(4,:)==frame_ini);
    ground(:,ground(4,:)==frame_ini);

    distancias_tracking_ground = [];

    for n_marker_tracking = 1:length(marker_tracking)
        for n_marker_ground = 1:length(marker_ground)
            distancias_tracking_ground(n_marker_ground,n_marker_tracking) = norm(tracking(1:3,tracking(4,:)==frame_ini&tracking(5,:)==marker_tracking(n_marker_tracking))...
                -ground(1:3,ground(4,:)==frame_ini&ground(5,:)==marker_ground(n_marker_ground)));
        end
    end

    matcheo_tracking_ground = [];
    for j=1:size(distancias_tracking_ground,2)
        [I,J] = find(distancias_tracking_ground(:,j)==min(distancias_tracking_ground(:,j)));
        matcheo_tracking_ground = [matcheo_tracking_ground;...
            marker_tracking(j),...
            marker_ground(I),...
            mean(sqrt(sum((tracking(1:3,tracking(4,:)>=frame_ini&tracking(4,:)<=frame_fin&tracking(5,:)==marker_tracking(j))...
            -ground(1:3,ground(4,:)>=frame_ini&ground(4,:)<=frame_fin&ground(5,:)==marker_ground(I))).^2))),...
            min(sqrt(sum((tracking(1:3,tracking(4,:)>=frame_ini&tracking(4,:)<=frame_fin&tracking(5,:)==marker_tracking(j))...
            -ground(1:3,ground(4,:)>=frame_ini&ground(4,:)<=frame_fin&ground(5,:)==marker_ground(I))).^2))),...
            max(sqrt(sum((tracking(1:3,tracking(4,:)>=frame_ini&tracking(4,:)<=frame_fin&tracking(5,:)==marker_tracking(j))...
            -ground(1:3,ground(4,:)>=frame_ini&ground(4,:)<=frame_fin&ground(5,:)==marker_ground(I))).^2)))];
    end

    disp(['path_tracking - path_ground - RMSE - E_{min} - E_{max}']);

    matcheo_tracking_ground = sortrows(matcheo_tracking_ground,3);

end