function outputImage = histogramEqualisationRGB(origImage)

origImageR = origImage(:,:,1);
origImageG = origImage(:,:,2);
origImageB = origImage(:,:,3);

outputImageR = histogramEqualisation(origImageR);
outputImageG = histogramEqualisation(origImageG);
outputImageB = histogramEqualisation(origImageB);

outputImage = cat(3,outputImageR,outputImageG,outputImageB);
outputImage = uint8(outputImage); % Check this