function Kmm=CalKmm(IterNum,z,x,qHyper,D,nz)
    Kmm=ones(nz);
    for j=1:D
        A=1/(2*qHyper.covariance(j,j)*x(IterNum,j)*x(IterNum,j)+1);
        zaver=0.5*(z(:,j)*ones(nz,1)'+ones(nz,1)*z(:,j)');
        %B=exp((Zaver(:,:,j)-x(IterNum,j)*Hyper.Mu(j)).^2.*(-A));
        Kmm=sqrt(A)*Kmm.*exp((zaver-x(IterNum,j)*qHyper.mean(j)).^2.*(-A));
    end
end
