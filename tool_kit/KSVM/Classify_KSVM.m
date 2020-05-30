function accuracy = Classify_KSVM(data,rand_Matrix,option)
    trainlabel = option.label_Train;
    testlabel = option.label_Test;
    [train_Samples,test_Samples]=split_Data(data,rand_Matrix,option);
    train_Samples = trans_Data(train_Samples);
    test_Samples = trans_Data(test_Samples);
    option.kernel = 'linear';
    option.libsvm = 'oneVSall';
    option.lc = 4; 
    option.alpha = 0.75;
    option.beta = 0.3;
    accuracy = SVMforClassification(train_Samples,test_Samples,option);
    
end