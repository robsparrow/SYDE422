%===============================================================================
% Title: Evolutionary Image Registration for Mosaicing of Remotely Sensed Images
% Author: Rob Sparrow, Systes Design Engineering, University of Waterloo
% April 4th, 2012
%===============================================================================
 
%-------------------------------------------------------------------------------
% Part 1: Traditional Method
% Adapted from: http://www.mathworks.com/products/computer-vision/demos.html
% ?file=/products/demos/shipping/vision/visionrecovertform.html
% Requires Computer Vision System Toolbox
%-------------------------------------------------------------------------------

% Load original image
original = imread('test.png');

% Apply some set of affine transforms to the image
scale = 0.7; %70% of original image size
theta = 30; %30 degree rotation counterclockwise
scaled = imresize(original, scale);
rotated = imrotate(scaled,theta);
distorted = rotated;

% Identify corresponding features automatically
ptsOriginal  = detectSURFFeatures(original); %Identify corresponding points
ptsTransform = detectSURFFeatures(distorted);

[featuresIn   validPtsIn]  = extractFeatures(original,  ptsOriginal); % Extract descriptors from points
[featuresOut validPtsOut]  = extractFeatures(distorted, ptsDistorted);

index_pairs = matchFeatures(featuresIn, featuresOut); % Match the features between the two images

matchedOriginal  = validPtsIn(index_pairs(:,1)); % Identify locations of matching features
matchedDistorted = validPtsOut(index_pairs(:,2));

%Use RANSAC to identify the image transformation matrix for the image
%registration problem
gte = vision.GeometricTransformEstimator; % defaults to RANSAC
gte.Transform = 'Nonreflective similarity';
gte.NumRandomSamplingsMethod = 'Desired confidence';
gte.MaximumRandomSamples = 1000;
gte.DesiredConfidence = 99.8;

% Compute the transformation from the distorted to the original image.
[tform_matrix inlierIdx] = step(gte, matchedDistorted.Location, ...
    matchedOriginal.Location);

%Recover the image transformations applied to Original from the transformation matrix
tform_matrix = cat(2,tform_matrix,[0 0 1]'); % pad the matrix
tinv  = inv(tform_matrix);

ss = tinv(2,1);
sc = tinv(1,1);
scale_recovered = sqrt(ss*ss + sc*sc)
theta_recovered = atan2(ss,sc)*180/pi

% Apply the transformation identified to the distorted image to retrieve
% the original
agt = vision.GeometricTransformer;
agt.OutputImagePositionSource = 'Property';
%  Use the size of the original image to set the output size.
[h, w] = size(original);
agt.OutputImagePosition = [1 1 w h];

recovered = step(agt, im2single(distorted), tform_matrix);

%Show the recovered and original images for comparison
figure, imshow(original);
title('original');
figure, imshow(recovered);
title('recovered');