clear;
clc;
for i = 1:1000
   In_Matrix(i,:) = randperm(100); 
end
save ('In_Matrix_Dy','In_Matrix');