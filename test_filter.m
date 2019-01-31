
%    This function evaluates the cascade framework
%    test_imgs: test samples
%    lm_inds    : the indix of the landmark of interest, [1,...,5]
%    imSz       : image size
%    fltSz      : filter size
%    feat       : contains the feature parameters,
%    th         : the threshold to compute correct detection

function [true_localization localization_error] = test_filter(test_imgs, lm_inds, feat, imSz, fltSz, th)

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


%%  level 0 : whole face
load 'Gabor40_Sobel2_Gray1/128.mat' 'filt';
filt  = reshape(filt, fltSz(1,1), fltSz(1,2), nbins, length(lm_inds));
filtF =   (fft2(filt, fltSz(1,1), fltSz(1,1)));
filtF = reshape(filtF, [],length(lm_inds));
filtF_128 = filtF;

%%  level 1 : filter of [64 64]
load 'Gabor40_Sobel2_Gray1/64.mat' 'filt';
filt  = reshape(filt, fltSz(2,1), fltSz(2,2), nbins, length(lm_inds));
filtF =  fft2(filt, fltSz(2,1), fltSz(2,2));
filtF = reshape(filtF, [],length(lm_inds));
filtF_64 = filtF;

%%  level 2 : filter of [32 32]
load 'Gabor40_Sobel2_Gray1/32.mat' 'filt';
filt  = reshape(filt, fltSz(3,1), fltSz(3,2), nbins, length(lm_inds));
filtF =  fft2(filt, fltSz(3,1), fltSz(3,2));
filtF = reshape(filtF, [],length(lm_inds));
filtF_32 = filtF;

%%  level 3 : filter of [16 16]
load 'Gabor40_Sobel2_Gray1/16.mat' 'filt';
filt  = reshape(filt, fltSz(4,1), fltSz(4,2), nbins, length(lm_inds));
filtF =  fft2(filt, fltSz(4,1), fltSz(4,2));
filtF = reshape(filtF, [],length(lm_inds));
filtF_16 = filtF;

%%  level 4 : filter of [8 8]
load 'Gabor40_Sobel2_Gray1/8.mat' 'filt';
filt  = reshape(filt, fltSz(5,1), fltSz(5,2), nbins, length(lm_inds));
filtF =  fft2(filt, fltSz(5,1), fltSz(5,2));
filtF = reshape(filtF, [],length(lm_inds));
filtF_8 = filtF;

%   true localization respect to the "th"
true_localization  = 0;

%   average localization error in pixel
localization_error = 0;

%%  test and visualize the detection
for i=1:length(test_imgs)
    
    left_eye_center_ind = 2;
    right_eye_center_ind= 1;
    left_eye_center  = test_imgs{i}.pnts(:,left_eye_center_ind);
    right_eye_center = test_imgs{i}.pnts(:,right_eye_center_ind);
    ocular_distance  = sqrt(sum((left_eye_center - right_eye_center).^2));
    ground_truth = test_imgs{i}.pnts(:,lm_inds);
    
    
    
    im = test_imgs{i}.im;
    if size(im,3)>1
        im = rgb2gray(im);
    end;
    im = double(im)/255;
    
    test_im = im;
    feat_cnls = get_feat_channels_fast(im, imSz, imSz, feat, sfilter);
    feat_cnls_org = feat_cnls;
    feat_cnlsF = fft2(feat_cnls_org);
    
    %%  correlation response over the cascade
    
    [rsps_128] = get_corr_resp(lm_inds, imSz, fltSz(1,:), nbins, filtF_128, feat_cnlsF);
    [x y] = find(rsps_128 == max(rsps_128(:)));
    [rx,ry,feat_cnls] = get_subwindow(feat_cnls_org, [x(1) y(1)], fltSz(2,:));% get the region of interest for the next level
    feat_cnlsF = fft2(feat_cnls);
    
    
    %     the final detection is the x and y in the last level (8x8
    %     filter), the average of all leveles can be also used!
    figure(1); imagesc(test_im); colormap gray;axis off;
    title(['landmark localization. blue: ground truth, and red: detected']);
    %   plot the final detection
    %   the x/y along with the "th" and ground truth can be used to compute
    %   the detection accuracy. This code just shows the detection result,
    %   the code needs to be modified to compute the accuracy!
    
    
    [rsps_64] = get_corr_resp(lm_inds, fltSz(2,:), fltSz(2,:), nbins, filtF_64, feat_cnlsF);
    [x y] = find(rsps_64 == max(rsps_64(:)));
    x = rx(1)+x-1;  %   compute the maximum response in the 128x128 frame
    y = ry(1)+y-1;
    [rx,ry,feat_cnls] = get_subwindow(feat_cnls_org, [x(1) y(1)], fltSz(3,:));
    feat_cnlsF = fft2(feat_cnls);
    
    [rsps_32] = get_corr_resp(lm_inds, fltSz(3,:), fltSz(3,:), nbins, filtF_32, feat_cnlsF);
    [x y] = find(rsps_32 == max(rsps_32(:)));
    x = rx(1)+x-1;
    y = ry(1)+y-1;
    [rx,ry,feat_cnls] = get_subwindow(feat_cnls_org, [x(1) y(1)], fltSz(4,:));
    feat_cnlsF = fft2(feat_cnls);
    
    [rsps_16] = get_corr_resp(lm_inds, fltSz(4,:), fltSz(4,:), nbins, filtF_16, feat_cnlsF );
    [x y] = find(rsps_16 == max(rsps_16(:)));
    x = rx(1)+x-1;
    y = ry(1)+y-1;
    [rx,ry,feat_cnls] = get_subwindow(feat_cnls_org, [x(1) y(1)], fltSz(5,:));
    feat_cnlsF = fft2(feat_cnls);
    
    [rsps_8] = get_corr_resp(lm_inds, fltSz(5,:), fltSz(5,:), nbins, filtF_8, feat_cnlsF );
    [x y] = find(rsps_8 == max(rsps_8(:)));
    x = rx(1)+x-1;
    y = ry(1)+y-1;
    %   visualize the detection
    hold on; plot(y(1),x(1),'xr');
    hold on; plot(ground_truth(1),ground_truth(2),'ob');

    drawnow;
    
    %   compute the true localization and localization error
    %   error_for_current_image: is the localization error normalized by
    %   the ocular distance.

    predicted_xy = [y ; x];
    error_for_current_image = (sqrt(sum((ground_truth - predicted_xy).^2))/ocular_distance);
    %   th is used as a threshold to identify a wrong/correct localization 
    localization_error = localization_error + error_for_current_image;
    
    if (error_for_current_image <= (th))
        true_localization= true_localization + 1;
    end;
    
    
end;
%   computing the average error and localization accuracy
true_localization  = true_localization  / numel(test_imgs);
localization_error = localization_error / numel(test_imgs);
end

