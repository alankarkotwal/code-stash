function outputImage = clAdaptiveHistogramEqualisationRGB(origImage, windowSize, clipValue)

origImageR = origImage(:,:,1);
origImageG = origImage(:,:,2);
origImageB = origImage(:,:,3);

outputImageR = clAdaptiveHistogramEqualisation(origImageR, windowSize, clipValue);
outputImageG = clAdaptiveHistogramEqualisation(origImageG, windowSize, clipValue);
outputImageB = clAdaptiveHistogramEqualisation(origImageB, windowSize, clipValue);

outputImage = cat(3,outputImageR,outputImageG,outputImageB);
outputImage = uint8(outputImage); % Check this