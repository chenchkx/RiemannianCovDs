function outS = AIRM(X1,X2,manifold)
l1 = size(X1,3);
l2 = size(X2,3);

outS = zeros(l1,l2);

for tmpC1 = 1:l1
    % tmpC1
    for tmpC2 = 1:l2
        X = X1(:,:,tmpC1);
        Y = X2(:,:,tmpC2);
       %t = real(geodesicDist(X,Y));
        t = manifold.dist(X,Y);       
        outS(tmpC1,tmpC2) = t;
        
        if  (outS(tmpC1,tmpC2) < 1e-10)
            outS(tmpC1,tmpC2) = 0.0;
        end
    end
end



