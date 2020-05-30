%% Author: Kai-Xuan Chen 
% Date: 2018.08.16-2018.08.22

function feature_Matrix = compute_Localfeas(patch_Image)
    [patch_Rows,patch_Cols] = size(patch_Image);
    [g_X,g_Y] = gradient(patch_Image);
    g_X = abs(g_X);
    g_Y = abs(g_Y);
    coor_X = repmat([1:patch_Rows]',1,patch_Cols);
    coor_Y = repmat([1:patch_Cols],patch_Rows,1);
    feature_Matrix(1,:) = reshape(coor_X,[1 patch_Rows*patch_Cols]);
    feature_Matrix(2,:) = reshape(coor_Y,[1 patch_Rows*patch_Cols]);
    feature_Matrix(3,:) = reshape(patch_Image,[1 patch_Rows*patch_Cols]);
    feature_Matrix(4,:) = reshape(g_X,[1 patch_Rows*patch_Cols]);
    feature_Matrix(5,:) = reshape(g_Y,[1 patch_Rows*patch_Cols]);
end