%% Riemannian K-Means & Riemannian differential for several Riemannian metric on SPD manifold
% Author: Kai-Xuan Chen
% Date: 2018.08.13-2018.12.10

function differential_Matrix = com_Riemannian_Differential(structural_Descriptors,option)

    switch option.rie_Metric
        case 'A'   % Riemannian differential while using AIRM
            cluster_center = RiemannianMean(structural_Descriptors);
            center_0d5 = cluster_center^(0.5);
            center_m0d5 = cluster_center^(-0.5);    
            for sam_th = 1:size(structural_Descriptors,3)
                current_StructuralDes = structural_Descriptors(:,:,sam_th);
                temp_DisGra = center_m0d5*current_StructuralDes*center_m0d5;
                log_Temp_DisGra = logm(temp_DisGra);
                current_Distance = norm(log_Temp_DisGra,'fro'); 
                current_Gradient =  log_Temp_DisGra; 
                if current_Distance < 1e-10 || norm(current_Gradient,'fro') < 1e-10
                    current_Differential = zeros(size(current_Gradient));
                    current_Differential = map2IDS_vectorize(current_Differential, 0);
                else
                    current_Differential = (current_Gradient/norm(current_Gradient,'fro'))*current_Distance;
                    current_Differential = map2IDS_vectorize(current_Differential, 0);
                end   
                differential_Matrix(:,sam_th) = current_Differential;
            end 
            
        case 'S'   % Riemannian differential while using Stein
            [~,cluster_center] = RMkmeans_Stein(structural_Descriptors, 1);        
            center_0d5 = cluster_center^(0.5);
            center_m1 = cluster_center^-1;
            for sam_th = 1:size(structural_Descriptors,3)
                current_StructuralDes = structural_Descriptors(:,:,sam_th);
                current_Distance = sqrt(Stein_Divergence(current_StructuralDes,cluster_center));
                current_Gradient = (cluster_center + current_StructuralDes)^-1 - 0.5 * center_m1;
                current_Gradient = center_0d5 * current_Gradient * center_0d5;
                if current_Distance < 1e-10 || norm(current_Gradient,'fro') < 1e-10
                    current_Differential = zeros(size(current_Gradient));
                    current_Differential = map2IDS_vectorize(current_Differential, 0);
                else
                    current_Differential = (current_Gradient/norm(current_Gradient,'fro'))*current_Distance;
                    current_Differential = map2IDS_vectorize(current_Differential, 0);                   
                end                  
                differential_Matrix(:,sam_th) = current_Differential;
            end 
  
        case 'J'    % Riemannian differential while using Jeffrey
            [~,cluster_center] = RMkmeans_Jeff(structural_Descriptors, 1);
            center_0d5 = cluster_center^(0.5);
            center_m1 = cluster_center^-1;           
            for sam_th = 1:size(structural_Descriptors,3)
                current_StructuralDes = structural_Descriptors(:,:,sam_th);
                current_m1 = current_StructuralDes^-1;
                current_Distance = sqrt(Jeff_Divergence_Here(current_StructuralDes,current_m1,cluster_center,center_m1));
                current_Gradient = current_m1 - center_m1*current_StructuralDes*center_m1;
                current_Gradient = center_0d5 * current_Gradient * center_0d5;
                if current_Distance < 1e-10 || norm(current_Gradient,'fro') < 1e-10
                    current_Differential = zeros(size(current_Gradient));
                    current_Differential = map2IDS_vectorize(current_Differential, 0);
                else
                    current_Differential = (current_Gradient/norm(current_Gradient,'fro'))*current_Distance;
                    current_Differential = map2IDS_vectorize(current_Differential, 0);
                end   
                differential_Matrix(:,sam_th) = current_Differential;
            end
            
        case 'L'   % Riemannian differential while using LEM
            for sam_th = 1:size(structural_Descriptors,3)
                logm_StrDes(:,:,sam_th) = logm(structural_Descriptors(:,:,sam_th));
            end
            mean_LogDes = mean(logm_StrDes,3);
            cluster_center = expm(mean_LogDes);
            center_m0d5 = cluster_center^(-0.5);   
            center_m1 = cluster_center^(-1);  
            for sam_th = 1:size(structural_Descriptors,3)

                log_Temp_DisGra = logm_StrDes(:,:,sam_th) - mean_LogDes;
                current_Distance = norm(log_Temp_DisGra,'fro'); 
                tmp_Gradient = center_m1*(mean_LogDes - logm_StrDes(:,:,sam_th));
                tmp_Gradient = cluster_center*(tmp_Gradient + tmp_Gradient')*cluster_center;
                current_Gradient =  center_m0d5*tmp_Gradient*center_m0d5;  
                
                if current_Distance < 1e-10 || norm(current_Gradient,'fro') < 1e-10
                    current_Differential = zeros(size(current_Gradient));
                    current_Differential = map2IDS_vectorize(current_Differential, 0);
                else
                    current_Differential = (current_Gradient/norm(current_Gradient,'fro'))*current_Distance;
                    current_Differential = map2IDS_vectorize(current_Differential, 0);
                end   
                differential_Matrix(:,sam_th) = current_Differential;
            end 
    end

end
