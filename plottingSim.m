% x = -1:0.2:1;
% y = sqrt(1-x.^2);
% 
% plot(x,y,'o', 'MarkerFaceColor', 'black');
% hold on;
% plot(x,-y,'o', 'MarkerFaceColor', 'black');
% 
% pause;
% 
% 
% xiFig = figure;
for i = 1:25
    plot(nongeneric,'o', 'MarkerFaceColor', 'black');
    hold on;
    text(real(nongeneric(i,1)), imag(nongeneric(i,1)),strcat(' ',num2str(i)), ...
                'HorizontalAlignment','right')
end
axis([-1.5 1.5 -1.5 1.5]);
