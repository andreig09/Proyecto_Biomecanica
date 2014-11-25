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
    
    % Marco los puntos a corregir
    X_out(6:7,X_out(5,:)==marker(i)&X_out(6,:)>thr(thr(:,1)==marker(i),2)) = NaN*ones(size(X_out(6:7,X_out(5,:)==marker(i)&X_out(6,:)>thr(thr(:,1)==marker(i),2))));
    
    % Busco el proximo invalido
    marker_i = X_out(:,find(isnan(X_out(7,:))==1&...
        X_out(5,:)==marker(i),1))
    
    if ~isempty(marker_i)
    
    % Busco el primer valido, luego del proximo invalido
    marker_j = X_out(:,find(isnan(X_out(7,:))==0&...
        X_out(5,:)==marker(i)&...
        X_out(4,:)>marker_i(4),1));
    
    end
    % Selecciono la cadena previa
    
    while ~isempty(marker_i) && ~isempty(marker_j)
    
    X_path = X_out(:,X_out(5,:)==marker(i)&X_out(4,:)<marker_i(4));
   
    M1=zeros(marker_j(4)-marker_i(4)+1,marker_j(4)-marker_i(4)+1+min([3,size(X_path,2)]));
    
    if size(X_path,2)==1
        for eq=1:size(M1,1)
            M1(eq,eq) = -1;
            M1(eq,eq+1) = 1;
        end
    elseif size(X_path,2)==2
        %X_path=X_path(:,size(X_path,2)-1:size(X_path,2));
        for eq=1:size(M1,1)
            M1(eq,eq) = 1;
            M1(eq,eq+1) = -2;
            M1(eq,eq+2) = 1;
        end
     
    elseif size(X_path,2)>=3
        X_path=X_path(:,size(X_path,2)-2:size(X_path,2));
        for eq=1:size(M1,1)
            M1(eq,eq) = -1;
            M1(eq,eq+1) = 3;
            M1(eq,eq+2) = -3;
            M1(eq,eq+3) = 1;
        end    
    end
    X_path
    M1
    A=M1(:,size(X_path,2)+1:size(M1,2)-1)
    B=-M1(:,1:size(X_path,2))*X_path(1:3,:)'-M1(:,size(M1,2))*marker_j(1:3,:)'
    X_aux = [(inv(A'*A)*A'*B)';...
        marker_i(4):marker_j(4)-1;...
        marker_i(5)*ones(1,marker_j(4)-marker_i(4));...
        NaN*ones(1,marker_j(4)-marker_i(4));...
        zeros(1,marker_j(4)-marker_i(4))];
    
    X_out(:,X_out(5,:)==marker(i)&...
        X_out(4,:)>=marker_i(4)&...
        X_out(4,:)<marker_j(4)) = X_aux;
    
    % Busco el proximo invalido
    marker_i = X_out(:,find(isnan(X_out(7,:))==1&...
        X_out(5,:)==marker(i),1))
    
    % Busco el primer valido, luego del proximo invalido
    
    if ~isempty(marker_i)
    
    marker_j = X_out(:,find(isnan(X_out(7,:))==0&...
        X_out(5,:)==marker(i)&...
        X_out(4,:)>marker_i(4),1));
  
    end
    
    end
    
end    
end

