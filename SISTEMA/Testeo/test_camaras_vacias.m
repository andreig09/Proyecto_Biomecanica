clc

m_cantidad = [];

j_x = [];

for i=min(rmse_i_total(4,:)):max(rmse_i_total(4,:))
    for j=min(rmse_i_total(5,:)):max(rmse_i_total(5,:))
        cantidad = size(rmse_i_total(:,rmse_i_total(5,:)==j&rmse_i_total(4,:)==i),2);
        m_cantidad(i+1-min(rmse_i_total(4,:)),j+1-min(rmse_i_total(5,:)))= cantidad;
        if cantidad<=1
            j_x = [j_x,j];
        end
    end;
end;

disp('Camaras Vacias')
disp(unique(j_x))
disp('Camaras a Utilizar :')
disp(setdiff(min(rmse_i_total(5,:)):max(rmse_i_total(5,:)),unique(j_x)))
        