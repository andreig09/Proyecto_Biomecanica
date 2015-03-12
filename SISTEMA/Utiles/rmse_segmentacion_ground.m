function [rmse,rmse_i,q_x,q_y,matcheo_inicial,rmse_i_t]=rmse_segmentacion_ground(Xi,Yi)
%Implementa metricas para comparar performance
%Xi, datos a comparar, Yi ground truth

rmse = [];

q_x = [zeros(2,size(Xi,2));Xi(4,:)];

q_y = [zeros(2,size(Yi,2));Yi(4,:)];

for frame=min(Xi(4,:)):max(Xi(4,:))
    xi = Xi(1:3,Xi(4,:)==frame);
    yi = Yi(1:3,Yi(4,:)==frame);
    
    q_x(1,Xi(4,:)==frame) = 1:size(xi,2);
    q_y(1,Yi(4,:)==frame) = 1:size(yi,2);
    
    matcheo = matcheo_intraframe_segmentacion_ground(xi,yi);

    if frame==min(Xi(4,:))
        Xi(:,Xi(4,:)==frame);
        Yi(:,Yi(4,:)==frame);
        matcheo_inicial = matcheo;
    end
    
    if ~isempty(matcheo)
    
    rmse = [rmse,...
        [sqrt(sum((xi(:,matcheo(:,1))-yi(:,matcheo(:,2))).^2));...
        matcheo(:,1)';...
        matcheo(:,2)';...
        frame*ones(1,size(matcheo,1))]];
    setdiff(1:size(xi,2),matcheo(:,1)');
    setdiff(1:size(yi,2),matcheo(:,2)');
    
    end
    
end

rmse_i = rmse;
rmse = mean(rmse(1,:));

rmse_i_t = [];
for t=min(rmse_i(4,:)):max(rmse_i(4,:))
    rmse_i_t(:,t) = [mean(rmse_i(1,rmse_i(4,:)==t));t];
end


%%

function matriz = distancia_intraframe_segmentacion_ground(xi,yi)
        matriz = [];
        for i=1:size(xi,2)
            for j=1:size(yi,2)
                matriz(i,j) = norm(xi(:,i)-yi(:,j));
            end
        end
    end

    function matcheo = matcheo_intraframe_segmentacion_ground(xi,yi)
        matriz = distancia_intraframe_segmentacion_ground(xi,yi);
        matcheo = [];
        aux = matriz;
        while ~isempty(aux)
            [I,J]=find(aux==min(min(aux)),1);
            aux_ij = aux(I,J);
            aux = aux(setdiff(1:size(aux,1),I),setdiff(1:size(aux,2),J));
            [I,J]=find(matriz==aux_ij);
            matcheo = [matcheo;I,J];
        end
    end

end