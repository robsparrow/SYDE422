clear all; clc;

%===============================================================================
% Title: Evolutionary Image Registration for Mosaicing of Remotely Sensed Images
% Author: Rob Sparrow, Systes Design Engineering, University of Waterloo
% April 4th, 2012
%===============================================================================
 
%--------------------------------------------------------------------------
% Part 1: Traditional method for registration
%--------------------------------------------------------------------------
targetFolder = 'Samples';
original = '4.png';
original = strcat(targetFolder, '\', original);
peppers = imread(original);
peppers = rgb2gray(peppers);
rect_peppers = [200 300 200 300];
onion = imcrop(peppers,rect_peppers);

rect_onion = [111 33 65 58];
rect_peppers = [163 47 143 151];
sub_onion = imcrop(onion,rect_onion);
sub_peppers = imcrop(peppers,rect_peppers);

c = normxcorr2(sub_onion(:,:,1),sub_peppers(:,:,1));

% offset found by correlation
[max_c, imax] = max(abs(c(:)));
[ypeak, xpeak] = ind2sub(size(c),imax(1));
corr_offset = [(xpeak-size(sub_onion,2)) 
               (ypeak-size(sub_onion,1))];

% relative offset of position of subimages
rect_offset = [(rect_peppers(1)-rect_onion(1)) 
               (rect_peppers(2)-rect_onion(2))];

% total offset
offset = corr_offset + rect_offset;
xoffset = offset(1);
yoffset = offset(2);

xbegin = xoffset+1;
xend   = xoffset+ size(onion,2);
ybegin = yoffset+1;
yend   = yoffset+size(onion,1);

% extract region from peppers and compare to onion
extracted_onion = peppers(ybegin:yend,xbegin:xend,:);
if isequal(onion,extracted_onion) 
   disp('onion.png was extracted from peppers.png')
end

recovered_onion = uint8(zeros(size(peppers)));
recovered_onion(ybegin:yend,xbegin:xend,:) = onion;

[m,n,p] = size(peppers);
mask = ones(m,n); 
i = find(recovered_onion(:,:,1)==0);
mask(i) = .2; % try experimenting with different levels of 
              % transparency

% overlay images with transparency
figure, imshow(peppers(:,:,1)) % show only red plane of peppers
hold on
h = imshow(recovered_onion); % overlay recovered_onion
set(h,'AlphaData',mask)