%==========================================================================
% Title: Evolutionary Image Registration for Mosaicing of Remotely Sensed 
% Images
% Author: Rob Sparrow, Systes Design Engineering, University of Waterloo
% April 4th, 2012
%==========================================================================
 
%--------------------------------------------------------------------------
% Part X: RMSE as a optimization criterion
% Meant to test alternative to mutual information
%--------------------------------------------------------------------------

function error = rmse(image1, image2)

%Get the mean squared error, then root mean squared error
originalRowSize = size(image1,1);
originalColSize = size(image1,2);

image1 = image1(:);
image2 = image2(:);

mse = sum((image1 - image2).^2)./(originalRowSize*originalColSize);
rmse = sqrt(mse);
error=rmse;
                                

end