close all;
clear all;
clc;
%{
load('marker3D.mat');
j=1;
for i=1:length(marker3D(j).X(1,:))
    
    plot3(marker3D(j).X(1,1:i),...
        marker3D(j).X(2,1:i),...
        marker3D(j).X(3,1:i),'+');
    title(marker3D(j).name);
    axis([min(marker3D(j).X(1,:)),max(marker3D(j).X(1,:)),...
        min(marker3D(j).X(2,:)),max(marker3D(j).X(2,:)),...
        min(marker3D(j).X(3,:)),max(marker3D(j).X(3,:))]);
    pause(1/500);
end;
%}
%% Carga de Archivos

load('cam.mat');
camera = 2;
marker= 5;

%limit=length(cam(camera).marker(marker).x);

%% Parametros de ploteo

limit_frames = 10;% cantidad de frames a plotear
limit_marker = 9;% cantidad de marcadores a plotear
correccion_zoom =0.005;% porcentaje de ventana de zoom
mantener_trayectoria = true; % mantiene o no la trayectoria
time_step = 1/300;% tiempo entre ploteo de frames
%% Inicializo variables

x=[];
y=[];
name=cellstr(num2str(zeros(limit_marker,1)));
%% Acumulo los marcadores en vectores

for marker=1:limit_marker
x=[x;cam(camera).marker(marker).x(1,1:limit_frames)];
y=[y;cam(camera).marker(marker).x(2,1:limit_frames)];
name(marker) = cellstr(cam(camera).marker(marker).name);
end;

%% Ploteo

for i=1:limit_frames
    if mantener_trayectoria
        plot(x(:,1:i)',y(:,1:i)','.-');
    else
        plot(x(:,i)',y(:,i)','.');
    end;
    axis square;
    axis([(1-correccion_zoom)*min(min(x)),...
        (1+correccion_zoom)*max(max(x)),...
       (1-correccion_zoom)*min(min(y)),...
        (1+correccion_zoom)*max(max(y))]);
    text(x(:,i)',y(:,i)', name, 'VerticalAlignment','bottom', ...
                             'HorizontalAlignment','right')
    pause(time_step);
end;

%%
%Comienzo enlazado

