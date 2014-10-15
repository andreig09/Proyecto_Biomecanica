function rmse=rmse_segmentacion_ground(Xi,Yi)

rmse = [];

for frame=min(Xi(4,:)):max(Xi(4,:))
    xi = Xi(1:3,Xi(4,:)==frame);
    yi = Yi(1:3,Yi(4,:)==frame);
    matcheo = matcheo_intraframe_segmentacion_ground(xi,yi);
    rmse = [rmse,sqrt(sum((xi(:,matcheo(:,1))-yi(:,matcheo(:,2))).^2))];
end

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
            [I,J]=find(aux==min(min(aux)));aux_ij = aux(I,J);
            aux = aux(setdiff(1:size(aux,1),I),setdiff(1:size(aux,2),J));
            [I,J]=find(matriz==aux_ij);
            matcheo = [matcheo;I,J];
        end
    end

rmse = mean(rmse);

end