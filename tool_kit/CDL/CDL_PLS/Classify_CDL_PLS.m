%% Author: Kai-Xuan Chen (Rewritten by Kai-Xuan Chen, tested on the logm of SPD matrices)
% Date: 2018.08.27
% Classification Method CDL_PLS(source code) from : Chinese Academy of Sciences (http://vipl.ict.ac.cn/homepage/rpwang/index.htm)
% Written by Ruiping Wang, August 28 2014 (version 1.0)
% Please refer to the following paper:
% R. Wang, H. Guo, L.S. Davis, and Q. Dai, "Covariance Discriminative Learning: A Natural and Efficient Approach to Image Set Classification", Proc. Int'l Conf. Computer Vision and Pattern Recognition, 2012.

function accuracy = Classify_CDL_PLS(data,rand_Matrix,option)
    Label_Train = option.label_Train;
    Label_Test = option.label_Test;
    [COV_EachSet_Train,COV_EachSet_Test]=split_Data(data,rand_Matrix,option);
    nTrain_COV = length(COV_EachSet_Train);
    nTest_COV = length(COV_EachSet_Test);
    KMatrix_Train = zeros(nTrain_COV,nTrain_COV);
    KMatrix_Test = zeros(nTrain_COV,nTest_COV);
    for i = 1:nTrain_COV
        for j = i:nTrain_COV
            COV_i = COV_EachSet_Train{i}; %% note that COV_i/j  is actually the log mapped COV
            COV_j = COV_EachSet_Train{j};
    %		KMatrix_Train(i,j) = trace(COV_i*COV_j); %% this is the original definition, following is for speed up
            A_1 = COV_i;
            A_2 = COV_j;
            A_11 = reshape(A_1,size(A_1,1)*size(A_1,2),1);
            A_22 = reshape(A_2,size(A_2,1)*size(A_2,2),1);
            KMatrix_Train(i,j) = A_11'*A_22;
            KMatrix_Train(j,i) = KMatrix_Train(i,j);
        end
    end

    for i = 1:nTrain_COV
        for j = 1:nTest_COV
            COV_i = COV_EachSet_Train{i}; %% note that COV_i/j  is actually the log mapped COV
            COV_j = COV_EachSet_Test{j};
    %		KMatrix_Test(i,j) = trace(COV_i*COV_j); %% this is the original definition, following is for speed up
            A_1 = COV_i;
            A_2 = COV_j;
            A_11 = reshape(A_1,size(A_1,1)*size(A_1,2),1);
            A_22 = reshape(A_2,size(A_2,1)*size(A_2,2),1);
            KMatrix_Test(i,j) = A_11'*A_22;
        end
    end
    % step 2: PLS training process
    label_0 = zeros(option.num_Class,1);
    X = [];
    Y = [];
    for i = 1:nTrain_COV
        COV_i = COV_EachSet_Train{i};
        A_1 = COV_i;
        A_11 = reshape(A_1,size(A_1,1)*size(A_1,2),1);
        N = size(A_11,2);
        X = [X A_11];
        Label_i = repmat(label_0,1,N);
        class_ind = Label_Train(1,i);
        Label_i(class_ind,:) = 1;
        Y = [Y Label_i];
    end
    X = X';
    Y = Y';

strDestFile = sprintf('HDR_TMatrix_COV_DA_PLS_Kernel_Nc_%d_dd_%d.mat',1,400);
if ( exist(strDestFile,'file') )
    load(strDestFile);
else 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% 20110812 KPLS training
    M_Y = mean(Y,1);
    N_train = size(X,1);
    Y_center = Y - repmat(M_Y,N_train,1);
    K_train = KMatrix_Train;
    M = eye(N_train)-ones(N_train,N_train)/N_train;
    K_train_center = M*K_train*M;

    Fac = 200; %% parameter for PLS dimension
%     [B,T,U,param_out] = KerNIPALS_new(K_train_center,Y_center,Fac,0);    %%% a) NIPALS based KPLS  
    %[B,T] = KerPLS_eig(K,Y,Fac,0); %%% b) K*Y*Y'*t = a *t based KPLS 
    [T,U] = Re_KPLS(K_train_center,Y_center,Fac);
    PLS_param.M_Y = M_Y;
    PLS_param.N_train = N_train;
    PLS_param.K_train = K_train;
    PLS_param.Y_center = Y_center;
    PLS_param.Fac = Fac;
%     PLS_param.B = B;
%     PLS_param.param = param_out;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    strVar_1 = 'PLS_param';
    strVar_2 = 'B';
%    save(strDestFile,strVar_1,strVar_2);
end

    % step 3: PLS testing process
    if isfield(option,'latentDim_PLS')
        Dim = option.latentDim_PLS;
    else
        Dim = option.num_Class - 1;
    end

    M_Y = PLS_param.M_Y;
    N_train = PLS_param.N_train;
    K_train = PLS_param.K_train;
    Y_center = PLS_param.Y_center;
    M = eye(N_train)-ones(N_train,N_train)/N_train;
    K_train_center = M*K_train*M;

    N_test = nTest_COV;
    K_test = KMatrix_Test';
    Mt = ones(N_test,N_train)/N_train;
    K_test_center = (K_test - Mt*K_train)*M;

    % step 3.1: KPLS regression
    kk = Dim;
    T = T(:,1:kk);
    U = U(:,1:kk);
    B = U*inv(T'*K_train_center*U)*T'*Y_center;
    YY = K_test_center*B + repmat(M_Y,N_test,1);

    % step 3.2: compute classification rate
    n_class = option.num_Class;
    TestMD_IDResultForm = zeros(nTest_COV,n_class,2);
    for i = 1:nTest_COV
        CurTestSetResult = zeros(1,n_class);
        CurTestSetResult(1,:) = YY(i,:);
        [tmp_1, ind_1] = sort(CurTestSetResult(1,:),2,'descend');
        TestMD_IDResultForm(i,:,1) = tmp_1(1:end);
        TestMD_IDResultForm(i,:,2) = ind_1(1:end);
    end

    nTestRightCount = 0;
    for i = 1:nTest_COV
        i_TestIndex = i;
        j_PredictIndex = TestMD_IDResultForm(i,1,2);

        GallaryID = Label_Test(1,i_TestIndex);
        PredictID = j_PredictIndex;
        if ( PredictID == GallaryID )
            nTestRightCount = nTestRightCount + 1;
        end
    end
    accuracy = nTestRightCount / nTest_COV;
%     disp(['The recognition rate is:  ' num2str(TestRate)]);

end