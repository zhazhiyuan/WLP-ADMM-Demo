clc;

clear;

close all;

filename          =      'House';

Deblur_type       =       2;  % 1 Uniform Kernel;  2 Gaussian Kernel;

if Deblur_type    ==      1
    
    mu            =      0.06;
    p             =      0.6;
    
else
    
    mu            =      0.02;
    
    p             =      0.7;
    
end

  im_out          =     WLP_ADMM_Deblurring_Main(filename,Deblur_type,mu,p);

  imshow(im_out,[]);

  imwrite(uint8(im_out),'House_Uniform_Deblur.png');

