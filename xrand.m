function y= xrand(m,n,r)
 rng('shuffle');
y= r(1)+rand(m,n)*(r(2)-r(1));
return