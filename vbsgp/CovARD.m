function K=CovARD(z,qHyper,x,Sigmaf)
    if nargin==1
        K=exp(-0.5*Dist(z,z)); 
    else if nargin==2
%             [n,D]=size(z);
%             expHyper=exp(Hyper(1:D));
%             Sigma_f=exp(Hyper(D+1));
            K=Sigmaf^2*exp(-0.5*Dist(diag(qHyper.mean)*z,diag(qHyper.mean)*z)); 
        else
%             [n,D]=size(z);
%             expHyper=exp(Hyper(1:D));
%             Sigma_f=exp(Hyper(D+1));
            K=Sigmaf*exp(-0.5*Dist(z,diag(qHyper.mean)*x));
        end
   end
end