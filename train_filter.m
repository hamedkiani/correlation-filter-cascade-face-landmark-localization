
%    train_imgs : training samples
%    ind        : the indix of the landmark of interest, [1,...,5]
%    imSz       : image size
%    fltSz      : filter size
%    feat       : contains the feature parameters,


function filt = train_filter(train_imgs, ind, imSz, fltSz, feat)

close all;

%   adding the helper functions path
addpath('helper functions/');

%   pre-computing of Gabor filters to save computation
[G g] = fourierGabor(feat.gSz, feat.gS, feat.gO);
g = reshape(g,feat.gSz(1), feat.gSz(2),[]);
sfilter = fft2(g, imSz(1),imSz(2));


%   detecting the number of feature bins
if feat.type==1
    nbins = feat.nbins;
elseif feat.type==2
    nbins = feat.gO * feat.gS;
    nbins = nbins + 3 ; %   40 + 2 soble + 1 normalized image
elseif feat.type==3
    nbins = feat.gO * feat.gS + feat.nbins;
elseif feat.type==4
    nbins = 1; %gray
elseif feat.type== 5
    nbins = 2;  % soble
elseif feat.type== 6
    nbins = feat.gO * feat.gS;  % Gabor
elseif feat.type== 7
    nbins = feat.gO * feat.gS;  % Gabor + gray
    nbins = nbins + 1;
elseif feat.type== 8
    nbins = feat.gO * feat.gS;  % Gabor + soble
    nbins = nbins + 2;
end;


%   initial variables for next computations
xyF  = zeros(prod(fltSz)*nbins,1);
filt = zeros(prod(fltSz)*nbins,length(ind));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   loop over all landmarks, train each landmark filter seperately
for indc=1:length(ind)
    %   loop over all images
    for i=1:length(train_imgs)
        display(['image # ' num2str(i) ' is processed!']);
        im = train_imgs{i}.im;
        if size(im,3)>1
            im = rgb2gray(im);
        end;
        im = double(im)/255;
        lm_xy = train_imgs{i}.pnts(:,ind(indc)); %   x_y of current landmark in current images
        lm_patch = im;
        feat_cnls = get_feat_channels_fast(lm_patch, imSz, imSz, feat, sfilter);
        
        %   if filter size is not same as the image size (smaller filter)
        %   then cropp the patch centered on the landmark of interest
        if (fltSz ~= imSz)
            [~,~,feat_cnls] = get_subwindow(feat_cnls, [lm_xy(2) lm_xy(1)], fltSz);
            lm_xy    = [size(feat_cnls,1) size(feat_cnls,2)]/2;
        end;
        
        %   getting features in the frequency domain
        feat_cnlsF = fft2(feat_cnls);
        %   Gaussian shape correlation output, with a peak on the landmark
        %   of interest
        rsp  = reshape(gen_response([lm_xy(2) lm_xy(1)], fltSz, feat.sigma),[],1);
        %   FFT of the rsp
        rspF = fftvec(rsp, fltSz);
        %   diagonalizing the features, according to the formulation in the
        %   paper
        diag_hogF = spdiags(reshape(feat_cnlsF, prod(fltSz), []), [0:size(feat_cnlsF,3)-1]* prod(fltSz), prod(fltSz), prod(fltSz)*size(feat_cnlsF,3));
        
        xyF  = xyF  + (diag_hogF'*rspF);
        if i==1
            xxF = diag_hogF'*diag_hogF;
        else
            xxF = xxF + (diag_hogF'*diag_hogF);
        end;
        
    end;    %   over all images
    %   computing the filters for all landmarks of interest
    I = speye(size(xxF,1));
    filtF = (xxF + I*feat.lambda)\xyF;
    filtF = (reshape(filtF, fltSz(1), fltSz(2), []));
    filt(:,indc)  =  reshape(circshift(real(ifft2(filtF)), [size(filtF,1) size(filtF,2)]/2),[],1);
end;
end