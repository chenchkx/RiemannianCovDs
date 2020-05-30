function accuracy = Classify_KNN_LogEKernel(Train_Spd,Test_Spd,Opt)
Label_Train = Opt.Label_Train;
Label_Test = Opt.Label_Test;
Num_Train = length(Train_Spd);
Num_Test = length(Test_Spd);
if iscell(Train_Spd)&&iscell(Test_Spd)
    [d ,~] = size(Train_Spd{1,1});
    Train_Matrix = zeros(d,d,Num_Train);
    Test_Matrix = zeros(d,d,Num_Test);
    switch Opt.Type_Spd
        case('Logm')
            for tr_th = 1:Num_Train
                Train_Matrix(:,:,tr_th) = Train_Spd{1,tr_th};
            end
            for tt_th = 1:Num_Test
                Test_Matrix(:,:,tt_th) = Test_Spd{1,tt_th};
            end
        case('Spd')
            for tr_th = 1:Num_Train
                Train_Matrix(:,:,tr_th) = logm(Train_Spd{1,tr_th});
            end
            for tt_th = 1:Num_Test
                Test_Matrix(:,:,tt_th) = logm(Test_Spd{1,tt_th});
            end
    end
end

Train_Matrix = reshape(Train_Matrix, size(Train_Matrix, 1) * size(Train_Matrix, 2), size(Train_Matrix, 3))';
Train_Matrix = bsxfun(@rdivide, Train_Matrix, sqrt(sum(Train_Matrix.^2, 2)));
Test_Matrix = reshape(Test_Matrix, size(Test_Matrix, 1) * size(Test_Matrix, 2), size(Test_Matrix, 3))';
Test_Matrix = bsxfun(@rdivide, Test_Matrix, sqrt(sum(Test_Matrix.^2, 2)));
% Train_Matrix = reshape(Train_Matrix,[d*d,Num_Train]);
% Test_Matrix = reshape(Test_Matrix,[d*d,Num_Test]);
K_Tr_Tr = Train_Matrix*Train_Matrix';
K_Tr_TT = Train_Matrix*Test_Matrix';
clear Train_Matrix clear Test_Matrix;
A = K_Tr_Tr;
[U ,S ,V]=svd(A);
A_OneHalf = U*diag(sqrt(diag(S)+eps(1)))*U';
A_OneHalf_inv = U * diag(1 ./ sqrt(diag(S))) * U';
test_kernel =  bsxfun(@rdivide, K_Tr_TT, sqrt(sum(K_Tr_TT .* K_Tr_TT, 1)));
Y = A_OneHalf_inv * test_kernel;
K_Tr_Tr = A_OneHalf;
K_Tr_TT = Y;
 

Out_Label = zeros(1,Num_Test);
for tt_th = 1:Num_Test
   TTsample = K_Tr_TT(:,tt_th) ;
   dis = zeros(1,Num_Train);
   for tr_th = 1:Num_Train
       Trsample = K_Tr_Tr(:,tr_th) ;
       dis(1,tr_th) = norm(TTsample-Trsample,2);
   end
   [~,ind] = min(dis);
   Out_Label(1,tt_th) = Label_Train(1,ind);
end
accuracy = sum((Out_Label - Label_Test) == 0)/size(Label_Test,2);