 function [EKmf,EKmfKfm,Edist]=Expectation(qHyper,x,z,Sigmaf,nx,nz,Dim)
 %  Hyper.mean, Hyper.cov X, Support set, Sigmaf. Number of X, Number of support, Data Dimension 
 %

 
 
 %[nx,Dx]=size(x);
 % [nz,Dz]=size(z);
    EKmfKfm=zeros(nz,nz);
%   zaver=zeros(nz,nz,Dim);
    Kmf=ones(nz,nx);
    for k=1:Dim
%       A=qHyper.covariance(k,k)*((ones(nz,1)*x(:,k)').^2)+1;
        A=qHyper.covariance(k,k)*bsxfun(@times,ones(nz,1),x(:,k)').^2+1;
        B=1./sqrt(A);
        D=-1./(2*A);
        F=qHyper.mean(k)*bsxfun(@times,ones(nz,1),x(:,k)')-bsxfun(@times,z(:,k),ones(nx,1)');
%       zaver(:,:,k)=0.5*(z(:,k)*ones(nz,1)'+ones(nz,1)*z(:,k)');
        G=exp(D.*(F.^2));
        Kmf=Kmf.*B.*G;
    end
    EKmf=Sigmaf.*Kmf;
    dist=Dist(z,z);
    Edist=exp(-0.25*dist);
    for num=1:nx
        EKmfKfm=EKmfKfm+CalKmm(num,z,x,qHyper,Dim,nz);
    end
    EKmfKfm=Sigmaf^2.*Edist.*EKmfKfm;
end
