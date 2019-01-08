function structural_Descriptors = gen_Structural_Descriptors(option,data_Matrix)
    for sam_th = 1:size(data_Matrix,3)
        current_Sample = data_Matrix(:,:,sam_th);
        structural_Descriptors(:,:,sam_th) = gen_SPD_MatrixViaGaussEmbedding(option,current_Sample); % structural descriptors for block_th block of all samples        
    end
end