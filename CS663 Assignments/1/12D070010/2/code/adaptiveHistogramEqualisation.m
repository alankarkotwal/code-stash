function outputImage = adaptiveHistogramEqualisation(origImage, windowSize)

origImageSize = size(origImage);

outputImage = double(zeros(origImageSize(1),origImageSize(2)));

for i = 1:(origImageSize(1))
    for j = 1:(origImageSize(2))
        windowMinX = max(1,i-windowSize);
        windowMinY = max(1,j-windowSize);
        windowMaxX = min(origImageSize(1),i+windowSize);
        windowMaxY = min(origImageSize(2),j+windowSize);
        window = origImage(windowMinX:windowMaxX,windowMinY:windowMaxY);
        
        windowCDF = getCDF(window);
        
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