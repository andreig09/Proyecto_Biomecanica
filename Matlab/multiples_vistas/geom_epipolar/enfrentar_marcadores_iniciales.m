function link_next = enfrentar_marcadores_iniciales(N1,N2,N3)
%{
ENTRADA

Ni - matriz DIM[2,3] filas, N[#marcadores@(frame)] columnas

N1 - Marcadores del frame (f)
N2 - Marcadores del frame (f+1)
N3 - Marcadores del frame (f+2)

SALIDA

link_next - Matriz,
    1era columna es el marcador en (f)
    2nda columna es el marcador en (f+1)
    4rta columna es la aceleracion resultante
%}
%%

        trayectorias = [];
        
        for i=1:size(N1,2)
            for j=1:size(N2,2)
                trayectorias=[trayectorias;i*ones(size(N3,2),1),j*ones(size(N3,2),1),(1:size(N3,2))',zeros(size(N3,2),1)];
            end;
        end;
        
        for i=1:size(trayectorias,1)
            trayectorias(i,4)=norm(N1(:,trayectorias(i,1))-2*N2(:,trayectorias(i,2))+N3(:,trayectorias(i,3)));
        end;
        
        aux = trayectorias;
        
        link_next = [];
        
        i=1;
        
        while ~isempty(aux)
            
            [min_acc,min_acc_index] = min(aux(:,4));
            
            link_next = [link_next;aux(aux(:,4)==min_acc,:)];
            
            aux = aux(aux(:,2)~=link_next(i,1)&aux(:,3)~=link_next(i,2),:);
            
            i=i+1;
            
        end;


end