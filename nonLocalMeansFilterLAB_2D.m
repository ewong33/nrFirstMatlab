clear;

tic;

%inputDir = '/Users/ewong3/Documents/MATLAB/D169_400_17Lux_7ft_17ft';  
%inputDir = '/Users/ewong3/Documents/MATLAB/Camera/30_VID_20241030_150912/labSequenceMotion';
inputDir = '/Users/ewong3/Documents/MATLAB/30_VID_20241030_151436';
inputDir = '/Users/ewong3/Documents/MATLAB/30_VID_20241030_151436/temporalHalf';
inputDir = '/Users/ewong3/Documents/MATLAB/30_VID_20241030_151436/diffusionFilteredImagesL_1D_1D';
inputDir = '/Users/ewong3/Documents/MATLAB/VID_20241106_120250';

%inputDir = '/Users/ewong3/Documents/MATLAB/homeScene/400_noNRPerson_VID_20241029_142546_Crop/homeSceneMotion';
outputDir = inputDir;  
outputDir = '/Users/ewong3/Documents/MATLAB/30_VID_20241030_151436/temporalHalfAndNLM'; 
outputDir = '/Users/ewong3/Documents/MATLAB/30_VID_20241030_151436/diffusionAndNLM'; 
outputDir = '/Users/ewong3/Documents/MATLAB/VID_20241106_120250/nlm';

% Get a list of all PNG files in the directory
fileList = dir(fullfile(inputDir, '*.png'));
pngFile = fullfile(inputDir, fileList(1).name);
imRGB = imread(pngFile); 
imLAB = rgb2lab(imRGB); 

[w, h, c] = size(imRGB);
numImages = length(fileList); 

patch = imLAB(200:900, 1750:2450);
patch = imLAB(100:500, 1300:2000); 

%patch = imLAB(1600:2100, 3300:3800);
%patchSq = patch .^ 2;
%edist = sqrt(sum(patchSq,3));
%patchVar = std2(edist).^2;
%multFactor = 1; 
%DegreeOfSmoothing = multFactor * patchVar;

patchSq = patch.^2;
edist = sqrt(sum(patchSq,3));
patchSigma = sqrt(var(edist(:)));
searchFactor = 11;
DegreeOfSmoothing = 2 * patchSigma;
%DegreeOfSmoothing = 5 * patchSigma;


for k = 1:numImages
    pngFile = fullfile(inputDir, fileList(k).name);
    imRGB = imread(pngFile); 
    imLAB = rgb2lab(imRGB); 

    denoisedLAB = imnlmfilt(imLAB,'DegreeOfSmoothing',DegreeOfSmoothing, 'SearchWindowSize', searchFactor);
    denoisedRGB = lab2rgb(denoisedLAB,"Out","uint8");

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
    %imwrite(denoisedRGB, fullfile(outputDir, ['/nonLocalMeansFilteredImagesLAB_1D/', outString, '_nlmfilt_multFactor_2_DoS_', num2str(DegreeOfSmoothing), '_Window_5_Search_', num2str(searchFactor), '.png']));                           
    imwrite(denoisedRGB, fullfile(outputDir, [outString, '_nlmfilt_multFactor_2_DoS_', num2str(DegreeOfSmoothing), '_Window_5_Search_', num2str(searchFactor), '.png'])); 
    
    fprintf("%i of %i numImages\n ", k, numImages);
end

disp('Conversion complete.');

elapsedTime = toc;
fprintf('Elapsed time: %.2f seconds\n', elapsedTime);