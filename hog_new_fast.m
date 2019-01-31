%   this function computes HOG features in the form of channels
%   same as the HOG features computed for the cat head detection paper!
%   G is HxYxnbins, where HxY is the dimension of the input image
%   nbins : # of feature channels / bins
%   cell_size: cell size
%   block_size: block size
function G = hog_new_fast(im, nbins, cell_size, block_size)

dx =  -[1 0 -1; 2 0 -2; 1 0 -1];
dy = dx';
e = 1;

Gx = imfilter(im, dx);
Gy = imfilter(im, dy);

G = zeros(size(im,1), size(im,2), nbins);
theta = atan2(Gy, Gx);
theta(find(theta<0)) = theta(find(theta<0)) + pi; 
B = round((theta./pi)*(nbins-1))+1;

for i=1:nbins
    G(:,:,i) =  (B==i);
end;


%% pooling

V = sqrt((Gx.*Gx) + (Gy.*Gy));
G = bsxfun(@times, G,V); 

%
V = imfilter(V, ones(cell_size)/prod(cell_size) );
V = 1.0 ./ (V + e ); 
 

G = imfilter(G,ones(cell_size)/prod(cell_size) );
G = bsxfun(@times, G,V); 

Gsum = imfilter(sum(G.*G,3), ones(block_size) );
Gsum = sqrt(Gsum);
 
G = bsxfun(@rdivide, G,(Gsum+e)); 
end
