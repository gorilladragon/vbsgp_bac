function [m, S, Kuu_inv, Xm_index] = vbsgp(data)

%  data = mountaincar;


	[N, D] = size(data);
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% number of inducing points
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	Num = 20;   % number of support points
	idx_induce = randperm(N, Num);  % randomly select idx of support points
	Xm_index = idx_induce;  % support index
	Datatrain.X = data(1:N, 1:D-1); % training input set 
	Datatrain.Y = data(1:N, D); % training output set
    Dim = D - 1;    % training input dimension

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% pick up inducing variables
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	z = Datatrain.X(idx_induce, :); % support input points

	ValidSet=200;
    IdValid=randperm(N,ValidSet);   % IdValid contains 200 unique values
    Xvalid=Datatrain.X(IdValid,:);  % corresponding input data
    Yvalid=Datatrain.Y(IdValid,:);  % corresponding ouput data

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% start the training procedure
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


	Batch = 100;
	jitter = 1e-5;  % 0.00001


	iter = 1;
    epoch = 5;

    ScaleU = 1;
    ScaleHyper = 1;
    pU = InducingPrior(z,jitter);   % mean vector of zeros, Cov. matrix of support
    qU = MultiGauss(Num,ScaleU);    % Num=20; mean vec of ones, eye Cov. matrix 
    qHyper = MultiGauss(Dim,ScaleHyper);    % Dim=9
    Beta = 4;
    Sigmaf = 0.5;
             
    rho.U.Mean = 1e-5;
    rho.U.Cov = 1e-5;
    rho.H.Mean = 1e-6;
    rho.H.Cov = 1e-6;
    rho.Beta = 1e-6;
    rho.Sigmaf = 1e-6;


    tau = 1;
    k = -1;


    I = eye(Num);
    L = chol(pU.covariance);    % cholesky decomposition 
    InvPcov = L\(L'\I);
    Kuu_inv = InvPcov;  % support Kernel inv

    qU.mean_temp = inf(Num,1);  % vector of inf
    qU.covariance_temp = inf(Num);  % Cov. matrix of inf
    qHyper.mean_temp = inf(Dim,1);
    qHyper.covariance_temp = inf(Dim);
    LB_Best = -inf;

%%
    for e = 1: epoch
    	id = randperm(N);
    	for m = 1%:Batch:N-Batch+1   % 1 to N-100+1, interval of 100
		    bData.X = Datatrain.X(id(m:m+Batch-1),:);   % each batch of training input data
            bData.Y = Datatrain.Y(id(m:m+Batch-1),:);   % each batch of training output data
            [dqU,dqHyper,dBeta,dSigmaf] = PartialDerive(qU,InvPcov,bData.X,bData.Y,z,Beta,Sigmaf,qHyper,Batch,Num,Dim);
            LB = LowerBound(qU,InvPcov,Xvalid,Yvalid,z,Beta,Sigmaf,qHyper,ValidSet,Num,Dim);
            if(LB>LB_Best)
                   BestParameter.U.mean=qU.mean;
                   BestParameter.U.covariance=qU.covariance;
                   BestParameter.H.mean=qHyper.mean;
                   BestParameter.H.covariance=qHyper.covariance;
                   BestParameter.Beta=Beta;
                   BestParameter.Sigmaf=Sigmaf;
           	end 
           	LB_Best=LB;


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

            iter = iter + 1;
    	end
	end
	m = BestParameter.U.mean;
	S = BestParameter.U.covariance;
end