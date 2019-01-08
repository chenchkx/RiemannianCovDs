% points are SPD matrices   X(:,:,1)...X(:,:,N)
%  inds is the cluster labels for points in X
function [inds,clusters] = RMkmeans_AIRM(X,K)
N = size(X,3);
inds = zeros(1,N);
initInds = randperm(N,K);
clusters = X(:,:,initInds);
manifold = sympositivedefinitefactory(size(X,1));
for i = 1:10
    i;
    %computing the minimum distance of each X(:,:,j) to the cluster centers (K)
    D = AIRM(X,clusters,manifold);
    [~,inds] = min(D,[],2);   
    %%
    %computing new clusters
    pr_clusters = clusters;
    for k = 1:K        
        temp = find( inds == k );% # nonzero elements for a cluster
        if (length(temp) > 1)  
            clusters(:,:,k) = positive_definite_karcher_mean(X(:,:,temp));            
            %clusters(:,:,k) = Compute_Karcher_AIRM(X(:,:,temp),10);           
        elseif (length(temp) == 1)               
            clusters(:,:,k) = X(:,:,temp);
        else
            disp(['No assignment to a cluster:' int2str(k)]);
        end
    end
    temp2= find(clusters - pr_clusters);
    if (isempty(temp2) && i > 1)%No change in centers
        disp('converged');
        break;
    end
    %%
end