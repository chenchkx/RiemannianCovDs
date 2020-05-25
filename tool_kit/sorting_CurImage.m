function sorted_StructByName = sorting_CurImage(struct_Image,type_Image)
    num_Image = length(struct_Image);
    value_Name = zeros(1,num_Image);
    for img_th = 1:num_Image
        current_Name = struct_Image(img_th).name;
        ind_End = strfind(current_Name,type_Image);
        value_Name(1,img_th) = str2num(current_Name(1:ind_End-1));      
    end
    [~,v_Ind] = sort(value_Name);
    sorted_StructByName = struct_Image(v_Ind);
end