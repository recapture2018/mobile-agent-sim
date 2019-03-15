% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Mobile Agent Simulator
% LinSimulation.m
% Last edited: 2019-03-14 by Casey Brito
% This simulation computes the solution for a path a group of mobile agents
% must take in order to collectively attain a certain shape formation.
%
% Changelog: (2019-03-14) Cleaned up and generalized code significantly.
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

% We need to clean up the simulation from last time (if applicable)
clear all;
warning('off','all');
warning;

% Pop a dialogue box for the desired formation
prompt = {'Please input the desired formation as a vector'};
title = 'Mobile Agent Simulator';
dim = [1 35];
answers = inputdlg(prompt,title,dim);
coordinates = str2num(answers{1});

% Convert the above vector to be complex for the remainder of the program
xi = complex(coordinates(:,1),coordinates(:,2));

% Next, build the sensing network graph
n = length(xi);
G = sensingGraphBuilder(n);

% Now build the Laplacian matrix
L = computeLaplacian(G,xi);

% Pop up a dialog box to ask for alpha, the desired eigenvalues, and time
prompt = {'Enter a value for \alpha','Enter eigenvalues','Enter time range','Enter initial positions'};
title = 'Mobile Agent Simulator - Convergence';
definput = {'3',num2str(-1*(3*ones(1,n) + 50*rand(1,n))),'[0 3]',num2str(complex(10*rand(n,1) - 5*ones(n,1),10*rand(n,1) - 5*ones(n,1)))};
opts.Interpreter = 'tex';
answers = inputdlg(prompt,title,[1 100],definput,opts);

% Insert the values into the appropriate variables
alpha = str2double(answers{1});
Lambda = str2num(answers{2});   % we use str2num here because str2double doesn't like cell lists.
timeVec = str2num(answers{3});
initialCondition = str2num(answers{4});

% Compute the diagonal matrix of controls
D = computeDiagMat(L,Lambda);

% Now, solve the dynamical system
[t, odeSol] = ode45(@(t,z) -D*L*z, timeVec, initialCondition);

% Finally, we plot the data, either via animated GIF or static plot
generatePlots(odeSol);
