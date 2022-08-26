function [LV,ID] = line_vectors(X,flag)

N=size(X,2);
LV=zeros(size(X,1),N*(N-1)/2);
L=1;H=0;
if flag==1
    ID=zeros(2,N*(N-1)/2);
end
for i=1:N
    x1=X(:,i);
    x2=X(:,i+1:N);
    SN=size(x2,2);
    lv=repmat(x1,1,SN)-x2;
    H=H+SN;
    if flag==1
        ID(1,L:H)=repmat(i,1,SN);
        ID(2,L:H)=i+1:N;
    end
    LV(:,L:H)=lv;
    L=H+1;
end

