% Set path to the 1/ directory here

%myNumOfColors = 200;
%myColorScale = [ [0:1/(myNumOfColors-1):1]' , [0:1/(myNumOfColors-1):1]' , [0:1/(myNumOfColors-1):1]' ];
%imagesc(single(phantom));
%colormap(myColorScale);
%daspect([1 1 1]);
%axis tight;
%colorbar;

%%
[q1aImage,q1aMap] = imread('images/circles_concentric.png');
q1a2Image = resizeImage(q1aImage,2);
q1a3Image = resizeImage(q1aImage,3);
save 'images/q1a2Image' q1a2Image;
save 'images/q1a3Image' q1a3Image;

figure;
subplot(1,3,1), imshow(q1aImage,q1aMap);
colorbar;
axis on;
subplot(1,3,2), imshow(q1a2Image,q1aMap);
colorbar;
axis on;
subplot(1,3,3), imshow(q1a3Image,q1aMap);
colorbar;
axis on;

%%
[q1bImage,q1bMap] = imread('images/barbaraSmall.png');
q1bExpImage = bilinearExpansion(q1bImage);
save 'images/q1bExpImage' q1bExpImage;

figure;
subplot(1,2,1), imshow(q1bImage,q1bMap);
colorbar;
axis on;
subplot(1,2,2), imshow(q1bExpImage,q1bMap);
colorbar;
axis on;

%%
[q1cImage,q1cMap] = imread('images/barbaraSmall.png');
q1cExpImage = nearestNeighborInterpolation(q1cImage);
save 'images/q1cExpImage' q1cExpImage;

figure;
subplot(1,2,1), imshow(q1cImage,q1cMap);
colorbar;
axis on;
subplot(1,2,2), imshow(q1cExpImage);
colorbar;
axis on;