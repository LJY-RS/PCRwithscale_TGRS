function [bestS,bestR,bestT]=RegWithScale(X,Y,bound,lbound,interval,ifestimateScale)

[Sxy, Snoise, ~, ~, map] = ScaleVector(X,Y,bound,lbound);
[bestS, inliers] = Scale_estimation(Sxy, Snoise,interval,ifestimateScale);
[Xin,Yin]=LvMaptoPt(X,Y,map,inliers,50);
[Sxy_R, Snoise_R, X_lv, Y_lv, mapR] = ScaleVector(Xin,Yin,bound,lbound);
[bestR,inliers] = Rotation_estimation(X_lv,Y_lv,Sxy_R,Snoise_R,bestS,bound);
[Xin,Yin]=LvMaptoPt(Xin,Yin,mapR,inliers,80);
bestT = Trans_estimation(Xin,Yin,bestS,bestR,bound);