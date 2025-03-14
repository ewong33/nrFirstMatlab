clear;

inputDir = '/Users/ewong3/Documents/MATLAB/D169_400_17Lux_7ft_17ft'; 
outputDir = inputDir;  

fileList = dir(fullfile(inputDir, '*.png'));
pngFile = fullfile(inputDir, fileList(1).name);
imRGB = imread(pngFile); 
imLAB = rgb2lab(imRGB); 
smoothedLAB = imLAB;

[w, h, c] = size(imRGB);

patch = imLAB(200:900, 1750:2450);
patchSq = patch .^ 2;
edist = sqrt(sum(patchSq,3));
patchVar = std2(edist).^2;
multFactor = 10; 
DegreeOfSmoothing = multFactor * patchVar;

gtPngFile = [inputDir, '/diffusionFilteredImagesL_git_2D/groundTruth.png'];
imGTD = imread(gtPngFile);
imGTDLAB = rgb2lab(imGTD); 

numIterations = 10;

varOut = zeros(1,numIterations); 
psnrOut = zeros(1, numIterations); 
ssimOut = zeros(1, numIterations); 


for k = 1:numIterations
    %smoothedLAB(:,:,1) = imdiffusefilt(imLAB(:,:,1), 'ConductionMethod', 'exponential', 'GradientThreshold', DegreeOfSmoothing, 'NumberOfIterations', k);
    smoothedLAB(:,:,1) = Explicit_PM_modified(imLAB(:,:,1), k, 0.250, DegreeOfSmoothing, 1, 0);

    ssimOut(k) = ssim(imGTDLAB(:,:,1), smoothedLAB(:,:,1));

    smoothedRGB = lab2rgb(smoothedLAB,"Out","uint8");

    % Save the image as a PNG file
    imwrite(smoothedRGB, fullfile(outputDir, ['/diffusionFilteredImagesL_git_2D/' num2str(k), '_diffusion_DoS_', num2str(DegreeOfSmoothing), '_decay_exp.png'])); 

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
    strLine = 'g';
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

saveas(gcf, fullfile(outputDir, ['/diffusionFilteredImagesL/diffusionFilterSqL.png'])); 
disp(['Plot saved']);