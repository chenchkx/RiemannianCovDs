function outS = Stein_Divergence(X1,X2)
l1 = size(X1,3);
l2 = size(X2,3);

outS = zeros(l1,l2);
for tmpC1 = 1:l1
    % tmpC1
    for tmpC2 = 1:l2
        X = X1(:,:,tmpC1);
        Y = X2(:,:,tmpC2);
        t = real(log(det(0.5*(X+Y))) - 0.5* (log(det(X)) + log(det(Y))));
        if isnan(t) || t == inf
            eigX = eig(X);
            eigX (eigX <= 0) = eps;
            eigY = eig(Y);
            eigY (eigY <= 0) = eps;
            t = real(sum(log(eig(0.5*(X+Y))))) - 0.5 *(real(sum(log(eigX))) + real(sum(log(eigY))) );          
            %t = log(det(0.5*(X+Y))) - 0.5* (log(det(X)) + log(det(Y)));
        end
        outS(tmpC1,tmpC2) = t;    
        
        if  (outS(tmpC1,tmpC2) < 1e-10)
            outS(tmpC1,tmpC2) = 0.0;
        end
    end
end



