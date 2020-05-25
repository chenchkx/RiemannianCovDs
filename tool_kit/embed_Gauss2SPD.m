%% Author: Kai-Xuan Chen 
% Date: 2018.12.13

function gaussEmbeSPD_Matrix = embed_Gauss2SPD(mean_Matrix,cov_Matrix,option)
    beta = option.beta_Gauss;
    [d,num_Sample] = size(mean_Matrix);
    gaussEmbeSPD_Matrix = zeros(d+1,d+1,num_Sample);
    for sam_th = 1:num_Sample
        mean_Feature = mean_Matrix(:,sam_th); 
        cov_Feature = cov_Matrix(:,:,sam_th);
        current_SPD = ones(d+1,d+1);
        current_SPD(1:d,1:d) = cov_Feature + beta^2.*mean_Feature*mean_Feature';
        current_SPD(1+d,1:d) = beta*mean_Feature;
        current_SPD(1:d,1+d) = beta*mean_Feature';
%         current_SPD = current_SPD^0.5;
        current_SPD = real(current_SPD);
%         current_SPD(find(abs(current_SPD)<=1e-10)) = 0;
        [~,S] = eig(current_SPD);
        [temp_min,~] = min(diag(S));
        while temp_min <= option.min_EigGau
            current_SPD = current_SPD + (option.min_EigGau)*trace(current_SPD)*eye(d+1);
            [~,S] = eig(current_SPD);
            [temp_min,~] = min(diag(S));
        end      
        gaussEmbeSPD_Matrix(:,:,sam_th) = current_SPD;
    end             
end