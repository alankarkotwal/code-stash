function outputImage = circularFilter(origImage, maxRadius)

origImageSize = size(origImage);

fftImage = double(fft2(origImage));
fftImage = fftshift(fftImage);

circularKernel = zeros(origImageSize);

for i=1:origImageSize(1)
    for j=1:origImageSize(2)
        radius = ((i-origImageSize(1)/2).^2+(j-origImageSize(2)/2).^(2));
        if(radius>maxRadius)
            circularKernel(i,j) = 0;
        else
            circularKernel(i,j) = 1;
        end
    end
end

finalFft = ifftshift(fftImage .* circularKernel);
outputImage = ifft2(finalFft);