function In_Matrix = gen_randMatrix(option)
    for i = 1:432
       In_Matrix(i,:) = randperm(option.num_Sample); 
    end
end