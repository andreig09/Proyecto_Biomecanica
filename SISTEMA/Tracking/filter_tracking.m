function [X_out,thr] = filter_tracking(X_out)
thr = [];
marker = unique(X_out(5,X_out(5,:)~=0));
for i=1:size(marker,2)
    %calculo de umbral para cada marcador
    X_path = X_out(1:3,X_out(5,:)==marker(i));
    frames = X_out(4,X_out(5,:)==marker(i));
    
    frames = frames(:,3:size(X_path,2));
    aceleracion = sum((-X_path(:,3:size(X_path,2))+2*X_path(:,2:size(X_path,2)-1)-X_path(:,1:size(X_path,2)-2)).^2).^(1/2);
    
    thr = [thr;marker(i),median(prctile(aceleracion,90:0.1:100))];
    %{
    figure
    plot(frames,aceleracion,'b.-',[min(frames),max(frames)],median(prctile(aceleracion,90:0.1:100))*[1,1],'r--')
    %}
    marker(i)
    frame_filter = frames(:,aceleracion>thr(thr(:,1)==marker(i),2))

    X_old = X_out(:,X_out(5,:)==marker(i)&X_out(4,:)==frame_filter(1))
    X_new = X_old;
        
    if (frame_filter(1)-3)<min(X_out(4,X_out(5,:)==marker(i)))
        X_out(1:3,X_out(5,:)==marker(i)...
             &X_out(4,:)<frame_filter(1)...
             &X_out(4,:)>=frame_filter(1)-2) 
        X_out(1:3,X_out(5,:)==marker(i)...
             &X_out(4,:)<frame_filter(1)...
             &X_out(4,:)>=frame_filter(1)-2)*[-1,2]'
    else
        X_out(1:3,X_out(5,:)==marker(i)...
             &X_out(4,:)<frame_filter(1)...
             &X_out(4,:)>=frame_filter(1)-3)
        X_out(1:3,X_out(5,:)==marker(i)...
             &X_out(4,:)<frame_filter(1)...
             &X_out(4,:)>=frame_filter(1)-3)*[1,-3,3]'
    
    X_path = X_out(1:3,X_out(5,:)==marker(i));
    frames = X_out(4,X_out(5,:)==marker(i));
    frames = frames(:,3:size(X_path,2));
    aceleracion = sum((-X_path(:,3:size(X_path,2))+2*X_path(:,2:size(X_path,2)-1)-X_path(:,1:size(X_path,2)-2)).^2).^(1/2);
    
    frame_filter = frames(:,aceleracion>thr(thr(:,1)==marker(i),2))

end
return
end

