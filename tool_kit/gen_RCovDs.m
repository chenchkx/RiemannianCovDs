%% Generating the Riemannian CovDs
% Author: Kai-Xuan Chen
% Date: 2018.09.03

function [num_Each_Matrix,time_Matrix] = gen_RCovDs(option)    
%     option = set_OptionPath(option,rie_Metric,type_Gauss);
    dis_Matrix_Path = option.dis_Matrix_Path;
    
    numTime_Matrix_Path_RieCovDs = option.numTime_Matrix_Path_RieCovDs;
    if ~exist(option.root_Path,'dir') 
        fprintf('  ----------------Warning----------------  \n');
        fprintf('  "Please check the path of your dataset"  \n'); % check path  
        fprintf('  ---------------------------------------  \n');
        num_Each_Matrix = [];time_Matrix = [];    
    else
        [block_Location_Matrix,block_Num] = get_Block_Information(option);
        input_Classes = dir(option.root_Path);
        readed_Class_th = 0;
        for class_th = 1:length(input_Classes)
            if( isequal(input_Classes(class_th).name, '.' )||...
                isequal(input_Classes(class_th).name, '..')||...
                ~input_Classes(class_th).isdir)               
                continue;
            end
            readed_Set_th = 0;
            readed_Class_th = readed_Class_th + 1;
%             fprintf('gen RieCovDs for %d_th class, named:  %s \n',readed_Class_th,input_Classes(class_th).name); 
            current_Class_inputPath = [option.root_Path,'\',input_Classes(class_th).name];        % path for current class  
            current_Class_outputPath = [option.mat_Path,'\',input_Classes(class_th).name];
            current_Class_gaussPath = [option.com_Path,'\',input_Classes(class_th).name];
            input_Sets = dir(current_Class_inputPath);          
            if ~exist(current_Class_outputPath,'dir')
                mkdir(current_Class_outputPath);
            end
            for set_th = 1:length(input_Sets)            
                if( isequal(input_Sets(set_th).name, '.' )||...
                    isequal(input_Sets(set_th).name, '..')||...
                    ~input_Sets(set_th).isdir)             
                    continue;
                end
                
                readed_Set_th = readed_Set_th + 1;
                fprintf('gen RieCovDs via %s and %s for %d_th class, %d_th set, cla_name: %s, set_name: %s  \n',....
                    option.rie_Metric,option.type_Gauss,readed_Class_th,readed_Set_th,input_Classes(class_th).name,input_Sets(set_th).name);     
                current_Set_inputPath = [current_Class_inputPath,'\',input_Sets(set_th).name,'\'];               % path for current set
                current_Set_outputPath = [current_Class_outputPath,'\',input_Sets(set_th).name,'\'];
                current_Set_gaussPath = [current_Class_gaussPath,'\',input_Sets(set_th).name,'\'];               % gauss component for current set
                if ~exist(current_Set_outputPath,'dir')
                    mkdir(current_Set_outputPath);
                end
%                 判断是否存所有可能的输出路径是否都存在               
                if jud_ExistAllTypeFile(option,current_Set_outputPath)
                   continue; 
                end
                out_RieCovDs_Name = [current_Set_outputPath,option.out_RieCovDs_Name];
                if exist(out_RieCovDs_Name,'file')
                    continue;
                end
                current_GaussComponent_Path = [current_Set_gaussPath,option.out_GaussComponent_Name];
                load(current_GaussComponent_Path);                    % load the feature of gauss component 
%% generating RieCovDs via resetting 'Riemannian metric' & 'gaussian embedding'
                
                tic;
                rie_CovDs = gen_RieCovDs_GausstypeAndRiemetric(descriptor_Cell,block_Num,option);
                rie_CovDs = rie_CovDs/length(descriptor_Cell);
                clear('descriptor_Cell');
                time_Matrix(readed_Class_th,readed_Set_th) = toc;
                spd_RCovDs = rie_CovDs;
                log_RCovDs =  real(logm(rie_CovDs)); 
                inv_RCovDs = rie_CovDs^(-1);                
                save(out_RieCovDs_Name,'spd_RCovDs','log_RCovDs','inv_RCovDs');
                clear('spd_RCovDs','log_RCovDs','inv_RCovDs','rie_CovDs');              
            end           
            num_Each_Matrix(readed_Class_th) = readed_Set_th;
        end        
        if ~exist('time_Matrix','var')
            time_Matrix = [];
        end   
        clear('block_Location_Matrix');
    end 
    save(numTime_Matrix_Path_RieCovDs,'time_Matrix','num_Each_Matrix');
end