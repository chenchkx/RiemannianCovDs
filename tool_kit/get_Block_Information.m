%% get the number of blocks and location matrix of all blocks
% Author: Kai-Xuan Chen
% Date: 2018.09.03


function [location_Matrix,block_Num] = get_Block_Information(option)
    block_Num = fix((option.resized_Row-option.block_Row)/option.step_Row+1)*fix((option.resized_Col-option.block_Col)/option.step_Col+1);
    temp_Matrix = zeros(2,block_Num);
    temp = 0;
    for row_th = 1:(option.resized_Row-option.block_Row)/option.step_Row+1
        x_Location = option.step_Row*(row_th-1)+1;
        for col_th = 1:(option.resized_Col-option.block_Col)/option.step_Col+1
            y_Location = option.step_Col*(col_th-1)+1;
            temp = temp + 1;
            temp_Matrix(1,temp) = x_Location;
            temp_Matrix(2,temp) = y_Location;
        end
    end
    location_Matrix = temp_Matrix;
    clear ('temp_Matrix','x_Location','y_Location','temp');
end