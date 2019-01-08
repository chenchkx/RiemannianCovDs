%% Riemannian K-Means & Riemannian differential for several Riemannian metric on SPD manifold
% Author: Kai-Xuan Chen
% Date: 2018.08.13-2018.12.10

function differential_Matrix = com_Riemannian_Differential(structural_Descriptors,option)
% first release
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
%                 current_Gradient = cluster_center^-0.5 * RM_log(cluster_center,current_StructuralDes) * cluster_center^-0.5; 
%                 current_Gradient = center_0d5 * current_Gradient * center_0d5; 
                current_Gradient =  log_Temp_DisGra; 
                if current_Distance < 1e-10 || norm(current_Gradient,'fro') < 1e-10
                    current_Differential = zeros(size(current_Gradient));
                    current_Differential = map2IDS_vectorize(current_Differential, 0);
                else
                    current_Differential = (current_Gradient/sqrt(norm(current_Gradient,'fro')))*current_Distance;
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
                current_Distance = Stein_Divergence(current_StructuralDes,cluster_center);
                current_Gradient = (cluster_center + current_StructuralDes)^-1 - 0.5 * center_m1;
                current_Gradient = center_0d5 * current_Gradient * center_0d5;
                if current_Distance < 1e-10 || norm(current_Gradient,'fro') < 1e-10
                    current_Differential = zeros(size(current_Gradient));
                    current_Differential = map2IDS_vectorize(current_Differential, 0);
                else
                    current_Differential = (current_Gradient/sqrt(norm(current_Gradient,'fro')))*current_Distance;
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
%                 current_Distance = Jeff_Divergence(current_StructuralDes,cluster_center);
                current_Distance = Jeff_Divergence_Here(current_StructuralDes,current_m1,cluster_center,center_m1);
                current_Gradient = current_m1 - center_m1*current_StructuralDes*center_m1;
                current_Gradient = center_0d5 * current_Gradient * center_0d5;
                if current_Distance < 1e-10 || norm(current_Gradient,'fro') < 1e-10
                    current_Differential = zeros(size(current_Gradient));
                    current_Differential = map2IDS_vectorize(current_Differential, 0);
                else
                    current_Differential = (current_Gradient/sqrt(norm(current_Gradient,'fro')))*current_Distance;
                    current_Differential = map2IDS_vectorize(current_Differential, 0);
                end   
                differential_Matrix(:,sam_th) = current_Differential;
            end
            
        case 'L'   % Riemannian differential while using LogEu
            for sam_th = 1:size(structural_Descriptors,3)
                logm_StrDes(:,:,sam_th) = logm(structural_Descriptors(:,:,sam_th));
            end
            mean_LogDes = mean(logm_StrDes,3);
%             for sam_th = 1:size(structural_Descriptors,3)
%                 current_Gradient = logm_StrDes(:,:,sam_th) - mean_LogDes;
%                 current_Differential = current_Gradient/sqrt(norm(current_Gradient,'fro'));
%                 current_Differential = map2IDS_vectorize(current_Differential, 0);
%                 differential_Matrix(:,sam_th) = current_Differential;               
%             end
            
            cluster_center = expm(mean_LogDes);
            center_m0d5 = cluster_center^(-0.5);    
            for sam_th = 1:size(structural_Descriptors,3)
                current_StructuralDes = structural_Descriptors(:,:,sam_th);
                temp_DisGra = center_m0d5*current_StructuralDes*center_m0d5;
                log_Temp_DisGra = logm(temp_DisGra);
                current_Distance = norm(log_Temp_DisGra,'fro'); 
%                 current_Gradient = cluster_center^-0.5 * RM_log(cluster_center,current_StructuralDes) * cluster_center^-0.5; 
%                 current_Gradient = center_0d5 * log_Temp_DisGra * center_0d5; 
                current_Gradient =  log_Temp_DisGra; 
                if current_Distance < 1e-10 || norm(current_Gradient,'fro') < 1e-10
                    current_Differential = zeros(size(current_Gradient));
                    current_Differential = map2IDS_vectorize(current_Differential, 0);
                else
                    current_Differential = (current_Gradient/sqrt(norm(current_Gradient,'fro')))*current_Distance;
                    current_Differential = map2IDS_vectorize(current_Differential, 0);
                end   
                differential_Matrix(:,sam_th) = current_Differential;
            end 
    end
    
