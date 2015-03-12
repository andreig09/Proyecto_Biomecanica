function mostrar_trayectorias(X_out,n_marker)
        
    clc
    close all

    figure
        
    if nargin ==1
        n_marker=0;
    end
    plot3(X_out(1,:),X_out(2,:),X_out(3,:),'b.',...
        X_out(1,X_out(5,:)==n_marker),X_out(2,X_out(5,:)==n_marker),X_out(3,X_out(5,:)==n_marker),'go');
    axis equal;
    grid on;
    xlabel('X(m)');
    ylabel('Y(m)');
    zlabel('Z(m)');
    
    if n_marker~=0
        title(['Marcador ',num2str(n_marker)])
        figure
        X_marker = X_out(1:4,X_out(5,:)==n_marker);
        plot3(X_marker(1,:),X_marker(2,:),X_marker(3,:),'b.');
        axis equal;
        grid on;
        xlabel('X(m)');
        ylabel('Y(m)');
        zlabel('Z(m)');
        
        figure
        subplot(3,1,1)
        velocidad = sum((X_marker(1:3,2:size(X_marker,2))-X_marker(1:3,1:size(X_marker,2)-1)).^2).^(1/2);
        plot(X_marker(4,2:size(X_marker,2)),velocidad,'b.-',...
            [min(X_marker(4,3:size(X_marker,2))),max(X_marker(4,3:size(X_marker,2)))],median(prctile(velocidad,90:0.1:100))*[1,1],'r--')
        title(['Marker ' num2str(n_marker) ' - Velocidad']);
        xlabel('Frame');ylabel('metro/frame');
        
        subplot(3,1,2)
        aceleracion = sum((-X_marker(1:3,3:size(X_marker,2))+2*X_marker(1:3,2:size(X_marker,2)-1)-X_marker(1:3,1:size(X_marker,2)-2)).^2).^(1/2);
        plot(X_marker(4,3:size(X_marker,2)),aceleracion,'b.-',...
            [min(X_marker(4,3:size(X_marker,2))),max(X_marker(4,3:size(X_marker,2)))],median(prctile(aceleracion,90:0.1:100))*[1,1],'r--')
        title(['Marker ' num2str(n_marker) ' - Aceleracion']);
        xlabel('Frame');ylabel('metro/frame^2');
        subplot(3,1,3)
        v_aceleracion = sum((-X_marker(1:3,4:size(X_marker,2))+3*X_marker(1:3,3:size(X_marker,2)-1)-3*X_marker(1:3,2:size(X_marker,2)-2)+X_marker(1:3,1:size(X_marker,2)-3)).^2).^(1/2);
        plot(X_marker(4,4:size(X_marker,2)),v_aceleracion,'b.-',...
            [min(X_marker(4,3:size(X_marker,2))),max(X_marker(4,3:size(X_marker,2)))],median(prctile(v_aceleracion,90:0.1:100))*[1,1],'r--')
        title(['Marker ' num2str(n_marker) ' - Var.Aceleracion']);
        xlabel('Frame');ylabel('metro/frame^3');   
    
    end
    
    

end