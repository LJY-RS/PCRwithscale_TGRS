function [x_,R,W]=IRLS_SACauchy(x,y,iter,sigma)
W=ones(3,size(x,2));
w=W;
u1=max(x(:));
u2=min(x(:));
u=(u1-u2)^2;
div=1.2;
for i=1:iter
    [x_,R,W]=SA_Cauchy(x,y,u,W(1,:));
    if max(max(abs(w-W)))<1e-6
        break;
    end
    w=W;
    if u>(3*sigma)^2
        u=u/div;
    end
end

W(1,W(1,:)<0.6)=0;
w=W(1,:);
if sum(w)>10
    [x_,R,W]=SA_Cauchy(x,y,u,w);
end