%% Author: Kai-Xuan Chen 
% Date: 2018.08.24
% NN methods(AIRM,Stein,Jeffrey,LogED) on distance matrix via different Reimannian metrices

function accuracy = nn_Via_disMatrix(option,ind_Matrix,disMatrix)
    label_Matrix_Row = reshape(ones(option.num_Sample,option.num_Class)*diag([1:option.num_Class]),...
        [1,option.num_Class*option.num_Sample]);
    label_Matrix_Col = label_Matrix_Row;
    ind_Gallery = []; ind_Probe = [];
    for cla_th = 1:option.num_Class
        current_Ind = ind_Matrix(cla_th,:)+option.num_Sample*(cla_th-1);
        ind_Gallery = [ind_Gallery, current_Ind(1,1:option.num_Gallery)];
        ind_Probe = [ind_Probe, current_Ind(1,option.num_Gallery+1:option.num_Sample)];
    end
    disMatrix_Gallery2Probe = disMatrix(ind_Gallery,ind_Probe);
    label_Gallery = label_Matrix_Col(1,ind_Gallery);
    label_Probe = label_Matrix_Col(1,ind_Probe);
    [~,ind_Label] = min(disMatrix_Gallery2Probe);
    out_Label = label_Gallery(1,ind_Label);
    accuracy = sum((out_Label - label_Probe) == 0)/size(label_Probe,2);
end