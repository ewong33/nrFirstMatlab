clear;

tic;

%inputDir = '/Users/ewong3/Documents/MATLAB/D169_400_17Lux_7ft_17ft'; 
inputDir = '/Users/ewong3/Documents/MATLAB/Camera/30_VID_20241030_150912/labSequenceMotion';
outputDir = inputDir; 

fileList = dir(fullfile(inputDir, '*.png'));
pngFile = fullfile(inputDir, fileList(1).name);

imRGB = imread(pngFile); 
[w, h, c] = size(imRGB);
numImages = length(fileList);

vector5 = zeros(w, h, 5); 
vectorL = zeros(w, h, numImages); 

for k = 1:numImages
    pngFile = fullfile(inputDir, fileList(k).name);
    imRGB = imread(pngFile); 
    imLAB = rgb2lab(imRGB); 
    vectorL(:,:,k) = imLAB(:,:,1); 

    fprintf("%i of %i numImages\n ", k, numImages);
end


filterDim = 5;


for k = 3:numImages - 2
    pngFile = fullfile(inputDir, fileList(k).name)
    imRGB = imread(pngFile); 
    imLAB = rgb2lab(imRGB); 
    vector5(:,:,1) = vectorL(:,:,k-2); 
    vector5(:,:,2) = vectorL(:,:,k-1); 
    vector5(:,:,3) = vectorL(:,:,k);
    vector5(:,:,4) = vectorL(:,:,k+1); 
    vector5(:,:,5) = vectorL(:,:,k+2);

    temp = medfilt3(vector5, [filterDim filterDim filterDim]); 
    
    %2 and 3
    imLAB(:,:,1) = temp(:,:,3); 
    medianImage = lab2rgb(imLAB,"Out","uint8");

    if k <= 9
        outString = ['000', num2str(k)]
    elseif k <= 99
        outString = ['00', num2str(k)] 
    elseif k <= 999
        outString = ['0', num2str(k)]
    else 
        outString = num2str(k) 
    end

    imwrite(medianImage, fullfile(outputDir, ['/medianFilteredImagesL_5/' outString, '_medfilt_', num2str(filterDim), '.png'])); 

    fprintf("%i of %i numImages\n ", k, numImages);
end

disp('Conversion complete.');

elapsedTime = toc;
fprintf('Elapsed time: %.2f seconds\n', elapsedTime);