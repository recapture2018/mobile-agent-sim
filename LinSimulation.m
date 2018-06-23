clear all;
warning('off','all');
warning;

%Our Desired Formation

%xi = [-1i; -0.6; -0.7 + 0.5i; -0.5 + 1.25i; -0.2 + 1.24i; 1i; 0.2 + 1.4i; 0.5 + 1.1i; 0.63 + 0.5i; 0.55];
%xi = [-1+1i;1i;1+1i;-1;0;1;-1-1i;-1i;1-1i];
%xi = [-2/3+i;2/3+i;-1;1;-2/3-1/3*i;2/3-1/3*i;-1/3-1/2*i;1/3-1/3*i;-1/2*i];
coordinates = [-4 5; -4 6; -3 6; -2 6; -1 6; 0 6; 1 6; 2 6; 3 6; 4 6; 4 5;
                0 5; 0 4; -2 3; -1 3; 0 3; 1 3; 2 3; -2 2.5; 2 2.5; 0 2;
                0 1; -1 0; 0 0; 1 0];
xi = complex(coordinates(:,1),coordinates(:,2));


%Create L
n = length(xi);

% Create G, and consequently L
% G = digraph([1 2 2 3 4 4 4 5 5 5 5 6 6 6 7 8 8 9], ...
%             [2 3 5 6 1 6 7 1 2 8 9 3 4 9 4 5 7 8]);
% G = digraph([1 1 2 2  3 4 4 4 5 6 6 7 7  8 8 9 9 9 9 10 10], ...
%             [3 8 5 10 4 6 7 1 4 3 8 5 10 1 9 2 4 6 7 2  9]);
G = digraph([1 1 1  1  1  2 2  2  2  2  3 4 4 4 4 5 6 6 7 7  8 8  9 9 9 9  10 10 11 11 12 12 13 14 14 14 14 15 16 16 17 17 18 19 19 19 19 19 19 20 21 21 22 22 23 24 24 24 24 25], ...
           [3 8 13 18 23 5 10 15 20 25 4 1 2 6 7 4 3 8 5 10 9 11 4 6 7 14 9  12 9  13  9 15 14 11 12 16 17 14 13 18 15 20 19 14 16 17 21 22 24 19 18 23 20 25 24 1  2  21 22 24]);

% G = digraph([1 1 2 2 3 3 4 4 4 5 5  6 6 7 7  8  8  9 9 9  10 10 11 11 12 12 13 13 14 14 14 15], ...
%             [3 4 4 5 6 8 3 5 9 7 10 8 9 4 10 11 13 6 7 14 12 15 9  13 9  15 1  14 11 12 15 2]);
L = computeLaplacian(G,xi);

%Make random eigenvalues to assign based on alpha
alpha = 3;
%a = alpha*ones(1,9) + 50*rand(1,9);
Lambda = alpha*ones(1,n) + 50*rand(1,n);
%b = 100*rand(1,9) - 50*ones(1,9);
%b = zeros(1,9);

%Lambda = complex(a,b);
D = computeDiagMat(L,-Lambda);

%Display the eigenvalues of -D*L
%disp(eig(-D*L));
%disp(eig(-L));
a = 10*rand(n,1) - 5*ones(n,1);
b = 10*rand(n,1) - 5*ones(n,1);
initialCondition = complex(a,b);
%initialCondition = xi;
%[t, odeSol] = ode45(@(t,z) -D*L*z, [0 3], initialCondition);

[t, odeSol] = ode45(@(t,z) -D*L*z, [0 3], initialCondition);

%Somehow, the Imag part of the solution is negated, so we need this
%INVESTIGATE WHY
%odeSol = complex(real(odeSol(:,:)),-imag(odeSol(:,:)));
odeSol = conj(odeSol);



%Animation
nframe = length(odeSol(:,1));
h = figure;
j = 1;

%Picture only
for k = 1:n
        plot(odeSol(end,k),'o', 'MarkerFaceColor', 'blue');
        text(real(odeSol(end,k)), imag(odeSol(end,k)),num2str(k), ...
            'HorizontalAlignment','right')
        hold on;
end
hold off;
pause;

%for j = 1:nframe
while (norm(-D*L*(odeSol(j,:)')) >= 1) && (j < length(odeSol(:,1)))
    clf;
    
    for k = 1:n
        plot(odeSol(j,k),'o', 'MarkerFaceColor', 'blue');
        text(real(odeSol(j,k)), imag(odeSol(j,k)),num2str(k),'HorizontalAlignment','right')
        %text(real(odeSol(i,k)), imag(odeSol(i,k)), strcat(strcat('(',num2str(real(odeSol(i,k))),strcat(num2str(imag(odeSol(i,k)))),')')), 'HorizontalAlignment','left');
        hold on;
    end
    axis([-inf inf -inf inf]);
    
    %Debug text
    text(-40,-30, strcat('$$\|\dot z\| = $$ ', ...
        num2str(norm(-D*L*(odeSol(j,:)')))),'Interpreter', 'latex');
    
    %grid on;
    drawnow
    
    frame = getframe(h); 
    im = frame2im(frame); 
    [imind,cm] = rgb2ind(im,256); 
    % Write to the GIF File 
    if j == 1 
        imwrite(imind,cm,'Paths.gif','DelayTime',0, 'Loopcount',inf); 
    else 
        imwrite(imind,cm,'Paths.gif','DelayTime',0,'WriteMode','append'); 
    end
    j = j+1;
end
