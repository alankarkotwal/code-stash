% Set path to the 2/ directory here

% myNumOfColors = 200;
% myColorScale = [ [0:1/(myNumOfColors-1):1]' , [0:1/(myNumOfColors-1):1]' , [0:1/(myNumOfColors-1):1]' ];
% imagesc(single(phantom));
% colormap(myColorScale);
% daspect([1 1 1]);
% axis tight;
% colorbar;

%-------------------------- Q2 Part A ----------------------------------

%%
[q2a1Image,q2a1Map] = imread('images/barbara.png');
q2a1EnhancedImage = linearContrastStretching(q2a1Image);
save 'images/q2a1EnhancedImage' q2a1EnhancedImage;

figure;
subplot(1,2,1), imshow(q2a1Image,q2a1Map);
axis on;
colorbar;
subplot(1,2,2), imshow(q2a1EnhancedImage,q2a1Map);
axis on;
colorbar;

[q2a2Image,q2a2Map] = imread('images/TEM.png');
q2a2EnhancedImage = linearContrastStretching(q2a2Image);
save 'images/q2a2EnhancedImage' q2a2EnhancedImage;

figure;
subplot(1,2,1), imshow(q2a2Image,q2a2Map);
axis on;
colorbar;
subplot(1,2,2), imshow(q2a2EnhancedImage,q2a2Map);
axis on;
colorbar;

%%
[q2a3Image,q2a3Map] = imread('images/canyon.png');
q2a3EnhancedImage = linearContrastStretchingRGB(q2a3Image);
save 'images/q2a3EnhancedImage' q2a3EnhancedImage;

figure;
myNumOfColors = 200;
myColorScale = [ [0:1/(myNumOfColors-1):1]', [0:1/(myNumOfColors-1):1]' , [0:1/(myNumOfColors-1):1]' ];
imagesc (single (phantom));
colormap (myColorScale);
colormap jet;
daspect ([1 1 1]);
axis tight;
subplot(1,2,1), imshow(q2a3Image,q2a3Map);
axis on;
colorbar;
subplot(1,2,2), imshow(q2a3EnhancedImage,q2a3Map);
axis on;
colorbar;

%-------------------------- Q2 Part B ----------------------------------

%%
[q2b1Image,q2b1Map] = imread('images/barbara.png');
q2b1EnhancedImage = histogramEqualisation(q2b1Image);
save 'images/q2b1EnhancedImage' q2b1EnhancedImage;

figure;
subplot(1,2,1), imshow(q2b1Image,q2b1Map);
axis on;
colorbar;
subplot(1,2,2), imshow(q2b1EnhancedImage,q2b1Map);
axis on;
colorbar;

%%
[q2b2Image,q2b2Map] = imread('images/TEM.png');
q2b2EnhancedImage = histogramEqualisation(q2b2Image);
save 'images/q2b2EnhancedImage' q2b2EnhancedImage;

figure;
subplot(1,2,1), imshow(q2b2Image,q2b2Map);
axis on;
colorbar;
subplot(1,2,2), imshow(q2b2EnhancedImage,q2b2Map);
axis on;
colorbar;

%%
[q2b3Image,q2b3Map] = imread('images/canyon.png');
q2b3EnhancedImage = histogramEqualisationRGB(q2b3Image);
save 'images/q2b3EnhancedImage' q2b3EnhancedImage;

figure;
myNumOfColors = 200;
myColorScale = [ [0:1/(myNumOfColors-1):1]', [0:1/(myNumOfColors-1):1]' , [0:1/(myNumOfColors-1):1]' ];
imagesc (single (phantom));
colormap (myColorScale);
colormap jet;
daspect ([1 1 1]);
axis tight;
subplot(1,2,1), imshow(q2b3Image,q2b3Map);
axis on;
colorbar;
subplot(1,2,2), imshow(q2b3EnhancedImage,q2b3Map);
axis on;
colorbar;

%-------------------------- Q2 Part C ----------------------------------

%%
[q2c1Image,q2c1Map] = imread('images/barbara.png');
q2c1EnhancedImage = adaptiveHistogramEqualisation(q2c1Image, 100);
save 'images/q2c1EnhancedImage' q2c1EnhancedImage;

figure;
colorbar;
subplot(1,2,1), imshow(q2c1Image,q2c1Map);
axis on;
colorbar;
subplot(1,2,2), imshow(q2c1EnhancedImage,q2c1Map);
axis on;
colorbar;

%%
[q2c2Image,q2c2Map] = imread('images/TEM.png');
q2c2EnhancedImage = adaptiveHistogramEqualisation(q2c2Image, 100);
imwrite(q2c2EnhancedImage,'images/q2c2EnhancedImage.png');
save 'images/q2c2EnhancedImage' q2c2EnhancedImage;

figure;
subplot(1,2,1), imshow(q2c2Image,q2c2Map);
axis on;
colorbar;
subplot(1,2,2), imshow(q2c2EnhancedImage,q2c2Map);
axis on;
colorbar;

%%
[q2c3Image,q2c3Map] = imread('images/canyon.png');
q2c3EnhancedImage = adaptiveHistogramEqualisationRGB(q2c3Image, 150);
save 'images/q2c3EnhancedImage' q2c3EnhancedImage;

figure;
myNumOfColors = 200;
myColorScale = [ [0:1/(myNumOfColors-1):1]', [0:1/(myNumOfColors-1):1]' , [0:1/(myNumOfColors-1):1]' ];
imagesc (single (phantom));
colormap (myColorScale);
colormap jet;
daspect ([1 1 1]);
axis tight;
subplot(1,2,1), imshow(q2c3Image);
axis on;
colorbar;
subplot(1,2,2), imshow(q2c3EnhancedImage);
axis on;
colorbar;

%-------------------------- Q2 Part D ----------------------------------

%%
[q2d1Image,q2d1Map] = imread('images/barbara.png');
q2d1EnhancedImage = clAdaptiveHistogramEqualisation(q2d1Image, 100, 128);
save 'images/q2d1EnhancedImage' q2d1EnhancedImage;

figure;
subplot(1,2,1), imshow(q2d1Image,q2d1Map);
axis on;
colorbar;
subplot(1,2,2), imshow(q2d1EnhancedImage,q2d1Map);
axis on;
colorbar;

%%
[q2d2Image,q2d2Map] = imread('images/TEM.png');
q2d2EnhancedImage = clAdaptiveHistogramEqualisation(q2d2Image, 100, 128);
save 'images/q2d2EnhancedImage' q2d2EnhancedImage;

figure;
subplot(1,2,1), imshow(q2d2Image,q2d2Map);
axis on;
colorbar;
subplot(1,2,2), imshow(q2d2EnhancedImage,q2d2Map);
axis on;
colorbar;

%%
[q2d3Image,q2d3Map] = imread('images/canyon.png');
q2d3EnhancedImage = clAdaptiveHistogramEqualisationRGB(q2d3Image, 150, 200);
save 'images/q2d3EnhancedImage' q2d3EnhancedImage;

figure;
subplot(1,2,1), imshow(q2d3Image,q2d3Map);
axis on;
colorbar;
subplot(1,2,2), imshow(q2d3EnhancedImage,q2d3Map);
axis on;
colorbar;