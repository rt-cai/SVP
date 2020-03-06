function out = wblpdf303(x,lambda,k)

if x < 0
    out = 0;
else
    out = k/lambda*(x/lambda)^(k-1)*exp(-(x/lambda)^k); 
end