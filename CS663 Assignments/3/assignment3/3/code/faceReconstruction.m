% Face recognition
% ORL dataset in images/1

clc;

% Timing
tic

% Settings
folder = 21;            % Select whose image to reconstruct
imageNo = 7;            % Select which image to reconstruct

imageFolders = ['images/1/01/'; 'images/1/02/'; 'images/1/03/'; 'images/1/04/'; 'images/1/05/'; 'images/1/06/'; 'images/1/07/'; 'images/1/08/'; 'images/1/09/'; ...
                     'images/1/10/'; 'images/1/11/'; 'images/1/12/'; 'images/1/13/'; 'images/1/14/'; 'images/1/15/'; 'images/1/16/'; 'images/1/17/'; ...
                     'images/1/18/'; 'images/1/19/'; 'images/1/20/'; 'images/1/21/'; 'images/1/22/'; 'images/1/23/'; 'images/1/24/'; 'images/1/25/'; ...
                     'images/1/26/'; 'images/1/27/'; 'images/1/28/'; 'images/1/29/'; 'images/1/30/'; 'images/1/31/'; 'images/1/32/'; 'images/1/33/'; ...
                     'images/1/34/'; 'images/1/35/'];
nFolders = 35;
imagesInit =   ['1.pgm '; '2.pgm '; '3.pgm '; '4.pgm '; '5.pgm '; '6.pgm '; '7.pgm '; '8.pgm '; '9.pgm '; '10.pgm']; 
images = cellstr(imagesInit);
nImages = 10;
sizeX = 112;
sizeY = 92;
kArr =         [2, 10, 20, 50, 75, 100, 125, 150, 175];
maxKInd = 9;

% Main code

% Generate X matrix from the images
X = zeros([sizeX*sizeY nFolders*nImages]);

for i = 1:nFolders
    for j = 1:nImages
        image = imread([imageFolders(i,:) images{j}]);
        X(:,nImages*i-nImages+j) = image(:);
    end
end

% Mean subtraction
mean = transpose(sum(transpose(X)))/(nFolders*nImages);
%meanImage = reshape(mean, sizeX, sizeY);
%imshow(meanImage/max(max(meanImage)));
X = X - kron(mean, ones([1 nFolders*nImages]));

% Generate XT*X and find its eigenvectors
L = transpose(X)*X;
[W,D] = eig(L);

% Get eigenvectors and eigenvalues of C and normalize them
V = X*W;
norms = sqrt(sum(V.^2));
V = V ./ kron(norms, ones([sizeX*sizeY 1]));

% Sort eigenvectors by their eigenvalues
[D,sortOrder]=sort(diag(D), 'descend');
Vs = V(:, sortOrder);

% Get the image
myImage = imread([imageFolders(folder,:) images{imageNo}]);
myImage = double(myImage(:));

subplot(2, 5, 1), imshow(reshape(myImage, sizeX, sizeY)/max(myImage));
title('Original Image');

for kInd = 1:maxKInd
    % Reconstruct using the highest k eigenvectors
    k = kArr(kInd);
    Vr = Vs(:, 1:k);
    coeffs = transpose(Vr)*(myImage-mean);
    
    comps = kron(transpose(coeffs), ones([sizeX*sizeY 1])).*Vr;
    myReconstructedImage = reshape(transpose(sum(transpose(comps)))+mean, sizeX, sizeY);

    subplot(2, 5, kInd+1), imshow(myReconstructedImage/max(max(myReconstructedImage)));
    title(['k = ' int2str(kArr(kInd))]);
end

figure;

for kEig = 1:25
    E = Vs(:,kEig);
    eigenface = reshape(E, sizeX, sizeY);
    subplot(5, 5, kEig), imshow(eigenface/max(max(eigenface)));
    title(['k = ' int2str(kEig)]);
end

figure;

for kEig = 1:25
    E = Vs(:,kEig);
    eigenface = log(1+abs(fftshift(fft2(reshape(E, sizeX, sizeY)))));
    subplot(5, 5, kEig), imshow(eigenface/max(max(eigenface)));
    title(['k = ' int2str(kEig)]);
end

% Timing
toc