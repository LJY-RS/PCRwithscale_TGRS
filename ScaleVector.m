function [Sxy, Snoise, X_lv, Y_lv, map] = ScaleVector(X,Y,bound,lengthbound)

[X_lv,map] = line_vectors(X,1);
Y_lv = line_vectors(Y,0);
D_xlv=sqrt(sum(X_lv.^2));
D_ylv=sqrt(sum(Y_lv.^2));
idx1=(D_xlv<=lengthbound);
idx2=(D_ylv<=lengthbound);
idx=idx1|idx2;
D_xlv(idx)=[];
D_ylv(idx)=[];
map(:,idx)=[];
X_lv(:,idx)=[];
Y_lv(:,idx)=[];
Sxy=D_ylv./(D_xlv+eps);
Snoise = bound./(D_xlv+eps);