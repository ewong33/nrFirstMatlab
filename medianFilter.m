clear;

inputDir = '/Users/ewong3/Documents/MATLAB/D169_400_17Lux_7ft_17ft';  
outputDir = inputDir;  

fileList = dir(fullfile(inputDir, '*.png'));
pngFile = fullfile(inputDir, fileList(1).name);
imageData = imread(pngFile); 

[w, h, c] = size(imageData);
filteredImage = im2uint8(zeros(w, h, c));

r = imageData(:,:,1);
g = imageData(:,:,2);
b = imageData(:,:,3);

gtPngFile = [inputDir, '/medianFilteredImages/groundTruth.png'];
groundTruthData = imread(gtPngFile);

numIterations = 10;
filterDim = 3;

varOut = zeros(1,numIterations); 
psnrOut = zeros(1, numIterations); 

for k = 1:numIterations
    r = medfilt2(r, [filterDim filterDim]); 
    g = medfilt2(g, [filterDim filterDim]); 
    b = medfilt2(b, [filterDim filterDim]);

    filteredImage(:,:,1) = r;
    filteredImage(:,:,2) = g;
    filteredImage(:,:,3) = b; 

    imwrite(filteredImage, fullfile(outputDir, ['/medianFilteredImages/' num2str(k), '_medfilt' num2str(filterDim) '.png'])); 

    cropImage = g(200:900, 1750:2450); 
    varOut(k) = var(im2double(cropImage(:)));

    diffSq = (groundTruthData(:,:,2) - g) .^ 2; 
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

figure(1), subplot(2,1,1), plot(varOut,strPoint), xlabel('iteration'), ylabel('MSE'), title('Median Filter [3x3=b, 5x5=g]: Patch Variance vs Iterations'), hold on
plot(varOut,strLine), grid on, hold on 

subplot(2,1,2), plot(psnrOut, strPoint), xlabel('iteration'), ylabel('PSNR[db]'), title('Median Filter [3x3=b, 5x5=g]: PSNR vs Iterations'), hold on 
plot(psnrOut, strLine), grid on, hold on 

saveas(gcf, fullfile(outputDir, ['/medianFilteredImages/medianFilter.png'])); % Save the current figure as a PNG file
disp(['Plot saved']);
