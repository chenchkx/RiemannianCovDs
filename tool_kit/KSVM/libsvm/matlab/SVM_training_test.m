% Author:
% --Peihua Li(peihuali at dlut dot edu dot cn)
%
% This file is provided without any warranty of
% fitness for any purpose. You can redistribute
% this file and/or modify it under the terms of
% the GNU General Public License (GPL) as published
% by the Free Software Foundation, either version 3
% of the License or (at your option) any later version.
   


function [predict_label, accuracy, dec_values]  = SVM_training_test(base_image_dir, training_num_per_category, file_suffix)


categories_dir0 = dir(base_image_dir);
categories_dir = struct([]);
for i=1:length(categories_dir0)
    if strcmp(categories_dir0(i).name, '.') ==1 ||  strcmp(categories_dir0(i).name, '..') ==1 || categories_dir0(i).isdir == 0
        continue;
    end
    categories_dir = [categories_dir; categories_dir0(i)];
end

    trainlist = [];
    testlist  = [];
    currentNum = 0;

    train_label = [];
    test_label  = [];
    category_idx = 1;

    all_file_list = cell(0, 1);
    ObjectKinds = 0;
    [pathstr, name, ext] = fileparts(base_image_dir);
    for i = 1:length(categories_dir)

         %Select in random the training images per class
         file_list = dir(fullfile(base_image_dir, categories_dir(i).name, '*.mat'));
         file_num = size(file_list, 1);
         randomized_idx = randperm(file_num);
         training_file_idx = randomized_idx(1:training_num_per_category);
         testing_file_idx  = randomized_idx(training_num_per_category+1:end);

         % Store indeces of training and testing images (in ALL the images)
         trainlist = [trainlist; training_file_idx' + currentNum];
         testlist  = [testlist;   testing_file_idx' + currentNum];
         currentNum = currentNum + file_num;

         %Store the labels of training and testing images
         curr_train_label = zeros(length(training_file_idx), 1);
         curr_train_label(:) = category_idx;
         train_label = [train_label; curr_train_label];

         curr_test_label = zeros(length(testing_file_idx), 1);
         curr_test_label(:) = category_idx;
         test_label = [test_label; curr_test_label];

         category_idx = category_idx + 1;


         for j = 1: file_num
             curr_file_name =  file_list(j).name;
             full_file_name = fullfile(base_image_dir, categories_dir(i).name, curr_file_name);
             all_file_list = [all_file_list;full_file_name];
        end

         ObjectKinds = ObjectKinds + 1;

    end 
   
    %% Load models of training images
    pyramid_train = cell(length(trainlist), 1);
    pyramid_files = all_file_list(trainlist);
    parfor i = 1:length(trainlist)
        pyramid_train{i} = load_one_file(pyramid_files{i});
    end
    dataTrain  = double(cat(1, pyramid_train{:}));   pyramid_train = [];
%     dataTrain = sign(dataTrain) .* sqrt(abs(dataTrain));
%     dataTrain = bsxfun(@rdivide, dataTrain, max(sqrt(sum(dataTrain .^2, 2)), eps(4)));
    
    flag_vlfeat = 0;
    if flag_vlfeat == 0
        model = train(train_label, sparse(dataTrain), '-s 0 -c 1000 -q');      
        %model = train(train_label, sparse(dataTrain), '-s 4 -c 50 -q');        %faster but a little worse
    else
        C = 10;
        lambda = 1 / (C*numel(train_label)) ;
        par = {'Solver', 'sdca', 'Verbose', ...
               'BiasMultiplier', 1, ...
               'Epsilon', 0.001, ...
               'MaxNumIterations', 100 * numel(train_label)} ;
        w = cell(1, length(categories_dir)) ;
        b = cell(1, length(categories_dir)) ;
        for c = 1:length(categories_dir)
            pos_idx = find(train_label == c);
            neg_idx = find(train_label ~= c);
            label = ones(1,numel(train_label));
            label(neg_idx) = -1;
            [w{c},b{c}] = vl_svmtrain(dataTrain', label, lambda, par{:}) ;
        end
    end
    dataTrain = [];


    predict_label = zeros(length(testlist), 1);
    
    num_per_time = 2000;
    num_iter = floor(length(testlist) / num_per_time);
    pyramid_test = cell(num_per_time, 1);
    for k = 1:num_iter
        curr_idx = (k - 1) * num_per_time+1: k*num_per_time;
        pyramid_files = all_file_list(testlist(curr_idx));
        parfor i = 1 : num_per_time
            pyramid_test{i} = load_one_file(pyramid_files{i});
        end
        dataTest  = double(cat(1, pyramid_test{:}));   
%         dataTest = sign(dataTest) .* sqrt(abs(dataTest));
%         dataTest = bsxfun(@rdivide, dataTest, max(sqrt(sum(dataTest .^2, 2)), eps(4)));
        if flag_vlfeat == 0
            [~, predict_label(curr_idx), accuracy, dec_values] = evalc('predict(test_label(curr_idx), sparse(dataTest), model)'); 
        else
            dec_values = 0;   %no sense
            scores = cell(1, length(categories_dir)) ;
            for c = 1:length(categories_dir)
                scores{c} = w{c}' * dataTest' + b{c} ;
            end
            scores = cat(1,scores{:}) ;
            [~,predict_label(curr_idx)] =  max(scores, [], 1) ;
        end
    end
    
    curr_idx = k * num_per_time+1: length(testlist);
    if length(curr_idx) > 0
        pyramid_test = cell(length(curr_idx), 1);
        pyramid_files = all_file_list(testlist(curr_idx));
        parfor i = 1 : length(curr_idx)
            pyramid_test{i} = load_one_file(pyramid_files{i});
        end
        dataTest  = double(cat(1, pyramid_test{:}));   pyramid_test = [];
%         dataTest = sign(dataTest) .* sqrt(abs(dataTest));
%         dataTest = bsxfun(@rdivide, dataTest, max(sqrt(sum(dataTest .^2, 2)), eps(4)));
        if flag_vlfeat == 0
            [~, predict_label(curr_idx), accuracy, dec_values] = evalc('predict(test_label(curr_idx), sparse(dataTest), model)'); 
        else
            dec_values = 0;   %no sense
            scores = cell(1, length(categories_dir)) ;
            for c = 1:length(categories_dir)
                scores{c} = w{c}' * dataTest' + b{c} ;
            end
            scores = cat(1,scores{:}) ;
            [~,predict_label(curr_idx)] =  max(scores, [], 1) ;
        end
    end
    accuracy = sum(predict_label == test_label) / length(test_label)*100;
      
    fprintf('Accuracy=%2.2f%% (%d/%d)\n', accuracy, sum(predict_label == test_label), length(test_label));

%     %% Load models of test images
%     pyramid_test = cell(length(testlist), 1);
%     pyramid_files = all_file_list(testlist);
%     parfor i = 1:length(testlist)
%         pyramid_test{i} = load_one_file(pyramid_files{i});
%     end
%     dataTest  = double(cat(1, pyramid_test{:}));   pyramid_test = [];
%     dataTest = sign(dataTest) .* sqrt(abs(dataTest));
% 
%     [predict_label, accuracy, dec_values] = predict(test_label, sparse(dataTest), model); 
%     dataTest = [];

end

function [pyramid_cell] = load_one_file(file_name)
           load(file_name, 'pyramid_cell');
end


