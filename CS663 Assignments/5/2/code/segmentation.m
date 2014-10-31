% Implement segmentation and filtering using mean-shift.

tic

% Get the image
origImage = imread('images/parrot.png');
origImageSize = size(origImage);
outputImage = zeros(origImageSize);

% Produce the samples and set values
n_samples = origImageSize(1)*origImageSize(2);
samples = zeros(5, n_samples);
max_iter = Inf;
min_dist = 2;
square_size = 23;
square_radius = (square_size-1)/2;

for i=1:origImageSize(1)
    for j=1:origImageSize(2)
        samples(:, origImageSize(2)*i-origImageSize(2)+j) = [i; j; origImage(i, j, 1); origImage(i, j, 2); origImage(i, j, 3)];
    end
end

output = samples;
iterations = zeros(5, n_samples);
iter = 0;

% Do the mean-shift
for i=1:n_samples
    disp(i);
    dist = 10;
    iter = 0;
    while dist>min_dist && iter<max_iter
        xMin = max((output(1, i)-square_radius), 1);
        xMax = min((output(1, i)+square_radius), origImageSize(1));
        yMin = max((output(2, i)-square_radius), 1);
        yMax = min((output(2, i)+square_radius), origImageSize(2));
        croppedImageSize = [xMax-xMin+1 yMax-yMin+1];
        nCroppedSamples = croppedImageSize(1)*croppedImageSize(2);
        croppedSamples = zeros([5 nCroppedSamples]);
        for k=xMin:xMax
            for j=yMin:yMax
                croppedSamples(:, croppedImageSize(2)*(k-xMin+1)-croppedImageSize(2)+(j-yMin+1)) = [k; j; origImage(k, j, 1); origImage(k, j, 2); origImage(k, j, 3)];
            end
        end
        exponen = exp(-1*sum((croppedSamples(1:2, :)-[output(1, i)*ones(1, nCroppedSamples); output(2, i)*ones(1, nCroppedSamples)]).^2)/144 + ...
                      -1*sum((croppedSamples(3:5, :)-[output(3, i)*ones(1, nCroppedSamples); output(4, i)*ones(1, nCroppedSamples); output(5, i)*ones(1, nCroppedSamples)]).^2)/144);
        num = [sum(croppedSamples(1, :).*exponen); ...
               sum(croppedSamples(2, :).*exponen); ...
               sum(croppedSamples(3, :).*exponen); ...
               sum(croppedSamples(4, :).*exponen); ...
               sum(croppedSamples(5, :).*exponen) ];
        
        denom = sum(exponen);
        newPoint = num / denom;
        dist = sqrt(sum((output(:, i)-newPoint).^2));
        output(:, i) = round(newPoint);
        iter = iter+1;
    end
    yC = mod(i, origImageSize(2));
    if(yC==0)
        yC = origImageSize(2); 
    end
    xC = (i-yC)/origImageSize(2) + 1;
    outputImage(xC, yC, :) = origImage(output(1, i), output(2, i), :);
    iterations(i) = iter;
end

toc