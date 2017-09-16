    clear all;
    clc;
    load('./Dataset/ProcessDataTwitter.mat');
    [N,Dim]=size(DataTrain.X);
        
%     Datatrain.X=DataTrain.X;
    Datatrain.X=bsxfun(@times,bsxfun(@minus,DataTrain.X,mean(DataTrain.X)),1./sqrt(var(DataTrain.X)));
    Datatrain.Y=(DataTrain.Y-mean(DataTrain.Y))/sqrt(var(DataTrain.Y));



    [Ntest,~]=size(DataTest.Y);
    Datatest.X=bsxfun(@times,bsxfun(@minus,DataTest.X,mean(DataTrain.X)),1./sqrt(var(DataTrain.X)));
%     Datatest.X=DataTest.X;    
    
    %the size of the validation set
    ValidSet=200;
    IdValid=randperm(N,ValidSet);
    Xvalid=Datatrain.X(IdValid,:);
    Yvalid=Datatrain.Y(IdValid,:);

    
    % the size of mini-batch each iteration
    Batch=100;
    
    Const=1./[1,1,1,1,1,1];
    %jitter=1e-05;
    jitter=0;
    thresh=1;
    patience=10;
    Round=4;
    
    Num=200;
    fprintf('Function PickInduce Randomly:\n');
%     Z=Datatrain.X(randperm(N,Num),:);
%     z=bsxfun(@times,Z,Const);

    c = parcluster('local');
    c.NumWorkers = 12;
  
    for Experiment=1:1
        %Datatest.Y=(DataTest.Y-mean(DataTrain.Y))/sqrt(var(DataTrain.Y));
        % Const=2./(abs(min(Datatrain.X))+max(Datatrain.X));
        % Const=1./[19.7,8.5,1.5,320.5,8547.7,8.9];
        %Const=1./[0.804,1.034,31.05,0.995,3.919,1783.623];
        % using K-means to pick induce and randomly select batch
        % data
        % fprintf('Function PickInduce in Kmeans:\n');
        % tic;
        % Z=PickInduce2(Datatrain,Num);
        % toc;
%         
%         if(Experiment==1)
%             donelooping=true;
%         end;
        fprintf('\n\nExperiment %d \n\n',Experiment);
        fprintf('\n\nValidation:%3d \t Inducing_Points:%3d \t Batch_Data:%3d \n\n',ValidSet,Num,Batch);
        Iter=1;
        flag=0;
        % fprintf('Function PartitionData Randomly:\n');
        % tic;
        % bData=PartitionData2(Datatrain,Batch);
        % toc;

        % fprintf('Function PickInduce Randomly:\n');
        %String=sprintf('./Dataset/InducingPoints%d.mat',Num);
        %load(String);


        % fprintf('Function PartitionData Randomly:\n');
        % tic;
        % Cluster=PartitionData(Dataremain(1:10000,:),kBlocks);
        % toc;

        %Cluster=PartitionData(Dataremain,kBlocks);

        %z=bsxfun(@times,bsxfun(@minus,Z,mean(DataTrain.X)),1./sqrt(var(DataTrain.X)));

        % [~,Dim]=size(z);
        ScaleU=1;
        ScaleHyper=1;
        pU=InducingPrior(z,jitter);
        qU=MultiGauss(Num,ScaleU);
        qHyper=MultiGauss(Dim,ScaleHyper);
        Beta=4;
        Sigmaf=0.5;
        
%         
        rho.U.Mean=1e-5;
        rho.U.Cov=1e-5;
        rho.H.Mean=1e-6;
        rho.H.Cov=1e-6;
        rho.Beta=1e-6;
        rho.Sigmaf=1e-6;
        
        
                
