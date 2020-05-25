function X = Compute_Karcher_Stein(A,maxiter)

if (nargin < 2)
    maxiter = 15;
end

[n,~,p] = size(A);
I_n = eye(n);
X = sum(A,3)/p;



for tmpC0 = 1:maxiter
    tmpX = zeros(n);
    for tmpC1 = 1:p
        tmpX = real(tmpX + I_n/((A(:,:,tmpC1) + X)/2));
    end
    tmpX = tmpX/p;
    X = I_n/tmpX;
end

end