%% function for generating index matrix
% Author: Kai-Xuan Chen
% Date: 2018.12.13
% Date: 2018.12.22
function ind_Beg_Matrix = compute_NumVolume(block_Depth,step_Temporal,num_Sam)
    ind_Beg_LastVolume = num_Sam - block_Depth + 1;
    temp_Ind_Beg_Matrix = [1:step_Temporal:ind_Beg_LastVolume];
%     if temp_Ind_Beg_Matrix(end) ~= ind_Beg_LastVolume
%         temp_Ind_Beg_Matrix(1,1+end) = ind_Beg_LastVolume;
%     end
    ind_Beg_Matrix = temp_Ind_Beg_Matrix;
end