%         rho.U.Mean=4e-2;
%         rho.U.Cov=4e-4;
%         rho.H.Mean=4e-2;
%         rho.H.Cov=4e-2;
%         rho.Beta=4e-3;
%         rho.Sigmaf=4e-4;

        rho0=1;
        tau =1;
        k=-1;


        % tic;
        % InvPcov=inv(pU.covariance);
        % toc;




        % bData=PartitionData2(Datatrain,Batch);



        % [~,Dim]=size(z);
        % pU=InducingPrior(Z,jitter);
        % qU=MultiGauss(Num);
        % qHyper=MultiGauss(Dim);
        % Sigman=0.1;
        % Sigmaf=1;

        I=eye(Num);
        L=chol(pU.covariance);
        InvPcov=L\(L'\I);

        qU.mean_temp=inf(Num,1);
        qU.covariance_temp=inf(Num);
        qHyper.mean_temp=inf(Dim,1);
        qHyper.covariance_temp=inf(Dim);
        LB_Best=-inf;
        RMSE_Temp=inf;
        donelooping=false;

        
%         if(Experiment==1)
%             donelooping=true;
%         end;
        
        String1=sprintf('./Batch%d_Inducing%d',Batch,Num);
        String2=sprintf('Experiment%d',Experiment);
        mkdir(String1,String2);
        fclose('all');


        % FqUmean=fopen('qUmean.txt','a');
        % FqUcov=fopen('qUcov.txt','a');
        % FqHmean=fopen('qHypermean.txt','a');
        % FqHcov=fopen('qHypercov.txt','a');
        % FBeta=fopen('Beta.txt','a');
        % FSigmaf=fopen('Sigmaf.txt','a');


        % FLowerBound=fopen('.\Experiment\LowerBound.txt','a');
        % fprintf(FLowerBound,'Validation:%3d \n Inducing_Points:%3d \n Batch_Data:%3d \n',ValidSet,Num,Batch);
        % fclose(FLowerBound);


        % RMSE, Hyper Covariance, Time per gradient calculation, Time per -prediction calculation 
        FilenameRMSE=sprintf('%s/%s/RMSE.txt',String1,String2);
        FilenameqHcov=sprintf('%s/%s/qHypercov.txt',String1,String2);
        FilenameTGrad=sprintf('%s/%s/T_Grad.txt',String1,String2);
        FilenameTPredict=sprintf('%s/%s/T_Predict.txt',String1,String2);
        FilenameBeta=sprintf('%s/%s/Beta.txt',String1,String2);
        FilenameSigmaf=sprintf('%s/%s/Sigmaf.txt',String1,String2);


        FRMSE=fopen(FilenameRMSE,'a');
        fprintf(FRMSE,'Inducing-Points %3d \n Batch-Data %3d \n Test-Data %3d\n',Num,Batch,Ntest);
        fclose(FRMSE);

        FqHcov=fopen(FilenameqHcov,'a');
        fprintf(FqHcov,'Inducing-Points %3d \n Batch-Data %3d \n Test-Data %3d\n',Num,Batch,Ntest);
        fclose(FqHcov);

        FT_Grad=fopen(FilenameTGrad,'a');
        fprintf(FT_Grad,'Inducing-Points %3d \n Batch-Data %3d \n Test-Data %3d\n',Num,Batch,Ntest);
        fclose(FT_Grad);

        FT_Predict=fopen(FilenameTPredict,'a');
        fprintf(FT_Predict,'Inducing-Points %3d \n Batch-Data %3d \n Test-Data %3d\n',Num,Batch,Ntest);
        fclose(FT_Predict);

        while(~donelooping)
           id=randperm(N);
           for m=1:Batch:N-Batch+1
                tic;
                fprintf('Cycle %d\n',Iter)
        % bData=PartitionData2(Datatrain,Batch);
                bData.X=Datatrain.X(id(m:m+Batch-1),:);
                bData.Y=Datatrain.Y(id(m:m+Batch-1),:);
        % bDataNew.X=bsxfun(@times,bData.X,Const);
        % bDataNew.Y=bData.Y;
        % dqU=PartialDeriveInducing(qU,InvPcov,bData.X,bData.Y,z,Sigman,Sigmaf,qHyper,Batch,Num,Dim);
        % dqHyper=PartialDeriveHyper(qU,InvPcov,bData.X,bData.Y,z,Sigman,Sigmaf,qHyper,Batch,Num,Dim);
               tic;
               [dqU,dqHyper,dBeta,dSigmaf]=PartialDerive(qU,InvPcov,bData.X,bData.Y,z,Beta,Sigmaf,qHyper,Batch,Num,Dim);
               T_Grad(Iter)=toc;
               FT_Grad=fopen(FilenameTGrad,'a');
               fprintf(FT_Grad,'%d %f\n',Iter,T_Grad(Iter));
               fclose(FT_Grad);

               fprintf('\t Time_Gradient:%f\n',T_Grad(Iter));
               LB=LowerBound(qU,InvPcov,Xvalid,Yvalid,z,Beta,Sigmaf,qHyper,ValidSet,Num,Dim);
               fprintf('\t LB_Old:%s\t LB_New:%s\n',num2str(LB_Best),num2str(LB));
               fprintf('\t |qU.covariance|:%e\n',det(qU.covariance));
               if(LB>LB_Best)
                   BestParameter.U.mean=qU.mean;
                   BestParameter.U.covariance=qU.covariance;
                   BestParameter.H.mean=qHyper.mean;
                   BestParameter.H.covariance=qHyper.covariance;
                   BestParameter.Beta=Beta;
                   BestParameter.Sigmaf=Sigmaf;
               end  

               LB_Best=LB;

        %        plot(Iter,LB,'x');
        %        pause(0.01);

        %        FLowerBound=fopen('.\Experiment\LowerBound.txt','a');
        %        fprintf(FLowerBound,'%d: %f\n',Iter,LB);
        %        fclose(FLowerBound);

               if(flag>=patience)
                    donelooping=true;
                    break;
               end
        % rho=rho0/(1+tau*rho0*Iter)^k;
%                 rho.U.Mean=1e-2;
%                 rho.U.Cov=1e-4;
%                 rho.H.Mean=1e-2;
%                 rho.H.Cov=1e-2;
%                 rho.Beta=1e-3;
%                 rho.Sigmaf=1e-4;
                qU.mean_temp=qU.mean;
                qU.covariance_temp=qU.covariance;
                qHyper.mean_temp=qHyper.mean;
                qHyper.covariance_temp=qHyper.covariance;
                Beta_temp=Beta;
                Sigmaf_temp=Sigmaf;

        % FqUmean=fopen('qUmean.txt','a');
        % FqUcov=fopen('qUcov.txt','a');
        % FqHmean=fopen('qHypermean.txt','a');
        % FqHcov=fopen('qHypercov.txt','a');
        % FBeta=fopen('Beta.txt','a');
        % FSigmaf=fopen('Sigmaf.txt','a');
        % FLowerBound=fopen('LowerBound.txt','a');


%              if(mod(Iter,Round)==0||Iter==1)
            if(mod(Iter,Round)==0)
                %Test data
               tic;
               testY_star=Prediction(Datatest,BestParameter,z,Ntest,Num,InvPcov,1);
               T_Predict(Iter)=toc;
               FT_Predict=fopen(FilenameTPredict,'a');
               fprintf(FT_Predict,'%d %f\n',Iter,T_Predict(Iter));
               fclose(FT_Predict);
               fprintf('\t Time_Predict:%f\n',T_Predict(Iter));        
                %Root Mean Square Root Error
                TestY_star.mean=bsxfun(@plus,bsxfun(@times,testY_star.mean,sqrt(var(DataTrain.Y))),mean(DataTrain.Y));
%                 TestY_star.covariance=bsxfun(@times,testY_star.covariance,var(DataTrain.Y));
                RMSE=norm(DataTest.Y-TestY_star.mean)/sqrt(Ntest);
                FRMSE=fopen(FilenameRMSE,'a');
                fprintf(FRMSE,'%d %f\n',Iter,RMSE);
                fprintf('The RMSE is %f \t',RMSE);
                fclose(FRMSE);
%                 plot(Iter,RMSE,'x');
%                 pause(0.01);
                if(abs(RMSE-RMSE_Temp)<thresh)
                    flag=flag+1;
                else
                    flag=1;
                end  
                fprintf('The flag is %d\n',flag);
                RMSE_Temp=RMSE;
            end


        FqHcov=fopen(FilenameqHcov,'a');
        % FqUmean=fopen('C:\Users\????\Desktop\Experiment5\qUmean.txt','a');
        % FqUcov=fopen('C:\Users\????\Desktop\Experiment5\qUcov.txt','a');
        % FqHmean=fopen('C:\Users\????\Desktop\Experiment5\qHypermean.txt','a');
        % FqHcov=fopen('C:\Users\????\Desktop\Experiment5\qHypercov.txt','a');
        FBeta=fopen(FilenameBeta,'a');
        FSigmaf=fopen(FilenameSigmaf,'a');


        % Write2File(FqUmean,qU.mean,Iter); 
        % Write2File(FqUcov,qU.covariance,Iter);
        % Write2File(FqHmean,qHyper.mean,Iter);
        Write2File(FqHcov,qHyper.covariance,Iter);
        fprintf('\t qHyper.mean:%f,%f,%f,%f,%f.%f\n',qHyper.mean);
        fprintf('\t qHyper.covariance:%f,%f,%f,%f,%f.%f\n',diag(qHyper.covariance));
        Write2File(FBeta,Beta,Iter);
        Write2File(FSigmaf,Sigmaf,Iter);


        % fclose(FqUmean);fclose(FqUcov);
        %fclose(FqHmean);
        fclose(FqHcov);
        fclose(FBeta);fclose(FSigmaf);




                qU.mean=qU.mean+rho.U.Mean*dqU.mean;
                qU.covariance=qU.covariance+rho.U.Cov*dqU.covariance;
                qHyper.mean=qHyper.mean+rho.H.Mean*dqHyper.mean;
                qHyper.covariance=qHyper.covariance+rho.H.Cov*dqHyper.covariance;
                Beta=Beta+rho.Beta*dBeta;
                Sigmaf=Sigmaf+rho.Sigmaf*dSigmaf;

                rho.U.Mean=rho.U.Mean*(1+tau*rho.U.Mean)^k;
                rho.U.Cov=rho.U.Cov*(1+tau*rho.U.Cov)^k;
                rho.H.Mean=rho.H.Mean*(1+tau*rho.H.Mean)^k;
                rho.H.Cov=rho.U.Cov*(1+tau*rho.H.Cov)^k;
                rho.Beta=rho.Beta*(1+tau*rho.Beta)^k;
                rho.Sigmaf=rho.Sigmaf*(1+tau*rho.Sigmaf)^k;

        % Error=norm(qU.mean_temp-qU.mean)+norm(qU.covariance_temp-qU.covariance)+...
        % norm(qHyper.mean_temp-qHyper.mean)+norm(qHyper.covariance_temp-qHyper.covariance)+...
        % norm(Beta_temp-Beta)+norm(Sigmaf_temp-Sigmaf);
        % fprintf('Cycle %d:Error is %f\t',Iter,Error);

                Iter=Iter+1;
                T_Iter=toc; 
                fprintf('\t Time_Iteration:%f\n',T_Iter);
           end

        end





    end

