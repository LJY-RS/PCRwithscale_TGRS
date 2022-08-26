function [Bfit,R,W]=SA_Cauchy(A,B,u,w)

matmvec=@(M,v) bsxfun(@minus,M,v); %matrix-minus-vector
mattvec=@(M,v) bsxfun(@times,M,v); %matrix-times-vector

sw=sum(w);
if sw==0
    w=ones(1,size(A,2));
    sw=sum(w);
end
w=w/sw;
lc=A*w';   rc=B*w';                %weighted centroids
w2=sqrt(w);
left  = matmvec(A,lc);             %weighted coordinates
left  = mattvec(left,w2);
right = matmvec(B,rc);
right = mattvec(right,w2);
M=left*right.';

[Sxx,Syx,Szx,  Sxy,Syy,Szy,   Sxz,Syz,Szz]=dealr(M(:));
N=[(Sxx+Syy+Szz)  (Syz-Szy)      (Szx-Sxz)      (Sxy-Syx);...
    (Syz-Szy)      (Sxx-Syy-Szz)  (Sxy+Syx)      (Szx+Sxz);...
    (Szx-Sxz)      (Sxy+Syx)     (-Sxx+Syy-Szz)  (Syz+Szy);...
    (Sxy-Syx)      (Szx+Sxz)      (Syz+Szy)      (-Sxx-Syy+Szz)];
[V,D]=eig(N);
[~,emax]=max(real(  diag(D)  )); emax=emax(1);
q=V(:,emax);                     %Gets eigenvector corresponding to maximum eigenvalue
q=real(q);                       %Get rid of imaginary part caused by numerical error
[~,ii]=max(abs(q)); sgn=sign(q(ii(1)));
q=q*sgn;                         %Sign ambiguity

quat=q(:);
quat=quat./norm(quat);
q0=quat(1);
qx=quat(2);
qy=quat(3);
qz=quat(4);
v =quat(2:4);          

Z=[q0 -qz qy;...               %estimate R (map to orthogonal matrix)
    qz q0 -qx;...
    -qy qx  q0 ];
R=v*v.' + Z^2;

Bfit=R*A;

E=sqrt(sum((Bfit-B).^2));      %update weights
w=u./(u+E.^2);
% w=u./(u+abs(E));
W=[w;w;w];
end


function varargout=dealr(v)
varargout=num2cell(v);
end


