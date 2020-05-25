%% Function for extracting local features 
% Author: Kai-Xuan Chen
% Date: 2018.12.13

function fea_Matrix = compute_LocalFea(option,image_Sam)
    if strcmp(option.type_C,'RGB') && size(image_Sam,3)~=3
        image_Sam = repmat(image_Sam,[1,1,3]);
        image_Sam = double(image_Sam); 
    elseif strcmp(option.type_C,'Gray') && size(image_Sam,3)~=1
        image_Sam = rgb2gray(image_Sam);
        image_Sam = double(image_Sam); 
    else
        image_Sam = double(image_Sam); 
    end
    [f_Dim,s_Dim,t_Dim] = size(image_Sam);   
    x_Matrix = repmat([1:f_Dim]',1,s_Dim);
    y_Matrix = repmat([1:s_Dim],f_Dim,1);
    fea_Matrix(:,:,1) = x_Matrix;
    fea_Matrix(:,:,2) = y_Matrix;
    for cha_th = 1:t_Dim
        current_Cha = image_Sam(:,:,cha_th);
        temp_CurCha = computa_SinFea(current_Cha);
        fea_Matrix = cat(3,fea_Matrix,temp_CurCha);
    end

end     

function tem_Matrix = computa_SinFea(sinFea_Matrix)
        tem_Matrix(:,:,1) = sinFea_Matrix;
        [x_G,y_G] = gradient(sinFea_Matrix);
        tem_Matrix(:,:,2) = abs(x_G);
        tem_Matrix(:,:,3) = abs(y_G);
%         [xx_G,~] = gradient(x_G);
%         [~,yy_G] = gradient(y_G);
%         tem_Matrix(:,:,4) = abs(xx_G);
%         tem_Matrix(:,:,5) = abs(yy_G);
end