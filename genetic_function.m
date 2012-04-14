%==========================================================================
% Title: Evolutionary Image Registration for Mosaicing of Remotely Sensed 
% Images
% Author: Rob Sparrow, Systes Design Engineering, University of Waterloo
% April 4th, 2012
%==========================================================================
 
%--------------------------------------------------------------------------
% Section Title: Function to be optimized in the genetic algorithm
%--------------------------------------------------------------------------

function similarityMeasure=genetic_function(x, original, distorted)

% Setup transformations
% theta = x(1); % degree rotation counterclockwise
xTrans = x(1); %x translation defined in pixels
yTrans = x(2); %y translation defined in pixels
% scale = x(3)/100; %image scale (divide by 10 because GA returns ints)
imgRegistered = distorted; 

% Apply the rotation to the image
% if theta ~=0
% 	imgRegistered = imrotate(imgRegistered,theta);
% end

% imgRegistered = imresize(imgRegistered,scale);

% Crop the model based on the translation for comparison
% Crop is small to facilitate performance improvements
% The window specifies the lower left hand corner of the image, which is
% the point being moved
% cropWindow is [xmin ymin width height]
cropWindow = [xTrans yTrans 200 200];
original = imcrop(original,cropWindow);
cropWindow = [0 0 200 200];
imgRegistered = imcrop(imgRegistered,cropWindow);

%Measure similarity of images based on MI
%Since GA toolbox needs to minimize, we manipulate MI to achieve this
similarityMeasure=momi(imgRegistered, original, 'Normalized');
similarityMeasure=-similarityMeasure*1000;

end