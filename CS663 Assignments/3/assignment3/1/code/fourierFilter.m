function outputImage = fourierFilter(origImage, freqParam)

origImageSize = size(origImage);

fftImage = double(fft2(origImage));
fftImage = fftshift(fftImage);

butterworthKernel = zeros(origImageSize);

for i=1:origImageSize(1)
    for j=1:origImageSize(2)
        butterworthKernel(i,j) = 1/(1+(((i-origImageSize(1)/2).^2+(j-origImageSize(2)/2).^(2))/(freqParam*freqParam)).^2);
    end
end

figure;
imshow(butterworthKernel);

finalFft = ifftshift(fftImage .* butterworthKernel);
outputImage = ifft2(finalFft);