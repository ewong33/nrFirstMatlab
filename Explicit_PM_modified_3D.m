function diffIm = Explicit_PM_modified(vector3, numIterations, deltaT, kappa, option, sigma)

vector3 = double(vector3);

diffIm = vector3; 

dx = 1;
dy = 1;
dyx = sqrt(2); 

% previous and post
dPrev = dx;
dPost = dPrev;  
dPrevNSEW = dyx; 
dPostNSEW = dPrevNSEW; 
dPrevCorner = sqrt(3); 
dPostCorner = dPrevCorner; 

N = [0 1 0; 0 -1 0; 0 0 0];
S = [0 0 0; 0 -1 0; 0 1 0];
E = [0 0 0; 0 -1 1; 0 0 0];
W = [0 0 0; 1 -1 0; 0 0 0];

hNW = [1 0 0; 0 -1 0; 0 0 0];
hNE = [0 0 1; 0 -1 0; 0 0 0];
hSW = [0 0 0; 0 -1 0; 1 0 0];
hSE = [0 0 0; 0 -1 0; 0 0 1];

%slice1
slice2 = zeros(3,3); 
slice2(2,2) = -1; 
slice3 = zeros(3,3); 

slice1 = zeros(3,3);
slice1(2,2) = 1; 
prevAxis = cat(3, slice1, slice2, slice3); 

slice1 = zeros(3,3); 
slice1(1,2) = 1; 
prevN = cat(3, slice1, slice2, slice3); 

slice1 = zeros(3,3);
slice1(3,2) = 1; 
prevS = cat(3, slice1, slice2, slice3); 

slice1 = zeros(3,3); 
slice1(2,3) = 1; 
prevE = cat(3, slice1, slice2, slice3); 

slice1 = zeros(3,3); 
slice1(2,1) = 1; 
prevW = cat(3, slice1, slice2, slice3);

slice1 = zeros(3,3); 
slice1(1,1) = 1; 
prevNW = cat(3, slice1, slice2, slice3); 

slice1 = zeros(3,3); 
slice1(1,3) = 1; 
prevNE = cat(3, slice1, slice2, slice3); 

slice1 = zeros(3,3); 
slice1(3,1) = 1; 
prevSW = cat(3, slice1, slice2, slice3); 

slice1 = zeros(3,3); 
slice1(3,3) = 1; 
prevSE = cat(3, slice1, slice2, slice3); 

%slice2
slice1 = zeros(3,3);
slice3 = zeros(3,3); 

slice2 = zeros(3,3); 
slice2(2,2) = -1; 
slice2(1,2) = 1; 
currentN = cat(3, slice1, slice2, slice3);

slice2 = zeros(3,3);
slice2(2,2) = -1;
slice2(3,2) = 1; 
currentS = cat(3, slice1, slice2, slice3); 

slice2 = zeros(3,3); 
slice2(2,2) = -1;
slice2(2,3) = 1; 
currentE = cat(3, slice1, slice2, slice3); 

slice2 = zeros(3,3); 
slice2(2,2) = -1;
slice2(2,1) = 1; 
currentW = cat(3, slice1, slice2, slice3);

slice2 = zeros(3,3); 
slice2(2,2) = -1;
slice2(1,1) = 1; 
currentNW = cat(3, slice1, slice2, slice3); 

slice2 = zeros(3,3); 
slice2(2,2) = -1;
slice2(1,3) = 1; 
currentNE = cat(3, slice1, slice2, slice3); 

slice2 = zeros(3,3); 
slice2(2,2) = -1;
slice2(3,1) = 1; 
currentSW = cat(3, slice1, slice2, slice3); 

slice2 = zeros(3,3); 
slice2(2,2) = -1;
slice2(3,3) = 1; 
currentSE = cat(3, slice1, slice2, slice3); 

%slice3
slice1 = zeros(3,3); 
slice2 = zeros(3,3); 
slice2(2,2) = -1; 

slice3 = zeros(3,3);
slice3(2,2) = 1; 
postAxis = cat(3, slice1, slice2, slice3); 

slice3 = zeros(3,3); 
slice3(1,2) = 1; 
postN = cat(3, slice1, slice2, slice3); 

slice3 = zeros(3,3);
slice3(3,2) = 1; 
postS = cat(3, slice1, slice2, slice3); 

slice3 = zeros(3,3); 
slice3(2,3) = 1; 
postE = cat(3, slice1, slice2, slice3); 

slice3 = zeros(3,3); 
slice3(2,1) = 1; 
postW = cat(3, slice1, slice2, slice3);

