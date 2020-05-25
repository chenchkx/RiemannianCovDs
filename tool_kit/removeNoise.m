function out_Matrix = removeNoise(input_Matrix)
    temp_Matrix = zeros(size(input_Matrix));
    for i = 1:size(input_Matrix,3)
        current_M = real(input_Matrix(:,:,i));
        [x_I,y_I] = find(current_M <= 1e-10);
        current_M(x_I,y_I) = 0;
        temp_Matrix(:,:,i)=current_M;
    end
    out_Matrix = temp_Matrix;
end