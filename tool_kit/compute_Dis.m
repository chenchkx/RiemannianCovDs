%% Author: Kai-Xuan Chen 
% Date: 2018.08.23
% compute distance matrix for NN methods
% input:  
%       option for current dataset
% output: 
%       distance matrix of current dataset

function dis_Matrix = compute_Dis(option)
%     option = set_OptionPath(option,rie_Metric,type_Gauss);
    data_Path = option.mat_Path;
    num_Class = option.num_Class;
    num_Set = option.num_Sample;
    row_th = 0;                   % row of dis_Matrix
    col_th = 0;                   % col of dis_Matrix
    for cla_rth = 1:num_Class
        current_rclass_Path = [data_Path,'\',option.pre_Class,num2str(cla_rth),'\'];
        for set_rth = 1:num_Set
            row_th = row_th + 1;
            current_rset_Path = [current_rclass_Path,option.pre_Set,num2str(set_rth),'\'];
            current_rset_Mat = [current_rset_Path,option.out_RieCovDs_Name];
            load (current_rset_Mat);
            r_spd_RCovDs = spd_RCovDs;
            r_log_RCovDs = log_RCovDs;
            r_inv_RCovDs = inv_RCovDs;
            clear ('spd_RCovDs','log_RCovDs','inv_RCovDs');
%%  for columns
            for cla_cth = 1:num_Class
            current_cclass_Path = [data_Path,'\',option.pre_Class,num2str(cla_cth),'\'];
                for set_cth = 1:num_Set
                    col_th = col_th + 1;
                    if col_th >= row_th
                        current_cset_Path = [current_cclass_Path,option.pre_Set,num2str(set_cth),'\'];
                        current_cset_Mat = [current_cset_Path,option.out_RieCovDs_Name];
                        load (current_cset_Mat);
                        c_spd_RCovDs = spd_RCovDs;
                        c_log_RCovDs = log_RCovDs;
                        c_inv_RCovDs = inv_RCovDs;
                        % distance while using AIRM
                        tmpEig =  eig(r_spd_RCovDs,c_spd_RCovDs); 
                        dis_AIRM = decide_Dis(sum(log(tmpEig).^2)); 
                        % distance while using Stein
                        dis_Stein = decide_Dis(compute_Stein_D(r_spd_RCovDs,c_spd_RCovDs));
                        % distance while using Jeffrey
                        dis_Jeff = decide_Dis(0.5*trace(r_inv_RCovDs*c_spd_RCovDs)+0.5*trace(c_inv_RCovDs*r_spd_RCovDs) - size(r_spd_RCovDs,1));
                        % distance while using LogED
                        dis_LogEu = decide_Dis(norm((r_log_RCovDs-c_log_RCovDs),'fro'));
                        if mod(row_th,5)==0 && mod(col_th,10)==0
                            fprintf('computing dis_Matrix of %d_th row, %d_th col for RieCovDs via %s. \n',row_th,col_th,option.rie_Metric); 
                        end                    
                        dis_Matrix_A(row_th,col_th) = dis_AIRM;dis_Matrix_A(col_th,row_th) = dis_AIRM;
                        dis_Matrix_S(row_th,col_th) = dis_Stein;dis_Matrix_S(col_th,row_th) = dis_Stein;
                        dis_Matrix_J(row_th,col_th) = dis_Jeff;dis_Matrix_J(col_th,row_th) = dis_Jeff;
                        dis_Matrix_L(row_th,col_th) = dis_LogEu;dis_Matrix_L(col_th,row_th) = dis_LogEu;
                        clear ('spd_RCovDs','log_RCovDs','inv_RCovDs');  
                        clear ('c_spd_RCovDs','c_log_RCovDs','c_inv_RCovDs');                       
                    end  
                end       
            end  
            col_th = 0;
            clear ('r_spd_RCovDs','r_log_RCovDs','r_inv_RCovDs');
        end       
    end
    dis_Matrix.A = dis_Matrix_A;
    dis_Matrix.S = dis_Matrix_S;
    dis_Matrix.J = dis_Matrix_J;
    dis_Matrix.L = dis_Matrix_L;
    save(option.dis_Matrix_Path,'dis_Matrix');
end