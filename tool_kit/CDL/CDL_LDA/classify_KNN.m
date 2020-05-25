function label_Test = classify_KNN(data_Train,data_Test,label_Train)
    [~,num_Test] = size(data_Test);
    label_Test = zeros(1,num_Test);
    [~,num_Train] = size(data_Train);
    for test_th = 1:num_Test
        current_Test = data_Test(:,test_th);
        dis_V = zeros(1,num_Train);
        for train_th = 1:num_Train
            current_Train = data_Train(:,train_th);
            dis_V(1,train_th) = norm(current_Test-current_Train,2);           
        end
        [~,ind] = min(dis_V);
        label_Test(1,test_th) = label_Train(1,ind);
    end
end