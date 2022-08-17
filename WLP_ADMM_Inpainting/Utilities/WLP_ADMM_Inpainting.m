

function [reconstructed_image] = WLP_ADMM_Inpainting(y,A,para,p)

initial              =                    para.Initial;

mu                   =                    para.mu;

IterNums             =                    para.IterNums;

x_org                =                    para.org;

MASK                 =                    A;

A                    =                    @(x) MASK.*x;

AT                   =                    @(x) MASK.*x;

ATy                  =                    AT(y);

x                    =                    initial;

c                    =                    zeros(size(y));

z                    =                    zeros(size(y));

Muinv                =                    1/mu;

InvAAT               =                    1./(mu+MASK);

All_PSNR             =                    zeros(1,IterNums);

fprintf('Initial PSNR = %f\n',csnr(x,x_org,0,0));

for j = 1:IterNums
    
    
    z                     =         WLP_GST(x-c, para,p);  %Eq.(12)
    
    R                     =         ATy +mu*(z+c);
    
    x                     =         Muinv*(R - AT(InvAAT.*A(R))); %Eq.(11)
    
    c                     =         c + (z - x); %Eq.(9)
    
    All_PSNR(j)           =         csnr(x,x_org,0,0);
    
    fprintf('iter number = %d, PSNR = %f, FSIM = %f\n',j,csnr(x,x_org,0,0),FeatureSIM(x_org,x));

    if j>1
        if(All_PSNR(j)-All_PSNR(j-1)<0)
            break;
        end
    end

end

reconstructed_image    =     x;


end

