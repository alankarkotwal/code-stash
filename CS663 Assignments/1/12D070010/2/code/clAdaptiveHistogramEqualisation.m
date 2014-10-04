function outputImage = clAdaptiveHistogramEqualisation(origImage, windowSize, clipValue)

origImageSize = size(origImage);
outputImage = zeros(origImageSize(1), origImageSize(2));

for i = 1:(origImageSize(1))
    for j = 1:(origImageSize(2))
        windowMinX = max(1,i-windowSize);
        windowMinY = max(1,j-windowSize);
        windowMaxX = min(origImageSize(1),i+windowSize);
        windowMaxY = min(origImageSize(2),j+windowSize);
        window = origImage(windowMinX:windowMaxX,windowMinY:windowMaxY);
        
        imageHistogram = imhist(window);
        excessMass = 0;
        histogramSize = size(imageHistogram);

        for k = 1:histogramSize(1)
            if imageHistogram(k) > clipValue
                excessMass = excessMass + imageHistogram(k) - clipValue;
                imageHistogram(k) = clipValue;
            end
        end

        excessMassPerBin = excessMass/histogramSize(1);

        for k = 1:size(imageHistogram(1))
            imageHistogram(k) = imageHistogram(k)+excessMassPerBin;
        end

        windowCDF = double(zeros(1,255));

        windowCDF(1) = imageHistogram(1);
        for k = 2:256
            windowCDF(k) = double(imageHistogram(k))+windowCDF(k-1);
        end

        if origImage(i,j) == 0
            outputImage(i,j) = 0;
        else
            outputImage(i,j) = windowCDF(origImage(i,j));
        end
    end
end

maximum = max(max(outputImage));

for i = 1:(origImageSize(1))
    for j = 1:(origImageSize(2))
        outputImage(i,j) = outputImage(i,j)*255.0/maximum;
    end
end