% second release
%     switch rie_Metric
%         case 'A'   % Riemannian differential while using AIRM
%             cluster_center = RiemannianMean(structural_Descriptors);
%             center_0d5 = cluster_center^(0.5);
%             center_m0d5 = cluster_center^(-0.5);    
%             for sam_th = 1:size(structural_Descriptors,3)                                                                                                             
%                 current_StructuralDes = structural_Descriptors(:,:,sam_th);
%                 temp_DisGra = center_m0d5*current_StructuralDes*center_m0d5;
%                 log_Temp_DisGra = logm(temp_DisGra);
%                 current_Distance = norm(log_Temp_DisGra,'fro'); 
%                 current_Gradient = 2*center_0d5*log_Temp_DisGra*center_0d5;                
%                 if current_Distance < 1e-10
%                     current_Differential = zeros(size(current_Gradient));
%                 else
%                     current_Differential = (current_Gradient/sqrt(norm(current_Gradient,'fro')))*current_Distance;
%                 end   
%                 current_Differential = map2IDS_vectorize(current_Differential, 0);
%     %                 current_Differential = normalize_Processing(current_Differential);
%                 differential_Matrix(:,sam_th) = current_Differential;
%             end 
% 
%         case 'S'   % Riemannian differential while using Stein
%             [~,cluster_center] = RMkmeans_Stein(structural_Descriptors, 1);            
%             for sam_th = 1:size(structural_Descriptors,3)
%                 current_StructuralDes = structural_Descriptors(:,:,sam_th);
%                 current_Distance = Stein_Divergence(current_StructuralDes,cluster_center);
%                 current_Gradient = cluster_center*(cluster_center + current_StructuralDes)^-1*cluster_center - 0.5*cluster_center;
% %                 current_Gradient = cluster_center(cluster_center + current_StructuralDes)^-1 - 0.5 * cluster_center^-1;
% %                 current_Gradient = cluster_center^0.5 * current_Gradient * cluster_center^0.5;
%                 if current_Distance < 1e-10
%                     current_Differential = zeros(size(current_Gradient));
%                 else
%                     current_Differential = (current_Gradient/sqrt(norm(current_Gradient,'fro')))*current_Distance;
%                 end   
%                 current_Differential = map2IDS_vectorize(current_Differential, 0);
%                 differential_Matrix(:,sam_th) = current_Differential;
%             end 
% 
%         case 'J'    % Riemannian differential while using Jeffrey
%             [~,cluster_center] = RMkmeans_Jeff(structural_Descriptors, 1);
%             center_m1 = cluster_center^-1;
%             for sam_th = 1:size(structural_Descriptors,3)
%                 current_StructuralDes = structural_Descriptors(:,:,sam_th);
%                 current_m1 = current_StructuralDes^-1;
%                 current_Distance = Jeff_Divergence_Here(current_StructuralDes,current_m1,cluster_center,center_m1);
%                 current_Gradient = current_m1 - center_m1*current_StructuralDes*center_m1;
%                 current_Gradient = 0.5*cluster_center*current_Gradient*cluster_center;
%                 if current_Distance < 1e-10
%                     current_Differential = zeros(size(current_Gradient));
%                 else
%                     current_Differential = (current_Gradient/sqrt(norm(current_Gradient,'fro')))*current_Distance;
%                 end   
%                 current_Differential = map2IDS_vectorize(current_Differential, 0);
%                 differential_Matrix(:,sam_th) = current_Differential;
%             end
% 
%         case 'L'   % Riemannian differential while using LogEu
%             for sam_th = 1:size(structural_Descriptors,3)
%                 logm_StrDes(:,:,sam_th) = logm(structural_Descriptors(:,:,sam_th));
%             end
%             mean_LogDes = mean(logm_StrDes,3);
%             mean_ExpDes = expm(mean_LogDes);         
%             for sam_th = 1:size(structural_Descriptors,3)
%                 current_Gradient = (mean_LogDes - logm_StrDes(:,:,sam_th))*mean_ExpDes;
%                 current_Distance = norm(mean_LogDes - logm_StrDes(:,:,sam_th),'fro');
%                 if current_Distance < 1e-10
%                     current_Differential = zeros(size(current_Gradient));
%                 else
%                     current_Differential = (current_Gradient/sqrt(norm(current_Gradient,'fro')))*current_Distance;
%                 end               
%                 current_Differential = map2IDS_vectorize(current_Differential, 0);
%                 differential_Matrix(:,sam_th) = current_Differential;   
%             end
%     end
end
