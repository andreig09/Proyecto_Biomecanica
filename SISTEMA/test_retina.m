clc
close all
clear all

load retina_ground_truth.mat
load retina_real.mat

[promedio,errores] = rmse_segmentacion_ground([x1;ones(1,size(x1,2))],[x2;ones(1,size(x2,2))])

hist(errores(1,:),100)