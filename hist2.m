function n=hist2(A,B,L) 
%HIST2 Calculates the joint histogram of two images or signals
%
%   n=hist2(A,B,L) is the joint histogram of matrices A and B, using L
%   bins for each matrix.

ma=min(A(:)); 
MA=max(A(:)); 
mb=min(B(:)); 
MB=max(B(:));

% Scale and round to fit in {0,...,L-1} 
A=round((A-ma)*(L-1)/(MA-ma+eps)); 
B=round((B-mb)*(L-1)/(MB-mb+eps)); 
n=zeros(L); 
x=0:L-1; 
for i=0:L-1 
    n(i+1,:) = histc(B(A==i),x,1); 
end
end
