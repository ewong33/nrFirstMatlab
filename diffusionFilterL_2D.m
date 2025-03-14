clear;

tic;

%inputDir = '/Users/ewong3/Documents/MATLAB/D169_400_17Lux_7ft_17ft'; 
%inputDir = '/Users/ewong3/Documents/MATLAB/Camera/30_VID_20241030_150912/labSequenceMotion';
inputDir = '/Users/ewong3/Documents/MATLAB/30_VID_20241030_151436';

inputDir = '/Users/ewong3/Documents/MATLAB/30_VID_20241030_151436/temporalHalf';

inputDir = '/Users/ewong3/Documents/MATLAB/VID_20241106_120250';
%inputDir = '/Users/ewong3/Documents/MATLAB/homeScene/400_noNRPerson_VID_20241029_142546_Crop/homeSceneMotion';
outputDir = inputDir;  

outputDir = '/Users/ewong3/Documents/MATLAB/30_VID_20241030_151436/temporalHalfAndDiffusion'; 
outputDir = '/Users/ewong3/Documents/MATLAB/VID_20241106_120250/diffusion';


fileList = dir(fullfile(inputDir, '*.png'));
pngFile = fullfile(inputDir, fileList(1).name);
imRGB = imread(pngFile); 
imLAB = rgb2lab(imRGB); 
smoothedLAB = imLAB;
[w, h, c] = size(imRGB);

numImages = length(fileList);
%numIterations = 8; 
numIterations = 10; 


patch = imLAB(200:900, 1750:2450);
patch = imLAB(100:500, 1300:2000); 

%patch = imLAB(1600:2100, 3300:3800);
patchSq = patch .^ 2;
edist = sqrt(sum(patchSq,3));
patchVar = std2(edist).^2;
multFactor = 1; 
DegreeOfSmoothing = multFactor * patchVar;


for k = 2014:numImages
    pngFile = fullfile(inputDir, fileList(k).name);
    imRGB = imread(pngFile); 


    %figure(1), imshow(imRGB(200:900, 1750:2450,:))
    %figure(2), imshow(imRGB)
    

    smoothedLAB = rgb2lab(imRGB); 
 
    smoothedLAB(:,:,1) = imdiffusefilt(smoothedLAB(:,:,1), 'ConductionMethod', 'exponential', 'GradientThreshold', DegreeOfSmoothing, 'NumberOfIterations', numIterations);
    smoothedRGB = lab2rgb(smoothedLAB,"Out","uint8");

    if k <= 9
        outString = ['000', num2str(k)]
    elseif k <= 99
        outString = ['00', num2str(k)] 
    elseif k <= 999
        outString = ['0', num2str(k)]
    else 
        outString = num2str(k) 
    end

    % Save the image as a PNG file
    %imwrite(smoothedRGB, fullfile(outputDir, ['/diffusionFilteredImagesL_1D_1D/', outString, '_diffusion_DoS_', num2str(DegreeOfSmoothing), '_iterations_', num2str(numIterations), '_decay_exp.png'])); 
      
    imwrite(smoothedRGB, fullfile(outputDir, [outString, '_diffusion_DoS_', num2str(DegreeOfSmoothing), '_iterations_', num2str(numIterations), '_decay_exp.png']));  
    fprintf("%i of %i numImages\n ", k, numImages);
end

