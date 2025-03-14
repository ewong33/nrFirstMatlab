clear;

tic;

inputDir = '/Users/ewong3/Documents/MATLAB/D169_400_17Lux_7ft_17ft'; 
outputDir = inputDir; 

fileList = dir(fullfile(inputDir, '*.png'));
pngFile = fullfile(inputDir, fileList(1).name);
imRGB = imread(pngFile); 
imLAB = rgb2lab(imRGB); 

[w, h, c] = size(imRGB);

patch = imLAB(200:900, 1750:2450);
%patch = imLAB(200:900, 1650:2350);

patchSq = patch .^ 2;
edist = sqrt(sum(patchSq,3));
patchVar = std2(edist).^2;
multFactor = 10; 
DegreeOfSmoothing = multFactor * patchVar;

gtPngFile = [inputDir, '/diffusionFilteredImagesL/groundTruth.png'];
imGTD = imread(gtPngFile);
imGTDLAB = rgb2lab(imGTD); 

numIterations = 20;

varOut = zeros(1,numIterations); 
psnrOut = zeros(1, numIterations); 
ssimOut = zeros(1, numIterations); 

vector3 = zeros(w, h, 3); 

pngFile1 = fullfile(inputDir, fileList(1).name);
imRGB1 = imread(pngFile1); 
imLAB1 = rgb2lab(imRGB1); 

pngFile2 = fullfile(inputDir, fileList(2).name);
imRGB2 = imread(pngFile2); 
imLAB2 = rgb2lab(imRGB2); 

pngFile3 = fullfile(inputDir, fileList(3).name);
imRGB3 = imread(pngFile3); 
imLAB3 = rgb2lab(imRGB3); 

vector3(:,:,1) = imLAB1(:,:,1);
vector3(:,:,2) = imLAB2(:,:,1);
vector3(:,:,3) = imLAB3(:,:,1); 

smoothedLAB = imLAB2; 

for k = 1:numIterations
    temp = Explicit_PM_modified_3D(vector3, k, (1.0 / 26.0), DegreeOfSmoothing, 1, 0); 
    smoothedLAB(:,:,1) = temp(:,:,2); 

    ssimOut(k) = ssim(imGTDLAB(:,:,1), smoothedLAB(:,:,1));

    smoothedRGB = lab2rgb(smoothedLAB,"Out","uint8");

    imwrite(smoothedRGB, fullfile(outputDir, ['/diffusionFilteredImagesL_git_3D/' num2str(k), '_diffusion_DoS_', num2str(DegreeOfSmoothing), '_decay_exp.png'])); 

    cropImage = smoothedLAB(200:900, 1750:2450, 1); 
    varOut(k) = var(im2double(cropImage(:)));

    diffSq = (imGTDLAB(:,:,1) - smoothedLAB(:,:,1)) .^ 2; 
    diffSqCenter = diffSq(numIterations + 1:w - numIterations, numIterations + 1: h - numIterations); 

    numTerms = (w - (2 * numIterations)) * (h - (2 * numIterations));
    MSE =  sum(diffSqCenter(:)) / numTerms;
    psnrOut(k) = 10 * log10((255.0 * 255.0) / MSE);

    fprintf("%i of %i numIterations\n ", k, numIterations);
end

disp('Conversion complete.');


if multFactor == 1
    strPoint = 'b*';
    strLine = 'b';
elseif multFactor == 2
    strPoint = 'g*';
    strLine = 'g:';
elseif multFactor == 10
    strPoint = 'r*';
    strLine = 'r';
end

figure(1), subplot(3,1,1), plot(varOut,strPoint), xlabel('Iterations'), ylabel('MSE'), title(['Diffusion Filter [' num2str(patchVar) '], multFactor:1=b, multFactor:2=g, multFactor:10=r, Sq, Patch Variance vs Iterations']), hold on
plot(varOut,strLine), grid on, hold on 

subplot(3,1,2), plot(psnrOut, strPoint), xlabel('Iterations'), ylabel('PSNR [db]'), title(['Diffusion Filter [' num2str(patchVar) '], multFactor:1=b, multFactor:2=g, multFactor:10=r, Sq, PSNR vs Iterations']), hold on 
plot(psnrOut, strLine), grid on, hold on 

subplot(3,1,3), plot(ssimOut, strPoint), xlabel('Iterations'), ylabel('SSIM'), title(['Diffusion Filter [' num2str(patchVar) '], multFactor:1=b, multFactor:2=g, multFactor:10=r, Sq, SSIM vs Iterations']), hold on 
plot(ssimOut, strLine), grid on, hold on 

saveas(gcf, fullfile(outputDir, ['/diffusionFilteredImagesL_git_3D/diffusionFilterSqL.png'])); 
disp(['Plot saved']);


elapsedTime = toc;
fprintf('Elapsed time: %.2f seconds\n', elapsedTime);