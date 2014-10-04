function enlargedImage = nearestNeighborInterpolation(origImage)

origImageSize = size(origImage);

enlargedImageSize = [3*origImageSize(1)-2 2*origImageSize(2)-1];
enlargedImage = uint8(zeros(enlargedImageSize(1),enlargedImageSize(2)));

for i = 1:(enlargedImageSize(1))
    for j = 1:(enlargedImageSize(2))
        xCoord = (i-1)*(origImageSize(1)-1)/(3*origImageSize(1)-3)+1;
        yCoord = (j-1)*(origImageSize(2)-1)/(2*origImageSize(2)-2)+1;
        xCoord = round(xCoord);
        yCoord = round(yCoord);
        enlargedImage(i,j) = origImage(xCoord,yCoord);
    end
end