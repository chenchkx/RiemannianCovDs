%% function : transform vector
% Author: Kai-Xuan Chen
% Date: 2018.12.21

function out_V = trans_Vector_Sign_Norm(input_V,option)
    out_V = zeros(size(input_V));
    for i = 1:size(input_V,2)
        temp_input_V = input_V(:,i);
        if strcmp(option.type_Norm_RLDV,'s')
            temp_out_V =  sign(temp_input_V) .* abs(temp_input_V).^ (0.5);
        elseif strcmp(option.type_Norm_RLDV,'n')
            temp_out_V = temp_input_V ./norm(temp_input_V,2);
        elseif strcmp(option.type_Norm_RLDV,'m')
            temp_input_V =  sign(temp_input_V) .* abs(temp_input_V).^ (0.5);
            temp_out_V = temp_input_V ./norm(temp_input_V,2);
        else
            temp_out_V = temp_input_V;
        end
        out_V(:,i) = temp_out_V;
    end
end