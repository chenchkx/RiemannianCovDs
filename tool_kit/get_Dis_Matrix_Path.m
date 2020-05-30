%% Author: Kai-Xuan Chen 
% Date: 2018.08.24
% get '.mat' file of distance matrix
% input: the option for dataset
% output: the path of distance matrix

function dis_Matrix_Path = get_Dis_Matrix_Path(option)
    dis_Matrix_Path = [option.mat_Path,'\','disMatrix_',option.rie_Metric,'_typeBlock',num2str(option.num_Sqrt_Block),...
                    '_',option.type_F,'.mat'];
end