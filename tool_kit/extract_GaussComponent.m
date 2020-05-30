%% Generating the Riemannian CovDs
% Author: Kai-Xuan Chen
% Date: 2018.09.03

function [new_Opt,num_Each_Matrix,time_Matrix] = extract_GaussComponent(option)    
    
    option = set_OptionPath(option);
    numTime_Matrix_Path_GaussCom = option.numTime_Matrix_Path_GaussCom;
    if ~exist(option.root_Path,'dir') 
        fprintf('  ----------------Warning----------------  \n');
        fprintf('  "Please check the path of your dataset"  \n'); % check path  
        fprintf('  ---------------------------------------  \n');
        num_Each_Matrix = [];time_Matrix = [];    
    else
        if strcmp(option.type_F, 'VGG') == 1
            net = load(['.\tool_kit\matconvnet\model\',option.cnn_Model]);
            net.layers =  net.layers(1:option.num_Layers);
        else
            net = [];
        end
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
            fprintf('read data for %d_th class, named:  %s \n',readed_Class_th,input_Classes(class_th).name); 
            current_Class_inputPath = [option.root_Path,'\',input_Classes(class_th).name];        % path for current class  
            current_Class_outputPath = [option.com_Path,'\',input_Classes(class_th).name];
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
                fprintf('read data for %d_th set, named:  %s \n',readed_Set_th,input_Sets(set_th).name); 
                current_Set_inputPath = [current_Class_inputPath,'\',input_Sets(set_th).name,'\'];               % path for current set
                current_Set_outputPath = [current_Class_outputPath,'\',input_Sets(set_th).name,'\'];
                if ~exist(current_Set_outputPath,'dir')
                    mkdir(current_Set_outputPath);
                end
                out_GaussComponent_Path = [current_Set_outputPath,option.out_GaussComponent_Name];
                if exist(out_GaussComponent_Path,'file')
                    continue; 
                else
                    current_Pics = dir(strcat(current_Set_inputPath,'*',option.type_Image));              % image name in current set
                    current_Num_Pictures = size(current_Pics,1);                                          % number of images in current set
                    image_Cell = cell(1,current_Num_Pictures);
                    if option.type_Dataset          % 如果是顺序的视频序列
                        current_Pics = sorting_CurImage(current_Pics,option.type_Image); 
                        if current_Num_Pictures > option.length_Tem
                            block_Depth = ceil(current_Num_Pictures/option.length_Tem);
                            step_Temporal = ceil(current_Num_Pictures/option.length_Tem);
                            begInds_Volume = compute_NumVolume(block_Depth,step_Temporal,current_Num_Pictures);
                        else
                            block_Depth = 1;
                            step_Temporal=1;
                            begInds_Volume = compute_NumVolume(block_Depth,step_Temporal,current_Num_Pictures);
                        end
                    else
                        block_Depth = option.block_Depth;
                        step_Temporal = option.step_Temporal;
                        begInds_Volume = compute_NumVolume(block_Depth,step_Temporal,current_Num_Pictures);
                    end                
                    for sam_th = 1:current_Num_Pictures
                        sample_th = imread([current_Set_inputPath,current_Pics(sam_th,1).name]);          % read current image                                                                            
                        sample_th = imresize(sample_th,[option.resized_Row,option.resized_Col],'bicubic');  
                        image_Cell{1,sam_th} = sample_th;
                        clear('sample_th');
                    end 
                    %                 image_Matrix = zeros(option.resized_Row,option.resized_Col,current_Num_Pictures
                    num_Volumes = length(begInds_Volume);
                    descriptor_Cell = cell(1,num_Volumes);
                    tic;
                    for vol_th = 1:num_Volumes
                        begInd_CurrentVolume = begInds_Volume(vol_th);
                        endInd_CurrentVolume = begInd_CurrentVolume + block_Depth - 1;
                        currentVolume_Images = image_Cell(1,begInd_CurrentVolume:endInd_CurrentVolume);
                        descriptor_Cell{1,vol_th} = compute_VoluDescriptor(option,currentVolume_Images,block_Location_Matrix,net);
                        clear('currentVolume_Images');
                    end     
                    time_Matrix(readed_Class_th,readed_Set_th) = toc;
                    save(out_GaussComponent_Path,'descriptor_Cell'); 
                    clear('descriptor_Cell','block_Depth','step_Temporal');
                end
            end           
            num_Each_Matrix(readed_Class_th) = readed_Set_th;
        end        
        if ~exist('time_Matrix','var')
            time_Matrix = [];
        end   
        clear('block_Location_Matrix');
    end 
    save(numTime_Matrix_Path_GaussCom,'time_Matrix','num_Each_Matrix');
    new_Opt = option;
end