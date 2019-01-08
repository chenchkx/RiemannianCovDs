% Karcher mean using gradient descent
% X is 3 dimensional X(:,:,N)
function M = Compute_Karcher_AIRM(X, maxItr)
th = 1e-2;
N = size(X,3);
if (N == 0)
    error('Number of samples in X is zero ( in function karcherMean)');
end
%first estimate of mean 
%M = X(:,:,floor(N/2));% mean
M = Mean_eye(X);
%%
%Computing Karcher mean using Gradient descent
i = 0;
prDist = Inf;
prM = M;
while (i==0 || geodesicDist(prM,M)^0.5 > th)
    i=i+1;
    prM = M;
    %computing mean using prM as the reference point
    S = zeros(size(X,1),size(X,2));
    for j=1:N
        S = S + RM_log( prM , X(:,:,j));
    end
    %transfer to RM
    M = RM_exp( prM, S / N);

    Dist = geodesicDist(prM,M);
    if (i > 10 && Dist > prDist)
        M=prM;
        break;
    elseif i > maxItr         
        break;        
    end    
    prDist = Dist;
end
%%
