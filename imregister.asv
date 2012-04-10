clear; close all; clc;

%===============================================================================
% Title: Evolutionary Image Registration for Mosaicing of Remotely Sensed Images
% Author: Rob Sparrow, Systes Design Engineering, University of Waterloo
% April 4th, 2012
%===============================================================================
 
%-------------------------------------------------------------------------------
% Part 1: Traditional Method
% Adapted from:
% http://www.mathworks.com/help/toolbox/images/ref/imregconfig.html
%-------------------------------------------------------------------------------

% Load original image
original = imread('test.png');
original = uint8(original);

% Setup transformations
scale = 0; %70% of original image size
theta = 0; %30 degree rotation counterclockwise
yTrans = 0; %y translation defined in pixels
xTrans = 0; %x translation defined in pixels

%Apply all transformations to the image
[distorted, sample, xdata,ydata] = imretrieve(original, xTrans, yTrans, scale, theta);

%Find similarity of the two images using a number of criterion
mutualInformation=momi(original, distorted, 'Normalized');
error = rmse(double(original), double(distorted));

%Show original and transformed images for comparison, then an overlay
figure, imshow(original);
title('Original');
figure, imshow(sample);
title('Sample Distortion');
figure, imshow(distorted);
title('Distortion');
imshowpair(original, distorted,'Scaling','joint');
title('Overlay');

%Create the optimizer, using a regular gradient descent method
%Create the metric based on Mattes Mutual Information
%[optimizer, metric]  = imregconfig('monomodal');
optimizer = registration.optimizer.RegularStepGradientDescent;
metric = registration.metric.MattesMutualInformation();

%Perform the registration, and show results of using Matte's Mutual
%Information
imgRegistered = imregister(distorted,original,'affine',optimizer, metric,'DisplayOptimization',true);

%Show the result of the registration as the registered image and then as an
%overlay with the original
figure, imshow(distorted);
title('Registered');
figure, imshowpair(original, imgRegistered,'Scaling','joint');
title('Overlay after registration');