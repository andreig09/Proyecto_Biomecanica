function thr = histograma_tracking(X_out,porcentaje)
n_bins = 100;
[A,B]=hist(X_out(7,X_out(7,:)<10*median(X_out(7,:))),n_bins);
figure
hist(X_out(7,X_out(7,:)<10*median(X_out(7,:))),n_bins);
bins = mean(B(2:length(B))-B(1:length(B)-1));
area_total = sum(A*bins);
area_parcial = [];

for i=1:length(A)
    area_parcial(i) = sum(A(1:i)*bins);
end
%figure
%plot(B,100*area_parcial/area_total,'.')
C=[100*area_parcial/area_total;B];
thr = C(2,find(C(1,:)>porcentaje,1));
disp([  num2str(porcentaje) '% @ ' num2str(thr)]);
end