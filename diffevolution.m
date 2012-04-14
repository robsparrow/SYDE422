clear all; clc;

%===============================================================================
% Title: Evolutionary Image Registration for Mosaicing of Remotely Sensed Images
% Author: Rob Sparrow, Systes Design Engineering, University of Waterloo
% April 4th, 2012
%===============================================================================
 
%-------------------------------------------------------------------------------
% Section Title: Setup and execute the differential evolution algorithm
%-------------------------------------------------------------------------------

%Col1:Reference,2:xVal,3:yVal,4:number of evals
performance=zeros(7,4);
performance(:,1)=4:10;
for i=4:10
% Load original image
sample=num2str(i);
targetFolder = 'Samples';
original = strcat(targetFolder, '\', sample, '.png');
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
image = 'model';
image = strcat(targetFolder, '\', image, sample, '.png');
imwrite(original, image, 'png');
image = 'scene';
image = strcat(targetFolder, '\', image, sample, '.png');
imwrite(distorted, image, 'png');

%Run the DE
%(population,# of parameters,step size,crossover probability,itermax,strategy);
[bestmem,nfeval] = diffevolution_function(5000,2,1,.2,1000,1, original, distorted);
performance(i-3,2)=bestmem(1);
performance(i-3,3)=bestmem(2);
performance(i-3,4)=nfeval;
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
% 
% figure(1),subplot(3,1,1),imshow(original),title('Model');
% subplot(3,1,2),imshow(distorted),title('Scene');
end