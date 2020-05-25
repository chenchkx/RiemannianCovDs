function [trainlist testlist] = random_split_training_test(exprs,categories_dir)

% random_split_training_test splits the training and testing sets 
%
% For  theoretical and technical details, please refer to the following paper:
%
% Qilong Wang, Peihua Li, Wangmeng Zuo, and Lei Zhang. RAID-G: Robust Estimation of 
% Approximate Infinite Dimensional Gaussian with Application to Material Recognition. 
% IEEE Conference on Computer Vision and Pattern Recognition Pattern Recognition (CVPR), 2016.
% 
% Please cite the paper above if you use the code:
%
% For questions,  please conact:  Qilong Wang  (Email:  qlwang at mail dot dlut dot edu dot cn), 
%                                               Peihua  Li (Email: peihuali at dlut dot edu dot cn) 
%
% The software is provided ''as is'' and without warranty of any kind,
% experess, implied or otherwise, including without limitation, any
% warranty of merchantability or fitness for a particular purpose.

trainlist = cell(length(categories_dir),1);
testlist = cell(length(categories_dir),1);

 for i = 1:length(categories_dir)

     %Select in random the training images per class
    file_list = dir(fullfile(exprs.base_image_dir, categories_dir(i).name, '*.jpg'));
    file_num = size(file_list, 1);

    randomized_idx = randperm(file_num);
    training_file_idx = randomized_idx(1:exprs.training_num_per_category);
    testing_file_idx  = randomized_idx(exprs.training_num_per_category+1:end);

    % Store indeces of training and testing images
    trainlist{i} = training_file_idx';
    testlist{i}  = testing_file_idx';

 end 
    