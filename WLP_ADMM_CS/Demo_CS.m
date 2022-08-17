clc
clear;
close all;


filename = 'boats';

Original_Filename = [filename '.tif'];

Original = imread(Original_Filename);

[Row, Col] = size(Original);

Original_Image = double(Original);

p = 0.65; 
% 0.6 for 0.1 N measurements
% 0.5 for 0.2 N measurements
% 0.95 for 0.3 N measurements
subrate = 0.1;

% Constructe Measurement Matrix (Gaussian Random)
patch_size = 32;

NN = patch_size * patch_size;

MM = round(subrate * NN);

randn('seed',0);

PHI = orth(randn(NN, NN))';

PHI = PHI(1:MM, :);

X = im2col(Original_Image, [patch_size patch_size], 'distinct');  

Y = PHI * X;  % CS Measurements
% Initial
disp('Begining Initilization ...');

[x_MH, ~] = MH_BCS_SPL_Decoder(Y, PHI, subrate, Row, Col);

disp('Ending  Initilization ...');

% Parameter Setting
par = [];

if ~isfield(par,'PHI')
       par.PHI = PHI; % Sampling Matrix
end

if ~isfield(par,'patch_size')        
       par.patch_size = patch_size;
end

if ~isfield(par,'Row')    
       par.Row = Row;
end

if ~isfield(par,'Col')           
       par.Col = Col;
end
   
if ~isfield(par,'patch')
       par.patch = 7; % patch size
end  
       
if ~isfield(par,'mu')
       par.mu = 0.0001;
end
 % 0.0001 for 0.1N measurements. 
 % 0.0005 for 0.2N measurements. 
 % 0.05 for 0.3N and 0.4N measurements. 
       
if ~isfield(par,'sigma')
       par.sigma = sqrt(2);
end
       
if ~isfield(par,'e')
       par.e = 0.4;
end
        
if ~isfield(par,'Initial')
      par.Initial = double(x_MH);
end

if ~isfield(par,'Org')        
      par.Org = Original_Image;
end
        
if ~isfield(par,'IterNum')
      par.IterNum = 600;
end

if ~isfield(par,'loop')
       par.loop = 200;
end
        
if ~isfield(par,'step')
       par.step = 4;
end  
         
if ~isfield(par,'Similar_patch')
       par.Similar_patch = 60; % Similar patch numbers
end
         
if ~isfield(par,'Region')
       par.Region = 20;
end   

[reconstructed_image, PSNR, FSIM]= WLP_ADMM_CS(Y, par,p);

Recon= strcat(filename,'_ratio_',num2str(subrate),'_PSNR_',num2str(PSNR),'_FSIM_',num2str(FSIM),'.png');
imwrite(uint8(reconstructed_image),strcat('./CS_Results/',Recon));
              
        