slice3 = zeros(3,3); 
slice3(1,1) = 1; 
postNW = cat(3, slice1, slice2, slice3); 

slice3 = zeros(3,3); 
slice3(1,3) = 1; 
postNE = cat(3, slice1, slice2, slice3); 

slice3 = zeros(3,3); 
slice3(3,1) = 1; 
postSW = cat(3, slice1, slice2, slice3); 

slice3 = zeros(3,3); 
slice3(3,3) = 1; 
postSE = cat(3, slice1, slice2, slice3); 


for t = 1:numIterations 
    nablaN = imfilter(diffIm,currentN,'conv');
    nablaS = imfilter(diffIm,currentS,'conv');     
    nablaE = imfilter(diffIm,currentE,'conv');
    nablaW = imfilter(diffIm,currentW,'conv');

    nablaNW = imfilter(diffIm,currentNW,'conv');
    nablaNE = imfilter(diffIm,currentNE,'conv');
    nablaSW = imfilter(diffIm,currentSW,'conv');
    nablaSE = imfilter(diffIm,currentSE,'conv');   

    nablaPrevAxis = imfilter(diff_im, prevAxis,'conv'); 
    nablaPrevN = imfilter(diff_im,prevN,'conv');
    nablaPrevS = imfilter(diff_im,prevS,'conv');   
    nablaPrevE = imfilter(diff_im,prevE,'conv');
    nablaPrevW = imfilter(diff_im,prevW,'conv');
    
    nablaPrevNW = imfilter(diff_im,prevNW,'conv');
    nablaPrevNE = imfilter(diff_im,prevNE,'conv');
    nablaPrevSW = imfilter(diff_im,prevSW,'conv');
    nablaPrevSE = imfilter(diff_im,prevSE,'conv');   

    nablaPostAxis = imfilter(diff_im, postAxis,'conv'); 
    nablaPostN = imfilter(diff_im,postN,'conv');
    nablaPostS = imfilter(diff_im,postS,'conv');   
    nablaPostE = imfilter(diff_im,postE,'conv');
    nablaPostW = imfilter(diff_im,postW,'conv');

    nablaPostNW = imfilter(diff_im,postNW,'conv');
    nablaPostNE = imfilter(diff_im,postNE,'conv');
    nablaPostSW = imfilter(diff_im,postSW,'conv');
    nablaPostSE = imfilter(diff_im,postSE,'conv');   

    nablaN(1,:) = 0;
    nablaS(end,:) = 0;
    nablaE(:,end) = 0;
    nablaW(:,1) = 0;

    nablaNW(1,:) = 0;
    nableNW(:,1) = 0; 
    nablaNE(1,:) = 0;
    nablaNE(:,end) = 0; 
    nablaSW(end,:) = 0;
    nablaSW(:,1) = 0; 
    nablaSE(end,:) = 0;
    nablaSE(:,end) = 0; 

    nablaPrevN(1,:) = 0;
    nablaPrevS(end,:) = 0;
    nablaPrevE(:,end) = 0;
    nablaPrevW(:,1) = 0;
    
    nablaPrevNW(1,:) = 0;
    nablePrevNW(:,1) = 0; 
    nablaPrevNE(1,:) = 0;
    nablaPrevNE(:,end) = 0; 
    nablaPrevSW(end,:) = 0;
    nablaPrevSW(:,1) = 0; 
    nablaPrevSE(end,:) = 0;
    nablaPrevSE(:,end) = 0; 

    nablaPostN(1,:) = 0;
    nablaPostS(end,:) = 0;
    nablaPostE(:,end) = 0;
    nablaPostW(:,1) = 0;

    nablaPostNW(1,:) = 0;
    nablePostNW(:,1) = 0; 
    nablaPostNE(1,:) = 0;
    nablaPostNE(:,end) = 0; 
    nablaPostSW(end,:) = 0;
    nablaPostSW(:,1) = 0; 
    nablaPostSE(end,:) = 0;
    nablaPostSE(:,end) = 0; 

    if sigma > 0    
        diffBlur = imgaussfilt(diffIm,sigma);
        nablaNBlur = imfilter(diffBlur,N,'conv');
        nablaSBlur = imfilter(diffBlur,S,'conv');   
        nablaEBlur = imfilter(diff_Blur,E,'conv');
    	nablaWBlur = imfilter(diffBlur,W,'conv');
              
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
            cE = exp(-(nablaE/kappa).^2);
            cW = exp(-(nablaW/kappa).^2);
            

            cNW = exp(-(nablaNW/kappa).^2);
            cNE = exp(-(nablaNE/kappa).^2);       
            cSW = exp(-(nablaSW/kappa).^2);
            cSE = exp(-(nablaSE/kappa).^2);

            
            cPrevAxis = exp(-(nablaPrevAxis/kappa).^2);
            cPrevN = exp(-(nablaPrevN/kappa).^2);
            cPrevS = exp(-(nablaPrevS/kappa).^2);          
            cPrevE = exp(-(nablaPrevE/kappa).^2);
            cPrevW = exp(-(nablaPrevW/kappa).^2);

            cPrevNW = exp(-(nablaPrevNW/kappa).^2);
            cPrevNE = exp(-(nablaPrevNE/kappa).^2);
            cPrevSW = exp(-(nablaPrevSW/kappa).^2);
            cPrevSE = exp(-(nablaPrevSE/kappa).^2);


            cPostAxis = exp(-(nablaPostAxis/kappa).^2);
            cPostN = exp(-(nablaPostN/kappa).^2);
            cPostS = exp(-(nablaPostS/kappa).^2);
            cPostE = exp(-(nablaPostE/kappa).^2);
            cPostW = exp(-(nablaPostW/kappa).^2);
            

            cPostNW = exp(-(nablaPostNW/kappa).^2);
            cPostNE = exp(-(nablaPostNE/kappa).^2);
            cPostSW = exp(-(nablaPostSW/kappa).^2);
            cPostSE = exp(-(nablaPostSE/kappa).^2);

        elseif option == 2
            cN = 1./(1 + (nablaN/kappa).^2);
            cS = 1./(1 + (nablaS/kappa).^2);
            cW = 1./(1 + (nablaW/kappa).^2);
            cE = 1./(1 + (nablaE/kappa).^2);

            cNW = 1./(1 + (nablaNW/kappa).^2);
            cNE = 1./(1 + (nablaNE/kappa).^2);
            cSW = 1./(1 + (nablaSW/kappa).^2);
            cSE = 1./(1 + (nablaSE/kappa).^2);
        end
    end
        
    %diffIm = diffIm + ...
    %    deltaT * (...
    %    (1/(dy^2))*cN.*nablaN + (1/(dy^2))*cS.*nablaS + ...
    %    (1/(dx^2))*cW.*nablaW + (1/(dx^2))*cE.*nablaE );

    %diffIm = diffIm + ...
    %    deltaT * (...
    %    (1/(dy^2))*cN.*nablaN + (1/(dy^2))*cS.*nablaS + ...
    %    (1/(dx^2))*cW.*nablaW + (1/(dx^2))*cE.*nablaE + ...
    %    (1/(dyx^2))*cNW.*nablaNW + (1/(dyx^2))*cNE.*nablaNE + ...
    %    (1/(dyx^2))*cSW.*nablaSW + (1/(dyx^2))*cSE.*nablaSE); 


    diffIm = diffIm + ...
        deltaT * (...
        (1/(dy^2))*cN.*nablaN + (1/(dy^2))*cS.*nablaS + ...
        (1/(dx^2))*cW.*nablaW + (1/(dx^2))*cE.*nablaE + ...
        (1/(dyx^2))*cNW.*nablaNW + (1/(dyx^2))*cNE.*nablaNE + ...
        (1/(dyx^2))*cSW.*nablaSW + (1/(dyx^2))*cSE.*nablaSE + ...
        (1/(dy^2))*cPrevAxis.*nablaPrevAxis + ...
        (1/(dyx^2))*cPrevN.*nablaPrevN + (1/(dyx^2))*cPrevS.*nablaPrevS + ...
        (1/(dyx^2))*cPrevW.*nablaPrevW + (1/(dyx^2))*cPrevE.*nablaPrevE + ...
        (1/(dPrevCorner^2))*cPrevNW.*nablaPrevNW + (1/(dPrevCorner^2))*cPrevNE.*nablaPrevNE + ...
        (1/(dPrevCorner^2))*cPrevSW.*nablaPrevSW + (1/(dPrevCorner^2))*cPrevSE.*nablaPrevSE + ...
        (1/(dy^2))*cPostAxis.*nablaPostAxis + ...
        (1/(dyx^2))*cPostN.*nablaPostN + (1/(dyx^2))*cPostS.*nablaPostS + ...
        (1/(dyx^2))*cPostW.*nablaPostW + (1/(dyx^2))*cPostE.*nablaPostE + ...
        (1/(dPrevCorner^2))*cPostNW.*nablaPostNW + (1/(dPrevCorner^2))*cPostNE.*nablaPostNE + ...
        (1/(dPrevCorner^2))*cPostSW.*nablaPostSW + (1/(dPrevCorner^2))*cPostSE.*nablaPostSE);
end
