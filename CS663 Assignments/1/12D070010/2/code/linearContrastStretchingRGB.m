function outputImage = linearContrastStretchingRGB(origImage)

origImageR = origImage(:,:,1);
origImageG = origImage(:,:,2);
origImageB = origImage(:,:,3);

outputImageR = linearContrastStretching(origImageR);
outputImageG = linearContrastStretching(origImageG);
outputImageB = linearContrastStretching(origImageB);

outputImage = cat(3,outputImageR,outputImageG,outputImageB);
outputImage = uint8(outputImage); % Check this