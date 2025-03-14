clear;

tic;

%inputDir = '/Users/ewong3/Documents/MATLAB/D169_400_17Lux_7ft_17ft';  
inputDir = '/Users/ewong3/Documents/MATLAB/Camera/30_VID_20241030_150912/labSequenceMotion';
outputDir = inputDir; 
 
fileList = dir(fullfile(inputDir, '*.png'));
pngFile = fullfile(inputDir, fileList(1).name);
imRGB = imread(pngFile); 
imLAB = rgb2lab(imRGB); 
smoothedLAB = imLAB;

[w, h, c] = size(imRGB);
numImages = length(fileList);

patch = imLAB(200:900, 1750:2450);
%patch = imLAB(200:1300, 1350:3150);

patchSq = patch .^ 2;
edist = sqrt(sum(patchSq,3));
patchVar = std2(edist).^2;
multFactor = 2; 
DegreeOfSmoothing = multFactor * patchVar;
radius = 6; 


%figure(10), imagesc(patch, [0, 255]), colormap('gray')
%pause

for k = 1:numImages
    pngFile = fullfile(inputDir, fileList(k).name);
    imRGB = imread(pngFile); 
    imLAB = rgb2lab(imRGB); 
    smoothedLAB = imLAB; 
    smoothedLAB(:,:,1) = imbilatfilt(imLAB(:,:,1), DegreeOfSmoothing, radius);

    smoothedRGB = lab2rgb(smoothedLAB,"Out","uint8");

    % Save the image as a PNG file
    imwrite(smoothedRGB, fullfile(outputDir, ['/bilateralFilteredImagesL_mult2_r6_1D/' num2str(k), '_bilateral_DoS_', num2str(DegreeOfSmoothing), '_Sigma_', num2str(radius), '.png'])); 


    fprintf("%i of %i numImages\n ", k, numImages);
end

disp('Conversion complete.');

elapsedTime = toc;
fprintf('Elapsed time: %.2f seconds\n', elapsedTime);