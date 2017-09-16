function [dEKmb,dEKmbbm]=dExpectation(EKmb,Edist,xbatch,z,Sigmaf,qHyper,nx,nz,K)
         %dEKmb.mean=zeros(nz,nx,K);
         dEKmb.mean=cell(1,K);
         %dEKmb.covariance=zeros(nz,nx,K);
         dEKmb.covariance=cell(1,K);
         
         %dEKmbbm.mean=zeros(nz,nz,K);
         dEKmbbm.mean=cell(1,K);
         %dEKmbbm.covariance=zeros(nz,nz,K);
         dEKmbbm.covariance=cell(1,K);
         for k=1:K
             X=ones(nz,1)*xbatch(:,k)';
             Z=z(:,k)*ones(nx,1)';
             %dEKmb.mean(:,:,k)=EKmb.*(1./(qHyper.covariance(k,k)*X.^2+1)).*(-qHyper.mean(k)*X.^2+Z.*X);
             dEKmb.mean{k}=EKmb.*(1./(qHyper.covariance(k,k)*X.^2+1)).*(-qHyper.mean(k)*X.^2+Z.*X);
             %dEKmb.covariance(:,:,k)=EKmb.*(-1./(2*(qHyper.covariance(k,k)*X.^2+1)).*(X.^2)+...
             %                        0.5./((qHyper.covariance(k,k)*X.^2+1).^2).*((-qHyper.mean(k)*(X.^2)+Z.*X).^2));
             dEKmb.covariance{k}=EKmb.*(-1./(2*(qHyper.covariance(k,k)*X.^2+1)).*(X.^2)+...
                                     0.5./((qHyper.covariance(k,k)*X.^2+1).^2).*((-qHyper.mean(k)*(X.^2)+Z.*X).^2));
         end
         for k=1:K 
             dEKmbbm.mean{k}=zeros(nz);
             dEKmbbm.covariance{k}=zeros(nz);
            for num=1:nx
                %dEKmbbm.mean(:,:,k)=dEKmbbm.mean(:,:,k)+CaldEKmmmean(num,z,xbatch,qHyper,K,nz,k);
                dEKmbbm.mean{k}=dEKmbbm.mean{k}+CaldEKmmmean(num,z,xbatch,qHyper,K,nz,k);
                %dEKmbbm.covariance(:,:,k)=dEKmbbm.covariance(:,:,k)+CaldEKmmcovariance(num,z,xbatch,qHyper,K,nz,k);
                dEKmbbm.covariance{k}=dEKmbbm.covariance{k}+CaldEKmmcovariance(num,z,xbatch,qHyper,K,nz,k);
            end
            %dEKmbbm.mean(:,:,k)=Sigmaf^2*Edist.*dEKmbbm.mean(:,:,k); 
            dEKmbbm.mean{k}=Sigmaf^2*Edist.*dEKmbbm.mean{k}; 
            %dEKmbbm.covariance(:,:,k)=Sigmaf^2*Edist.*dEKmbbm.covariance(:,:,k);
            dEKmbbm.covariance{k}=Sigmaf^2*Edist.*dEKmbbm.covariance{k};
         end     
end 