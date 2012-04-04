clear all; clc;

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

% Apply some set of affine transforms to the image
scale = 0.7; %70% of original image size
theta = 30; %30 degree rotation counterclockwise
scaled = imresize(original, scale);
rotated = imrotate(scaled,theta);
distorted = rotated;

%Show original and transformed images for comparison, then an overlay
figure, imshow(original);
title('Original');
figure, imshow(distorted);
title('Distorted');
imshowpair(original, distorted,'Scaling','joint');
title('Overlay');

%Create the optimizer, monomodal because images are same spectrum
%Create Metric based on Mattes Mutual Information
optimizer = imregconfig('monomodal');
metric = registration.metric.MattesMutualInformation();

%Perform the registration
imgRegistered = imregister(distorted,original,'affine',optimizer, metric);

%Show the result of the registration as the registered image and then as an
%overlay with the original
figure, imshow(distorted);
title('Registered');
figure, imshowpair(original, imgRegistered,'Scaling','joint');
title('Overlay after registration');