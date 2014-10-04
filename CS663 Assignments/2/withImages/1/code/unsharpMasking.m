function outputImage = unsharpMasking(origImage, sd, scale, winSizeX, winSizeY)

filter = fspecial('gaussian', [winSizeX winSizeY], sd);
blurredImage = imfilter(origImage, filter, 'same');

invertedImage = imcomplement(blurredImage);
scaledImage = scale*invertedImage;

outputImage = origImage - scaledImage;