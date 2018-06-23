function L = computeLaplacian(G, xi, W)
    
    %Determine how many nodes there are in the graph
    n = length(xi);
    
    %Determine whether we need to make weights or the user has some to use
    switch nargin
        %Assume only G is provided
        case 2
            %Allocate the Laplacian Matrix
            L = zeros(n);
            
            %Cycle through all n nodes
            for i=1:n
                
                %For node i, determine N_i, the in-neighbor set of node i.
                [~,N_i] = inedges(G,i);
                
                if ~isempty(N_i)
                    %Generate (length(N_i)-1) random C numbers for weights
                    wVec = zeros(length(N_i),1);
                    wVec(1:end-1) = 20*(rand((length(N_i)-1),1) + ...
                                        1i*rand((length(N_i)-1),1)) - ...
                                        10*ones((length(N_i)-1),1) - ...
                                        1i*(10)*ones(length(N_i)-1,1);
                                    %disp(wVec);

                    %Compute the final weight by subtracting all others
                    for k=1:(length(N_i)-1)
                        wVec(end) = wVec(end) - wVec(k)*(xi(N_i(k)) - xi(i));
                    end
                    wVec(end) = wVec(end)/(xi(N_i(end)) - xi(i));
                    %wVec = [wVec(1:end); sum(wVec)/(xi(i)-xi(N_i(end)))];

                    %Insert the weights into the respective rows and columns
                    for k=1:length(N_i)
                        L(i,N_i(k)) = -1*wVec(k);
                    end

                    L(i,i) = sum(wVec);

                end
                
            end
            
        case 3
            %Assuming the user has weights they want to use, find weights
            %such that the sum of the weights and sum w_ij(xi_j - xi_i) = 0
        otherwise
            disp('Not enough information is given to determine Laplacian');
    end

end