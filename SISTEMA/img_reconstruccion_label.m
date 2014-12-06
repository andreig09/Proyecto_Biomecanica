%clc
close all

load 'C:\Proyecto\PB_2014_11_27\Archivos_mat\CMU_8_07_hack\1600_600-100-200\Reconstruccion\skeleton.mat'

frame_ini = 10;
n_frames = get_info(skeleton_rec,'n_frames');

Xi = [];

frame_plot = 3;

for frame=frame_ini:n_frames
    xi = get_info(skeleton_rec,'frame', frame, 'marker', 'coord');
    Xi=[Xi,[xi;frame*ones(1,size(xi,2));1:size(xi,2)]];
end

test_in = Xi(:,Xi(4,:)<=frame_plot+min(Xi(4,:)))
test_out = X_out(:,X_out(4,:)<=frame_plot+min(X_out(4,:)))

test_plot = test_in;

for frame=min(test_plot(4,:)):max(test_plot(4,:))
    plot3(test_plot(1,test_plot(4,:)==frame),...
        test_plot(2,test_plot(4,:)==frame),...
        test_plot(3,test_plot(4,:)==frame),'b.')
      labels = cellstr(num2str(test_plot(5,test_plot(4,:)==frame)'));
    for l=1:size(labels,1)
        labels{l} =sprintf('%s-%s',num2str(frame),labels{l});
    end
	text(test_plot(1,test_plot(4,:)==frame),...
        test_plot(2,test_plot(4,:)==frame),...
        test_plot(3,test_plot(4,:)==frame)...
        ,labels,'VerticalAlignment','bottom','HorizontalAlignment','right');

    axis equal
    grid on
    hold on
    
end

title(sprintf('Puntos Reconstruidos Frame-Marker\nFrames %d-%d',(min(test_plot(4,:))),(max(test_plot(4,:)))))
xlabel('x (metros)');
ylabel('y (metros)');
zlabel('z (metros)');