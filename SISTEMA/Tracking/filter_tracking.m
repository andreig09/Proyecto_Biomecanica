function [X_out,thr] = filter_tracking(X_out)

%{

Funcion que realiza el filtra cada trayectoria, buscando el "codo" en la
densidad de aceleracion para establecer un umbral, y filtrar las
trayectorias

%}

thr = [];
marker = unique(X_out(5,X_out(5,:)~=0));
for i=1:size(marker,2)
    %calculo de umbral para cada marcador
    X_path = X_out(1:3,X_out(5,:)==marker(i));
    
    if X_path(1:3,:)~=zeros(size(X_path(1:3,:)))
        
        frames = X_out(4,X_out(5,:)==marker(i));
        
        frames = frames(:,3:size(X_path,2));
        aceleracion = sum((-X_path(:,3:size(X_path,2))+2*X_path(:,2:size(X_path,2)-1)-X_path(:,1:size(X_path,2)-2)).^2).^(1/2);
        
        p=50:0.01:100;
        test = prctile(aceleracion,p);
        %figure
        %subplot(1,2,1)
        %plot(test,p,'b.-')
        %title(['Distribucion Aceleracion - Marker ' num2str(marker(i))]);
        %subplot(1,2,2)
        p=p(2:size(p,2));
        test=(test(2:size(test,2))-test(1:size(test,2)-1))./(test(1:size(test,2)-1));
        %plot(p,test,'b.-')
        thr_i = prctile(aceleracion,p(find(test==max(test),1)));
        %title(num2str(thr_i))
        %subplot(1,2,1)
        %hold on
        %plot(thr_i*[1,1],[min(p),max(p)],'r--');grid on;xlabel('Aceleracion');ylabel('Porcentaje')
        %pause
        %close(gcf)
        
        
        thr = [thr;...
            marker(i),...
            thr_i];
        
        %{
    %Filtro de "promedio"
    
    for f=min(X_out(4,:))+3:max(X_out(4,:))-3
        X_out(1:3,X_out(4,:)==f&X_out(5,:)==marker(i)) = (1/6)*(...
            -X_out(1:3,X_out(4,:)==(f-2)&X_out(5,:)==marker(i))...
            +4*X_out(1:3,X_out(4,:)==(f-1)&X_out(5,:)==marker(i)) ...
            +4*X_out(1:3,X_out(4,:)==(f+1)&X_out(5,:)==marker(i)) ...
            -X_out(1:3,X_out(4,:)==(f+2)&X_out(5,:)==marker(i)));
        %X_out(6,X_out(4,:)==f&X_out(5,:)==marker(i)) = NaN;
        %X_out(7,X_out(4,:)==f&X_out(5,:)==marker(i)) = NaN;
        
    end
    
            %}
            %Filtro
            
            
            % Marco los puntos a corregir
            X_out(6:7,X_out(5,:)==marker(i)&...
                (X_out(4,:)>min(X_out(4,:))+1)&...
                (...
                isnan(X_out(6,:))...
                |...
                X_out(6,:)>thr(thr(:,1)==marker(i),2)...
                )...
                ) ...
                = NaN*ones(size(...
                X_out(6:7,X_out(5,:)==marker(i)&...
                (X_out(4,:)>min(X_out(4,:))+1)&...
                (...
                isnan(X_out(6,:))...
                |X_out(6,:)>thr(thr(:,1)==marker(i),2)...
                )...
                )...
                )...
                );
            
            
            % Busco el proximo invalido
            marker_i = X_out(:,find(isnan(X_out(7,:))==1&...
                X_out(5,:)==marker(i),1));
            
            if ~isempty(marker_i)
                
                marker_i = X_out(:,X_out(5,:)==marker(i)&X_out(4,:)==(marker_i(4)-1));
                
                % Busco el primer valido, luego del proximo invalido
                marker_j = X_out(:,find(isnan(X_out(7,:))==0&...
                    X_out(5,:)==marker(i)&...
                    X_out(4,:)>marker_i(4),1));
                
            end
            % Selecciono la cadena previa
            
            while ~isempty(marker_i) && ~isempty(marker_j)
                
                
                X_path = X_out(:,X_out(5,:)==marker(i)&X_out(4,:)<marker_i(4));
                
                M = [];
                
                M1=zeros(marker_j(4)-marker_i(4)+1,marker_j(4)-marker_i(4)+1+min([3,size(X_path,2)]));
                
                if size(X_path,2)==1
                    for eq=1:size(M1,1)
                        M1(eq,eq) = -1;
                        M1(eq,eq+1) = 1;
                    end
                    
                    M=[M1];
                    
                elseif size(X_path,2)==2
                    %X_path=X_path(:,size(X_path,2)-1:size(X_path,2));
                    
                    M2 = zeros(size(M1));
                    
                    for eq=1:size(M1,1)
                        M1(eq,eq) = 1;
                        M1(eq,eq+1) = -2;
                        M1(eq,eq+2) = 1;
                        
                        M2(eq,eq+1) = -1;
                        M2(eq,eq+2) = 1;
                    end
                    
                    M=[M1;M2];
                    
                elseif size(X_path,2)>=3
                    
                    X_path=X_path(:,size(X_path,2)-2:size(X_path,2));
                    
                    M2 = zeros(size(M1));
                    
                    M3 = zeros(size(M1));
                    
                    for eq=1:size(M1,1)
                        M1(eq,eq) = -1;
                        M1(eq,eq+1) = 3;
                        M1(eq,eq+2) = -3;
                        M1(eq,eq+3) = 1;
                        
                        M2(eq,eq+1) = 1;
                        M2(eq,eq+2) = -2;
                        M2(eq,eq+3) = 1;
                        
                        M3(eq,eq+2) = 1;
                        M3(eq,eq+3) = -1;
                        
                    end
                    
                    M = [M1;M2;M3];
                    
                end
                %X_path;
                
                A=M(:,size(X_path,2)+1:size(M,2)-1);
                B=-M(:,1:size(X_path,2))*X_path(1:3,:)'-M(:,size(M,2))*marker_j(1:3,:)';
                A;
                B;
                X_path;
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
                    X_out(5,:)==marker(i),1));
                
                % Busco el primer valido, luego del proximo invalido
                
                if ~isempty(marker_i)
                    
                    marker_i = X_out(:,X_out(5,:)==marker(i)&X_out(4,:)==(marker_i(4)-1));
                    
                    marker_j = X_out(:,find(isnan(X_out(7,:))==0&...
                        X_out(5,:)==marker(i)&...
                        X_out(4,:)>marker_i(4),1));
                    
                end
                
            end
            
            %%
            
    end
end
end

