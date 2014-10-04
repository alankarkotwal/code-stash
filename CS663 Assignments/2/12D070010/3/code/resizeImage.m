function shrunkImage = resizeImage(origImage, shrinkFactor)

origImageSize = size(origImage);

shrunkImageSize = [floor(origImageSize(1)/shrinkFactor) floor(origImageSize(2)/shrinkFactor)];
shrunkImage = zeros(shrunkImageSize(1),shrunkImageSize(2));

for i = 1:origImageSize(1)
    for j = 1:origImageSize(2)
        if rem(i,shrinkFactor) == 0 && rem(j,shrinkFactor) == 0
            shrunkImage(i/shrinkFactor,j/shrinkFactor) = origImage(i,j);
        end
    end
end
