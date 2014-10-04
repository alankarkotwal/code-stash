function outputImage = linearContrastStretching(origImage)

origImageSize = size(origImage);

outputImage = double(zeros(origImageSize(1),origImageSize(2)));

minPixelValue = double(min(min(origImage)));
maxPixelValue = double(max(max(origImage)));

for i = 1:(origImageSize(1))
    for j = 1:(origImageSize(2))
        outputImage(i,j) = (double(origImage(i,j)) - minPixelValue)/(maxPixelValue - minPixelValue)*255;
    end
end