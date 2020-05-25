function out_Matrix = gen_RieCovDs_GausstypeAndRiemetric(descriptor_Cell,block_Num,option)
        num_Sample = length(descriptor_Cell);
        differential_Cell = cell(1,block_Num);
        for block_th = 1:block_Num
            mean_Cell = cell(1,num_Sample);
            cov_Cell = cell(1,num_Sample);
            for sam_th = 1:num_Sample
                mean_Cell{1,sam_th} = descriptor_Cell{1,sam_th}.mean{1,block_th};
                cov_Cell{1,sam_th} = descriptor_Cell{1,sam_th}.cov{1,block_th};
            end
            % Riemannian differential  on SPD when use 'rie_Metric'             
            differential_Matrix = gen_Riemannian_Differential(mean_Cell,cov_Cell,option); % Riemannian differential for structural descriptors to their Riemannian mean
            differential_Cell{1,block_th} = differential_Matrix;                              % Riemannian differential matrices for all blocks
            clear('mean_Cell','cov_Cell','differential_Matrix');
        end                                   
        rie_CovDs = compute_RCovDs(differential_Cell);                % compute RCovDs for 'set_tr_th' image set
        clear('differential_Cell');
        [~,S] = eig(rie_CovDs);
        [temp_min,~] = min(diag(S));
        while temp_min <= option.min_EigRieCovDs
            rie_CovDs = rie_CovDs + (option.min_EigRieCovDs)*trace(rie_CovDs)*eye(size(rie_CovDs,1));
            [~,S] = eig(rie_CovDs);
            [temp_min,~] = min(diag(S));
        end   
        out_Matrix = rie_CovDs;

end