clear;

%inputDir = '/Users/ewong3/Documents/MATLAB/D169_400_17LuxP30_7ft_17ft/compareMethods';  
inputDir = '/Users/ewong3/Documents/MATLAB/D169_400_17Lux_7ft_17ft/compareMethods';
%inputDir = '/Users/ewong3/Documents/MATLAB/D169_400_17LuxP30_7ft_17ft/compareMethods'; 

outputDir = inputDir; 

imageFiles = dir(fullfile(inputDir, '*.png'));

imageOut = im2uint8(zeros(2400, 2400, 3));
imageOutExtreme = im2uint8(zeros(2400, 2400, 3)); 
%imageOutWall = im2uint8(zeros(1500, 1500, 3));
imageOutWall = im2uint8(zeros(300, 300, 3)); 
%imageOutWallExtreme = im2uint8(zeros(1500, 1500, 3)); 
imageOutWallExtreme = im2uint8(zeros(300, 300, 3)); 
imageOutText = im2uint8(zeros(300, 300, 3));
imageOutTextExtreme = im2uint8(zeros(300, 300, 3)); 
imageOutTextExecutive = im2uint8(zeros(200, 200, 3));

imageOutText2 = im2uint8(zeros(300, 300, 3));
imageOutText2Extreme = im2uint8(zeros(300, 300, 3));
imageOutChart = im2uint8(zeros(300,300, 3)); 
imageOutChartExtreme = im2uint8(zeros(300, 300, 3)); 
imageOutChartExecutive = im2uint8(zeros(200, 200, 3)); 

imageOutFace = im2uint8(zeros(900,900, 3));
imageOutFaceExtreme = im2uint8(zeros(300, 300, 3)); 
imageOutFaceExecutive = im2uint8(zeros(600, 600, 3));



