function [X_,enlazado]=do_tracking(X)

if size(X,2)<size(X,1)
    X=X';
end

if size(X,1)==4
    if(X(3,:)==ones(1,size(X,2)))
        dim_max=2;
    else
        dim_max=3;
    end;
else
    dim_max=2;
end;

f_ini=min(X(size(X,1),:));
f_fin=max(X(size(X,1),:));

d3=Inf;d4=Inf;

for frame=f_ini:(f_fin-1)
    
    if(mod(frame,10)==0)
        disp([ 'Tracking... ' num2str(100*(frame-f_ini)/(f_fin-1-f_ini)) '%']);
        clc;
    end;
    
    X_f0=X(1:dim_max,X(size(X,1),:)==frame);
    X_f1=X(1:dim_max,X(size(X,1),:)==frame+1);
    X_f2=X(1:dim_max,X(size(X,1),:)==frame+2);
    
    if frame==f_ini
        
        %% Inicializacioon de Tracking, por cadena con menor aceleracion;
        link_next=enfrentar_marcadores_iniciales(X_f0,X_f1,X_f2);
    else
        X_f_prev=X(1:dim_max,X(size(X,1),:)==frame-1);
        % Cargo los marcadores a enfrentar del frame (f) a enlazar
        marker_versus = 1:size(X_f0,2);
        % Busco los enlaces previos de los marcadores a enfrentar
        link_prev = enlazado.frame(frame-f_ini+1).marcador(marker_versus);
        % Calculo los enlaces proximos
        link_next = enfrentar_marcadores_multiples_v2(X_f_prev,X_f0,X_f1,X_f2,marker_versus,link_prev,d3,d4);
        
        if size(link_next,1) ~= size(X_f0,2)
            
            % Si no se encontro ningun enlace, inicializo el vector
            % link_next
            
            if isempty(link_next)
                link_next=[0,0,0,0];
            end
            
            link_next = [link_next;...
                enfrentar_marcadores_restantes(X_f_prev,X_f0,X_f1,X_f2,...% Marcadores de X_f0 que no fueron enlazados
                setdiff((1:size(X_f0,2))',link_next(:,1)),...% Enlaces previos de los marcadores de X_f0 que no fueron encontrados
                enlazado.frame(frame-f_ini+1).marcador(setdiff((1:size(X_f0,2))',link_next(:,1))),...% Marcadores de X_f1 que no fueron enlazados
                setdiff((1:size(X_f1,2))',link_next(:,2)))];
            
            % Quito los marcadores cuya primer columna tengo enlaces nulos
            
            link_next=link_next(link_next(:,1)>0,:);
            
        end;
        
        N5=[enlazado.frame(frame-f_ini+1).marcador(link_next(:,1))',link_next];
        
        % Calculo las distancias entre  X_f1 y (2*X_f0-X_f_prev), d3
        %                               X_f2 y (2*X_f1-X_f0), d4
        % Usando los enlaces obtenidos, para la proxima iteracion
        
        d3 = mean(sqrt(sum(X_f1(:,N5(:,3))'-(2*X_f0(:,N5(:,2))-X_f_prev(:,N5(:,1)))').^2));
        d4 = mean(sqrt(sum(X_f2(:,N5(:,4))'-(2*X_f1(:,N5(:,2))-X_f0(:,N5(:,1)))').^2));
        
    end
    
    for i=1:size(link_next,1)
        enlazado.frame(frame-f_ini+1+1).marcador(link_next(i,2))=link_next(i,1);
        enlazado.frame(frame-f_ini+1+1).d_acc(link_next(i,2))=link_next(i,4);
    end;
    
    index_marcadores_actual=X(4,:)==frame;
    cantidad_actual = size(X(:,X(size(X,1),:)==frame),2);
    
    if frame==f_ini
        %inicializo los indices de marcadores
        %fila INDEX+1, indices de marcadores frame a frame
        %fila INDEX+2, indices de marcadores en frame original
        X_=X;
        X_(size(X,1)+1,index_marcadores_actual)=1:cantidad_actual;
        %X_(size(X,1)+2,index_marcadores_actual)=1:cantidad_actual;
    else
        
        index_marcadores_previo=(X(4,:)==frame-1);
        
        track_previo = X_(size(X,1)+1,index_marcadores_previo);
        
        enlaces = enlazado.frame(frame-f_ini+1).marcador;
        d_acc = enlazado.frame(frame-f_ini+1).d_acc;
        
        X_(size(X,1)+1,index_marcadores_actual)=track_previo(enlaces(1:cantidad_actual));
        X_(size(X,1)+2,index_marcadores_actual)=d_acc(1:cantidad_actual);
        
        x_actual=X_(:,index_marcadores_actual);
        x_previo=X_(:,index_marcadores_previo);
        
        x_dim=size(X,1)+3;
        
        for marker=min(x_actual(5,:)):max(x_actual(5,:))
            x_actual(x_dim,x_actual(5,:)==marker)=norm(x_actual(1:3,x_actual(5,:)==marker)-x_previo(1:3,x_previo(5,:)==marker));
        end;
        
        X_(x_dim,index_marcadores_actual)=x_actual(size(x_actual,1),:);
        
        %disp(num2str(enlaces));
        %pause(0.1);
        %X_(size(X,1)+2,index_marcadores_actual)=1:cantidad_actual;
        %disp('fuck');
        
    end;
end;


end