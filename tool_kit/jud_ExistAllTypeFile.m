function res = jud_ExistAllTypeFile(option,current_Set_OutputPath)

   pre_Out_File_Name = [current_Set_OutputPath,option.type_F,'_resized',num2str(option.resized_Row),'_blockSize',...
                num2str(option.block_Row),'_stepSize',num2str(option.step_Row)];
   outFile_A_D = [pre_Out_File_Name,'_A_DE','.mat'];
   outFile_S_D = [pre_Out_File_Name,'_S_DE','.mat'];
   outFile_J_D = [pre_Out_File_Name,'_J_DE','.mat'];
   outFile_L_D = [pre_Out_File_Name,'_L_DE','.mat'];
   
   
   outFile_A_I = [pre_Out_File_Name,'_A_IE','.mat'];
   outFile_S_I = [pre_Out_File_Name,'_S_IE','.mat'];
   outFile_J_I = [pre_Out_File_Name,'_J_IE','.mat'];
   outFile_L_I = [pre_Out_File_Name,'_L_IE','.mat'];
   res_D = exist(outFile_A_D,'file') && exist(outFile_S_D,'file') && exist(outFile_J_D,'file') && exist(outFile_L_D,'file');
   res_I = exist(outFile_A_I,'file') && exist(outFile_S_I,'file') && exist(outFile_J_I,'file') && exist(outFile_L_I,'file');
   if res_D && res_I
        res = 1;
   else
       res = 0;
   end

end