clc;
clear all;
close all;
%% Cargo Datos relevados, 77 frames, en 13 marcadores
%   M =[  x   y   z   fila    marcador    frame  ]
load('wave_ground_truth.mat');
% Elijo marcador entre 0 y 12. Si es mas de un marcador, lo armo como
% matriz
marcador = 0:12;
marcador = 4;
M(:,2)=-M(:,2);
x=[];y =[];z =[];
for i=1:length(marcador)
    x = [x;M(find(M(:,5)==marcador(i)),1)'];
    y = [y;M(find(M(:,5)==marcador(i)),2)'];
    z = [z;M(find(M(:,5)==marcador(i)),3)'];
end



% "Periodizo" artificalmente
%{
x= [x,x,x];
y= [y,y,y];
z= [z,z,z];
%}
% Elijo los ejes a graficar
X = y;
label_X = 'y';

Y = z;
label_Y = 'z';

for i=1:length(X)
   if length(marcador)>1
       plot(X(:,i),Y(:,i),'x');
   else
       plot(X(:,1:i),Y(:,1:i),'x');
   end;
   xlabel(label_X);ylabel(label_Y);
   axis([min(min(X)),max(max(X)),min(min(Y)),max(max(Y))]);
   axis square;
   pause(1/60);
end;
if length(marcador)==1
    figure
    subplot(2,1,1)
    plot(X,'.');
    xlabel('frame');ylabel(label_X);
    subplot(2,1,2)
    plot(Y,'.');
    xlabel('frame');ylabel(label_Y);
end;