for k = 1:length(imageFiles)
    imagePath = fullfile(inputDir, imageFiles(k).name);

    imageIn = imread(imagePath);

    imageOutCrop = imageIn(601:1400,1101:1900,:);
    imwrite(imageOutCrop, fullfile(outputDir, ['/crop/' num2str(k), '_crop.png'])); 

    %imageOutCropWall = imageIn(201:700, 1501:2000,:);
    imageOutCropWall = imageIn(601:700, 1801:1900,:);
    %imageOutCropWall = imageIn(1301:1400, 1696:1795,:);
    imwrite(imageOutCropWall, fullfile(outputDir, ['/cropWall/', num2str(k), '_cropWall.png']));

    imageOutCropText = imageIn(1101:1200, 1601:1700,:);
    imwrite(imageOutCropText, fullfile(outputDir, ['/cropText/', num2str(k), '_cropText.png']));

    imageOutCropText2 = imageIn(1611:1710, 526:625,:);
    imwrite(imageOutCropText2, fullfile(outputDir, ['/cropText2/', num2str(k), '_cropText2.png']));

    imageOutCropChart = imageIn(1421:1520, 1696:1795,:);
    imwrite(imageOutCropChart, fullfile(outputDir, ['/cropChart/', num2str(k), '_cropChart.png']));

    imageOutCropFace = imageIn(751:1050, 1401:1700,:);
    imwrite(imageOutCropFace, fullfile(outputDir, ['/cropFace/', num2str(k), '_cropFace.png']));

    if k == 1
        imageOut(1:800, 1:800, :) = imageOutCrop;
        %imageOutWall(1:500, 1:500, :) = imageOutCropWall;
        imageOutWall(1:100, 1:100, :) = imageOutCropWall;
        imageOutText(1:100, 1:100, :) = imageOutCropText;
        imageOutTextExecutive(1:100, 101:200, :) = imageOutCropText; 

        imageOutText2(1:100, 1:100, :) = imageOutCropText2; 
        imageOutChart(1:100, 1:100, :) = imageOutCropChart;
        imageOutChartExecutive(1:100, 101:200, :) = imageOutCropChart; 

        imageOutFace(1:300, 1:300, :) = imageOutCropFace; 
        imageOutFaceExecutive(1:300, 1:300, :) = imageOutCropFace;

    elseif k == 2
        imageOut(1:800, 801:1600, :) = imageOutCrop;
        %imageOutWall(1:500, 501:1000, :) = imageOutCropWall;
        imageOutWall(1:100, 101:200, :) = imageOutCropWall;
        imageOutText(1:100, 101:200, :) = imageOutCropText;
        imageOutText2(1:100, 101:200, :) = imageOutCropText2;
        imageOutChart(1:100, 101:200, :) = imageOutCropChart;
        imageOutFace(1:300, 301:600, :) = imageOutCropFace;
    elseif k == 3
        imageOut(1:800, 1601:2400, :) = imageOutCrop;
        %imageOutWall(1:500, 1001:1500, :) = imageOutCropWall;
        imageOutWall(1:100, 201:300, :) = imageOutCropWall;
        imageOutText(1:100, 201:300, :) = imageOutCropText;
        imageOutTextExecutive(101:200, 1:100, :) = imageOutCropText;

        imageOutText2(1:100, 201:300, :) = imageOutCropText2;
        imageOutChart(1:100, 201:300, :) = imageOutCropChart;
        imageOutChartExecutive(101:200, 1:100, :) = imageOutCropChart; 

        imageOutFace(1:300, 601:900, :) = imageOutCropFace;
    elseif k == 4
        imageOut(801:1600, 1:800, :) = imageOutCrop;
        %imageOutWall(501:1000, 1:500, :) = imageOutCropWall;
        imageOutWall(101:200, 1:100, :) = imageOutCropWall;
        imageOutText(101:200, 1:100, :) = imageOutCropText;
        imageOutText2(101:200, 1:100, :) = imageOutCropText2;
        imageOutChart(101:200, 1:100, :) = imageOutCropChart;
        imageOutFace(301:600, 1:300, :) = imageOutCropFace;
    elseif k == 5
        imageOut(801:1600, 801:1600, :) = imageOutCrop;
        %imageOutWall(501:1000, 501:1000, :) = imageOutCropWall;
        imageOutWall(101:200, 101:200, :) = imageOutCropWall;
        imageOutText(101:200, 101:200, :) = imageOutCropText;
        imageOutText2(101:200, 101:200, :) = imageOutCropText2;
        imageOutChart(101:200, 101:200, :) = imageOutCropChart;
        imageOutFace(301:600, 301:600, :) = imageOutCropFace;
    elseif k == 6 
        imageOut(801:1600, 1601:2400, :) = imageOutCrop;
        %imageOutWall(501:1000, 1001:1500, :) = imageOutCropWall;
        imageOutWall(101:200, 201:300, :) = imageOutCropWall;
        imageOutText(101:200, 201:300, :) = imageOutCropText;
        imageOutText2(101:200, 201:300, :) = imageOutCropText2;
        imageOutChart(101:200, 201:300, :) = imageOutCropChart;
        imageOutChartExecutive(1:100, 1:100, :) = imageOutCropChart;

        imageOutFace(301:600, 601:900, :) = imageOutCropFace;
    elseif k == 7
        imageOut(1601:2400, 1:800, :) = imageOutCrop;
        %imageOutWall(1001:1500, 1:500, :) = imageOutCropWall;
        imageOutWall(201:300, 1:100, :) = imageOutCropWall;
        imageOutText(201:300, 1:100, :) = imageOutCropText;
        imageOutTextExecutive(1:100, 1: 100, :) = imageOutCropText;

        imageOutText2(201:300, 1:100, :) = imageOutCropText2;
        imageOutChart(201:300, 1:100, :) = imageOutCropChart;
        imageOutChartExecutive(1:100, 1:100, :) = imageOutCropChart; 

        imageOutFace(601:900, 1:300, :) = imageOutCropFace;
        imageOutFace(1:300, 301:600, :) = imageOutCropFace; 
    elseif k == 8
        imageOut(1601:2400, 801:1600, :) = imageOutCrop;
        %imageOutWall(1001:1500, 501:1000, :) = imageOutCropWall;
        imageOutWall(201:300, 101:200, :) = imageOutCropWall;
        imageOutText(201:300, 101:200, :) = imageOutCropText;
        imageOutText2(201:300, 101:200, :) = imageOutCropText2;
        imageOutChart(201:300, 101:200, :) = imageOutCropChart;
        imageOutFace(601:900, 301:600, :) = imageOutCropFace;
    elseif k == 9
        imageOut(1601:2400, 1601:2400, :) = imageOutCrop;
        %imageOutWall(1001:1500, 1001:1500, :) = imageOutCropWall;
        imageOutWall(201:300, 201:300, :) = imageOutCropWall;
        imageOutText(201:300, 201:300, :) = imageOutCropText;
        imageOutTextExecutive(101:200, 101:200, :) = imageOutCropText;

        imageOutText2(201:300, 201:300, :) = imageOutCropText2;
        imageOutChart(201:300, 201:300, :) = imageOutCropChart;
        imageOutChartExecutive(101:200, 101:200, :) = imageOutCropChart;

        imageOutFace(601:900, 601:900, :) = imageOutCropFace;
        imageOutFaceExecutive(301:600, 301:600, :) = imageOutCropFace;  

        imageOutExtreme(1601:2400, 1601:2400, :) = imageOutCrop;
        %imageOutWallExtreme(1001:1500, 1001:1500, :) = imageOutCropWall;
        imageOutWallExtreme(201:300, 201:300, :) = imageOutCropWall;
        imageOutTextExtreme(201:300, 201:300, :) = imageOutCropText;
        imageOutText2Extreme(201:300, 201:300, :) = imageOutCropText2;
        imageOutChartExtreme(201:300, 201:300, :) = imageOutCropChart;
        imageOutFaceExtreme(601:900, 601:900, :) = imageOutCropFace;
    elseif k == 10
        imageOutExtreme(1601:2400, 801:1600, :) = imageOutCrop;
        %imageOutWallExtreme(1001:1500, 501:1000, :) = imageOutCropWall;
        imageOutWallExtreme(201:300, 101:200, :) = imageOutCropWall;
        imageOutTextExtreme(201:300, 101:200, :) = imageOutCropText;
        imageOutText2Extreme(201:300, 101:200, :) = imageOutCropText2;
        imageOutChartExtreme(201:300, 101:200, :) = imageOutCropChart;

        imageOutFaceExtreme(601:900, 301:600, :) = imageOutCropFace;
        imageOutFaceExecutive(301:600, 1:300, :) = imageOutCropFace; 
    end   
