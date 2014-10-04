% Part 1: Fourier filtering with Butterworth Filter

storedStruct1 = load('images/boat.mat');
q11OrigImage = storedStruct1.imageOrig/255;

q11OrigImageSize = size(q11OrigImage);
q11CorruptMask = 0.1*max(max(q11OrigImage))*randn(q11OrigImageSize);
q11CorruptImage = q11OrigImage + q11CorruptMask;

q11FinalImage = fourierFilter(q11CorruptImage, 99);
save 'images/boatFiltered.mat' q11FinalImage;
rmsd = sqrt(sum(sum((q11FinalImage-q11OrigImage).^2))/(q11OrigImageSize(1)*q11OrigImageSize(2)));
disp(rmsd);

%for i=90:0.1:110
%    q11FinalImage = fourierFilter(q11CorruptImage, i);
%    rmsd = sqrt(sum(sum((q11FinalImage-q11OrigImage).^2))/(q11OrigImageSize(1)*q11OrigImageSize(2)));
%    disp(i);
%    disp(rmsd);
%end

figure;
subplot(1,3,1), imshow(q11OrigImage);
title('Original Image');
colorbar;
axis on;
subplot(1,3,2), imshow(q11CorruptImage);
title('Corrupted Image');
colorbar;
axis on;
subplot(1,3,3), imshow(q11FinalImage);
title('Corrected Image');
colorbar;
axis on;

%%
% Part 2: Circular disk mask

storedStruct2 = load('images/boat.mat');
q12OrigImage = storedStruct2.imageOrig/255;

q12OrigImageSize = size(q12OrigImage);
q12CorruptMask = 0.1*max(max(q12OrigImage))*randn(q12OrigImageSize);
q12CorruptImage = q12OrigImage + q12CorruptMask;

%origFft = fftshift(fft2(q12OrigImage));
%corrFft = fftshift(fft2(q12CorruptImage));

%disp(origFft(256, 256));
%disp(corrFft(256, 256));

q12FinalImage = circularFilter(q12CorruptImage, 3537);
rmsd = sqrt(sum(sum((q12FinalImage-q12OrigImage).^2))/(q12OrigImageSize(1)*q12OrigImageSize(2)));
disp(rmsd);

% totalEnergy = sum(sum((q12OrigImage).^2));
% rmsd = zeros(1024);
% for i=1:1024
%     q12FinalImage = circularFilter(q12OrigImage, i);
%     energyPercent = 100*sum(sum((q12FinalImage).^2))/totalEnergy;
%     rmsd = sqrt(sum(sum((q12FinalImage-q12OrigImage).^2))/(q12OrigImageSize(1)*q12OrigImageSize(2)));
%     disp(i);
%     disp(rmsd);
%     disp(energyPercent);
% end

figure;
subplot(2,3,1), imshow(q12OrigImage);
title('Original Image');
colorbar;
axis on;
q12Image1 = circularFilter(q12CorruptImage, 2);
subplot(2,3,2), imshow(q12Image1);
title('R=2');
colorbar;
axis on;
q12Image2 = circularFilter(q12CorruptImage, 7);
subplot(2,3,3), imshow(q12Image2);
title('R=7');
colorbar;
axis on;
q12Image3 = circularFilter(q12CorruptImage, 27);
subplot(2,3,4), imshow(q12Image3);
title('R=27');
colorbar;
axis on;
q12Image4 = circularFilter(q12CorruptImage, 222);
subplot(2,3,5), imshow(q12Image4);
title('R=222');
colorbar;
axis on;
q12Image5 = circularFilter(q12CorruptImage, 3537);
subplot(2,3,6), imshow(q12Image5);
title('R=3537');
colorbar;
axis on;