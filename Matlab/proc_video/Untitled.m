clc;
clear all;
close all;
%% Cargo Datos relevados, 77 frames, en 13 marcadores
%   M =[  x   y   z   fila    marcador    frame  ]
load('wave_ground_truth.mat');
% Elijo marcador entre 0 y 12. Si es mas de un marcador, lo armo como
% matriz
marcador = 0:12;
x=[];y =[];z =[];
for i=1:length(marcador)
    x = [x;M(find(M(:,5)==marcador(i)),1)'];
    y = [y;M(find(M(:,5)==marcador(i)),2)'];
    z = [z;M(find(M(:,5)==marcador(i)),3)'];
end
% Elijo los ejes a graficar
X = y;
Y = z;

for i=1:length(X)
   plot(X(:,i),Y(:,i),'+');
   axis([min(min(X)),max(max(X)),min(min(Y)),max(max(Y))]);
   axis square;
   pause(1/60);
end;
