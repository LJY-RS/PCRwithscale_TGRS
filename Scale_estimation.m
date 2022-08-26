function [bestS, inliers] = Scale_estimation(Sxy, Snoise, interval, flag)

Sxy_sub=Sxy(1:interval:end);
Snoise_sub=Snoise(1:interval:end);

if flag==1
    iter = 0; p=0.99;
    Niter = 10^5; bestscore=0; 
%     innerIter = 0; innerFlag=1;
    while (iter< Niter)
        id = randsample(size(Sxy,2),1);
        s = Sxy(id);
        res=Snoise_sub-abs(Sxy_sub-s*ones(1,size(Sxy_sub,2)));
        inliers=find(res>0);
        ninliers = length(inliers);
        if ninliers > bestscore
            Sxy_in=Sxy_sub(inliers);
            Snoise_bin2=Snoise_sub(inliers).^2;
            s_f = sum(Sxy_in./Snoise_bin2)/sum(1./Snoise_bin2);
            res_f=Snoise_sub-abs(Sxy_sub-s_f*ones(1,size(Sxy_sub,2)));
            inliers_f=find(res_f>0);
            ninliers_f = length(inliers_f);
            if ninliers_f>=ninliers
                bestscore = ninliers_f;  % Record data for this model
                bestS = s_f;
            else
                bestscore = ninliers;  % Record data for this model
                bestS = s;
            end
%             innerIter = innerIter+1;
%             if innerIter>10
%                 innerFlag=0;
%             end
            fracinliers =  bestscore/size(Sxy_sub,2);
            pNoOutliers = 1 -  fracinliers;
            pNoOutliers = max(eps, pNoOutliers);  
            pNoOutliers = min(1-eps, pNoOutliers);
            Niter = log(1-p)/log(pNoOutliers);
            Niter = max(Niter,1000); % at least try 20 times
        end
        iter = iter+1;
    end
    res=Snoise-abs(Sxy-bestS*ones(1,size(Sxy,2)));
    inliers=find(res>0);
    Sxy_in=Sxy(inliers);
    Snoise_bin2=Snoise(inliers).^2;
    bestS = sum(Sxy_in./Snoise_bin2)/sum(1./Snoise_bin2);
else
    bestS=1;
    res=Snoise-abs(Sxy-bestS*ones(1,size(Sxy,2)));
    inliers=find(res>0);
end