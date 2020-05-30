%% set option for deifferent dataset
% Author: Kai-Xuan Chen
% Date:2018.12.11
%% set option for deifferent dataset
% Author: Kai-Xuan Chen
% Date:2018.12.11
function option = set_Option(name,type_F,type_C)
    % add paths
    addpath(genpath('tool_Kit'));
    if strcmp(type_F,'Sift')
        option.type_F = type_F;
        option.scales = [2,1.4142,1,0.7071]; 
    else
        option.type_F = type_F;
        option.scales = [1];
    end
    if strcmp(type_C,'RGB')
        option.type_C = type_C;
        option.data_Path = '.\data_RGB'; 
    elseif strcmp(type_C,'Gray')
        option.type_C = type_C;
        option.data_Path = '.\data_Gray';
    end

    switch name
        case 'ETH'
            option.name_Dataset = 'ETH';                                        % relative path of Riemannian CovDs 
            option.root_Path = '.\ETH-80';            % rootpath of dataset in your computer
            option.mat_Path = [option.data_Path,'\mat_',option.name_Dataset];   % relative path of Riemannian CovDs 
            option.com_Path = [option.data_Path,'\com_',option.name_Dataset];   % relative path of Gauss component(mean vectors & covariance matrices)
            option.res_Path = [option.data_Path,'\res_',option.name_Dataset];   % relative path of dot mat files of accuracies 
            option.num_Ite = 100;                                               % number of experiment iterations 
            option.num_Class = 8;                                               % number of categories
            option.num_Sample = 10;                                             % number of sample in each class
            option.num_Gallery = 5;                                             % number of gallery sample
            option.num_Probe = option.num_Sample - option.num_Gallery;          % number of probe sample
            option.label_Gallery = reshape(ones(option.num_Gallery,option.num_Class)*diag([1:option.num_Class]),[1,option.num_Class*option.num_Gallery]);
                                                                                % label of gallery sample
            option.label_Probe = reshape(ones(option.num_Probe,option.num_Class)*diag([1:option.num_Class]),[1,option.num_Class*option.num_Probe]);
                                                                                % label of probe sample
            option.type_Image = '.png';                                         % suffix of images                                                                                           
            option.resized_Row = 256;                                           % row size of image
            option.resized_Col = 256;                                           % column size of image
            option.block_Row = 32;                                              % row size of block
            option.block_Col = 32;                                              % column size of block
            option.block_Depth = 1;
            option.step_Row = 28;                                               % row step of block
            option.step_Col = 28;                                               % column step of block    
            option.step_Temporal = 1; 
            option.pre_Set = '';                                                % prefix string of each image set  
            option.pre_Class = '';                                              % prefix string of each class
            option.LogEK_N = 1;                                                 % paramter for LogEKSR
            option.alpha_Gauss = 0.9;                                           % paramter for 'DE' RLDV
            option.beta_Gauss = 0.6;                                            % paramter for Gaussian embedding          
            option.min_EigCov = 1e-9;                                           % min_Value 
            option.min_EigGau = 1e-9;                  
            option.min_EigRieCovDs = 1e-9;
            option.rie_Metric = 'A';                                            % Riemannian metric on SPD
            option.cnn_Model = 'imagenet-vgg-verydeep-16.mat';
            option.num_Layers = 4;
            option.type_Gauss = 'DE';                                            % 'DE' or 'IE' 
            option.type_Dataset = 0;                                             % 0: Image Set  1: Video
            option.latentDim_PLS = option.num_Class + 1;
            option.type_Norm_RLDV = 's';                                         % s: sign   n: normanlization  m: mixed aboved two
      
        case 'Virus'
            option.name_Dataset = 'Virus';
            option.root_Path = 'E:\WORKSPACE\DATASET\Virus\Virus';
            option.mat_Path = [option.data_Path,'\mat_',option.name_Dataset];
            option.com_Path = [option.data_Path,'\com_',option.name_Dataset];                                
            option.res_Path = [option.data_Path,'\res_',option.name_Dataset];           
            option.num_Ite = 100;
            option.num_Class = 15;
            option.num_Sample = 5;
            option.num_Gallery = 3;
            option.num_Probe = option.num_Sample - option.num_Gallery;
            option.label_Gallery = reshape(ones(option.num_Gallery,option.num_Class)*diag([1:option.num_Class]),[1,option.num_Class*option.num_Gallery]);
            option.label_Probe = reshape(ones(option.num_Probe,option.num_Class)*diag([1:option.num_Class]),[1,option.num_Class*option.num_Probe]);
            option.type_Image = '.png';                                          
            option.resized_Row = 40;
            option.resized_Col = 40;
            option.block_Row = 5;
            option.block_Col = 5;
            option.block_Depth = 1;
            option.step_Temporal = 1; 
            option.step_Row = 5;
            option.step_Col = 5;                           
            option.pre_Set = '';
            option.pre_Class = '';    
            option.LogEK_N = 1;    
            option.alpha_Gauss = 1;
            option.beta_Gauss = 0.4;                                         
            option.min_EigCov = 1e-9;                                          
            option.min_EigGau = 1e-9;                  
            option.min_EigRieCovDs = 1e-9;
            option.rie_Metric = 'A';                                          
            option.cnn_Model = 'imagenet-vgg-verydeep-16.mat';
            option.num_Layers = 4;
            option.type_Gauss = 'DE';                                
            option.type_Dataset = 0;   
            option.latentDim_PLS = option.num_Class + 1;
            option.type_Norm_RLDV = 's'; 
            
        case 'CG'
            option.name_Dataset = 'CG';
            option.root_Path = 'E:\WORKSPACE\DATASET\CGesture';
            option.mat_Path = [option.data_Path,'\mat_',option.name_Dataset];
            option.com_Path = [option.data_Path,'\com_',option.name_Dataset];                                
            option.res_Path = [option.data_Path,'\res_',option.name_Dataset];   
            option.num_Ite = 100;
            option.num_Class = 9;
            option.num_Sample = 100;
            option.num_Gallery = 20;
            option.num_Probe = option.num_Sample - option.num_Gallery;
            option.label_Gallery = reshape(ones(option.num_Gallery,option.num_Class)*diag([1:option.num_Class]),[1,option.num_Class*option.num_Gallery]);
            option.label_Probe = reshape(ones(option.num_Probe,option.num_Class)*diag([1:option.num_Class]),[1,option.num_Class*option.num_Probe]);
            option.type_Image = '.jpg';                                                                                       
            option.resized_Row = 240;
            option.resized_Col = 320;
            option.block_Row = 60;
            option.block_Col = 80;
            option.block_Depth = 1;
            option.step_Temporal = 1; 
            option.step_Row = 30;
            option.step_Col = 40;                           
            option.pre_Set = 's';
            option.pre_Class = '';    
            option.LogEK_N = 1;    
            option.alpha_Gauss = 0.2;
            option.beta_Gauss = 0.7;                                          
            option.min_EigCov = 1e-9;                                          
            option.min_EigGau = 1e-9;                   
            option.min_EigRieCovDs = 1e-9;
            option.rie_Metric = 'A';                                           
            option.cnn_Model = 'imagenet-vgg-verydeep-16.mat';
            option.num_Layers = 4;
            option.type_Gauss = 'DE';                                 
            option.type_Dataset = 0;   
            option.latentDim_PLS = option.num_Class + 1;
            option.type_Norm_RLDV = 's'; 
            
        case 'MDSD'  
            option.name_Dataset = 'MDSD';
            option.root_Path = 'E:\WORKSPACE\DATASET\MDSD';
            option.mat_Path = [option.data_Path,'\mat_',option.name_Dataset];
            option.com_Path = [option.data_Path,'\com_',option.name_Dataset];                                
            option.res_Path = [option.data_Path,'\res_',option.name_Dataset];              
            option.num_Ite = 100;
            option.num_Class = 13;
            option.num_Sample = 10;
            option.num_Gallery = 7;
            option.num_Probe = option.num_Sample - option.num_Gallery;
            option.label_Gallery = reshape(ones(option.num_Gallery,option.num_Class)*diag([1:option.num_Class]),[1,option.num_Class*option.num_Gallery]);
            option.label_Probe = reshape(ones(option.num_Probe,option.num_Class)*diag([1:option.num_Class]),[1,option.num_Class*option.num_Probe]);
            option.type_Image = '.jpg';
            option.resized_Row = 240;
            option.resized_Col = 320;
            option.block_Row = 60;
            option.block_Col = 80;
            option.block_Depth = 60;  % if equal 0, that means computed by 'option.type_Dataset' abd ' option.length_Tem '
            option.step_Row = 20;
            option.step_Col = 30;       
            option.step_Temporal = 60;                      
            option.pre_Set = 's';
            option.pre_Class = 'c';    
            option.LogEK_N = 1;   
            option.alpha_Gauss = 0.3;
            option.beta_Gauss = 0.9;                                                                                  
            option.min_EigCov = 1e-9;                                          
            option.min_EigGau = 1e-9;                  
            option.min_EigRieCovDs = 1e-9;
            option.rie_Metric = 'A';                                           
            option.cnn_Model = 'imagenet-vgg-verydeep-16.mat';
            option.num_Layers = 4;
            option.type_Gauss = 'DE';                                
            option.type_Dataset = 1;  % if equal 1, means thats dataset vieds as video instead of image set 
            option.length_Tem = 60;  % when option.type_Dataset == 1; length of temporals
            option.latentDim_PLS = option.num_Class + 1;
            option.type_Norm_RLDV = 's';  
    end
end