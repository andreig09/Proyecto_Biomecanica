function marker_frame = get_frame_from_tracking(X,x,y,z)
    if x<0
        x_min=1.005*x;x_max=0.995*x;
    else
        x_min=0.995*x;x_max=1.005*x;
    end
    if y<0
        y_min=1.005*y;y_max=0.995*y;
    else
        y_min=0.995*y;y_max=1.005*y;
    end
    if z<0
        z_min = 1.005*z;z_max = 0.995*z;
    else
        z_max = 1.005*z;z_min = 0.995*z;
    end
    marker_frame = X(:,X(1,:)>x_min&X(1,:)<x_max&X(2,:)>y_min&X(2,:)<y_max&X(3,:)>z_min&X(3,:)<z_max);
end