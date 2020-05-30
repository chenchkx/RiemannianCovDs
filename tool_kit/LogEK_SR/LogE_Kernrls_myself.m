function Kmatrix = LogE_Kernrls_myself(Train_Matrix,Test_Matrix,d)
Num_Trains = size(Train_Matrix,3);
Num_Tests = size(Test_Matrix,3);
Kmatrix = zeros(Num_Trains,Num_Tests);
for ii = 1:Num_Trains
    for jj = 1:Num_Tests
        Kmatrix(ii,jj) = reshape(Train_Matrix(:,:,ii),1,d*d)*reshape(Test_Matrix(:,:,jj),d*d,1);
    end
end
