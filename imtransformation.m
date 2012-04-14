%===============================================================================
% Title: Evolutionary Image Registration for Mosaicing of Remotely Sensed Images
% Author: Rob Sparrow, Systes Design Engineering, University of Waterloo
% April 4th, 2012
%===============================================================================
 
%-------------------------------------------------------------------------------
% Section Title: Image retreival and manipulation
% This function applies the transformation determined by the GA or DE
% algorithm. This is different than function imprepare which applies the
% initial manipulation to the image (rotation, cropping, etc.).
%-------------------------------------------------------------------------------
function [distorted] = imtransformation(img, theta, xTrans, yTrans)
    %Setup a transformation matrix with x and y cooridnate translation
    translationMatrix = zeros(3,3);
    translationMatrix(1,1)=1;
    translationMatrix(2,2)=1;
    translationMatrix(3,3)=1;
    translationMatrix(3,1)=xTrans;
    translationMatrix(3,2)=yTrans;

    %Apply all transformations to the image
    tformTranslate = maketform('affine',translationMatrix);
    [translated xdata ydata]= imtransform(img, tformTranslate);
    distorted = translated;
    if theta ~=0
            rotated = imrotate(translated,theta);
            distorted = rotated;
    end
end