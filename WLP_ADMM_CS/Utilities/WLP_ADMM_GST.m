
function [Imout] = WLP_ADMM_GST(InputImage, par, p )

[H, W]   =   size(InputImage);

Region = par.Region;

patch    =    par.patch;

Patchsize    =   patch*patch;

Similar_patch   =   par.Similar_patch;

step     =   par.step;

N     =  H-patch+1;

M     =  W-patch+1;

L     =  N*M;

row     =  [1:step:N];

row     =  [row row(end)+1:N];

col     =  [1:step:M];

col    =  [col col(end)+1:M];

Groupset     =  zeros(Patchsize, L, 'single');

cnt     =  0;

for i  = 1:patch
    for j  = 1:patch
        cnt    =  cnt+1;
        Patch  =  InputImage(i:H-patch+i,j:W-patch+j);
        Patch  =  Patch(:);
        Groupset(cnt,:) =  Patch';
    end
end

GroupsetT  =   Groupset';

I        =   (1:L);

I        =   reshape(I, N, M);

NN       =   length(row);

MM       =   length(col);

Imgtemp     =  zeros(H, W);

Imgweight   =  zeros(H, W);

Array_Patch  =  zeros(patch, patch, Similar_patch);


for  i  =  1 : NN
    for  j  =  1 : MM
        
        currow      =   row(i);
        curcol      =   col(j);
        off      =   (curcol-1)*N + currow;
        
        Patchindx  =  Similar_Search(GroupsetT, currow, curcol, off, Similar_patch, Region, I);
        
        curArray = Groupset(:, Patchindx);
        
        M_temp   =repmat(mean(curArray,2),1,Similar_patch);
        
        curArray = curArray-M_temp;
        
        [GR_S, GR_V, GR_D] = svd(full(curArray),'econ');  %svd(CurArray);
        
        cc=  sqrt( mean(GR_V.^2, 2) );
        
        lambda      =   2*sqrt(2)*par.sigma^2./(cc + par.e);
        
        tau =  lambda*step*Similar_patch/par.mu;

        Thre=1./(diag(GR_V)+0.1);
        
        GR_Z = GST_Algo(GR_V,diag(tau.*Thre),p);
        
      %  GR_Z = soft(GR_V,diag(tau.*Thre));

        curArray = GR_S*GR_Z*GR_D'+M_temp;
        
        for k = 1:Similar_patch
            Array_Patch(:,:,k) = reshape(curArray(:,k),patch,patch);
        end
        
        for k = 1:length(Patchindx)
            RowIndx  =  ComputeRowNo((Patchindx(k)), N);
            ColIndx  =  ComputeColNo((Patchindx(k)), N);
            Imgtemp(RowIndx:RowIndx+patch-1, ColIndx:ColIndx+patch-1)    =   Imgtemp(RowIndx:RowIndx+patch-1, ColIndx:ColIndx+patch-1) + Array_Patch(:,:,k)';
            Imgweight(RowIndx:RowIndx+patch-1, ColIndx:ColIndx+patch-1)  =   Imgweight(RowIndx:RowIndx+patch-1, ColIndx:ColIndx+patch-1) + 1;
        end
        
    end
end

Imout = Imgtemp./(Imgweight+eps);

return;



