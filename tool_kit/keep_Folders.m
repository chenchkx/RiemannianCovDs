%% Author: Kai-Xuan Chen 
% Date: 2018.08.23-2018.08.23
% verify dir

function folders = keep_Folders(input)
    folder_th = 0;
    n=length(input);
    for i=1:n
        if (input(i).isdir && ~strcmp(input(i).name,'.') && ~strcmp(input(i).name,'..'))
            folder_th = folder_th + 1;
            temp_folders(folder_th) = folder_th;
        end
    end
    folders = temp_folders;
end