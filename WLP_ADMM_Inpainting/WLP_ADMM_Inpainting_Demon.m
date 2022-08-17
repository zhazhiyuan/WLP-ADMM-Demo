clc;

clear;

close all;

filename          =      'Girl';

p_miss            =       0.2;    % 0.2~0.6

if p_miss==0.6    %Text_Removeal
    patches       =      10; 
    
    mu            =      0.06; 
    
    p             =      0.95;
    
elseif p_miss==0.2   % 80% missing
    patches       =      8; 
    
    mu            =      0.0003; 
    
    p             =      0.45;
    
elseif p_miss==0.3   % 70% missing
    patches       =      8;
    
    mu            =      0.0003; 
    
    p             =      0.45;
    
elseif p_miss==0.4  % 60% missing
    patches       =      8; 
    
    mu            =      0.03;  
    
    p             =      0.95;   
    
else     %    50% missing
    patches       =       8; 
    
    mu            =       0.04;  
    
    p             =       0.95;   
end


  im_out          =     WLP_ADMM_Inpainting_Main(filename, patches, p_miss,mu,p);

  imshow(im_out,[]);

  imwrite(uint8(im_out),'Girl_80%_missing_restored.png');

