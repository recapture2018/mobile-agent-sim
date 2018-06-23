function D = computeDiagMat(L, Lambda)
    %Determine size of L, as well as how many iterations to carry out
    n = length(L(:,1));
    m = n^2;
    
    %Preallocate our necessary matrices and vectors
    k = ones(n-2,1);
    
    %Compute the rank factorization of L
    [R,colBasis] = rref(L);
    U = L(:,colBasis);
    V = R(1:n-2,:);
    
    % Perform the Newton iteration
    for i = 1:m
        F = computeF;
        G = computeG;
        k = k - G\F;
    end
    
    % Return the result for D
    D = diag([k;1;1]);
    
    %Function to compute A(k)
    function M = A(k)
        M = V*diag([k;1;1])*U;
    end

    function v = computeF
        v = zeros(n-2,1);
        for p = 1:(n-2)
            v(p) = det(A(k)+Lambda(p)*eye(n-2));
            if (isnan(v(p)))
                error('NaN computed. Rerun program.');
            end
        end
    end

    function M = computeG
        M = zeros(n-2);
        for p = 1:(n-2)
            for q = 1:(n-2)
                if (abs(F(p)) > 10^(-5))
                    M(p,q) = F(p)*trace((A(k)+Lambda(p)*eye(n-2))\(V(:,q)*U(q,:)));
                else
                    M(p,q) = trace((det(A(k)+Lambda(p)*eye(n-2))*(A(k)+Lambda(p)*eye(n-2)))\(V(:,q)*U(q,:)));
                end
            end
        end
        if (isnan(M(1,1)))
            error('NaN computed. Rerun program.');
        end
    end
end