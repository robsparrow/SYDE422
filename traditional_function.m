%==========================================================================
% Title: Evolutionary Image Registration for Mosaicing of Remotely Sensed 
% Images
% Author: Rob Sparrow, Systes Design Engineering, University of Waterloo
% April 4th, 2012
%==========================================================================
 
%--------------------------------------------------------------------------
% Section Title: Algorithm for traditional registration of the images
% Adapted from: http://www.mathworks.com/matlabcentral/fileexchange/4145
%--------------------------------------------------------------------------

function [h,theta,I,J]=traditional_function(image1, image2, angle);
% Rigid registration - only translation and rotation are corrected
% For each angle of rotation set of translation is checked
% Can use only for translation by setting angle=0
%
% INPUT:
% Larger IMAGE2 is registered to smaller IMAGE1
%
% angle - vector of angles to check, for example 
% angle=[-30:2:30] or 
% angle=15;
%
% step - how many pixels to shift in x and y directions for translation check
%
% crop = 0 to eliminate cropping image
% crop=1 to crop the image and save computational time 
% You'll be asked to crop an area out of the original IMAGE2 
% If you have the kowledge of where approximately the matching area is the
% cropping allows you to limit the search to this area and to save
% calculation time.  Otherwise, select crop=0 
%
% OUTPUT:
% im_matched - matched part of image 2
% h - MI for the best theta
% theta - best angle of rotation
% I and J - coordinates of left top corner of matched area within large
% IMAGE2
theta=0;
step=4;

a=isa(image1,'uint16');
if a==1
     image1=double(image1)/65535*255;  
 else
     image1=double(image1);
end

a=isa(image2,'uint16');
if a==1
    image2=double(image2)/65535*255;
else
    image2=double(image2);    
end

[m,n]=size(image1);
[p,q]=size(image2); 
[a,b]=size(angle);
im1=round(image1); 
method='Normalized';

sub_image2=image2;
   
for k=1:b
    J = imrotate(sub_image2, angle(k),'bilinear'); %rotated cropped IMAGE2
    image21=round(J);
    [m1,n1]=size(image21);
    for i=1:step:(m1-m)
        for j=1:step:(n1-n)
                im2=image21(i:(i+m-1),j:(j+n-1)); % selecting part of IMAGE2 matching the size of IMAHE1
                im2=round(im2); 
                h(k,i,j)=momi(im1,im2,method); % calculating MI
            end
        end
    end
  

[a, b] = max(h(:));% finding the max of MI and indecises
[K,I,J] = ind2sub(size(h),b);

end