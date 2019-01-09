function accuracy = SVMforClassification(traindata,testdata,exprs)

% this method is implemented by Qilong Wang [1] using SVM toolkit[2]:
% [1] Qilong Wang, Peihua Li, Wangmeng Zuo, and Lei Zhang. RAID-G: Robust Estimation of 
% Approximate Infinite Dimensional Gaussian with Application to Material Recognition. 
% IEEE Conference on Computer Vision and Pattern Recognition Pattern Recognition (CVPR), 2016.
% [2] Chih-Chung Chang and Chih-Jen Lin. Libsvm: a library for support vector machines. ACM transactions on intelligent systems and technology
% (TIST), 2(3):27, 2011.

classnum = exprs.num_Class;
trainlabel = exprs.label_Train';
testlabel = exprs.label_Test';
%%Compute Kernel 
if strcmp(exprs.kernel,'linear')==1 %%linear kernel
%%Do nothing
elseif strcmp(exprs.kernel,'homker')==1  %%additive kernel
    for m = 1:size(traindata,1)
        traindata(m,:) = vl_homkermap(traindata(m,:), 1, 'kchi2');
    end
elseif strcmp(exprs.kernel,'hellinger')==1
    for m = 1:size(traindata,1)
        traindata(m,:) = sign( traindata(m,:)) .* sqrt(abs( traindata(m,:)));   
    end
end

if strcmp(exprs.kernel,'poly')==1
    
    dist_matrix = 1 - squareform(pdist(traindata', 'cosine'));
    K =  dist_matrix .^ exprs.n;
    
    dist_matrix = 1 - pdist2(traindata', testdata', 'cosine');
    K_test =  dist_matrix .^ exprs.n;
    
    K_test = K_test';
 
elseif strcmp(exprs.kernel,'exp')==1
    
    dist_matrix = 1 - squareform(pdist(traindata', 'cosine'));
    K =  exp(dist_matrix .^ exprs.n);
    dist_matrix = 1 - pdist2(traindata', testdata', 'cosine');
    K_test =  exp(dist_matrix .^ exprs.n);
    
    K_test = K_test';
     
elseif strcmp(exprs.kernel,'gaussian')==1    
    
   dist_matrix = sp_dist2(traindata',traindata'); 
   K =  exp(-exprs.beta.*dist_matrix.^2);
   
   dist_matrix = sp_dist2(traindata', testdata');
   K_test =  exp(-exprs.beta.*dist_matrix.^2);
   
   K_test = K_test';
    
else
    K = traindata'*traindata;
    K_test = (traindata'*testdata)';
end

clear traindata;
clear testdata;

K = double(K);
K_test = double(K_test);

if strcmp(exprs.libsvm,'oneVSone')==1
  
    KernelMartixTrain = [(1:size(K,1))',K];
    model = svmtrain(trainlabel, KernelMartixTrain,  sprintf(' -t 4 -c %f -b 1 -q -p 0.00001', exprs.lc));  
    KernelMartixTest = [(1:size(K_test,1))', K_test];
    [predict_label, acc, dec_values] = svmpredict(testlabel, KernelMartixTest, model,'-b 1'); 
    accuracy = acc(1);
    
elseif strcmp(exprs.libsvm,'oneVSall')==1
    libsvm = cell(classnum,1);
    for j=1:classnum
        these_labels = -ones(length(trainlabel),1);
        these_labels(trainlabel == j) = 1;
        libsvm{j} = svmtrain(these_labels, ...
            [(1:size(K,1))' K], ...
            sprintf(' -t 4 -c %f -q -p 0.00001', exprs.lc));
    end
    
    scores = cell(length(libsvm),1);
    for j=1:classnum
        [predictlabel, duh, scores{j}] = ...
            svmpredict(zeros(size(K_test,1),1), [[size(K,1)+1:size(K,1)+size(K_test,1)]' K_test], ...
            libsvm{j});
        if(libsvm{j}.Label(1)==-1)
            scores{j} = -scores{j};
        end
    end
    
    scores2 = scores';
    scores2 = cell2mat(scores2);
    [value, predictlabel] = max(scores2, [], 2);
    
    accuracy = mean(predictlabel == testlabel);
    
end