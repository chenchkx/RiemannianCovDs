function CRR = Classify_LogEK(data,rand_Matrix,option)
option.Type_Spd = 'Logm';
[Train_Spd_Cell,Test_Spd_Cell]=split_Data(data,rand_Matrix,option);
[d,~] =size(Train_Spd_Cell{1,1}); 
param = SetParams_Update(d,option.num_Class,option.num_Train,option.num_Test);
if isfield(option,'LogEK_Kernel')
   param.kernel = option.LogEK_Kernel; 
end
if isfield(option,'LogEK_N')
    param.n = option.LogEK_N;
end
Label_Train = option.label_Train;
Num_Trains = length(Label_Train);
Train_Matrix = zeros(d,d,Num_Trains);
Label_Test = option.label_Test;
Num_Tests = length(Label_Test);
Test_Matrix = zeros(d,d,Num_Tests);
switch option.Type_Spd
    case('Spd')
        for train_th = 1:Num_Trains
            Train_Matrix(:,:,train_th) = logm(Train_Spd_Cell{1,train_th});
        end  
        for test_th = 1:Num_Tests
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


TrainSet.X = Train_Matrix;
TrainSet.y = Label_Train';

%     [features] = Load_Cov_Features(data_dir,testdir{i},param);
TestSet.X = Test_Matrix;
TestSet.y = Label_Test;
%     fprintf('Dataset ----%s---- Kernelized SR Classification using  %s kernel: \n',testdir{i},param.kernel);
CRR= SPD_SRC_Classification(TrainSet,TestSet,param);