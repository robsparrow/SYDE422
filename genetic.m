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
theta = 30; % degree rotation counterclockwise
xTrans = 0; %x translation defined in pixels
yTrans = 0; %y translation defined in pixels

%Apply all transformations to the image
% [distorted, sample, xdata,ydata] = imretrieve(original, xTrans, yTrans, scale, theta);
distorted = im_rst(original, scale, theta, xTrans, yTrans);

%Save images, which will be accessed by the GA
targetFolder = 'Test Data';
image = 'model4.png';
image = strcat(targetFolder, '\', image);
imwrite(original, image, 'png');
image = 'scene4.png';
image = strcat(targetFolder, '\', image);
imwrite(distorted, image, 'png');

%Show original and transformed images for comparison
% figure(1),subplot(2,1,1),imshow(original),title('Model');
% subplot(2,1,2),imshow(distorted),title('Scene');

%Specify options related to the performance of the GA
options=gaoptimset;
options = gaoptimset('Generations', 2);

%Run the GA
[x fval reason] = ga(@genetic_function, 2, options);

%Show the registered scene image based on the GA
registered = im_rst(distorted, 1, x(1), 0, 0);
figure(1),subplot(3,1,1),imshow(original),title('Model');
subplot(3,1,2),imshow(distorted),title('Scene');
subplot(3,1,3),imshow(registered),title('Registered Scene');
