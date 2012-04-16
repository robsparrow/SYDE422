%===============================================================================
% Title: Evolutionary Image Registration for Mosaicing of Remotely Sensed Images
% Author: Rob Sparrow, Systes Design Engineering, University of Waterloo
% April 4th, 2012
%===============================================================================
 
%-------------------------------------------------------------------------------
% Section Title: Image retreival and manipulation
% This function retreives an image specified. It crops the image to a
% window defined by cropWindow and rotates the result. This is essentially the
% preparation of the scene image from the model.
%-------------------------------------------------------------------------------

function distorted = imprepare(img, theta, cropWindow, scale)
    %Setup the cropped image
    if cropWindow(:) ~= [0; 0; 0; 0]
        distorted = imcrop(img, cropWindow);
    else
        distorted = img;
    end
    
    %Apply scaling factor
    if scale ~=0
        distorted = imresize(distorted,scale);
    end
    
    %Apply rotation
    if theta ~=0
            distorted = imrotate(distorted,theta);
    end
end