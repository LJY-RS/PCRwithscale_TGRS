function bestT = Trans_estimation(X,Y,scale,R,bound)

Tv = Y-scale*R*X;
iter = 0; p=0.99;
Niter = 10^5; bestscore=0;
while iter< Niter
    id = randsample(size(Tv,2),1);
    ts = Tv(:,id);
    
    res=sqrt(sum((Tv-ts*ones(1,size(Tv,2))).^2));
    inliers=find(res<=bound);
    ninliers = length(inliers);
    if ninliers > bestscore
        Ts_in=Tv(:,inliers);
        ts_f = mean(Ts_in,2);
        res_f=sqrt(sum((Tv-ts_f*ones(1,size(Tv,2))).^2));
        inliers_f=find(res_f<bound);
        ninliers_f = length(inliers_f);
        if ninliers_f>=ninliers
            bestscore = ninliers_f;  % Record data for this model
            bestT = ts_f;
        else
            bestscore = ninliers;  % Record data for this model
            bestT = ts;
        end
        
        fracinliers =  bestscore/size(Tv,2);
        pNoOutliers = 1 -  fracinliers;
        pNoOutliers = max(eps, pNoOutliers);  % Avoid division by -Inf
        pNoOutliers = min(1-eps, pNoOutliers);% Avoid division by 0.
        Niter = log(1-p)/log(pNoOutliers);
        Niter = max(Niter,1000); % at least try 20 times
    end
    iter = iter+1;
end

res=sqrt(sum((Tv-bestT*ones(1,size(Tv,2))).^2));
inliers=res<=bound;
Ts_in=Tv(:,inliers);
bestT = mean(Ts_in,2);