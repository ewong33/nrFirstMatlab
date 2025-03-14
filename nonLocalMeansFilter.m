clear;

inputDir = '/Users/ewong3/Documents/MATLAB/D169_400_17Lux_7ft_17ft'; 
outputDir = inputDir;  

fileList = dir(fullfile(inputDir, '*.png'));
pngFile = fullfile(inputDir, fileList(1).name);
imRGB = imread(pngFile); 
imLAB = rgb2lab(imRGB); 

patch = imLAB(200:900, 1750:2450);
%patchSq = patch .^ 2;
%edist = sqrt(sum(patchSq,3));
%patchVar = std2(edist).^2;
%multFactor = 1; 
%DegreeOfSmoothing = multFactor * patchVar;

patchSq = patch.^2;
edist = sqrt(sum(patchSq,3));
patchSigma = sqrt(var(edist(:)));
searchFactor = 3; %11;

[w, h, c] = size(imRGB);

gtPngFile = [inputDir, '/nonLocalMeansFilteredImages/groundTruth.png'];
imGTD = imread(gtPngFile);
imGTDLAB = rgb2lab(imGTD); 


varOut = zeros(1,numIterations); 
psnrOut = zeros(1, numIterations); 


for k = 1:numIterations
    DegreeOfSmoothing = k * patchSigma;

    denoisedLAB = imnlmfilt(imLAB,'DegreeOfSmoothing',DegreeOfSmoothing, 'SearchWindowSize', searchFactor);
    denoisedRGB = lab2rgb(denoisedLAB,"Out","uint8");

    % Save the image as a PNG file
    imwrite(denoisedRGB, fullfile(outputDir, ['/nonLocalMeansFilteredImages/' num2str(k), '_nlmfilt_', num2str(DegreeOfSmoothing), '_Window5_Search', num2str(searchFactor), '.png'])); 

    cropImage = denoisedLAB(200:900, 1750:2450, 1); 
    varOut(k) = var(im2double(cropImage(:)));

    diffSq = (imGTDLAB(:,:,1) - denoisedLAB(:,:,1)) .^ 2; 
    diffSqCenter = diffSq(numIterations + 1:w - numIterations, numIterations + 1: h - numIterations); 

    numTerms = (w - (2 * numIterations)) * (h - (2 * numIterations));
    MSE =  sum(diffSqCenter(:)) / numTerms;
    psnrOut(k) = 10 * log10((255.0 * 255.0) / MSE);

    fprintf("%i of %i numIterations\n ", k, numIterations);
end

disp('Conversion complete.');


if searchFactor == 3 %11
    strPoint = 'b*';
    strLine = 'b';
elseif searchFactor == 4 %15
    strPoint = 'g*';
    strLine = 'g';
elseif searchFactor == 5 %21
    strPoint = 'r*';
    strLine = 'r';
end

figure(2), subplot(2,1,1), plot(varOut,strPoint), xlabel('Smoothing (k value)'), ylabel('MSE'), title(['NonLocalMeans Filter: sigma=[' num2str(patchSigma) '], Search:11=b, Search:15=g, Search:21=r: Patch Variance vs Smoothing (k*sigma)']), hold on
plot(varOut,strLine), grid on, hold on 

subplot(2,1,2), plot(psnrOut, strPoint), xlabel('Smoothing (k value)'), ylabel('PSNR[db]'), title(['NonLocalMeans Filter: sigma=[' num2str(patchSigma) '], Search:11=b, Search:15=g, Search21=r: PSNR vs Smoothing (k*sigma)']), hold on 
plot(psnrOut, strLine), grid on, hold on 

saveas(gcf, fullfile(outputDir, ['/nonLocalMeansFilteredImages/nonLocalMeansFilter.png'])); % Save the current figure as a PNG file
disp(['Plot saved']);