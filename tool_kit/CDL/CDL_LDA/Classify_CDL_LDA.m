function accuracy = Classify_CDL_LDA(data,rand_Matrix,option)
[Train_Spd_Cell,Test_Spd_Cell]=split_Data(data,rand_Matrix,option);
option.Type_Spd = 'Logm';
[d,~] =size(Train_Spd_Cell{1,1}); 
% param = SetParams_Update(d,Opt.Num_Class,Opt.Num_Train,Opt.Num_Test);
Label_Train = option.label_Train;
Num_Trains = length(Label_Train);
Label_Test = option.label_Test;
Num_Tests = length(Label_Test);

Train_Matrix = zeros(d,d,Num_Trains);
Test_Matrix = zeros(d,d,Num_Tests);
switch option.Type_Spd
    case('Spd')
        for train_th = 1:Num_Trains
            if mod(train_th,20) == 1
            fprintf('train SPD for logm : %d \n',train_th);
            end
            Train_Matrix(:,:,train_th) = logm(Train_Spd_Cell{1,train_th});
        end  
        for test_th = 1:Num_Tests
            if mod(test_th,20) == 1
            fprintf('test SPD for logm : %d \n',test_th);
            end
            Test_Matrix(:,:,test_th) =logm(Test_Spd_Cell{1,test_th});
        end 
    case('Logm')
        for train_th = 1:Num_Trains
            Train_Matrix(:,:,train_th) = Train_Spd_Cell{1,train_th};
        end  
        for test_th = 1:Num_Tests
            Test_Matrix(:,:,test_th) =Test_Spd_Cell{1,test_th};
        end  
end
  

X1_Train = reshape(Train_Matrix, size(Train_Matrix, 1) * size(Train_Matrix, 2), size(Train_Matrix, 3))';
% X1_Train = bsxfun(@rdivide, X1_Train, sqrt(sum(X1_Train.^2, 2)));
X2_Test = reshape(Test_Matrix, size(Test_Matrix, 1) * size(Test_Matrix, 2), size(Test_Matrix, 3))';
% X2_Test = bsxfun(@rdivide, X2_Test, sqrt(sum(X2_Test.^2, 2)));

KMatrix_Train = X1_Train*X1_Train';
KMatrix_Test = X1_Train*X2_Test';
% KMatrix_Train = KMatrix_Train.^50;
% KMatrix_Test = KMatrix_Test.^50;
% for ii = 1:Num_Trains
%     for jj = ii:Num_Trains
%         KMatrix_Train(ii,jj) = reshape(Train_Matrix(:,:,ii),1,d*d)*reshape(Train_Matrix(:,:,jj),d*d,1);
%         KMatrix_Train(jj,ii) = KMatrix_Train(ii,jj);
%     end
% end
% for ii = 1:Num_Trains
%     for jj = 1:Num_Tests
%         KMatrix_Test(ii,jj) = reshape(Train_Matrix(:,:,ii),1,d*d)*reshape(Test_Matrix(:,:,jj),d*d,1);
%     end
% end


% TrainSet.X = Train_Matrix;
% TrainSet.y = Label_Train';
% TestSet.X = Test_Matrix;
% TestSet.y = Label_Test;
% 
% [KMatrix_Train] = LogE_Kernels(TrainSet,TrainSet,param);
% [KMatrix_Test]  = LogE_Kernels(TrainSet,TestSet,param);




% fprintf('use fun_DCOVTrain function \n');
[EigVector,~] = fun_DCOVTrain(option,Label_Train,KMatrix_Train); 
% fprintf('fun_DCOVTrain function over\n');
Reduc_Train = EigVector'*KMatrix_Train;
Reduc_Test = EigVector'*KMatrix_Test;
Class_Lbale = classify_KNN(Reduc_Train,Reduc_Test,Label_Train);
accuracy = sum(Label_Test' == Class_Lbale')/Num_Tests;

