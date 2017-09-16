function K=Dist(x,y)
    [nx,Dx]=size(x);
    [ny,Dy]=size(y);
    K=(ones(ny,1)*sum((x.^2)',1))'+ones(nx,1)*sum((y.^2)',1)-2.*(x*(y'));    
end