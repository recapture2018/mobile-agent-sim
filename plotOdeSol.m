function f = plotOdeSol(odeSol)
    n = length(odeSol(1,:));
    % Plot the initial positions, trajectories, and final positions
    for k = 1:n
        
        % Initial positions
        plot(odeSol(1,k),'o', 'MarkerFaceColor', 'white');
        hold on;
        % Trajectories
        plot(odeSol(:,k));
        hold on;
        text(real(odeSol(end,k)), imag(odeSol(end,k)),num2str(k), ...
                'HorizontalAlignment','right');
        hold on;
        % Final positions
        plot(odeSol(end,k),'o', 'MarkerFaceColor', 'black');
        hold on;
        
    end
    
    hold off;
    f = figure;
end