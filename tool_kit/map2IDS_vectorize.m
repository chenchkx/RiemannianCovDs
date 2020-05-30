%% from: More about VLAD(CVPR 2015) 

function y = map2IDS_vectorize(inMat, map2IDS)
if map2IDS == 1
    inMat = logm(inMat);    
end
offDiagonals = tril(inMat,-1) * sqrt(2);
diagonals = diag(diag(inMat));
vecInMat = diagonals + offDiagonals; 
vecInds = tril(ones(size(inMat)));
map2ITS = vecInMat(:);
vecInds = vecInds(:);
y = map2ITS(vecInds == 1) ;