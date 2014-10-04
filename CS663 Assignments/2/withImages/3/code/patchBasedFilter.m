function outputImage = patchBasedFilter(origImage, sd, patchSize, windowSize)

origImageSize = size(origImage);
outputImage = zeros(origImageSize);

patchRadius = (patchSize-1)/2;
windowRadius = (windowSize-1)/2;

for i = 1:origImageSize(1)
    for j = 1:origImageSize(2)
        xMin = max(i-windowRadius,1);
        xMax = min(i+windowRadius,origImageSize(1));
        yMin = max(j-windowRadius,1);
        yMax = min(j+windowRadius,origImageSize(2));
        
        window = origImage(xMin:xMax,yMin:yMax);
        windowSize = size(window);
        
        xPrinPatchMin = max(i-patchRadius,1);
        xPrinPatchMax = min(i+patchRadius,origImageSize(1));
        yPrinPatchMin = max(j-patchRadius,1);
        yPrinPatchMax = min(j+patchRadius,origImageSize(2));
        principalPatch = origImage(xPrinPatchMin:xPrinPatchMax,yPrinPatchMin:yPrinPatchMax);
        principalPatchSize = size(principalPatch);
        
        windowWeights = zeros(windowSize);
        
        for k = 1:windowSize(1)
            for l = 1:windowSize(2)
                xPatchMin = max(k-patchRadius,1);
                xPatchMax = min(k+patchRadius,windowSize(1));
                yPatchMin = max(l-patchRadius,1);
                yPatchMax = min(l+patchRadius,windowSize(2));
                patch = window(xPatchMin:xPatchMax,yPatchMin:yPatchMax);
                patchSize = size(patch);
                
                if(principalPatchSize(1)>patchSize(1))
                    if(k>=windowSize/2)
                        finalPrincipalPatch = principalPatch(1:patchSize(1),:);
                        finalPatch = patch;
                    else
                        finalPrincipalPatch = principalPatch(principalPatchSize(1)-patchSize(1)+1:principalPatchSize(1),:);
                        finalPatch = patch;
                    end
                elseif(principalPatchSize(1)<patchSize(1))
                    if(i>=origImageSize(1)/2)
                        finalPrincipalPatch = principalPatch;
                        finalPatch = patch(1:principalPatchSize(1),:);
                    else
                        finalPrincipalPatch = principalPatch;
                        finalPatch = patch(patchSize(1)-principalPatchSize(1)+1:patchSize(1),:);
                    end
                else
                    finalPrincipalPatch = principalPatch;
                    finalPatch = patch;
                end
                
                if(principalPatchSize(2)>patchSize(2))
                    if(l>=windowSize/2)
                        finalPrincipalPatch = finalPrincipalPatch(:,1:patchSize(2));
                    else
                        finalPrincipalPatch = finalPrincipalPatch(:,principalPatchSize(2)-patchSize(2)+1:principalPatchSize(2));
                    end
                else
                    if(j>=origImageSize(2)/2)
                        finalPatch = finalPatch(:,1:principalPatchSize(2));
                    else
                        finalPatch = finalPatch(:,patchSize(2)-principalPatchSize(2)+1:patchSize(2));
                    end
                end
                
                finalXPatchSize = min(principalPatchSize(1), patchSize(1));
                finalYPatchSize = min(principalPatchSize(2), patchSize(2));
                
                windowWeights(k,l) = sqrt(sum(sum((finalPatch-finalPrincipalPatch).^2))/(finalXPatchSize*finalYPatchSize));
            end
        end
        
        gaussianKernel = exp(-(windowWeights).^2/(2*sd^2));
        convolvedMatrix = window.*gaussianKernel;
        outputImage(i,j) = sum(convolvedMatrix(:).*window(:))/sum(convolvedMatrix(:));
    end
end