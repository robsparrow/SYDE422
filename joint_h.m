%==========================================================================
% Title: Evolutionary Image Registration for Mosaicing of Remotely Sensed 
% Images
% Author: Rob Sparrow, Systes Design Engineering, University of Waterloo
% April 4th, 2012
%==========================================================================
 
%--------------------------------------------------------------------------
% Section Title: Joint histogram creation for MI claculation
% Adapted from: http://www.flash.net/~strider2/matlab.htm
%--------------------------------------------------------------------------

function h=joint_h(image_1,image_2)

rows=size(image_1,1);
cols=size(image_1,2);
N=256;

h=zeros(N,N);

for i=1:rows;    %  col 
  for j=1:cols;   %   rows
    h(image_1(i,j)+1,image_2(i,j)+1)= h(image_1(i,j)+1,image_2(i,j)+1)+1;
  end
end