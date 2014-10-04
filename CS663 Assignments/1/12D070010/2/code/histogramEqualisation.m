function outputImage = histogramEqualisation(origImage)

imageCDF = getCDF(origImage);
origImageSize = size(origImage);

outputImage = double(zeros(origImageSize(1),origImageSize(2)));

for i = 1:(origImageSize(1))
    for j = 1:(origImageSize(2))
        if origImage(i,j) == 0
            outputImage(i,j) = 0;
        else
            outputImage(i,j) = imageCDF(origImage(i,j));
        end
    end
end

maximum = max(max(outputImage));

for i = 1:(origImageSize(1))
    for j = 1:(origImageSize(2))
        outputImage(i,j) = outputImage(i,j)*255.0/maximum;
    end
end
