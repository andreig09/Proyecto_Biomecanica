    function X_f_0 = filtrar_entrada(X_f_0,umbral)
    
    %close all;

    %frame_ini = min(Xi(4,:));
    %frame_ini = 20;
    %frame_fin = max(Xi(4,:));
    %sombra = 10;
    %{
    X=Xi(1,Xi(4,:)>=frame_ini&Xi(4,:)<=frame_ini+sombra);mean(X),std(X)
    Y=Xi(2,Xi(4,:)>=frame_ini&Xi(4,:)<=frame_ini+sombra);mean(Y),std(Y)
    Z=Xi(3,Xi(4,:)>=frame_ini&Xi(4,:)<=frame_ini+sombra);mean(Z),std(Z)
    
    figure(1)
    plot(Y,X,'kx',...
        min(Y):(max(Y)-min(Y))/9:max(Y),(mean(X)-std(X))*ones(1,10),'r',...
        min(Y):(max(Y)-min(Y))/9:max(Y),mean(X)*ones(1,10),'r',...
        min(Y):(max(Y)-min(Y))/9:max(Y),(mean(X)+std(X))*ones(1,10),'r',...
        (mean(Y)-std(Y))*ones(1,10),min(X):(max(X)-min(X))/9:max(X),'r',...
        mean(Y)*ones(1,10),min(X):(max(X)-min(X))/9:max(X),'r',...
        (mean(Y)+std(Y))*ones(1,10),min(X):(max(X)-min(X))/9:max(X),'r');
    xlabel('Y');ylabel('X');
    axis square;
    axis equal;
    figure(2)
    plot(X,Z,'kx');
    xlabel('X');ylabel('Z');
    axis square;
    axis equal;
    figure(3)
    plot(Y,Z,'kx');
    xlabel('Y');ylabel('Z');
    axis square;
    axis equal;
    figure(4)
    hist(X);
    %}
    
    %X_f_0 = Xi(1:3,Xi(4,:)==(frame_ini+delay));
    %X_f_1 = Xi(1:3,Xi(4,:)==(frame_ini+delay+1));
    
    distancias_entre_frames = [];
    blacklist = [];
    
    for i=1:size(X_f_0,2)
        for j=1:size(X_f_0,2)
           distancias_entre_frames(i,j) = norm(X_f_0(1:3,i)-X_f_0(1:3,j)); 
        end
        if isempty(find(blacklist==i))
            [I,J] = find(distancias_entre_frames(i,:)>umbral);
            blacklist = unique([blacklist,J]);
        end
    end
    
    aux = zeros(1,size(X_f_0,2));
    
    if ~isempty(blacklist)
        for i=1:size(blacklist,2)
            aux(blacklist(i)) = 1;
        end
    end
    
    distancias_entre_frames(aux==0,aux==0);
    
    X_f_0 = X_f_0(:,aux==0);
    
    %distancias_entre_frames;
    
    %close all
    %plot3(X_f_0(1,:),X_f_0(2,:),X_f_0(3,:),'bo');axis equal;
    
end