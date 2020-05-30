function accuracy = Classify_NN_AIRM(data,rand_Matrix,option)
    Label_Train = option.label_Train;
    Label_Test = option.label_Test;
    [Train_Spd_Cell,Test_Spd_Cell]=split_Data(data,rand_Matrix,option);
    Num_Test = length(Test_Spd_Cell);
    Out_Label = zeros(1,Num_Test);

    Dis_AIRM = Compute_AIRM_Metric(Train_Spd_Cell,Test_Spd_Cell);
    for test_th = 1:Num_Test
        dis_th = Dis_AIRM(test_th,:);
        [~,ind] = min(dis_th);
        Out_Label(1,test_th) = Label_Train(1,ind);
    end
    accuracy = sum((Out_Label - Label_Test) == 0)/size(Label_Test,2);
end