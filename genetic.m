clear all; clc;

%===============================================================================
% Title: Evolutionary Image Registration for Mosaicing of Remotely Sensed Images
% Author: Rob Sparrow, Systes Design Engineering, University of Waterloo
% April 4th, 2012
%===============================================================================
 
%-------------------------------------------------------------------------------
% Part 3: Genetic Algorithms
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

%Save images, which will be accessed by the GA
targetFolder = 'Test Data';
image = 'model4';
image = strcat(targetFolder, '\', image);
imwrite(original, image);
image = 'scene4';
image = strcat(targetFolder, '\', image);
imwrite(distorted, image);

%Show original and transformed images for comparison, then an overlay
% figure(1),subplot(2,1,1),imshow(original),title('Original')
% subplot(2,1,2),imshow(distorted),title('Distorted')

%Specify options related to the performance of the GA
options=gaoptimset;
%Population size is 20 by default
options = gaoptimset('PopulationSize', 20)

%Run the GA
[x fval reason] = ga(@genetic_function, 4);