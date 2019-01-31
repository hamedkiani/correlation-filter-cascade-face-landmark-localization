
%   This function computes the feature channels
%   face_patch: input face patch
%   imSz      : patch size
%   fltSz     : filter size
%   feat      : feature parameters
%   sfilter   : pre-computed Gabor filters
function feat_cnls = get_feat_channels_fast(face_patch, imSz, fltSz, feat, sfilter)

%   for image gradients
dx =  [1 0 -1; 2 0 -2; 1 0 -1]; dy = dx';

%   power normalization
if feat.pn
    face_patch = powerNormalise(face_patch);
end;
%   cosine window
if feat.cw
    cos_window = gen_cosine_window(fltSz);
    face_patch = bsxfun(@times, face_patch, cos_window);
end;

%   image gradient x and y
Gx = imfilter(face_patch, dx);
Gy = imfilter(face_patch, dy);

%   to save feature channels
feat_cnls = [];

%   HOG feature (hog_new_fast)
if (feat.type == 1 || feat.type == 3)
    hog =  hog_new_fast(face_patch, feat.nbins, feat.cell_size, feat.block_size);    
end;

fF = fft2(face_patch);

%   Gabor feature
if (feat.type == 2 || feat.type==3 || feat.type==6 || feat.type==7 || feat.type==8)
    gabR = ifft2(bsxfun(@times, sfilter, fF));
    gab  = sqrt(real(gabR).^2 + imag(gabR).^2); 
    gab = circshift(gab, -floor(feat.gSz/2));      
end;
 

if (feat.type ==1)
    feat_cnls = hog; % hog
elseif (feat.type == 2) % gabor+ gray + sobel
    feat_cnls = gab;
    feat_cnls = cat(3, feat_cnls, Gx);
    feat_cnls = cat(3, feat_cnls, Gy);
    feat_cnls = cat(3, feat_cnls, face_patch);
elseif (feat.type == 3) % hog+gabor
    feat_cnls = cat(3, hog, gab);
end;

if (feat.type ==4) % gray
    feat_cnls = face_patch;
end;

if (feat.type == 5) % sobel
    feat_cnls = cat(3,Gx,Gy);
end;

if (feat.type == 6) % gabor
    feat_cnls = gab;
end;

if (feat.type == 7) % gabor + gray
    feat_cnls = cat(3, gab, face_patch);
end;

if (feat.type == 8) % gabor + sobel
    feat_cnls = cat(3, gab, Gx);
    feat_cnls = cat(3, feat_cnls, Gy);
end;


feat_cnls = double(feat_cnls);

%   min-max normalization of feature channels
for i=1:size(feat_cnls,3)
    tmp = feat_cnls(:,:,i);
    tmp = tmp + abs(min(tmp(:)));
    tmp = tmp ./ max(tmp(:));
    feat_cnls(:,:,i) = tmp; 
end; 
end