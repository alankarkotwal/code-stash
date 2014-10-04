storedStruct1 = load('images/barbara.mat');
q21OrigImage = storedStruct1.imageOrig;

filter = fspecial('gaussian', [5 5], 0.66);
blurredImage = imfilter(q21OrigImage, filter, 'same');

shrunkImage = resizeImage(blurredImage,2);
shrunkImageSize = size(shrunkImage);

corruptMask = 0.05*max(max(shrunkImage))*randn(shrunkImageSize);
corruptImage = shrunkImage + corruptMask;

q21SharpenedImage = patchBasedFilter(corruptImage, 4, 9, 25);
save "patchFilteredImage.mat" q21SharpenedImage;
rmsd = sqrt(sum(sum((shrunkImage-q21SharpenedImage).^2))/(shrunkImageSize(1)*shrunkImageSize(2)));
disp(rmsd);

figure;
colormap(gray);
subplot(1,3,1), imshow(q21OrigImage/100);
colorbar;
axis on;
subplot(1,3,2), imshow(corruptImage/100);
colorbar;
axis on;
subplot(1,3,3), imshow(q21SharpenedImage/100);
colorbar;
axis on;