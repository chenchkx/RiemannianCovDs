%% Author: Kai-Xuan Chen 
% Date: 2018.05.16-2018.05.16

function current_SPD = embed_Gauss2SPD_Sim(current_Feature,option)
        beta = option.beta_Gauss;
        [d,num_Pixels] = size(current_Feature);
        current_SPD = zeros(d+1,d+1);
        mean_Feature = mean(current_Feature,2);
        verify_Feature = current_Feature - repmat(mean_Feature,1,num_Pixels);
%         cov_Feature = cov(current_Feature');  
        if norm(verify_Feature,'fro')==0
            current_Feature = current_Feature + 2*(rand(size(current_Feature))-0.5);
        end
        cov_Feature = cov(current_Feature'); 
        current_SPD(1:d,1:d) = cov_Feature + beta^2.*mean_Feature*mean_Feature';
        current_SPD(1+d,1:d) = beta*mean_Feature;
        current_SPD(1:d,1+d) = beta*mean_Feature';
        current_SPD(1+d,1+d) = 1;
        [~,S] = eig(current_SPD);
        [temp_min,~] = min(diag(S));
        while temp_min <= option.min_Eig
            current_SPD = current_SPD + (option.min_Eig)*trace(current_SPD)*eye(d+1);
            [~,S] = eig(current_SPD);
            [temp_min,~] = min(diag(S));
        end             
end