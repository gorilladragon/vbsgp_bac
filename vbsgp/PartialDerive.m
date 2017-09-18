function [dqU,dqHyper,dBeta,dSigmaf]=PartialDerive(qU,InvKmm,xbatch,ybatch,z,Beta,Sigmaf,qHyper,Batch,bnz,D)

    % REMEMBER to COMMENT OUT
%     InvKmm=InvPcov; xbatch=bData.X; ybatch=bData.Y; bnz=Num; D=Dim;


    [EKmb,EKmbbm,Edist]=Expectation(qHyper,xbatch,z,Sigmaf,Batch,bnz,D);    
     I=eye(bnz);
%     L=chol(qU.covariance);
%     InvqUCov=L\(L'\I);
   
    
    dqU.mean=Beta*InvKmm*EKmb*ybatch-(InvKmm+Beta*InvKmm*EKmbbm*InvKmm)*qU.mean;
    dqU.covariance=0.5*(qU.covariance\I)-0.5*(InvKmm+Beta*InvKmm*EKmbbm*InvKmm);
    
     epsilon=1e-5;    
%     % Test whether the gradient with respect to the posterior of qU.mean is right
%     for k=1:nz
% 
%         Delta=[];
%         for i=1:nz
%            if i==k
%               num=epsilon;
%            else
%                num=0;
%            end
%         Delta=[Delta;num];
%         end
%     qUU.mean=qU.mean+Delta;
%     qUU.covariance=qU.covariance;
%     qUD.mean=qU.mean-Delta;
%     qUD.covariance=qU.covariance;
%     LB.qUmean.U=LowerBound(qUU,InvKmm,xbatch,ybatch,z,Beta,Sigmaf,qHyper,Batch,nz,D);
%     LB.qUmean.D=LowerBound(qUD,InvKmm,xbatch,ybatch,z,Beta,Sigmaf,qHyper,Batch,nz,D);
%     dqUmean(k)=(LB.qUmean.U-LB.qUmean.D)/(2*epsilon);
%     end
    
 
    
    
    dBeta=Batch/(2*Beta)-1/2*(ybatch'*ybatch-2*qU.mean'*InvKmm*EKmb*ybatch+qU.mean'*InvKmm*EKmbbm*InvKmm*qU.mean)-...
          1/2*trace(qU.covariance*InvKmm*EKmbbm*InvKmm)-Batch*Sigmaf^2/2+1/2*trace(InvKmm*EKmbbm);
        

    
    dSigmaf=Beta/Sigmaf*(qU.mean'*InvKmm*EKmb*ybatch-qU.mean'*InvKmm*EKmbbm*InvKmm*qU.mean-...
            trace(qU.covariance*InvKmm*EKmbbm*InvKmm)+trace(InvKmm*EKmbbm))-Batch*Beta*Sigmaf;  
        
        
%     % Test whether the gradient with respect to the Beta and Sigmaf is right
%     BetaU=Beta+epsilon;
%     BetaD=Beta-epsilon;
%     SigmafU=Sigmaf+epsilon;
%     SigmafD=Sigmaf-epsilon;
%     LB.Beta.U=LowerBound(qU,InvKmm,xbatch,ybatch,z,BetaU,Sigmaf,qHyper,Batch,nz,D);
%     LB.Beta.D=LowerBound(qU,InvKmm,xbatch,ybatch,z,BetaD,Sigmaf,qHyper,Batch,nz,D);
%     LB.Sigmaf.U=LowerBound(qU,InvKmm,xbatch,ybatch,z,Beta,SigmafU,qHyper,Batch,nz,D);
%     LB.Sigmaf.D=LowerBound(qU,InvKmm,xbatch,ybatch,z,Beta,SigmafD,qHyper,Batch,nz,D);
%     dBetaestimate=(LB.Beta.U-LB.Beta.D)/(2*epsilon);
%     dSigmafestimate=(LB.Sigmaf.U-LB.Sigmaf.D)/(2*epsilon);
    
    
    
    [dEKmb,dEKmbbm]=dExpectation(EKmb,Edist,xbatch,z,Sigmaf,qHyper,Batch,bnz,D);

% % Test whether the gradient with respect to the expectation is right    
%    for k=1:D;
%        Delta=[];
%        for i=1:D
%            if i==k
%               num=epsilon;
%            else
%                num=0;
%            end
%            Delta=[Delta;num];
%        end
% 
%        qMUHyper.mean=qHyper.mean+Delta;
%        qMDHyper.mean=qHyper.mean-Delta;    
%        qMUHyper.covariance=qHyper.covariance;
%        qMDHyper.covariance=qHyper.covariance;
%        [EKmbU,EKmbbmU,Edist]=Expectation(qMUHyper,xbatch,z,Sigmaf,Batch,nz,D);
%        [EKmbD,EKmbbmD,Edist]=Expectation(qMDHyper,xbatch,z,Sigmaf,Batch,nz,D); 
%        dEKmbmean{k}=(EKmbU-EKmbD)./(2*epsilon);
%        dEKmbbmmean{k}=(EKmbbmU-EKmbbmD)./(2*epsilon);
%        qUHyper.covariance=qHyper.covariance+diag(Delta);
%        qDHyper.covariance=qHyper.covariance-diag(Delta);
% 
%        qCUHyper.mean=qHyper.mean;
%        qCDHyper.mean=qHyper.mean;    
%        qCUHyper.covariance=qHyper.covariance+diag(Delta);
%        qCDHyper.covariance=qHyper.covariance-diag(Delta);
%        [EKmbCU,EKmbbmCU,Edist]=Expectation(qCUHyper,xbatch,z,Sigmaf,Batch,nz,D);
%        [EKmbCD,EKmbbmCD,Edist]=Expectation(qCDHyper,xbatch,z,Sigmaf,Batch,nz,D); 
%        dEKmbcov{k}=(EKmbCU-EKmbCD)./(2*epsilon);
%        dEKmbbmcov{k}=(EKmbbmCU-EKmbbmCD)./(2*epsilon);
%    end
%     
% %     fprintf('The difference between the each dimention:\n');
%     for i=1:D 
%         ErrordKmb.mean(i)=norm(dEKmb.mean{i}-dEKmbmean{i});
%         ErrordKmb.cov(i)=norm(dEKmb.covariance{i}-dEKmbcov{i});
%         ErrordKmbbm.mean(i)=norm(dEKmbbm.mean{i}-dEKmbbmmean{i});
%         ErrordKmbbm.cov(i)=norm(dEKmbbm.covariance{i}-dEKmbbmcov{i});
%     end
    
    
%         ErrordKmb.mean(1:D)
%         ErrordKmb.cov(1:D)
%         ErrordKmbbm.mean(1:D)
%         ErrordKmbbm.cov(1:D)
    
    
    for k=1:D
%         dqHyper.mean(k,1)=1/(Sigman^2)*(qU.mean)'*InvKmm*dEKmb.mean(:,:,k)*ybatch-...
%                  1/(2*(Sigman^2))*(qU.mean)'*InvKmm*dEKmbbm.mean(:,:,k)*InvKmm*(qU.mean)-...
%                  1/(2*(Sigman^2))*trace(qU.covariance*InvKmm*dEKmbbm.mean(:,:,k)*InvKmm)+...
%                  1/(2*(Sigman^2))*trace(InvKmm*dEKmbbm.mean(:,:,k))-qHyper.mean(k);


        dqHyper.mean(k,1)=Beta*(qU.mean)'*InvKmm*dEKmb.mean{k}*ybatch-...
                 Beta/2*(qU.mean)'*InvKmm*dEKmbbm.mean{k}*InvKmm*(qU.mean)-...
                 Beta/2*trace(qU.covariance*InvKmm*dEKmbbm.mean{k}*InvKmm)+...
                 Beta/2*trace(InvKmm*dEKmbbm.mean{k})-qHyper.mean(k);
             
             
%         dqHyper.covariance(k,k)=1/(Sigman^2)*(qU.mean)'*InvKmm*dEKmb.covariance(:,:,k)*ybatch-...
%                          1/(2*(Sigman^2))*(qU.mean)'*InvKmm*dEKmbbm.covariance(:,:,k)*InvKmm*(qU.mean)-...
%                          1/(2*(Sigman^2))*trace(qU.covariance*InvKmm*dEKmbbm.covariance(:,:,k)*InvKmm)+...
%                          1/(2*(Sigman^2))*trace(InvKmm*dEKmbbm.covariance(:,:,k))-0.5+1/qHyper.covariance(k,k);

        dqHyper.covariance(k,k)=Beta*(qU.mean)'*InvKmm*dEKmb.covariance{k}*ybatch-...
                         Beta/2*(qU.mean)'*InvKmm*dEKmbbm.covariance{k}*InvKmm*(qU.mean)-...
                         Beta/2*trace(qU.covariance*InvKmm*dEKmbbm.covariance{k}*InvKmm)+...
                         Beta/2*trace(InvKmm*dEKmbbm.covariance{k})-0.5+0.5/qHyper.covariance(k,k);

    end
    
%     Test whether the gradient with respect to the hyperparameters is correct
%      for k=1:D;
%        Delta=[];
%        for i=1:D
%            if i==k
%               num=epsilon;
%            else
%                num=0;
%            end
%            Delta=[Delta;num];
%        end
% 
%        qMUHyper.mean=qHyper.mean+Delta;
%        qMDHyper.mean=qHyper.mean-Delta;    
%        qMUHyper.covariance=qHyper.covariance;
%        qMDHyper.covariance=qHyper.covariance;
%        LBU=LowerBound(qU,InvKmm,xbatch,ybatch,z,Beta,Sigmaf,qMUHyper,Batch,nz,D);
%        LBD=LowerBound(qU,InvKmm,xbatch,ybatch,z,Beta,Sigmaf,qMDHyper,Batch,nz,D);
%        dqHypermean(k,1)=(LBU-LBD)/(2*epsilon);
%        
%        qCUHyper.mean=qHyper.mean;
%        qCDHyper.mean=qHyper.mean;    
%        qCUHyper.covariance=qHyper.covariance+diag(Delta);
%        qCDHyper.covariance=qHyper.covariance-diag(Delta);
%        
%        LBU=LowerBound(qU,InvKmm,xbatch,ybatch,z,Beta,Sigmaf,qCUHyper,Batch,nz,D);
%        LBD=LowerBound(qU,InvKmm,xbatch,ybatch,z,Beta,Sigmaf,qCDHyper,Batch,nz,D);
%        dqHypercov(k,1)=(LBU-LBD)/(2*epsilon);
%      
%      end
    
end