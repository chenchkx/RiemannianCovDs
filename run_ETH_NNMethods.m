%% Author: Kai-Xuan Chen 
% Date: 2018.08.24
% Date2: 2018.12.19
% NN methods(AIRM,Stein,Jeffrey,LogED) on Riemannian CovDs
clear;
clc;  
%% set Hy-Parameters
option = set_Option('ETH','Local','RGB');  
% input: 
%       param 1: the name of dataset
%       param 2: the kind of feature extracting :{Local,Sift,VGG}
%       param 3: color types of images: {Gray,RGB}
% output:
%       option : the struct of parameters  
In_Matrix = gen_randMatrix(option);                                     
row_total = size(In_Matrix,1);                                 % In_Matrix
%% classify via 'Riemannian metric' & 'gaussian embedding'
type_Metric_Gauss = {{'DE','A'},{'DE','S'},{'DE','J'},{'DE','L'},...
                    {'IE','A'},{'IE','S'},{'IE','J'},{'IE','L'}};
for i = 1:length(type_Metric_Gauss);
    rie_Metric = type_Metric_Gauss{i}{1,2};
    type_Gauss = type_Metric_Gauss{i}{1,1};
    option = set_OptionPath(option,rie_Metric,type_Gauss); % reset option via 'Riemannian metric' & 'gaussian embedding'     
    if ~exist(option.dis_Matrix_Path,'file')
        dis_Matrix = compute_Dis(option);
    else
        load(option.dis_Matrix_Path);
    end
    for ite_th = 1:option.num_Ite
        fprintf('------------ite_th :  %d------------------\n',ite_th);
        ind_Begin = (ite_th-1)*option.num_Class+1;     % the starting index
        if ind_Begin >row_total
            ind_Begin = mod(ind_Begin,row_total);      % if the starting index is greater than the number of rows in the entire index matrix, then re-assign the starting value
        end
        ind_End = ind_Begin + option.num_Class -1;     % end index based on start index calculation
        if ind_End > row_total                         % if the end of the index is greater than the number of rows of all the matrices, you need to re-assign the start index and the end index.
            ind_Begin = mod(ind_End,row_total);
            ind_End = ind_Begin + option.num_Class -1;
        end
        rand_Matrix = In_Matrix(ind_Begin:ind_End,:);  % index matrix for each class of each iteration

        tic;  % NN classifier via distance matrix(AIRM)
        accracy_Matrix(1,ite_th) = nn_Via_disMatrix(option,rand_Matrix,dis_Matrix.A);
        time_Matrix(1,ite_th) = toc;

        tic;  % NN classifier via distance matrix(Stein)
        accracy_Matrix(2,ite_th) = nn_Via_disMatrix(option,rand_Matrix,dis_Matrix.S);
        time_Matrix(2,ite_th) = toc;

        tic;  % NN classifier via distance matrix(Jeffrey)
        accracy_Matrix(3,ite_th) = nn_Via_disMatrix(option,rand_Matrix,dis_Matrix.J);
        time_Matrix(3,ite_th) = toc;

        tic;  % NN classifier via distance matrix(LogED)
        accracy_Matrix(4,ite_th) = nn_Via_disMatrix(option,rand_Matrix,dis_Matrix.L);
        time_Matrix(4,ite_th) = toc;
    end
    [MST.mean_Accuracy,mean_Accuracy] = deal(mean(accracy_Matrix,2)); % mean accracy
    [MST.std_Accuracy,std_Accuracy] = deal(std(accracy_Matrix,0,2));  % standard deviation
    [MST.mean_Time,mean_Time] = deal(mean(time_Matrix,2));            % time matrix
    nn_Res_Path = [option.res_Path,'\','nn_Methods'];
    if ~exist(nn_Res_Path,'dir')
        mkdir(nn_Res_Path);
    end
    save(option.res_NN_Path,'MST','mean_Accuracy','std_Accuracy','accracy_Matrix','time_Matrix');

end