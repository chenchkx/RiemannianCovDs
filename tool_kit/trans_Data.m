%% Author: Kai-Xuan Chen
% Date(1): 2018.08.18
% Date(2): 2018.09.23

function sample_Matrix = trans_Data(data_Cell)
    num_Cell = length(data_Cell);
    [d,~] =size(data_Cell{1,1});
    sample_Matrix = zeros(d,d,num_Cell);
    for i = 1:num_Cell
        sample_Matrix(:,:,i) = data_Cell{i};        
    end
    sample_Matrix = reshape(sample_Matrix,[size(sample_Matrix,1)*size(sample_Matrix,2),num_Cell]);
    
%     sample_Matrix = [];
%     for i = 1:num_Cell
%         current_Data = data_Cell{i};
%         sample_Matrix = [sample_Matrix(),reshape(current_Data,[size(current_Data,1)*size(current_Data,2),1])];        
%     end
end