function diffIm = Explicit_PM_modified(imageIn, numIterations, deltaT, kappa, option, sigma)

im = double(imageIn);
diffIm = im;


dx = 1;
dy = 1;

N = [0 1 0; 0 -1 0; 0 0 0];
S = [0 0 0; 0 -1 0; 0 1 0];
E = [0 0 0; 0 -1 1; 0 0 0];
W = [0 0 0; 1 -1 0; 0 0 0];


% Anisotropic diffusion.
for t = 1:numIterations
   
    %differences in respective directions
    nablaN = imfilter(diff_im,N,'conv');
    nablaS = imfilter(diff_im,S,'conv');   
    nablaE = imfilter(diff_im,E,'conv');
    nablaW = imfilter(diff_im,W,'conv');

        
    nablaN(1,:) = 0;
    nablaS(end,:) = 0;
    nablaE(:,end) = 0;
    nablaW(:,1) = 0;


    if sigma > 0    
        gaussBlur = imgaussfilt(diff_im,sigma);
        nablaNBlur = imfilter(gaussBlur,N,'conv');
        nablaSBlur = imfilter(gaussBlur,S,'conv');   
        nablaEBlur = imfilter(gaussBlur,E,'conv');
        nablaWBlur = imfilter(gaussBlur,W,'conv');
        

        nablaNBlur(1,:) = 0;
        nablaSBlur(end,:) = 0;
        nablaEBlur(:,end) = 0;
        nablaWBlur(:,1) = 0;
        
        
        if option == 1
            cN = exp(-(nablaNBlur/kappa).^2);
            cS = exp(-(nablaSBlur/kappa).^2);
            cE = exp(-(nablaEBlur/kappa).^2);
            cW = exp(-(nablaWBlur/kappa).^2);
            
        elseif option == 2
            cN = 1./(1 + (nablaNBlur/kappa).^2);
            cS = 1./(1 + (nablaSBlur/kappa).^2);
            cE = 1./(1 + (nablaEBlur/kappa).^2);
            cW = 1./(1 + (nablaWBlur/kappa).^2);
            
        end
    else
        if option == 1
            cN = exp(-(nablaN/kappa).^2);
            cS = exp(-(nablaS/kappa).^2);
            cW = exp(-(nablaW/kappa).^2);
            cE = exp(-(nablaE/kappa).^2);

        elseif option == 2
            cN = 1./(1 + (nablaN/kappa).^2);
            cS = 1./(1 + (nablaS/kappa).^2);
            cW = 1./(1 + (nablaW/kappa).^2);
            cE = 1./(1 + (nablaE/kappa).^2);

        end
    end
        
    diffIm = diffIm + deltaT * ((1/(dy^2)) * cN .* nablaN + (1/(dy^2)) *cS .* nablaS + ...
        (1/(dx^2)) * cW .* nablaW + (1/(dx^2)) *cE .* nablaE );
end

%figure('Name','PM');
%imshow(uint8(diffIm));