% This function brings a point in riemannian manifold into a tangent space
% TxM where the point X coincides with the 0 in the tangent space
function y = RM_log(X,Y)


% [U,D,V] = svd(X);
% 
% X05 = U * diag(diag(D).^0.5) * U';
% Xm05 = U * diag(diag(D).^-0.5) * U';
% temp = Xm05*Y*Xm05;
% [U,D,V] = svd(temp);
% expTemp = U * diag(diag(log(D))) * U';
% y = X05* expTemp * X05;

X05 = X^0.5;
Xm05 = X^(-0.5);
temp = Xm05*Y*Xm05;
[V,D] = eig(real(temp));
logTemp = V * diag(diag(log(D))) * V';
y = X05*  logTemp * X05;
