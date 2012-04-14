clear all; clc;

%===============================================================================
% Title: Evolutionary Image Registration for Mosaicing of Remotely Sensed Images
% Author: Rob Sparrow, Systes Design Engineering, University of Waterloo
% April 4th, 2012
%===============================================================================
 
%-------------------------------------------------------------------------------
% Section Title: Setup and execute the genetic algorithm
%-------------------------------------------------------------------------------

% Load original image
targetFolder = 'Samples';
original = '9.png';
original = strcat(targetFolder, '\', original);
original = imread(original);
original = rgb2gray(original);

% Setup transformations
% Note: pass [0 0 0 0] if the image is not cropped
theta = 0; % degree rotation counterclockwise
scale = 1; %Resizing of image after cropping
cropWindow = [200 200 300 300]; %Specify crop window of the model ([xmin ymin width height])

%Apply all transformations to the image
[distorted] = imprepare(original, theta, cropWindow, scale);

%Save images for access later
targetFolder = 'Test Data';
image = 'model4.png';
image = strcat(targetFolder, '\', image);
imwrite(original, image, 'png');
image = 'scene4.png';
image = strcat(targetFolder, '\', image);
imwrite(distorted, image, 'png');

%Retrieve GA options and run the GA
options = ga_options(original, distorted);
fitnessFunction={@genetic_function, original, distorted};
[x fval reason] = ga(fitnessFunction, 2, options);

%Show the registered scene image based on the GA
% x1 = scale, x2=x shift, x3=y shift
% if theta ~=0
% 	distorted = imrotate(distorted,-x(1));
% end

% recovered_scene = uint8(zeros(size(original)));
% recovered_scene(x(3):cropWindow(4),x(2):cropWindow(3),:) = distorted;
% 
% [m,n,p] = size(original);
% mask = ones(m,n); 
% i = find(recovered_scene(:,:,1)==0);
% mask(i) = .2;
% 
% % overlay images with transparency
% figure, imshow(original(:,:,1));
% hold on;
% h = imshow(recovered_scene); % overlay
% set(h,'AlphaData',mask);
% 
figure(1),subplot(3,1,1),imshow(original),title('Model');
subplot(3,1,2),imshow(distorted),title('Scene');