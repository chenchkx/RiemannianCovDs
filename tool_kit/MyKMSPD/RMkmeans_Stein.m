% points are SPD matrices   X(:,:,1)...X(:,:,N)
%  inds is the cluster labels for points in X
function [inds,clusters] = RMkmeans_Stein(X,K)
N = size(X,3);
inds = zeros(1,N);
initInds = randperm(N,K);
clusters = X(:,:,initInds);
for i = 1:10
    i;
    D = Stein_Divergence(X,clusters);   
    [~,inds] = min(D,[],2);   
    %%
    %computing new clusters
    pr_clusters = clusters;
    for k = 1:K        
        temp = find( inds == k );% # nonzero elements for a cluster
        if (length(temp) > 1)               
            clusters(:,:,k) = Compute_Karcher_Stein(X(:,:,temp));           
        elseif (length(temp) == 1)               
            clusters(:,:,k) = X(:,:,temp);
        else
            disp(['No assignment to a cluster:' int2str(k)]);
        end
    end
    temp2= find(clusters - pr_clusters);
    if (isempty(temp2) && i > 1)%No change in centers
%         disp('converged');
        break;
    end
    %%
end