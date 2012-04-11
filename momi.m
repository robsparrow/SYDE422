%==========================================================================
% Title: Evolutionary Image Registration for Mosaicing of Remotely Sensed 
% Images
% Author: Rob Sparrow, Systes Design Engineering, University of Waterloo
% April 4th, 2012
%==========================================================================
 
%--------------------------------------------------------------------------
% Section Title: Maximization of Mutual Information calculation for two
% images
% Adapted from: http://www.flash.net/~strider2/matlab.htm
%--------------------------------------------------------------------------

function h = momi(image_1, image_2, method)

a=joint_h(image_1,image_2); % calculating joint histogram for two images
[r,c] = size(a);
b= a./(r*c); % normalized joint histogram
y_marg=sum(b); %sum of the rows of normalized joint histogram
x_marg=sum(b');%sum of columns of normalized joint histogran

Hy=0;
for i=1:c;    %  col
      if( y_marg(i)==0 )
         %do nothing
      else
         Hy = Hy + -(y_marg(i)*(log2(y_marg(i)))); %marginal entropy for image 1
      end
   end
   
Hx=0;
for i=1:r;    %rows
   if( x_marg(i)==0 )
         %do nothing
      else
         Hx = Hx + -(x_marg(i)*(log2(x_marg(i)))); %marginal entropy for image 2
      end   
   end
h_xy = -sum(sum(b.*(log2(b+(b==0))))); % joint entropy

if method=='Normalized';
h = (Hx + Hy)/h_xy;% Mutual information
elseif method=='Non-Normalized'
h = Hx + Hy - h_xy;% Mutual information

end