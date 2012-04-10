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
targetFolder = 'Samples';
original = '4.png';
original = strcat(targetFolder, '\', original);
original = imread(original);
original = rgb2gray(original);

% Setup transformations
scale = 1; % % of original image size
theta = 10; % degree rotation counterclockwise
yTrans = 20; %y translation defined in pixels
xTrans = 20; %x translation defined in pixels

%Apply all transformations to the image
%[distorted, sample, xdata,ydata] = imretrieve(original, xTrans, yTrans, scale, theta);
distorted = im_rst(original, scale, theta, xTrans, yTrans);

momi=momi(original, distorted, 'Normalized');

%Show original and transformed images for comparison, then an overlay
figure(1),subplot(2,1,1),imshow(original),title('Original')
subplot(2,1,2),imshow(distorted),title('Distorted')