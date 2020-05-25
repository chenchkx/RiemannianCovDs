function M = Compute_Karcher_Jeff(X)


[n,~,p] = size(X);

B = sum(X,3);

A = zeros(n);
for tmpC1 = 1:p
    A = A + X(:,:,tmpC1)^ -1 ;
end

M = real( (A ^ -0.5) * (A^0.5 * B * A^0.5)^0.5 * (A ^ -0.5) );

end