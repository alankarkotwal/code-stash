function CDF = getCDF(image)

imageHistogram = imhist(image);
CDF = double(zeros(1,255));

CDF(1) = imageHistogram(1);
for i = 2:256
    CDF(i) = double(imageHistogram(i))+CDF(i-1);
end