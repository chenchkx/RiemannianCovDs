function [B,T,U,param] = KerNIPALS_new(K,Y,Fac,show)
  %%% 20140828 This KPLS code is from Dr. Roman Rosipal (courtesy) at http://aiolos.um.savba.sk/~roman/
  %%% 20110812 add new output for B with different dimensions

  %%% Kernel Partial Least Squares Regression - kernel-based NIPALS-PLS 
  %%%  
  %%%
  %%% Inputs  
    %     K    : kernel (Gram) matrix (number of samples  x number of samples) 
    %     y    : training outputs (number of samples  x dimY) 
    %     Fac  : number of score vectors (components,latent vectors)  to extract 
    %     show : 1 - print number of iterations needed (default) / 0 - do not print 
    %
    %     Outputs: 
    %     B      : matrix of dual-form regression coefficients (number of samples x dimY)     
    %     T,U    : matrix of latent vectors (number of samples x Fac)  



if ~exist('show')==1
  show=1;
end

%%%% max number of iterations  
maxit=50;
%%%% criterion for stopping 
crit=1e-8;

[n,n]=size(K);

T=[];
U=[];
Ie=eye(n);

Kres=K;
Yres=Y;

for num_lv=1:Fac

 %initialization 
 u=randn(n,1);t=randn(n,1);tgl=t+2;it=0;
  
 while (norm(t-tgl)/norm(t))>crit & (it<maxit)   
     tgl=t;
     it=it+1;
    
     w=Kres*u;
     t=w/norm(w);
     c=Yres'*t;
     u=Yres*c;
     u=u/norm(u);
 end
 if (num_lv > 1) 
   T=[T t];
   U=[U u];
 else 
   T=t;U=u; 
 end   

 %%% deflation procedures  
 %tt=t*t';
 %G=(Ie-tt);
 %Kres=G*Kres*G;
 Ktt=(Kres*t)*t';
 Kres=Kres-Ktt'-Ktt+(t*(t'*Ktt));
 
 Yres=Yres-t*(t'*Yres);
 
 if show~=0
     disp(' ') 
     fprintf('number of iterations: %g',it);
     disp(' ')
 end
 
end

%%% matrix of regression coefficients 
temp_Matrix = T'*K*U;
if rank(temp_Matrix) <size(temp_Matrix,1)
    
    [ve_M,ei_M] = eig(temp_Matrix);
    ei_M = real(diag(ei_M));
    ve_M = real(ve_M);
    [tmp_1, ind_1] = sort(ei_M,'descend');
    new_Matrix = zeros(size(ve_M,1));
    for eig_th = 1:rank(temp_Matrix) 
       new_Matrix =  new_Matrix + (tmp_1(eig_th)^(-1))*ve_M(:,ind_1(eig_th))*ve_M(:,ind_1(eig_th))';
    end
    B=U*new_Matrix*T'*Y;
else
    B=U*inv(temp_Matrix)*T'*Y;
end
param.T = T;
param.U = U;
