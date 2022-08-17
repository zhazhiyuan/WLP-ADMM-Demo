function [reconstructed_image]= WLP_ADMM_Deblurring_Main(filename,deblur_class,mu,p)


        ori_name                =                      [filename '.tif'];
        
        x_rgb                  =                      imread(ori_name); 
        
        x_yuv                  =                      rgb2ycbcr(x_rgb);
        
        x                      =                      double(x_yuv(:,:,1)); 
        
        x_org                  =                       x;
        
        x_inpaint_re           =                       zeros(size(x_yuv));
        
        x_inpaint_re(:,:,2)    =                      x_yuv(:,:,2); 
        
        x_inpaint_re(:,:,3)    =                       x_yuv(:,:,3); 

        switch deblur_class
            case 1  % Uniform Kernel
                sigma=sqrt(2);
                v=ones(9); v=v./sum(v(:));
            case 2  % Gaussian Kernel
                sigma=sqrt(2);
                v=fspecial('gaussian', 25, 1.6);
        end
        
        %  Blurring Operator
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        [Xv, Xh]              =                      size(x_org);
        
        [ghy,ghx]             =                      size(v);
        
        big_v                 =                      zeros(Xv,Xh); 
        
        big_v(1:ghy,1:ghx)    =                      v;
        
        big_v                 =                      circshift(big_v,-round([(ghy-1)/2 (ghx-1)/2])); % pad PSF with zeros to whole image domain, and center it
        
        h                     =                      big_v;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        y_blur                =                      imfilter(x_org, v, 'circular');
        
        randn('seed',0);
        % Generate the final blur image
        y                     =                      y_blur + sigma*randn(Xv,Xh);
        
        % Parameters setting............
        
        Paras                  =                      [];
    
        Paras.org              =                      x_org;
        
           
        if ~isfield(Paras,'IterNums')
            Paras.IterNums = 600;
        end
        
        if ~isfield(Paras,'initial')
            Paras.initial = y;
        end
        
        if ~isfield(Paras,'block_size')
            Paras.patch = 8;  % patchsize
        end
        
        if ~isfield(Paras,'mu')
            Paras.mu = mu;
        end
        
         if ~isfield(Paras,'p')
            Paras.p = p;
         end
        
         if ~isfield(Paras,'Region')
            Paras.Region = 25;  %L
         end
        
        if ~isfield(Paras,'step')
            Paras.step = 4;
        end
        if ~isfield(Paras,'Similar_patch')
            Paras.Similar_patch = 60; % similar patches c
        end    
        
        if ~isfield(Paras,'sigma')
            Paras.sigma = sqrt(2);
        end
        
        if ~isfield(Paras,'e')
               Paras.e = 0.3;
        end     
        
        fprintf('***************************************************************\n')
        fprintf('***************************************************************\n')
        fprintf('Running WSNM_ADMM Algorithm for  Image Deblurring ...\n')
        
        reconstructed_image = Deblurring_WLP(y,h,Paras);
        
        fprintf('Ending WSNM_ADMM Algorithm for   Image Deblurring ...\n')
        

        
        
        
     
end
        


