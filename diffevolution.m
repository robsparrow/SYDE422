clear all; clc;

%===============================================================================
% Title: Evolutionary Image Registration for Mosaicing of Remotely Sensed Images
% Author: Rob Sparrow, Systes Design Engineering, University of Waterloo
% April 4th, 2012
%===============================================================================
 
%-------------------------------------------------------------------------------
% Part 2: Differential Evolution
%-------------------------------------------------------------------------------

% Load original image
original = imread('test.png');

% Setup transformations
scale = 0.7; %70% of original image size
theta = 30; %30 degree rotation counterclockwise
yTrans = 20; %y translation defined in pixels
xTrans = 20; %x translation defined in pixels

%Apply all transformations to the image
[distorted, sample, xdata,ydata] = imretrieve(original, xTrans, yTrans, scale, theta);

%Show original and transformed images for comparison, then an overlay
figure, imshow(original);
title('Original');
figure, imshow(sample);
title('Sample Distortion');
imshowpair(original, distorted,'Scaling','joint');
title('Overlay');