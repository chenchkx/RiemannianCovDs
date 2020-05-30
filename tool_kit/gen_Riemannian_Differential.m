%% Riemannian K-Means & Riemannian differential for several Riemannian metric on SPD manifold
% Author: Kai-Xuan Chen
% Date: 2018.08.13-2018.08.13
% the corresponding source code can be found at: https://github.com/mfaraki/Riemannian_VLAD
%                   paper:  "More About VLAD: A Leap from Euclidean to Riemannian Manifolds", Masoud Faraki, Mehrtash Harandi, 
%                           and Fatih Porikli,In Proc. IEEE Conference on Computer Vision and Pattern Recognition (CVPR), Boston, USA, 2015. 

function differential_Matrix_Gauss = gen_Riemannian_Differential(mean_Cell,cov_Cell,option)
    cov_Matrix = cat(3,cov_Cell{1,:}); 
    cov_Matrix = real(cov_Matrix);
    if size(mean_Cell{1,1},1) ==1
        mean_Matrix = cat(1,mean_Cell{:})';
    else
        mean_Matrix = cat(2,mean_Cell{:});
    end
    switch option.type_Gauss 
        case 'DE'
            cov_Matrix = add2SPD(cov_Matrix,option);
            structural_Descriptors = cov_Matrix;
            different_Matrix_Cov = com_Riemannian_Differential(structural_Descriptors,option);
            mean_Vector = mean(mean_Matrix,2);
            different_Matrix_Mean = mean_Matrix - repmat(mean_Vector,1,size(mean_Matrix,2));
            temp_differential_Matrix_Gauss = [option.alpha_Gauss.*different_Matrix_Mean;different_Matrix_Cov];    
            differential_Matrix_Gauss = trans_Vector_Sign_Norm(temp_differential_Matrix_Gauss,option);
        case 'IE'
            structural_Descriptors = embed_Gauss2SPD(mean_Matrix,cov_Matrix,option);
            structural_Descriptors = real(structural_Descriptors);
            temp_differential_Matrix_Gauss = com_Riemannian_Differential(structural_Descriptors,option);
            differential_Matrix_Gauss = trans_Vector_Sign_Norm(temp_differential_Matrix_Gauss,option);
    end
end