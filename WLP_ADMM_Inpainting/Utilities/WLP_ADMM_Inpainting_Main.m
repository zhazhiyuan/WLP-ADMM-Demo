
function [reconstructed_image]=WLP_ADMM_Inpainting_Main(filename,patch,p_miss,mu,p)

        ori_gname              =                [filename '.tif'];
        
        x_rgb                  =                imread(ori_gname); 
        
        x_yuv                  =                rgb2ycbcr(x_rgb);
        
        x                      =                double(x_yuv(:,:,1)); 
        
        x_org                  =                 x;
        
        x_inpaint_re           =                zeros(size(x_yuv));
        
        x_inpaint_re(:,:,2)    =                x_yuv(:,:,2); 
        
        x_inpaint_re(:,:,3)    =                x_yuv(:,:,3); 
        
        ratio                  =                p_miss; 

        if ratio==0.6    %text mask
            
            MaskType    =    2; 
        else
            
            MaskType    =    1; % random mask; 
        end
        
        switch MaskType
            case 1  %random mask;
                rand('seed',0);
                O = double(rand(size(x)) > (1-ratio));
            case 2  %text mask
                O = imread('TextMask256.png');
                O = double(O>128);
        end
        
        y               =               x.* O;  % Observed Image
       
        para = [];
        
        if ~isfield(para,'mu')
            para.mu = mu;
        end
        
        if ~isfield(para,'org')
            para.org = x_org;
        end  
        
        if ~isfield(para,'IterNums')
            para.IterNums = 800;
        end 
        
        if ~isfield(para,'Initial')
            para.Initial = Inter_Initial(y,~O);
        end
        
        if ~isfield(para,'patch')
            para.patch = patch;  % patch d
        end
        
         if ~isfield(para,'step')
            para.step = 4;
         end       
        
         if ~isfield(para,'Similar_patch')
             para.Similar_patch = 60; % Similar patches c
         end
         
         if ~isfield(para,'Region')
              para.Region = 25;
         end        
        
        if ~isfield(para,'sigma')
               para.sigma = sqrt(2);
        end 
        if ~isfield(para,'e')
               para.e = 0.3;
        end         
        
   
        
     fprintf('.........................................\n');
     fprintf(ori_gname);
     fprintf('\n');
     fprintf('..........................................\n');
     
     if ratio==0.6
     fprintf('..................text removal.............\n');
     else
     fprintf('..............missing pixels.....   ratio = %f\n',ratio);
     end
     fprintf('Begining  WSNM_ADMM Algorithm for Image Inpainting\n');
     
     reconstructed_image        =         WLP_ADMM_Inpainting(y,O,para,p);
        
     fprintf('..................................................\n');      
     fprintf('Ending  WSNM_ADMM Algorithm for Image Inpainting\n');  
       
end

