% Demo_LogE_Kernel--Demo code to perform kernelized sparse coding (SR) on the space
% symmetric positive definite (SPD) matrices using the the FERET database.
%  For  theoretical and technical details, please refer to the following paper:
%
% Peihua Li,  Qilong Wang, Wangmeng Zuo, and Lei Zhang. Log-Euclidean Kernels for Sparse 
% Representation and Dictionary Learning. IEEE Int. Conf. on Computer Vision (ICCV), 2013.


clear all;
clc;
addpath('data');
data_dir = 'data';
traindir = {'ba','bk','bj'};
testdir = {'bg','bf','be','bd'};

%% Set parameters
param = SetParams();

%% Load covariance matrices of training samples and set their labels
fprintf('The Demo of Log-E kernels for SR of SPD matrices on the "b"subset of FERET database.\n');
fprintf('Load training data.....\n');
for i = 1:param.TrainNum  
    [features] = Load_Cov_Features(data_dir,traindir{i},param);
    param.TrainData(:,:,param.TrainPos) = features;
    param.TrainPos = param.TrainPos + 1;
end

Trainlable = zeros(param.TrainNum*param.TextureKinds,1);
Testlable = 1:param.TextureKinds;
for i =1:param.TextureKinds
    Trainlable((i-1)*param.TrainNum+1:i*param.TrainNum) = i;
end
TrainSet.X= param.TrainData;
TrainSet.y = Trainlable';

%% Classification
for i = 1:param.TestNum 
    tic;
    [features] = Load_Cov_Features(data_dir,testdir{i},param);
    TestSet.X = features;
    TestSet.y = Testlable;
    fprintf('Dataset ----%s---- Kernelized SR Classification using  %s kernel: \n',testdir{i},param.kernel);
    CRR= SPD_SRC_Classification(TrainSet,TestSet,param);
    toc;
end