end

%figure(1), image(imageOut)
%figure(2), image(imageOutWall)
%figure(3), image(imageOutText)
%figure(4), image(imageOutText2)
%figure(5), image(imageOutChart)
%figure(6), image(imageOutFace)

%figure(7), image(imageOutExtreme)
%figure(8), image(imageOutWallExtreme)
%figure(9), image(imageOutTextExtreme)
%figure(10), image(imageOutText2Extreme)
%figure(11), image(imageOutChartExtreme)
%figure(12), image(imageOutFaceExtreme)

figure(106), image(imageOutFaceExecutive)
figure(107), image(imageOutChartExecutive)
figure(108), image(imageOutTextExecutive)


%imwrite(imageOut, fullfile(outputDir, ['/crop/fullCropMontage.png'])); 
%imwrite(imageOutWall, fullfile(outputDir, ['/cropWall/fullCropMontage.png'])); 
%imwrite(imageOutText, fullfile(outputDir, ['/cropText/fullCropMontage.png'])); 
%imwrite(imageOutText2, fullfile(outputDir, ['/cropText2/fullCropMontage.png'])); 
%imwrite(imageOutChart, fullfile(outputDir, ['/cropChart/fullCropMontage.png'])); 
%imwrite(imageOutFace, fullfile(outputDir, ['/cropFace/fullCropMontage.png'])); 

imwrite(imageOutFaceExecutive, fullfile(outputDir, ['/cropFace/executiveMontage.png']))
imwrite(imageOutChartExecutive, fullfile(outputDir, ['/cropChart/executiveMontage.png']))
imwrite(imageOutTextExecutive, fullfile(outputDir, ['/cropText/executiveMontage.png']))

%imwrite(imageOutExtreme, fullfile(outputDir, ['/crop/fullCropMontageExtreme.png'])); 
%imwrite(imageOutWallExtreme, fullfile(outputDir, ['/cropWall/fullCropMontageExtreme.png'])); 
%imwrite(imageOutTextExtreme, fullfile(outputDir, ['/cropText/fullCropMontageExtreme.png'])); 
%imwrite(imageOutText2Extreme, fullfile(outputDir, ['/cropText2/fullCropMontageExtreme.png'])); 
%imwrite(imageOutChartExtreme, fullfile(outputDir, ['/cropChart/fullCropMontageExtreme.png'])); 
%imwrite(imageOutFaceExtreme, fullfile(outputDir, ['/cropFace/fullCropMontageExtreme.png'])); 