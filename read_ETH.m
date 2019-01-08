%% Riemannian CovDs (Region overlappping)
% Author : Kai-Xuan Chen
% Date1: 2018.08.24
% Date2: 2018.12.11

clear;
clc;
%% set Hy-Parameters
option = set_Option('ETH','Local','RGB');  
% input : 
%       param 1: the name of dataset
%       param 2: the kind of feature extracting:{Local,Sift,VGG}
%       param 3: color types of images: {Gray,RGB}
% output:
%       option : the struct of parameters 
%% extract Gauss Component(mean vectors & covariance matrices)
[option,num_Each_Matrix_GaussCom,time_Matrix_GaussCom] = extract_GaussComponent(option);
% input :
%       option : the struct of parameters
% output:
%       option : resetted struct of parameters which contains the paths of Gauss component
%       num_Each_Matrix_GaussCom : the matrix of the number of samples in each class
%       time_Matrix_GaussCom : the time consuming matrix
%% generating RieCovDs via 'Riemannian metric' & 'gaussian embedding'
type_Metric_Gauss = {{'DE','A'},{'DE','S'},{'DE','J'},{'DE','L'},...
                    {'IE','A'},{'IE','S'},{'IE','J'},{'IE','L'}};
%       DE/IE : compute Riemannian Local Difference Vector(RieLDV) directly/indirectly on the manifold of Gaussians
%       A/S/J/L : use AIRM/S-divergence/J-divergence/Log-Euclidean Metric to commpute RieLDV
pool = parpool(4);
parfor i = 1:length(type_Metric_Gauss)
% for i = 1:length(type_Metric_Gauss)
    rie_Metric = type_Metric_Gauss{i}{1,2}; 
    type_Gauss = type_Metric_Gauss{i}{1,1};
    new_Opt = set_OptionPath(option,rie_Metric,type_Gauss); % reset option via 'Riemannian metric' & 'gaussian embedding'
    [num_Each_Matrix,time_Matrix] = gen_RCovDs(new_Opt);    % generate Riemannian CovDs  
    if ~exist(new_Opt.dis_Matrix_Path,'file')
        dis_Matrix = compute_Dis(new_Opt);                  % generate distance matrix, if it does not exist.
    end
end
delete(pool);