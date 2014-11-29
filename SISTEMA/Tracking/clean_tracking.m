function X_out = clean_tracking(X_out)
%% Limpieza de puntos con nula aceleracion, posterior al inicio

X_out = (X_out(:,~(X_out(6,:)==0&X_out(4,:)>min(X_out(4,:)))));

%% Limpieza de puntos no trackeados
X_out = X_out(:,X_out(5,:)~=0);

%% Limpieza de trayectorias truncas

total_frames = max(X_out(4,:))-min(X_out(4,:));

for n_path=1:max(X_out(5,:))
    if size(X_out(:,X_out(5,:)==n_path),2)<0.9*total_frames
        X_out = X_out(:,X_out(5,:)~=n_path);
    end
end

end