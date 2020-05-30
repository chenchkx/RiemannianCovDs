function [T,U] = Re_KPLS(K,Y,Fac)
%%% 20140828 This KPLS code is from Dr. Roman Rosipal (courtesy) at http://aiolos.um.savba.sk/~roman/
%%% 20110812 add new output for B with different dimensions
%%% Kernel Partial Least Squares Regression - kernel-based NIPALS-PLS 
%%% Inputs  
%     K    : kernel (Gram) matrix (number of samples  x number of samples) 
%     y    : training outputs (number of samples  x dimY) 
%     Fac  : number of score vectors (components,latent vectors)  to extract 
%     show : 1 - print number of iterations needed (default) / 0 - do not print 
%
%     Outputs: 
%     B      : matrix of dual-form regression coefficients (number of samples x dimY)     
%     T,U    : matrix of latent vectors (number of samples x Fac)  

%%%% max number of iterations  
maxit=50;
%%%% criterion for stopping 
crit=1e-8;

[~,n]=size(K);

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
 
end