function spd_Matrix = add2SPD(sym_Matrix,option)
    [~,d,num] = size(sym_Matrix);
    for sam_th = 1:num
        currenr_Sam = sym_Matrix(:,:,sam_th);
        [~,S] = eig(currenr_Sam);
        [temp_min,~] = min(diag(S));
        while temp_min <= option.min_EigCov
            currenr_Sam = currenr_Sam + (option.min_EigCov)*trace(currenr_Sam)*eye(d);
            [~,S] = eig(currenr_Sam);
            [temp_min,~] = min(diag(S));
        end 
        spd_Matrix(:,:,sam_th) = currenr_Sam;
    end

end