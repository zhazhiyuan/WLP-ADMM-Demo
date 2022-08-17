
function [Reconstructed_image, PSN_Result,FSIM_Result] = WLP_ADMM_CS(Y, par,p)

Row = par.Row;

Col = par.Col;

PHI = par.PHI;

X_org = par.Org;

IterNum = par.IterNum;

X_Initial = par.Initial;

patch_size = par.patch_size;

loop = par.loop;

mu = par.mu;

X = im2col(X_Initial, [patch_size patch_size], 'distinct');

W = zeros(size(X));

C = zeros(size(X));

ATA = PHI'*PHI;

ATy = PHI'*Y;

IM = eye(size(ATA));

All_PSNR = zeros(1,IterNum);

for j = 1:IterNum
    
    
    X_HAT = X;

    r = col2im(X_HAT - C, [patch_size patch_size],[Row Col], 'distinct');  
    
    X_BAR = WLP_ADMM_GST(r, par,p);
    
    X_BAR = im2col(X_BAR, [patch_size patch_size], 'distinct');
    
    W = X_BAR;
    
   for jj = 1:loop
        
        D = ATA*X_HAT - ATy + mu*(X_HAT - W - C);
        DTD = D'*D;
        G = D'*(ATA + mu*IM)*D;
        Step_Matrix = abs(DTD./G); 
        STEP_LENGTH = diag(diag(Step_Matrix));
        X = X_HAT - D*STEP_LENGTH;
        X_HAT = X; 
       % This step is avoding inverse.
  end
    
    C = C - (X - W);
   
    X_IMG = col2im(X, [patch_size patch_size],[Row Col], 'distinct');
    
    All_PSNR(j)    =   csnr(X_IMG,X_org,0,1);
    
    fprintf('IterNum = %d, PSNR = %f, FSIM = %f\n',j,csnr(X_IMG,X_org,0,1),FeatureSIM(X_IMG,X_org));
    
    if j>1
        if (All_PSNR(j)-All_PSNR(j-1)<0)
            break;
        end
    end
    
end


Reconstructed_image = X_IMG;

PSN_Result  = csnr(Reconstructed_image,X_org,0,1);
FSIM_Result = FeatureSIM(Reconstructed_image,X_org);
end

