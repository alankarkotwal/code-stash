% Load the image
origImage = double(imread('images/barbara256.png'));
origImageSize = size(origImage);

% Corrupt the image
corruptMask = 20*randn(origImageSize);
corruptImage = origImage + corruptMask;

figure;
subplot(1, 3, 1), imshow(corruptImage/max(max(corruptImage)));

%% Part 1

P = zeros([49 (origImageSize(1)-6)*(origImageSize(2)-6)]);

for i=1:origImageSize(1)-6
    for j=1:origImageSize(2)-6
        
        % Generate the subimage
        patch = corruptImage(i:i+6, j:j+6);
        P(:, (origImageSize(2)-6)*i-(origImageSize(2)-6)+j) = patch(:);
        
    end
end

% Get eigenvectors
L = P*transpose(P);
[W,D] = eig(L);

% Normalize
norms = sqrt(sum(W.^2));
W = W ./ kron(norms, ones([7*7 1]));

% Get coefficients
coeffs = transpose(W)*P;

% Get estimates of original coefficients
origCoeffsTemp = transpose(sum(transpose(coeffs.^2)))/((origImageSize(1)-6)*(origImageSize(2)-6));
origCoeffsEst  = max(0, origCoeffsTemp-400);

% Modify coefficients
denoisedCoeffs = coeffs ./ (1 + 20./ kron(origCoeffsEst, ones([1 62500])));
denoisedPatches = W*denoisedCoeffs;

% Reconstruct image
outputImage = double(zeros(origImageSize));
outputMask = double(zeros(origImageSize));

for i=1:origImageSize(1)-6
    for j=1:origImageSize(2)-6
        
        outputImage(i:i+6, j:j+6) = outputImage(i:i+6, j:j+6) + reshape(denoisedPatches(:, (origImageSize(2)-6)*i-(origImageSize(2)-6)+j), 7, 7);
        outputMask(i:i+6, j:j+6) = outputMask(i:i+6, j:j+6) + 1;
        
    end
end

outputImage = outputImage./outputMask;

subplot(1, 3, 2), imshow(outputImage/max(max(outputImage)));

%% Part 2

tic

outputImage = double(zeros(origImageSize));
outputMask = double(zeros(origImageSize));

for i=1:origImageSize(1)-6
    for j=1:origImageSize(2)-6
        
        % Generate the subimage
        prinPatch = reshape(corruptImage(i:i+6, j:j+6), 49, 1);
        
        xMin = max(i-15,1);
        xMax = min(i+15-6,origImageSize(1)-6);
        yMin = max(j-15,1);
        yMax = min(j+15-6,origImageSize(2)-6);
        
        patches = zeros([49 (xMax-xMin+1)*(yMax-yMin+1)]);
        rmsds = zeros([1 (xMax-xMin+1)*(yMax-yMin+1)]);
        
        for k=xMin:xMax
            for l=yMin:yMax
                
                patch = reshape(origImage(k:k+6, l:l+6), 49, 1);
                rmsd = sqrt(sum((patch-prinPatch).^2));
                patches(:, (xMax-xMin+1)*(k-xMin+1)-(xMax-xMin+1)+(l-yMin+1)) = patch;
                rmsds((xMax-xMin+1)*(k-xMin+1)-(xMax-xMin+1)+(l-yMin+1)) = rmsd;
                
            end
        end
        
        [sortedRmsd,sortOrder]=sort(rmsds, 'ascend');
        sortedPatches = patches(:, sortOrder);
        sortedPatchesSize = size(sortedPatches);
        selectedPatches = sortedPatches(:, 1:min(250, sortedPatchesSize(2)));
        
        % Get eigenvectors
        L = selectedPatches*transpose(selectedPatches);
        [W,D] = eig(L);

        % Normalize
        norms = sqrt(sum(W.^2));
        W = W ./ kron(norms, ones([7*7 1]));

        % Get coefficients
        coeffs = transpose(W)*selectedPatches;

        % Get estimates of original coefficients
        origCoeffsTemp = transpose(sum(transpose(coeffs.^2)))/min(250, sortedPatchesSize(2));
        origCoeffsEst  = max(0, origCoeffsTemp-400);

        % Modify coefficients
        denoisedCoeffs = coeffs ./ (1 + 20./ kron(origCoeffsEst, ones([1 min(250, sortedPatchesSize(2))])));
        denoisedPatch = W*denoisedCoeffs(:, 1);
        
        outputImage(i:i+6, j:j+6) = outputImage(i:i+6, j:j+6) + reshape(denoisedPatch, 7, 7);
        outputMask(i:i+6, j:j+6) = outputMask(i:i+6, j:j+6) + 1;
        
    end
end

outputImage = outputImage./outputMask;

subplot(1, 3, 3), imshow(outputImage/max(max(outputImage)));

toc
