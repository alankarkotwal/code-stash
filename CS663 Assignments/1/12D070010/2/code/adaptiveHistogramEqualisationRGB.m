function outputImage = adaptiveHistogramEqualisationRGB(origImage, windowSize)

origImageR = origImage(:,:,1);
origImageG = origImage(:,:,2);
origImageB = origImage(:,:,3);

outputImageR = adaptiveHistogramEqualisation(origImageR, windowSize);
outputImageG = adaptiveHistogramEqualisation(origImageG, windowSize);
outputImageB = adaptiveHistogramEqualisation(origImageB, windowSize);

outputImage = cat(3,outputImageR,outputImageG,outputImageB);
outputImage = uint8(outputImage); % Check this