function [ features ] = Load_Cov_Features(data_dir,classdir,param)
% Load_Cov_Features loads the features from disk
%
% Please cite the following paper if you use the code:
%
% Peihua Li,  Qilong Wang, Wangmeng Zuo, and Lei Zhang. Log-Euclidean Kernels for Sparse 
% Representation and Dictionary Learning. IEEE Int. Conf. on Computer Vision (ICCV), 2013.


dataname     = fullfile(data_dir, sprintf('%s.mat',classdir));
logdataname = fullfile(data_dir, sprintf('log%s.mat',classdir));

switch param.features
        case('ori') % Load covariance matrices and compute their logarithms
            data = load(dataname);
            features = data.features;
            d = size(features, 1);
            U = zeros(d);
            S = zeros(d);
            V = zeros(d);
            for i=1:size(features, 3)
                [U S V]=svd(features(:, :, i));
                features(:, :, i)  = U * diag(log(diag(S))) * V';
            end              
        case('log') % Load directly the logarithms of the covariance matrices
            logdata = load(logdataname);
            features = logdata.logfeatures;   
end






