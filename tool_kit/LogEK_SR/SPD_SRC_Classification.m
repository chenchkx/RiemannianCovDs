function [accuracy] = SPD_SRC_Classification(TrainSet,TestSet,Lparam)
% SPD_SRC_Classification(TrainSet,TestSet,Lparam)  perform kernel based classification 
% given TrainSet and TestSet together with Lparam.
% The size of TrainSet is d by d by n1, where n1 denotes the 
% number of random vector and d is their dimension, the size of TestSet is d
% by d by n2, and TestSet contains the parameters used for computing the
% kernel matrix (c.f. SetParams.m).
%
% Please cite the following paper if you use the code:
%
% Peihua Li,  Qilong Wang, Wangmeng Zuo, and Lei Zhang. Log-Euclidean Kernels for Sparse 
% Representation and Dictionary Learning. IEEE Int. Conf. on Computer Vision (ICCV), 2013.
%
% For questions,  please conact:  Qilong Wang  (Email:  wangqilong.415@163.com), 
%                                               Peihua  Li (Email: peihuali at dlut dot edu dot cn) 
%
% The software is provided ''as is'' and without warranty of any kind,
% experess, implied or otherwise, including without limitation, any
% warranty of merchantability or fitness for a particular purpose.


% galleryKernel = exp(-1e1*Stein_Divergence(TrainSet.X,TrainSet.X));
% probeKernel = exp(-1e1*Stein_Divergence(TestSet.X,TrainSet.X))';
% training_kernel = galleryKernel./repmat(sqrt(sum(galleryKernel.^2)),[size(galleryKernel,1) 1]);
% test_kernel = probeKernel./repmat(sqrt(sum(probeKernel.^2)),[size(probeKernel,1) 1]);

%% Compute kernel matrix
[training_kernel] = LogE_Kernels(TrainSet,TrainSet,Lparam);
[test_kernel]  = LogE_Kernels(TestSet,TrainSet,Lparam);
test_kernel = test_kernel';

% d = size(TrainSet.X,1);
% training_kernel = LogE_Kernrls_myself(TrainSet.X,TrainSet.X,d);
% test_kernel = LogE_Kernrls_myself(TrainSet.X,TestSet.X,d);

%% Kernel based sparse represenation (SR)
%  Here we transform linearly kernelized SR to non-kernelized one, and the latter is  solved by
% SPArse Modeling Software (SPAMS) at http://spams-devel.gforge.inria.fr

A = training_kernel;
[U ,S ,V]=svd(A);
A_OneHalf = real(U*diag(sqrt(diag(S)+eps(1)))*U');
A_OneHalf_inv = U * diag(1 ./ sqrt(diag(S))) * U';
test_kernel =  bsxfun(@rdivide, test_kernel, sqrt(sum(test_kernel .* test_kernel, 1)));
Y =real(A_OneHalf_inv * test_kernel);
param.lambda = Lparam.SR_Lambda;
param.lambda2 =  Lparam.SR_Lambda * 1e-2; 
param.mode = 2;
sparse_X = full(mexLasso(Y, A_OneHalf, param));
 % classification
test_labels = SRC_Classification(A_OneHalf, TrainSet.y, sparse_X, Y);
% 
% SR_Lambda = 1e-2;
% [KD_U,KD_D,~] = svd(training_kernel);    
% A = diag(sqrt(diag(KD_D)))*KD_U';
% D_Inv = KD_U*diag(1./sqrt(diag(KD_D)));
% KX = D_Inv'*test_kernel;
% sparse_X = full(mexLasso(KX,A,struct('mode',2,'lambda',SR_Lambda,'lambda2',0)));
% test_labels = SRC_Classification(A, TrainSet.y, sparse_X, KX);
 


    
accuracy = sum((test_labels - TestSet.y == 0)) / size(test_kernel,2);
% fprintf('Classification accuracy is %f %% \n', accuracy*100);
end


