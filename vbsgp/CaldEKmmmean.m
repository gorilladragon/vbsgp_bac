function dEKmmmean=CaldEKmmmean(Iternum,z,x,qHyper,K,nz,k)
%       dEKmmmean=ones(nz);
        dKmmmean=ones(nz);
        for j=1:K
            A=1/(2*qHyper.covariance(j,j)*x(Iternum,j)*x(Iternum,j)+1);
            zaver=0.5*(z(:,j)*ones(nz,1)'+ones(nz,1)*z(:,j)');
            dKmmmean=sqrt(A)*dKmmmean.*exp((zaver-x(Iternum,j)*qHyper.mean(j)).^2.*(-A));
        end
        Zaver=0.5*(z(:,k)*ones(nz,1)'+ones(nz,1)*z(:,k)');
        dEKmmmean=dKmmmean.*((2*Zaver*x(Iternum,k)-2*x(Iternum,k)^2*qHyper.mean(k))/(2*qHyper.covariance(k,k)*x(Iternum,k)^2+1));
end