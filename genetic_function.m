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
scale = x(1); % % of original image size
theta = x(2); % degree rotation counterclockwise
yTrans = x(3); %y translation defined in pixels
xTrans = x(4); %x translation defined in pixels

%Apply a set of transformations to the distorted image
distorted = im_rst(distorted, scale, theta, xTrans, yTrans);

%Measure similarity of images based on MOMI
similarityMeasure=momi(original, distorted, 'Normalized');

%Singe GA toolbox needs to minimize, we manipulate MOMI to achieve this
similarityMeasure=-similarityMeasure;

end