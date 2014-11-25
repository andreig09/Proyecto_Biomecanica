function [angle,frames]=animar_angulo(X_out,marker_1,marker_2,marker_3)

%{
Punto 1, es el pivot del angulo a calcular
%}
clc
close all

x_1 = X_out(:,X_out(5,:)==marker_1);
x_2 = X_out(:,X_out(5,:)==marker_2);
x_3 = X_out(:,X_out(5,:)==marker_3);

angle = [];

frames = unique(X_out(4,:));

for f=min(frames):max(frames)
    x_1_f = x_1(1:3,x_1(4,:)==f);
    x_2_f = x_2(1:3,x_2(4,:)==f);
    x_3_f = x_3(1:3,x_3(4,:)==f);
    angle = [angle,(180/pi)*atan2(norm(cross(x_2_f-x_1_f,x_3_f-x_1_f)), dot(x_2_f-x_1_f,x_3_f-x_1_f))];
end

plot(frames,angle,'b.-')

end
