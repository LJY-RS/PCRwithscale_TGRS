function [Xin,Yin]=LvMaptoPt(X,Y,map,inliers,percent)

map_in=map(:,inliers);
tab=tabulate(map_in(:));
tab_sort=sortrows(tab,3,'descend');
sump=cumsum(tab_sort(:,3));
p_idx = sump<percent;
inlierPTS = tab_sort(p_idx,1);
Xin = X(:,inlierPTS);
Yin = Y(:,inlierPTS);
