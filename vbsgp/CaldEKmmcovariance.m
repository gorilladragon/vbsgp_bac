function dEKmmcov=CaldEKmmcovariance(Iternum,z,x,qHyper,K,nz,k)%
%        dEKmmcov=ones(nz,nz,k);
         dKmmcov=ones(nz);
         for j=1:K
             A=1/(2*qHyper.covariance(j,j)*x(Iternum,j)*x(Iternum,j)+1);
             zaver=0.5*(z(:,j)*ones(nz,1)'+ones(nz,1)*z(:,j)');
             dKmmcov=sqrt(A)*dKmmcov.*exp((zaver-x(Iternum,j)*qHyper.mean(j)).^2.*(-A));
         end
         Zaver=0.5*(z(:,k)*ones(nz,1)'+ones(nz,1)*z(:,k)');
         dEKmmcov=dKmmcov.*(-(x(Iternum,k)^2)/(2*qHyper.covariance(k,k)*(x(Iternum,k)^2)+1)+...
                  2*((Zaver*x(Iternum,k)-x(Iternum,k)^2*qHyper.mean(k))/(2*qHyper.covariance(k,k)*(x(Iternum,k)^2)+1)).^2);
end