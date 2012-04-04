%===============================================================================
% Title: Evolutionary Image Registration for Mosaicing of Remotely Sensed Images
% Author: Rob Sparrow, Systes Design Engineering, University of Waterloo
% April 4th, 2012
%===============================================================================
 
%-------------------------------------------------------------------------------
% Part X: Image retreival and manipulation
% This function retreives an image specified and applys some set of affine 
% transformations to the image. It returns the distorted image and new x
% and y positions for display.
%-------------------------------------------------------------------------------
function [distorted, sample, xdata, ydata] = imretrieve(img, xTrans, yTrans, scale, theta)
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
    if scale ~=0
        scaled = imresize(translated, scale);
        distorted = scaled;
        if theta ~=0
            rotated = imrotate(scaled,theta);
            distorted = rotated;
        end    
    elseif theta ~=0
            rotated = imrotate(translated,theta);
            distorted = rotated;
    end
 
    %Prepare sample of image transformation for display
    %Note: Not for processing
    transSample = imtransform(translated, tformTranslate,...
                            'XData', [1 (size(img,2)+ xTrans)],...
                            'YData', [1 (size(img,1)+ yTrans)]);
    sample = transSample;
    if scale ~=0
    scaledSample = imresize(transSample, scale);
    sample = scaledSample;
        if theta ~=0
            rotatedSample = imrotate(scaledSample,theta);
            sample = rotatedSample;
        end    
    elseif theta ~=0
        rotatedSample = imrotate(transSample,theta);
        sample = rotatedSample;
    end
    
end