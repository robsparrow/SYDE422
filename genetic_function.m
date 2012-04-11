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
scale = 1; %x(1); % % of original image size
theta = x(1); % degree rotation counterclockwise
xTrans = 0; %x(3); %x translation defined in pixels
yTrans = 0; %x(4); %y translation defined in pixels

%Apply a set of transformations to the distorted image
% [distorted, sample, xdata,ydata] = imretrieve(distorted, xTrans, yTrans, scale, theta);
distorted = im_rst(distorted, 1, theta, 0, 0);

%Measure similarity of images based on MI
similarityMeasure=mi(original, distorted);

%Singe GA toolbox needs to minimize, we manipulate MI to achieve this
similarityMeasure=-similarityMeasure;

end