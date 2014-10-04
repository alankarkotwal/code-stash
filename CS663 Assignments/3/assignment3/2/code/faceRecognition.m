% Face recognition
% ORL dataset in images/1
% Yale dataset in images/2
% Mode 1 is ORL, mode 2 is Yale

clc;

% Timing
tic

% Settings
mode = 1;           % Set if you want data for the ORL or the Yale dataset
%kInd = 11;          % Select a k from the kArr. Max 13 for ORL, 11 for Yale

if(mode == 1)
    trainImageFolders = ['images/1/01/'; 'images/1/02/'; 'images/1/03/'; 'images/1/04/'; 'images/1/05/'; 'images/1/06/'; 'images/1/07/'; 'images/1/08/'; 'images/1/09/'; ...
                         'images/1/10/'; 'images/1/11/'; 'images/1/12/'; 'images/1/13/'; 'images/1/14/'; 'images/1/15/'; 'images/1/16/'; 'images/1/17/'; ...
                         'images/1/18/'; 'images/1/19/'; 'images/1/20/'; 'images/1/21/'; 'images/1/22/'; 'images/1/23/'; 'images/1/24/'; 'images/1/25/'; ...
                         'images/1/26/'; 'images/1/27/'; 'images/1/28/'; 'images/1/29/'; 'images/1/30/'; 'images/1/31/'; 'images/1/32/'; 'images/1/33/'; ...
                         'images/1/34/'; 'images/1/35/'];
    nTrainFolders = 35;
    testImageFolders = ['images/1/01/'; 'images/1/02/'; 'images/1/03/'; 'images/1/04/'; 'images/1/05/'; 'images/1/06/'; 'images/1/07/'; 'images/1/08/'; 'images/1/09/'; ...
                         'images/1/10/'; 'images/1/11/'; 'images/1/12/'; 'images/1/13/'; 'images/1/14/'; 'images/1/15/'; 'images/1/16/'; 'images/1/17/'; ...
                         'images/1/18/'; 'images/1/19/'; 'images/1/20/'; 'images/1/21/'; 'images/1/22/'; 'images/1/23/'; 'images/1/24/'; 'images/1/25/'; ...
                         'images/1/26/'; 'images/1/27/'; 'images/1/28/'; 'images/1/29/'; 'images/1/30/'; 'images/1/31/'; 'images/1/32/'; 'images/1/33/'; ...
                         'images/1/34/'; 'images/1/35/'];
    nTestFolders = 35;
    trainImagesInit =   ['1.pgm '; '2.pgm '; '3.pgm '; '4.pgm '; '5.pgm ']; 
    testImagesInit =    ['6.pgm '; '7.pgm '; '8.pgm '; '9.pgm '; '10.pgm'];
    trainImages = cellstr(trainImagesInit);
    testImages = cellstr(testImagesInit);
    nTrainImages = 5;
    nTestImages =  5;
    sizeX = 112;
    sizeY = 92;
    kArr =              [1, 2, 3, 5, 10, 20, 30, 50, 75, 100, 125, 150, 170];
    maxKInd = 13;
    people = 1:nTestFolders;
    identities = kron(people, ones([1 nTestImages]));
