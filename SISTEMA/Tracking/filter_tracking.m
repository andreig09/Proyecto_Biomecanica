function [ X_out ] = filter_tracking( X_out )
    close all
    thr = 0.3;
    markers = unique(X_out(5,X_out(5,:)~=0))
    for i=1:size(markers,2)
    figure(i)
        X_i = X_out(:,X_out(5,:)==markers(i));
        
        X_3 = X_i(1:3,3:size(X_i,2)); 
        
        X_2 = X_i(1:3,2:size(X_i,2)-1);
        
        X_1 = X_i(1:3,1:size(X_i,2)-2);
        
        X_aux = 2*X_2-X_1;
        
        f_i = X_out(4,X_out(5,:)==markers(i));
        
        plot(f_i,...
            X_i(3,:),'b.-')
        
    
    end
end

