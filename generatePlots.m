% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Mobile Agent Simulator
% generatePlots.m
% Last edited: 2019-03-14 by Casey Brito
% Generates the plot or animation for the simulation.
%
% Changelog: (2019-03-14) Initial file creation
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

function generatePlots(odeSol)
% Ask the user what they want to do
    n = length(odeSol(1,:));
    choice = questdlg('Simulation complete. What output would you like?',...
	'Mobile Agent Simulator', ...                           % Window title
	'Generate Plot','Generate Animation','Generate Both');	% Choices

    % Handle the user input
    switch choice
        case 'Generate Plot'
            % Picture only
            for k = 1:n
                    plot(odeSol(end,k),'o', 'MarkerFaceColor', 'blue');
                    text(real(odeSol(end,k)), imag(odeSol(end,k)),num2str(k), ...
                        'HorizontalAlignment','right')
                    hold on;
            end
            hold off;
        case 'Generate Animation'
            % For optimal graphing
            xmin = 1.1*min(real(odeSol),[],'all');
            xmax = 1.1*max(real(odeSol),[],'all');
            ymin = 1.1*min(imag(odeSol),[],'all');
            ymax = 1.1*max(imag(odeSol),[],'all');
            currFrame = 1;
            h = figure;
            
            % Main loop for generating frames of the animation
            % while (norm(-D*L*(odeSol(currFrame,:)')) >= 1) && (currFrame < length(odeSol(:,1)))
            while currFrame < length(odeSol(:,1))
                % Clear the plot for the next frame
                clf;
                
                % Draw the next frame
                for k = 1:n
                    plot(odeSol(currFrame,k),'o', 'MarkerFaceColor', 'blue');
                    text(real(odeSol(currFrame,k)), imag(odeSol(currFrame,k)),num2str(k),'HorizontalAlignment','right')
                    hold on;
                end
                
                % Set the axis using the optimal graph settings
                axis([xmin xmax ymin ymax]);

                % Debug text
                % text(0.8*xmin,ymax*0.8, strcat('$$\|\dot z\| = $$ ', ...
                %     num2str(norm(-D*L*(odeSol(currFrame,:)')))),'Interpreter', 'latex');
                % drawnow
                
                % Begin assembling the GIF
                frame = getframe(h); 
                im = frame2im(frame); 
                [imind,cm] = rgb2ind(im,256); 
                % Write to the GIF File 
                if currFrame == 1 
                    imwrite(imind,cm,'Paths.gif','DelayTime',0, 'Loopcount',inf); 
                else 
                    imwrite(imind,cm,'Paths.gif','DelayTime',0,'WriteMode','append'); 
                end
                currFrame = currFrame + 1;
            end
        case 'Generate Both'
            disp('Not yet implemented');
            return;
    end
end
