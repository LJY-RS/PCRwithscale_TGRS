clc; clear;
close all;
warning off;
noise=0.1;                     %  noise level 10CM
bound=2*sqrt(3)*noise;
thre=3*noise;
nTest=100;
Nin=100;
OuRa=[0 0.2 0.4 0.6 0.8 0.9 0.95 0.99];
ER=[]; ET=[]; TIME=[];
esS=1;

fail=0;
for k=6:8
    InRa=1-OuRa(k);
    str=['the outlier rate =' num2str(OuRa(k)*100) '%']; disp(str);
    
    for i=1:nTest
        i
        Nou=round(Nin/InRa)-Nin;    % number of outliers
        X=xrand(3,Nin+Nou,[-100 100]);
        r=xrand(3,1,[-pi/2 pi/2]);       % randomly generated rotations
        R= rodrigues(r);                 % ground truth rotation matrix
        t=xrand(3,1,[-100 100]);
        s0=xrand(1,1,[1 5]);           %加上尺度差异 注意：本文算法中尺度估计时间复杂度最高，不考虑尺度，算法大大提速
%         s0=1;
        Ygt=s0*R*X(:,1:Nin)+repmat(t,1,Nin);         % true matches of X
        randomvals=xrand(3,Nin,[-noise noise]);
        Y=Ygt+randomvals;
        meanY=mean(abs(Ygt(:)));
        Yo=xrand(3,Nou,[-1000 1000]);
        Y=[Y Yo];
        
        [bestS,bestR,bestT]=RegWithScale(X,Y,bound,5*bound,2,1);
        norm(s0-bestS)    
        norm(R-bestR)
        norm(t-bestT)
    end
end


