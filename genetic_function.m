%==========================================================================
% Title: Evolutionary Image Registration for Mosaicing of Remotely Sensed 
% Images
% Author: Rob Sparrow, Systes Design Engineering, University of Waterloo
% April 4th, 2012
%==========================================================================
 
%--------------------------------------------------------------------------
% Section Title: Function to be optimized in the genetic algorithm
%--------------------------------------------------------------------------

function similarityMeasure=genetic_function(x)

% Load images
targetFolder = 'Test Data';
original = 'model4.png';
original = strcat(targetFolder, '\', original);
original = imread(original);
distorted = 'scene4.png';
distorted = strcat(targetFolder, '\', distorted);
distorted = imread(distorted);

% Setup transformations
scale = x(1); %x(1); % % of original image size
theta = x(2); % degree rotation counterclockwise
xTrans = x(3); %x(3); %x translation defined in pixels
yTrans = x(4); %x(4); %y translation defined in pixels

%Apply a set of transformations to the distorted image
[distorted, sample, xdata,ydata] = imretrieve(distorted, xTrans,...
    yTrans, 1, theta);
% im_rst(image, scale, angle, x shift, y shift)
% distorted = im_rst(distorted, 1, theta, 0, 0);

%Measure similarity of images based on MI
similarityMeasure=mi(original, distorted, 'Normalized');

%Measure similarity of images based on

%Singe GA toolbox needs to minimize, we manipulate MI to achieve this
similarityMeasure=-similarityMeasure;

end