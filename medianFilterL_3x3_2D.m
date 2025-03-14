clear;

inputDir = '/Users/ewong3/Documents/MATLAB/D169_400_17Lux_7ft_17ft';  
outputDir = inputDir;  

fileList = dir(fullfile(inputDir, '*.png'));
pngFile1 = fullfile(inputDir, fileList(1).name);
imRGB1 = imread(pngFile1); 
imLAB1 = rgb2lab(imRGB1); 
pngFile2 = fullfile(inputDir, fileList(2).name);
imRGB2 = imread(pngFile2); 
imLAB2 = rgb2lab(imRGB2); 
pngFile3 = fullfile(inputDir, fileList(3).name);
imRGB3 = imread(pngFile3); 
imLAB3 = rgb2lab(imRGB3); 

filteredLAB = imLAB2; 

[w, h, c] = size(imRGB1);
vector3D = zeros(w, h, 3); 
vector3D(:,:,1) = imLAB1(:,:,1);
vector3D(:,:,2) = imLAB2(:,:,1); 
vector3D(:,:,3) = imLAB3(:,:,1); 

gtPngFile = [inputDir, '/medianFilteredImagesL/groundTruth.png'];
imGTD = imread(gtPngFile);
imGTDLAB = im2double(rgb2lab(imGTD)); 

numIterations = 10;
filterDim = 3;

varOut = zeros(1, numIterations); 
psnrOut = zeros(1, numIterations); 
ssimOut = zeros(1, numIterations); 


for k = 1:numIterations
    vector3D = medfilt3(vector3D, [filterDim filterDim filterDim]); 
    filteredLAB(:,:,1) = vector3D(:,:,2);

    ssimOut(k) = ssim(imGTDLAB(:,:,1), filteredLAB(:,:,1));

    medianImage = lab2rgb(filteredLAB,"Out","uint8");

    % Save the image as a PNG file
    imwrite(medianImage, fullfile(outputDir, ['/medianFilteredImagesL/' num2str(k), '_medfilt_', num2str(filterDim), '.png'])); 

    cropImage = filteredLAB(200:900, 1750:2450, 1); 
    varOut(k) = var(im2double(cropImage(:)));

    diffSq = (imGTDLAB(:,:,1) - filteredLAB(:,:,1)) .^ 2; 
    diffSqCenter = diffSq(numIterations + 1:w - numIterations, numIterations + 1: h - numIterations); 

    numTerms = (w - (2 * numIterations)) * (h - (2 * numIterations));
    MSE =  sum(diffSqCenter(:)) / numTerms;
    psnrOut(k) = 10 * log10((255.0 * 255.0) / MSE);

    fprintf("%i of %i numIterations\n ", k, numIterations);
end

disp('Conversion complete.');

if filterDim == 3
    strPoint = 'b*';
    strLine = 'b';
elseif filterDim == 5
    strPoint = 'g*';
    strLine = 'g';
end

figure(1), subplot(3,1,1), plot(varOut,strPoint), xlabel('iteration'), ylabel('MSE'), title('Median Filter [3x3=b, 5x5=g]: Patch Variance vs Iterations'), hold on
plot(varOut, strLine), grid on, hold on 

subplot(3,1,2), plot(psnrOut, strPoint), xlabel('iteration'), ylabel('PSNR [db]'), title('Median Filter [3x3=b, 5x5=g]: PSNR vs Iterations'), hold on 
plot(psnrOut, strLine), grid on, hold on 

subplot(3,1,3), plot(ssimOut, strPoint), xlabel('iteration'), ylabel('SSIM'), title('Median Filter [3x3=b, 5x5=g]: SSIM vs Iterations'), hold on 
plot(ssimOut, strLine), grid on, hold on 

saveas(gcf, fullfile(outputDir, ['/medianFilteredImagesL/medianFilterL.png'])); % Save the current figure as a PNG file
disp(['Plot saved']);