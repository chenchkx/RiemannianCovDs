%% Author: Kai-Xuan Chen 
% Date: 2018.12.12-2018.12.12

function rie_CovDs = compute_RCovDs(differential_Cell)
    num_Cell = length(differential_Cell);    
    temp_Matrix = zeros(num_Cell,num_Cell);
    for i_th = 1:num_Cell
        i_Cell = real(differential_Cell{1,i_th});
        for j_th = i_th:num_Cell
            j_Cell = real(differential_Cell{1,j_th});
            variance_I_J = compute_Variance(i_Cell,j_Cell);
            temp_Matrix(i_th,j_th) = variance_I_J;
            temp_Matrix(j_th,i_th) = variance_I_J;
        end
    end
    rie_CovDs = temp_Matrix;    
end