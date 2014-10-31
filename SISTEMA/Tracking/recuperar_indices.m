function [Xi_aux,X_out_aux] = recuperar_indices(Xi,X_out)
%Funcion que permite recuperar la informacion de que indice de marcador
%corresponde a cada columna de X_i y X_out.
%Se devuelve las mismas matrices, pero con una fila extra indicando el
%indice de marcador de la columna
X1 = [Xi;(-1)*ones(1,size(Xi,2))];
X2 = [X_out;(-1)*ones(1,size(X_out,2))];
for frame=min(X2(4,:)):max(X2(4,:))
    X1_frame = X1(:,X1(4,:)==frame);
    X2_frame = X2(:,X2(4,:)==frame);
    
    X1(5,X1(4,:)==frame) = 1:size(X1_frame,2);
    for j=1:size(X2_frame,2)
        [~,J] = find(ismember(X1_frame(1:3,:),X2_frame(1:3,j)),1);
        if ~isempty(J)
            X2_frame(8,j) = J;
        end
    end
    X2(8,X2(4,:)==frame) = X2_frame(8,:);
end
X_out_aux = X2;
Xi_aux = X1;
end