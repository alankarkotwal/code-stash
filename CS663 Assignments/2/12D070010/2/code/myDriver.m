storedStruct1 = load('images/barbara.mat');
q21OrigImage = storedStruct1.imageOrig;

q21OrigImageSize = size(q21OrigImage);
corruptMask = 0.05*max(max(q21OrigImage))*randn([q21OrigImageSize(1) q21OrigImageSize(2)]);
corruptImage = q21OrigImage + corruptMask;

q21SharpenedImage = bilateralFilter(corruptImage, 2, 9, 5);
save "bilateralFiltered.mat" q21SharpenedImage;  
rmsd = sqrt(sum(sum((q21OrigImage-q21SharpenedImage).^2))/(q21OrigImageSize(1)*q21OrigImageSize(2)));
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

% q21SharpenedImage = bilateralFilter(corruptImage, 0.9*2, 9, 5);
% rmsd = sqrt(sum(sum((q21OrigImage-q21SharpenedImage).^2))/(q21OrigImageSize(1)*q21OrigImageSize(2)));
% disp(rmsd);
% 
% q21SharpenedImage = bilateralFilter(corruptImage, 1.1*2, 9, 5);
% rmsd = sqrt(sum(sum((q21OrigImage-q21SharpenedImage).^2))/(q21OrigImageSize(1)*q21OrigImageSize(2)));
% disp(rmsd);
% 
% q21SharpenedImage = bilateralFilter(corruptImage, 2, 9*0.9, 5);
% rmsd = sqrt(sum(sum((q21OrigImage-q21SharpenedImage).^2))/(q21OrigImageSize(1)*q21OrigImageSize(2)));
% disp(rmsd);
% 
% q21SharpenedImage = bilateralFilter(corruptImage, 2, 9*1.1, 5);
% rmsd = sqrt(sum(sum((q21OrigImage-q21SharpenedImage).^2))/(q21OrigImageSize(1)*q21OrigImageSize(2)));
% disp(rmsd);
% 
% for i = 1:5
%     for j = 1:4
%         q21SharpenedImage = bilateralFilter(corruptImage, i, j, 5);
%         rmsd(i,j) = sqrt(sum(sum((q21OrigImage-q21SharpenedImage).^2))/(q21OrigImageSize(1)*q21OrigImageSize(2)));
%     end
% end
% 
% disp(min(min(rmsd)));
% disp(rmsd);
