% Author: Kai-Xuan Chen
% Date: 2018.08.13

function [train_Data,test_Data] = split_Data(data,rand_Matrix,option)
    for class_th = 1:option.num_Class
        train_Data(1,option.num_Train*class_th-option.num_Train+1:option.num_Train*class_th) = data(class_th,rand_Matrix(class_th,1:option.num_Train));
        test_Data(1,option.num_Test*class_th-option.num_Test+1:option.num_Test*class_th) = data(class_th,rand_Matrix(class_th,1+option.num_Train:option.num_Sample));
    end
end