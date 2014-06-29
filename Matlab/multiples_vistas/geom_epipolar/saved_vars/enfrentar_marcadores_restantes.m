function link_next = enfrentar_marcadores_restantes(N1,N2,N3,N4,marker,link_prev,link_next)



marker = marker(link_prev>0);
link_prev = link_prev(link_prev>0);

trayectorias = [];

for i=1:length(marker)
    
    I3 = link_next;
    
    for j=1:length(I3)
        
        I4 = (1:size(N4,2))';
        trayectorias = [trayectorias;...
            link_prev(i)*ones(length(I4),1),...
            marker(i)*ones(length(I4),1),...
            I3(j)*ones(length(I4),1),...
            I4];
    end
end

for i=1:size(trayectorias,1)
    trayectorias(i,5)=delta_aceleracion(N1(:,trayectorias(i,1)),N2(:,trayectorias(i,2)),N3(:,trayectorias(i,3)),N4(:,trayectorias(i,4)));
    a1 = N2(:,trayectorias(i,2))-N1(:,trayectorias(i,1));
    a2 = N3(:,trayectorias(i,3))-N2(:,trayectorias(i,2));
    trayectorias(i,6) = acos(dot(a2,a1)/(norm(a1)*norm(a2)))*180/pi;
end;

aux = trayectorias;

link_next = [];

i=1;

while ~isempty(aux)
    
    [min_acc,min_acc_index] = min(aux(:,5));
    
    link_next = [link_next;aux(aux(:,5)==min_acc,2:5)];
    
    aux = aux(aux(:,2)~=link_next(i,1)&aux(:,3)~=link_next(i,2),:);
    
    i=i+1;
    
end;
end