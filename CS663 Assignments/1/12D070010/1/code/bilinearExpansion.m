function enlargedImage = bilinearExpansion(origImage)

origImageSize = double(size(origImage));

enlargedImageSize = [3*origImageSize(1)-2 2*origImageSize(2)-1];
enlargedImage = double(ones(enlargedImageSize(1),enlargedImageSize(2)));

for i = 1:(enlargedImageSize(1))
    for j = 1:(enlargedImageSize(2))
        xCoord = double(i-1)*(origImageSize(1)-1)/(3*origImageSize(1)-3)+1.0;
        yCoord = double(j-1)*(origImageSize(2)-1)/(2*origImageSize(2)-2)+1.0;
        xMin = floor(xCoord);
        xMax = ceil(xCoord);
        yMin = floor(yCoord);
        yMax = ceil(yCoord);
        area = (xMax-xMin)*(yMax-yMin);
        enlargedImage(i,j) = (origImage(xMin,yMin)*(xMax-xCoord)*(yMax-yCoord)+origImage(xMax,yMin)*(xCoord-xMin)*(yMax-yCoord)+origImage(xMin,yMax)*(xMax-xCoord)*(yCoord-yMin)+origImage(xMax,yMax)*(xCoord-xMin)*(yCoord-yMin))/area;
    end
end