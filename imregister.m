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

% Setup transformations
scale = 0.7; %70% of original image size
theta = 30; %30 degree rotation counterclockwise

%Setup a transformation matrix with x and y cooridnate translation
yTrans = 20; %y translation defined in pixels
xTrans = 20; %x translation defined in pixels
translationMatrix = zeros(3,3);
translationMatrix(1,1)=1;
translationMatrix(2,2)=1;
translationMatrix(3,3)=1;
translationMatrix(3,1)=xTrans;
translationMatrix(3,2)=yTrams;

%Apply all transformations to the image
tformTranslate = maketform('affine',translationMatrix);
[translated xdata ydata]= imtransform(original, tformTranslate);
scaled = imresize(translated, scale);
rotated = imrotate(scaled,theta);
distorted = rotated;

%Show original and transformed images for comparison, then an overlay
figure, imshow(original);
title('Original');
figure, imshow(distorted);
title('Distorted');
imshowpair(original, distorted,'Scaling','joint');
title('Overlay');

%Create the optimizer, using a regular gradient descent method
%Create the metric based on Mattes Mutual Information
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