elseif(mode == 2)
    trainImageFolders = ['images/2/01/'; 'images/2/02/'; 'images/2/03/'; 'images/2/04/'; 'images/2/05/'; 'images/2/06/'; 'images/2/07/'; 'images/2/08/'; 'images/2/09/'; ...
                         'images/2/10/'; 'images/2/11/'; 'images/2/12/'; 'images/2/13/'; 'images/2/15/'; 'images/2/16/'; 'images/2/17/'; 'images/2/18/'; ...
                         'images/2/19/'; 'images/2/20/'; 'images/2/21/'; 'images/2/22/'; 'images/2/23/'; 'images/2/24/'; 'images/2/25/'; 'images/2/26/'; ...
                         'images/2/27/'; 'images/2/28/'; 'images/2/29/'; 'images/2/30/'; 'images/2/31/'; 'images/2/32/'; 'images/2/33/'; 'images/2/34/'; ...
                         'images/2/35/'; 'images/2/36/'];
    nTrainFolders = 35;
    testImageFolders =  ['images/2/01/'; 'images/2/02/'; 'images/2/03/'; 'images/2/04/'; 'images/2/05/'; 'images/2/06/'; 'images/2/07/'; 'images/2/08/'; 'images/2/09/'; ...
                         'images/2/10/'; 'images/2/11/'; 'images/2/12/'; 'images/2/13/'; 'images/2/15/'; 'images/2/16/'; 'images/2/17/'; 'images/2/18/'; ...
                         'images/2/19/'; 'images/2/20/'; 'images/2/21/'; 'images/2/22/'; 'images/2/23/'; 'images/2/24/'; 'images/2/25/'; 'images/2/26/'; ...
                         'images/2/27/'; 'images/2/28/'; 'images/2/29/'; 'images/2/30/'; 'images/2/31/'; 'images/2/32/'; 'images/2/33/'; 'images/2/34/'; ...
                         'images/2/35/'; 'images/2/36/'];
    nTestFolders = 35;
    trainImagesInit =   ['1.pgm'; '2.pgm'];
    testImagesInit =    ['3.pgm'; '4.pgm'; '5.pgm'];
    trainImages = cellstr(trainImagesInit);
    testImages = cellstr(testImagesInit);
    nTrainImages = 2;
    nTestImages =  3;
    sizeX = 192;
    sizeY = 168;
    kArr =              [1, 2, 3, 5, 10, 20, 30, 50, 60, 65, 70];
    maxKInd = 11;
    people1 = 1:13;
    people2 = 15:36;
    people = [people1 people2];
    identities = kron(people, ones([1 nTestImages]));
end

% Main code

% Generate X matrix from the images
X = zeros([sizeX*sizeY nTrainFolders*nTrainImages]);

for i = 1:nTrainFolders
    for j = 1:nTrainImages
        image = imread([trainImageFolders(i,:) trainImages{j}]);
        X(:,nTrainImages*i-nTrainImages+j) = image(:);
    end
end

% Mean subtraction
mean = transpose(sum(transpose(X)))/(nTrainFolders*nTrainImages);
%meanImage = reshape(mean, sizeX, sizeY);
%imshow(meanImage/max(max(meanImage)));
X = X - kron(mean, ones([1 nTrainFolders*nTrainImages]));

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

recognitionRates = zeros(maxKInd);

for kInd = 1:maxKInd
    % Keep the highest k eigenvectors and find their coefficients
    k = kArr(kInd);
    Vr = Vs(:, 1:k);
    coeffs = transpose(Vr)*X;

    % Now get the testing images
    XTest = zeros([sizeX*sizeY nTestFolders*nTestImages]);

    for i = 1:nTestFolders
        for j = 1:nTestImages
            image = imread([testImageFolders(i,:) testImages{j}]);
            XTest(:,nTestImages*i-nTestImages+j) = double(image(:))-mean;
        end
    end

    testCoeffs = transpose(transpose(Vr)*XTest);
    predIdentities = transpose((floor((dsearchn(transpose(coeffs), testCoeffs(:,:))-1)/nTrainImages))+1);

    corrIdentities = 0;
    for i = 1:nTestFolders*nTestImages
        if(mode==2)
            if(predIdentities(i)>=14)
                predIdentities(i) = predIdentities(i)+1;
            end
        end
        if(identities(i) == predIdentities(i))
            corrIdentities = corrIdentities + 1;
        end
    end

    recognitionRate = 100*corrIdentities/(nTestFolders*nTestImages);
    recognitionRates(kInd) = recognitionRate;
    disp('Recognition rate for k=');
    disp(kArr(kInd));
    disp(recognitionRate);
end

figure;
plot(1:maxKInd, recognitionRates);
title('Recognition Rate versus k');
xlabel('k');
ylabel('Recognition Rate');
axis on;

% Timing
toc
