function variance = compute_Variance(matrix_A,matrix_B)
    num_Sample = size(matrix_A,2);
    temp_Variance = 0;
    for i = 1:num_Sample
        temp_Variance = temp_Variance + real(matrix_A(:,i)'*matrix_B(:,i));
    end
    variance = temp_Variance;
end