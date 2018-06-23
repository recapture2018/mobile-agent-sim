% Here we generate the digraph G and its Laplacian, and produce eigenvalues
% to stabilize the multi-agent system.

% To reduce the verbosity of the output, we clear everything and
% turn off the warnings.
clear all;
warning('off','all');
warning;

% Our Desired Formation, initially plotted in R^2 and then converted to C
coordinates = [-4 5; -4 6; -3 6; -2 6; -1 6; 0 6; 1 6; 2 6; 3 6; 4 6; 4 5;
                0 5; 0 4; -2 3; -1 3; 0 3; 1 3; 2 3; -2 2.5; 2 2.5; 0 2;
                0 1; -1 0; 0 0; 1 0];
xi = complex(coordinates(:,1),coordinates(:,2));

% Obtain the number of agents
n = length(xi);

% Create G, and consequently L
G = digraph([1 1 1  1  1  2 2  2  2  2  3 4 4 4 4 5 6 6 7 7 ...
                8 8  9 9 9 9  10 10 11 11 12 12 13 14 14 14 ...
                14 15 16 16 17 17 18 19 19 19 19 19 19 20 21 ...
                21 22 22 23 24 24 24 24 25], ...
           [3 8 13 18 23 5 10 15 20 25 4 1 2 6 7 4 3 8 5 ...
           10 9 11 4 6 7 14 9  12 9  13  9 15 14 11 12 16 ...
           17 14 13 18 15 20 19 14 16 17 21 22 24 19 18 23 ...
           20 25 24 1  2  21 22 24]);
       
% Now, compute the Laplacian of G
L = computeLaplacian(G,xi);

% We generate the eigenvalues for some set alpha.
alpha = input('Enter convergence parameter alpha > 0: ');
Lambda = alpha*ones(1,n) + 50*rand(1,n);

% And lastly generate some initial positions for the agents.
x0 = 10*rand(n,1) - 5*ones(n,1);
y0 = 10*rand(n,1) - 5*ones(n,1);
initialCondition = complex(x0,y0);