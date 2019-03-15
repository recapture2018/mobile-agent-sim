% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Mobile Agent Simulator
% sensingGraphBuilder.m
% Last edited: 2019-03-14 by Casey Brito
% This function aids the user in the arduous process of creating the
% sensing network vector.
%
% Changelog: (2019-03-14) Initial creation
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

function G = sensingGraphBuilder(n)
    % Ask the user what they want to do
    choice = questdlg('Do you want to build a sensing graph now, or use an already-existing one?', ...
	'Sensing Graph Builder', ...                            % Window title
	'Build','Use Existing','Cancel');                       % Choices

    % Vector variables we'll be using in the first two cases
    initialVec = [];
    terminalVec = [];

    % Handle the user input
    switch choice
        case 'Build'
            % Build the initial and terminal vectors
            for i=1:n
                prompt = {sprintf('Which nodes are agent %d directed towards?: ', i)};
                title = 'Sensing Graph Builder - Build';
                dim = [1 35];
                
                % Pop a dialogue box for agent i where the user enters a
                % list of numbers
                answers = inputdlg(prompt,title,dim);
                entries = str2num(answers{1});
                
                % Decide if we need to do anything for this next iteration
                if (~isempty(entries))
                    % Add new entries to initialVec
                    initialVec = [initialVec, i*ones(1,length(entries))];
                    terminalVec = [terminalVec, entries];
                end
            end
            
            % Finally, compute our digraph to be returned
            G = digraph(initialVec, terminalVec);
        case 'Use Existing'
            % Pop up a dialogue box where the user enters info.
            prompt = {'Initial Nodes','Terminal Nodes'};
            title = 'Sensing Graph Builder - Use Existing';
            dims = [1 35];
            answers = inputdlg(prompt,title,dims);
            
            % Build initialVec and terminalVec
            initialVec = str2num(answers{1});
            terminalVec = str2num(answers{2});
            
            % And then create the digraph to be returned
            G = digraph(initialVec, terminalVec);
        case 'Cancel'
            disp('User terminated the program')
            return;
    end
end
