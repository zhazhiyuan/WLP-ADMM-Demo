function reconstructed_image = Deblurring_WLP(y,A,Paras)

mu                        =                      Paras.mu;

x_org                     =                      Paras.org;

IterNums                  =                      Paras.IterNums;

initial                   =                      Paras.initial;

h                         =                      A;

H_FFT                     =                      fft2(h);

HC_FFT                    =                      conj(H_FFT);

A                         =                      @(x) real(ifft2(H_FFT.*fft2(x)));

At                        =                      @(x) real(ifft2(HC_FFT.*fft2(x)));

Aty                       =                      At(y);

x                         =                      initial;

c                         =                      zeros(size(y));

z                         =                      zeros(size(y));

all_psnr                  =                      zeros(1,IterNums);

muinv                     =                      1/mu;

filter_FFT                =                      HC_FFT./(abs(H_FFT).^2 + mu).*H_FFT;


fprintf('Initial PSNR = %f\n',csnr(x,x_org,0,0));


for Outloop  = 1:IterNums
   
    z                   =                        WLP_GST(x-c, Paras, Paras.p);  % Eq. (12)
    
    r                   =                        Aty + mu*(z+c);
    
    x                   =                        muinv*( r - real(ifft2(filter_FFT.*fft2(r))) );   %Eq. (11)
     
    c                   =                        c + (z - x);  % Eq. (9)
    
    all_psnr(Outloop)   =                        csnr(x,x_org,0,0);

    fprintf('iter number = %d, PSNR = %f, FSIM = %f\n',Outloop,csnr(x,x_org,0,0),FeatureSIM(x,x_org));
    
  if Outloop>1
      
     if(all_psnr(Outloop)-all_psnr(Outloop-1)<0)
            break;
     end
     
  end

      
end

reconstructed_image = x;


end

