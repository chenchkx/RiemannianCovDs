%% Over loading option for NN Methods
% Author: Kai-Xuan Chen
% Date: 2018.08.25

function [option,output_LogData] = loading_DisMethods_Para(option)
    option.num_Train = option.num_Gallery;
    option.num_Test = option.num_Probe;
    option.label_Train = option.label_Gallery;
    option.label_Test = option.label_Probe; 
    output_LogData = cell(option.num_Class,option.num_Sample);
    if ~exist(option.res_Path,'dir')
        mkdir (option.res_Path);
    end
    for cla_th = 1:option.num_Class
        current_Class_Mat = [option.mat_Path,'\',option.pre_Class,num2str(cla_th)];
        for set_th = 1:option.num_Sample
            current_Set_Mat = [current_Class_Mat,'\',option.pre_Set,num2str(set_th)];
            current_Mat = [current_Set_Mat,'\',option.out_RieCovDs_Name];
            load (current_Mat);
            output_LogData{cla_th,set_th}=log_RCovDs;    
            clear('current_Set_Mat','current_Mat','log_RCovDs','spd_RCovDs','inv_RCovDs');
        end
        clear('current_Class_Mat');
    end
end