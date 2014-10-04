function outputImage = bilateralFilter(origImage, sdSpace, sdIntensity, windowSize)

[xDist,yDist] = meshgrid(-windowSize:windowSize,-windowSize:windowSize);
gaussianSpaceKernel = exp(-(xDist.^2+yDist.^2)/(2*sdSpace^2));

origImageSize = size(origImage);
outputImage = zeros(origImageSize);

for i = 1:origImageSize(1)
    for j = 1:origImageSize(2)
        xMin = max(i-windowSize,1);
        xMax = min(i+windowSize,origImageSize(1));
        yMin = max(j-windowSize,1);
        yMax = min(j+windowSize,origImageSize(2));
        window = origImage(xMin:xMax,yMin:yMax);
        
        gaussianIntensityKernel = exp(-(window-origImage(i,j)).^2/(2*sdIntensity^2));
        convolvedMatrix = gaussianIntensityKernel.*gaussianSpaceKernel((xMin:xMax)-i+windowSize+1,(yMin:yMax)-j+windowSize+1);
        outputImage(i,j) = sum(convolvedMatrix(:).*window(:))/sum(convolvedMatrix(:));
    end
end