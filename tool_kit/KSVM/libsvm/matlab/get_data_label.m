function [traindata testdata trainlabel testlabel] =  get_data_label(categories_dir,featperclass,trainlist,testlist)

% get_data_label obtains training/testing data and label with meta information 
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

trainl = cell(length(categories_dir),1);
testl = cell(length(categories_dir),1);
traind = cell(length(categories_dir),1);
testd = cell(length(categories_dir),1);

 for i = 1:length(categories_dir)
     
    traind{i} = featperclass{i}(:,trainlist{i})';
    testd{i} = featperclass{i}(:,testlist{i})';
   
    trainl{i} = (i.*ones(length(trainlist{i}),1));
    testl{i}  = (i.*ones(length(testlist{i}),1));

 end
 
 traindata = cell2mat(traind);
 clear traind;
 traindata = traindata';
 testdata = cell2mat(testd);
 clear testd;
 testdata = testdata';
 trainlabel = cell2mat(trainl);
 testlabel = cell2mat(testl);