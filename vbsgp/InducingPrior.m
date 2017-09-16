function P=InducingPrior(z,jitter)
[n,~]=size(z);
P.mean=zeros(n,1);
% znew= z./Const;
P.covariance=CovARD(z)+jitter*eye(n);
end