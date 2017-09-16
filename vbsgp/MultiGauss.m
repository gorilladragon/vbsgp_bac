function Q=MultiGauss(Input,scale)
% [n,Dim]=size(Input);
Q.mean=ones(Input,1);
Q.covariance=scale*eye(Input);
end