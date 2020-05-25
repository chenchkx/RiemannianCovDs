%% Author: Kai-Xuan Chen 
% Date: 2018.08.23
% generate structural descriptor for regions 

function spd = gen_SPD_MatrixViaGaussEmbedding(option,raw_Sample)
    switch option.type_F
        case ('Local')
            feature_Matrix = compute_Localfeas(double(raw_Sample));       
        case ('Gabor')
            row_GaborK = fix(option.row_GaborK/option.num_Sqrt_Block);
            col_GaborK = fix(option.col_GaborK/option.num_Sqrt_Block);
            if mod(row_GaborK,2) == 0
                row_GaborK = row_GaborK + 1;
            end
            if mod(col_GaborK,2) == 0
                col_GaborK = col_GaborK + 1;
            end   
%             row_GaborK = option.row_GaborK;
%             col_GaborK = option.col_GaborK;
            gabor_Image = ZF_GaborFilter(double(raw_Sample),option.scale_Gabor,option.orientation_Gabor,row_GaborK,col_GaborK);
            gabor_Image = reshape(gabor_Image,[size(gabor_Image,1)*size(gabor_Image,2),option.scale_Gabor*option.orientation_Gabor]);
%             feature_Matrix = gabor_Image;
            gabor_Image = zscore(gabor_Image);
            feature_Matrix = compute_Localfeas(double(raw_Sample));
            feature_Matrix = [feature_Matrix;gabor_Image'];
            clear('gabor_Image');
        case ('Sift')
            feature_Matrix =  DSIFT(double(raw_Sample),option.size_Sift,option.step_Sift);
    end
    
    spd = embed_Gauss2SPD_Sim(feature_Matrix,option);
    clear('feature_Matrix');
%     Cov = cov(feature_Matrix');
%     spd = Cov;    
end