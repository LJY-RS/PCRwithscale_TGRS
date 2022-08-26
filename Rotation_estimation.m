function [bestR,inliers] = Rotation_estimation(X_lv,Y_lv,Sxy,Snoise,scale,bound)

res=Snoise-abs(Sxy-scale*ones(1,size(Sxy,2)));
inliers=find(res>0);
X_lv_in=X_lv(:,inliers);
Y_lv_in=Y_lv(:,inliers);
X_lv_in=X_lv_in*scale;
[~,bestR]=IRLS_SACauchy(X_lv_in,Y_lv_in,100,bound);

res=sqrt(sum((Y_lv-scale*bestR*X_lv).^2));
inliers=find(res<bound);