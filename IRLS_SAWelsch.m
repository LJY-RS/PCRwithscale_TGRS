function [x_,R,T,W]=IRLS_SAWelsch(x,y,W,iter,sigma)
w=W;
u1=max(x(:));
u2=min(x(:));
u=(u1-u2);
div=1.1;
for i=1:iter
    [x_,R,T,W]=SA_Welsch(x,y,u,W(1,:));
    if max(max(abs(w-W)))<1e-6
        break;
    end
    w=W;
    if u>3.0802*sigma
        u=u/div;
    end
end