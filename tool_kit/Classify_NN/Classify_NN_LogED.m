function accuracy = Classify_NN_LogED(data,rand_Matrix,option)
Label_Train = option.label_Train;
Label_Test = option.label_Test;
[Train_Spd_Cell,Test_Spd_Cell]=split_Data(data,rand_Matrix,option);
Num_Train = length(Train_Spd_Cell);
Num_Test = length(Test_Spd_Cell);
Out_Label = zeros(1,Num_Test);

Dis_LogED = Compute_LogE_Metric(Train_Spd_Cell,Test_Spd_Cell,option);

for test_th = 1:Num_Test
    dis_th = Dis_LogED(test_th,:);
    [~,ind] = min(dis_th);
    Out_Label(1,test_th) = Label_Train(1,ind);
end
accuracy = sum((Out_Label - Label_Test) == 0)/size(Label_Test,2);
% switch Opt.Type_Spd
%     case ('Spd')
%         for ii = 1:Num_Train
%             Sample_Train = Train_Spd_Cell{1,ii};
%             Sample_Train(isnan(Sample_Train)) = 0;
%             Train_LogSpd_Cell{1,ii} = logm(Sample_Train);
%         end
%         for ii = 1:Num_Test
%             Sample_Test = Test_Spd_Cell{1,ii};
%             Sample_Test(isnan(Sample_Test)) = 0;
%             Test_LogSpd_Cell{1,ii} = logm(Sample_Test);
%         end
%     case ('Logm')
%         for ii = 1:Num_Train
%             Sample_Train = Train_Spd_Cell{1,ii};
%             Sample_Train(isnan(Sample_Train)) = 0;
%             Train_LogSpd_Cell{1,ii} = Sample_Train;
%         end
%         for ii = 1:Num_Test
%             Sample_Test = Test_Spd_Cell{1,ii};
%             Sample_Test(isnan(Sample_Test)) = 0;
%             Test_LogSpd_Cell{1,ii} = Sample_Test;
%         end
%         
% end

% for tt_th = 1:Num_Test
%     if mod(tt_th,10) == 1
%         fprintf('Test %d_th test sample use NN  \n',tt_th); 
%     end
%     Dis_Tr = zeros(1,Num_Train);
%     for tr_th = 1:Num_Train
%         if mod(tt_th,10) == 1 && mod(tr_th,10) == 0
%             fprintf('Compute distance with %d_th train sample \n',tr_th); 
%         end
%         Dis_Tr(1,tr_th) = norm(Test_LogSpd_Cell{1,tt_th} - Train_LogSpd_Cell{1,tr_th},'fro');
%         
%     end
%     [~,ind] = min(Dis_Tr);
%     Out_Label(1,tt_th) = Label_Train(1,ind);
% end
% 
% accuracy = sum((Out_Label - Label_Test) == 0)/size(Label_Test,2);