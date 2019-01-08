function outS = Jeff_Divergence(X1,X2)
l1 = size(X1,3);
l2 = size(X2,3);
n = size(X1,1);
outS = zeros(l1,l2);
%epsI = eps*eye(size(X1,1), size(X1,2));
for tmpC1 = 1:l1
    % tmpC1
    for tmpC2 = 1:l2
        X = X1(:,:,tmpC1);
        Y = X2(:,:,tmpC2);
        t = 0.5 * trace(X^-1 * Y) + 0.5 * trace(Y^-1 * X) - n;
        outS(tmpC1,tmpC2) = t;
        
        if  (outS(tmpC1,tmpC2) < 1e-10)
            outS(tmpC1,tmpC2) = 0.0;
        end
    end
end



