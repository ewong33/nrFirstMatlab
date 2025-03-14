clear;

tic;

inputDir = '/Users/ewong3/Documents/MATLAB/D169_400_17Lux_7ft_17ft'; 
outputDir = inputDir; 

fileList = dir(fullfile(inputDir, '*.png'));
pngFile = fullfile(inputDir, fileList(1).name);
imRGB = imread(pngFile); 
imLAB = rgb2lab(imRGB); 

[w, h, c] = size(imRGB);
numImages = length(fileList); 

patch = imLAB(200:900, 1750:2450);
%patchSq = patch .^ 2;
%edist = sqrt(sum(patchSq,3));
%patchVar = std2(edist).^2;
%multFactor = 1; 
%DegreeOfSmoothing = multFactor * patchVar;

patchSq = patch.^2;
edist = sqrt(sum(patchSq,3));
patchSigma = sqrt(var(edist(:)));
searchFactor = 3;
DegreeOfSmoothing = 2 * patchSigma;


for k = 1:numImages
    pngFile = fullfile(inputDir, fileList(k).name);
    imRGB = imread(pngFile); 
    imLAB = rgb2lab(imRGB); 

    denoisedLAB = imnlmfilt(imLAB,'DegreeOfSmoothing',DegreeOfSmoothing, 'SearchWindowSize', searchFactor);
    denoisedRGB = lab2rgb(denoisedLAB,"Out","uint8");

    imwrite(denoisedRGB, fullfile(outputDir, ['/nonLocalMeansFilteredImagesLAB_2_21_3D/' num2str(k), '_nlmfilt_DoS_', num2str(DegreeOfSmoothing), '_Window_5_Search_', num2str(searchFactor), '.png'])); 

    fprintf("%i of %i numImages\n ", k, numImages);
end

disp('Conversion complete.');

elapsedTime = toc;
fprintf('Elapsed time: %.2f seconds\n', elapsedTime);