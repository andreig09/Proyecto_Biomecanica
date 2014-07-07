function link_next_versus = enfrentar_marcadores_multiples(N1,N2,N3,marker_versus,link_prev_versus,d3)
    
    marker_versus = marker_versus(link_prev_versus>0);
    link_prev_versus = link_prev_versus(link_prev_versus>0);
    
    trayectorias_versus = [];

    for i=1:length(marker_versus)
        if nargin>5
            I3 = vecinos_intraframe(N3', (2*N2(:,marker_versus(i))-N1(:,link_prev_versus(i)))', d3);
        else
            I3=(1:length(N3))';
        end
        trayectorias_versus = [trayectorias_versus;link_prev_versus(i)*ones(length(I3),1),marker_versus(i)*ones(length(I3),1),I3];
    end

    for i=1:size(trayectorias_versus,1)
        trayectorias_versus(i,4) = norm(N3(:,trayectorias_versus(i,3))-2*N2(:,trayectorias_versus(i,2))+N1(:,trayectorias_versus(i,1)));
    end

    %trayectorias_versus = sortrows(trayectorias_versus,4);

    aux = trayectorias_versus;

    link_next_versus = [];
    
    i=1;
    
    while ~isempty(aux)

        [min_acc,min_acc_index] = min(aux(:,4));

        link_next_versus = [link_next_versus;aux(aux(:,4)==min_acc,2:4)];

        aux = aux(aux(:,2)~=link_next_versus(i,1)&aux(:,3)~=link_next_versus(i,2),:);
        
        i=i+1;

    end
end