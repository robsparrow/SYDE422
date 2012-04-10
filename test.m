clear all; clc;

%===============================================================================
% Title: Evolutionary Image Registration for Mosaicing of Remotely Sensed Images
% Author: Rob Sparrow, Systes Design Engineering, University of Waterloo
% April 4th, 2012
%===============================================================================
 
%-------------------------------------------------------------------------------
% Test Code
%-------------------------------------------------------------------------------

% Load original image
targetFolder = 'Samples';
original = '1_small.tif';
original = strcat(targetFolder, '\', original);
original = imread(original);